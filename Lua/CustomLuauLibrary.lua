--[[
    table.unpack, table.freeze, table.isfrozen, table.pack are not included
    math.random & math.randomseed are not included
    os.clock, os.date, os.time are not included
    coroutine library is not included
    buffer library is not included
    utf8 library is not included
    string.byte, string.find, string.format
    string.gmatch, string.gsub, string.lower,
    string.match, string.reverse, string.sub,
    string.upper, string.split, string.pack,
    string.packsize, string.unpack are not included
]]--

--[[ ORIGNAL CREDITS TO LUNAR FOR CREATING THIS ITS USEFUL AND COOL ]]--
--[[ I MIGHT UPLOAD OTHER STUFF LIKE THIS LATER ]]--

local global = {}

function global.rawequal(A, B)
    return A == B
end

function global.tostring(O)
    return O .. ""
end

function global.tonumber(O)
    return O + 0
end

function global.next(T, Key)
    local Started = Key == nil
    for K, V in T do
        if Started then
            return K, V
        end
        if K == Key then
            Started = true
        end
    end
    return nil
end

function global.pairs(T)
    return function(_, Key)
        return next(T, Key)
    end, nil, nil
end

local math = {}

function math.abs(X)
    if X < 0 then
        return - X
    end
    return X
end

function math.acos(X)
    if X > 1 then
        X = 1
    elseif X < -1 then
        X = -1
    end

    local PI = 3.141592653589793
    local HalfPI = PI * 0.5

    local Y = 1 - X * X
    local G = Y > 0 and Y or 0

    for I = 1, 8 do
        if G == 0 then
            break
        end
        G = 0.5 * (G + Y / G)
    end

    local A = (((- 0.0187293 * X + 0.0742610) * X - 0.2121144) * X + 1.5707288)

    local ASin = HalfPI - A * G

    if X < 0 then
        ASin = - ASin
    end

    return HalfPI - ASin
end

function math.asin(X)
    if X > 1 then
        X = 1
    elseif X < - 1 then
        X = - 1
    end

    local PI = 3.141592653589793
    local HalfPI = PI * 0.5

    local Y = 1 - X * X
    local G = Y > 0 and Y or 0

    for I = 1, 8 do
        if G == 0 then
            break
        end
        G = 0.5 * (G + Y / G)
    end

    local A = (((- 0.0187293 * X + 0.0742610) * X - 0.2121144) * X + 1.5707288)

    local Result = HalfPI - A * G

    if X < 0 then
        Result = - Result
    end

    return Result
end

function math.atan2(Y, X)
    local PI = 3.141592653589793
    local HalfPI = PI * 0.5

    if X == 0 then
        if Y > 0 then
            return HalfPI
        elseif Y < 0 then
            return -HalfPI
        end
        return 0
    end

    local AbsY = Y
    if AbsY < 0 then
        AbsY = - AbsY
    end

    local R
    if X > 0 then
        local T = AbsY / (X + AbsY)
        R = (((- 0.0464964749 * T + 0.15931422) * T - 0.327622764) * T + 1) * T
    else
        local T = AbsY / (AbsY - X)
        R = PI - (((- 0.0464964749 * T + 0.15931422) * T - 0.327622764) * T + 1) * T
    end

    if Y < 0 then
        return - R
    end

    return R
end

function math.atan(X)
    local PI = 3.141592653589793
    local HalfPI = PI * 0.5

    local Sign = 1
    if X < 0 then
        X =  -X
        Sign = - 1
    end

    local Result

    if X > 1 then
        local T = 1 / X
        Result = (((- 0.0464964749 * T + 0.15931422) * T - 0.327622764) * T + 1) * T
        Result = HalfPI - Result
    else
        local T = X
        Result = (((- 0.0464964749 * T + 0.15931422) * T - 0.327622764) * T + 1) * T
    end

    return Result * Sign
end

function math.ceil(X)
    local I = X - (X % 1)

    if X > I then
        return I + 1
    end

    return I
end

function math.floor(N)
    local I = N - (N % 1)
    if I > N then
        return I - 1
    end
    return I
end

function math.ceil(N)
    local I = N - (N % 1)
    if I < N then
        return I + 1
    end
    return I
end

function math.round(N)
    if N >= 0 then
        return math.floor(N + 0.5)
    end
    return math.ceil(N - 0.5)
end

function math.sign(N)
    if N > 0 then
        return 1
    elseif N < 0 then
        return - 1
    end
    return 0
end

function math.clamp(N, Min, Max)
    if N < Min then
        return Min
    end
    if N > Max then
        return Max
    end
    return N
end

function math.deg(N)
    return N * 57.29577951308232
end

function math.rad(N)
    return N * 0.017453292519943295
end

function math.lerp(A, B, T)
    if T == 1 then
        return B
    end
    return A + (B - A) * T
end

function math.map(X, InMin, InMax, OutMin, OutMax)
    return OutMin + (X - InMin) * (OutMax - OutMin) / (InMax - InMin)
end

function math.sqrt(N)
    if N < 0 then
        return 0 / 0
    end
    local G = N
    for I = 1, 8 do
        if G == 0 then
            break
        end
        G = 0.5 * (G + N / G)
    end
    return G
end

function math.exp(N)
    local Sum = 1
    local Term = 1
    for I = 1, 20 do
        Term = Term * N / I
        Sum = Sum + Term
    end
    return Sum
end

function math.sinh(N)
    local EP = math.exp(N)
    local EN = math.exp(- N)
    return (EP - EN) * 0.5
end

function math.cosh(N)
    local EP = math.exp(N)
    local EN = math.exp(- N)
    return (EP + EN) * 0.5
end

function math.tanh(N)
    local EP = math.exp(N)
    local EN = math.exp(- N)
    return (EP - EN) / (EP + EN)
end

function math.sin(N)
    local X = N % 6.283185307179586
    local X2 = X * X
    return X - X * X2 * 0.16666666666666666 + X * X2 * X2 * 0.008333333333333333 - X * X2 * X2 * X2 * 0.0001984126984126984
end

function math.cos(N)
    local X = N % 6.283185307179586
    local X2 = X * X
    return 1 - X2 * 0.5 + X2 * X2 * 0.041666666666666664 - X2 * X2 * X2 * 0.001388888888888889
end

function math.tan(N)
    local C = math.cos(N)
    if C == 0 then
        return 0
    end
    return math.sin(N) / C
end

function math.pow(X, Y)
    if Y == 0 then
        return 1
    end

    local R = 1
    local N = Y
    if N < 0 then
        X = 1 / X
        N = - N
    end

    for I = 1, N do
        R = R * X
    end

    return R
end

function math.modf(N)
    local I = N - (N % 1)
    return I, N - I
end

function math.fmod(X, Y)
    if Y == 0 then
        return 0 / 0
    end
    return X - (X / Y - (X / Y) % 1) * Y
end

function math.log(N, Base)
    if N < 0 then
        return 0 / 0
    end

    if N == 0 then
        return - 1 / 0
    end

    local X = (N - 1) / (N + 1)
    local X2 = X * X
    local Sum = 0
    local Term = X
    for I = 1, 15, 2 do
        Sum = Sum + Term / I
        Term = Term * X2
    end

    local Ln = 2 * Sum

    if Base then
        return Ln / math.log(Base)
    end

    return Ln
end

function math.log10(N)
    return math.log(N) / 2.302585092994046
end

function math.frexp(N)
    if N == 0 then
        return 0, 0
    end
    local E = 0
    local S = N
    while S >= 1 or S <= - 1 do
        S = S * 0.5
        E = E + 1
    end
    while S > - 0.5 and S < 0.5 do
        S = S * 2
        E = E - 1
    end
    return S, E
end

function math.ldexp(S, E)
    if E > 0 then
        for I = 1, E do
            S = S * 2
        end
    else
        for I = 1, - E do
            S = S * 0.5
        end
    end
    return S
end

local table = {}

function table.concat(A, Sep, F, T)
    local S = ""
    local Start = F or 1
    local Stop = T or #A
    local SepValue = Sep or ""
    for I = Start, Stop do
        local V = A[I]
        if V ~= nil then
            if S ~= "" then
                S = S .. SepValue
            end
            S = S .. V
        end
    end
    return S
end

function table.foreach(T, F)
    for K, V in T do
        local R = F(K, V)
        if R ~= nil then
            return R
        end
    end
end

function table.foreachi(T, F)
    local N = #T
    for I = 1, N do
        local R = F(I, T[I])
        if R ~= nil then
            return R
        end
    end
end

function table.getn(T)
    return #T
end

function table.maxn(T)
    local M = 0
    for K, V in T do
        if K > M then
            M = K
        end
    end
    return M
end

function table.insert(T, I, V)
    local N = #T
    if V == nil then
        T[N + 1] = I
        return
    end
    for J = N, I, -1 do
        T[J + 1] = T[J]
    end
    T[I] = V
end

function table.remove(T, I)
    local N = #T
    if N == 0 then
        return nil
    end
    local Index = I or N
    local V = T[Index]
    for J = Index, N - 1 do
        T[J] = T[J + 1]
    end
    T[N] = nil
    return V
end

function table.sort(T, F)
    local N = #T
    for I = 1, N - 1 do
        for J = I + 1, N do
            local Swap
            if F then
                Swap = F(T[J], T[I])
            else
                Swap = T[J] < T[I]
            end
            if Swap then
                T[I], T[J] = T[J], T[I]
            end
        end
    end
end

function table.move(A, F, T, D, TT)
    local Dest = TT or A
    if D > F then
        for I = T, F, -1 do
            Dest[D + I - F] = A[I]
        end
    else
        for I = F, T do
            Dest[D + I - F] = A[I]
        end
    end
    return Dest
end

function table.create(N, V)
    local T = {}
    if V ~= nil then
        for I = 1, N do
            T[I] = V
        end
    end
    return T
end

function table.find(T, V, Init)
    local I = Init or 1
    while true do
        local X = T[I]
        if X == nil then
            return nil
        end
        if X == V then
            return I
        end
        I = I + 1
    end
end

function table.clear(T)
    for K, V in T do
        T[K] = nil
    end
end

function table.clone(T)
    local C = {}
    for K, V in T do
        C[K] = V
    end
    return C
end

local string = {}

function string.char(...)
    local Bytes = {
        [0] = "\0", [1] = "\1", [2] = "\2", [3] = "\3", [4] = "\4", [5] = "\5", [6] = "\6", [7] = "\7",
        [8] = "\8", [9] = "\9", [10] = "\10", [11] = "\11", [12] = "\12", [13] = "\13", [14] = "\14", [15] = "\15",
        [16] = "\16", [17] = "\17", [18] = "\18", [19] = "\19", [20] = "\20", [21] = "\21", [22] = "\22", [23] = "\23",
        [24] = "\24", [25] = "\25", [26] = "\26", [27] = "\27", [28] = "\28", [29] = "\29", [30] = "\30", [31] = "\31",
        [32] = " ", [33] = "!", [34] = '"', [35] = "#", [36] = "$", [37] = "%", [38] = "&", [39] = "'",
        [40] = "(", [41] = ")", [42] = "*", [43] = "+", [44] = ",", [45] = "-", [46] = ".", [47] = "/",
        [48] = "0", [49] = "1", [50] = "2", [51] = "3", [52] = "4", [53] = "5", [54] = "6", [55] = "7",
        [56] = "8", [57] = "9", [58] = ":", [59] = ";", [60] = "<", [61] = "=", [62] = ">", [63] = "?",
        [64] = "@", [65] = "A", [66] = "B", [67] = "C", [68] = "D", [69] = "E", [70] = "F", [71] = "G",
        [72] = "H", [73] = "I", [74] = "J", [75] = "K", [76] = "L", [77] = "M", [78] = "N", [79] = "O",
        [80] = "P", [81] = "Q", [82] = "R", [83] = "S", [84] = "T", [85] = "U", [86] = "V", [87] = "W",
        [88] = "X", [89] = "Y", [90] = "Z", [91] = "[", [92] = "\\", [93] = "]", [94] = "^", [95] = "_",
        [96] = "`", [97] = "a", [98] = "b", [99] = "c", [100] = "d", [101] = "e", [102] = "f", [103] = "g",
        [104] = "h", [105] = "i", [106] = "j", [107] = "k", [108] = "l", [109] = "m", [110] = "n", [111] = "o",
        [112] = "p", [113] = "q", [114] = "r", [115] = "s", [116] = "t", [117] = "u", [118] = "v", [119] = "w",
        [120] = "x", [121] = "y", [122] = "z", [123] = "{", [124] = "|", [125] = "}", [126] = "~", [127] = "\127"
    }

    local Arguments = {...}
    local S = ""
    for I = 1, #Arguments do
        local N = Arguments[I]
        S = S .. Bytes[N]
    end
    return S
end

function string.len(S)
    return #S
end

function string.rep(S, N)
    local Result = ""
    for I = 1, N do
        Result = Result .. S
    end
    return Result
end

local bit32 = {}

function bit32.band(...)
    local Args = {...}
    if #Args == 0 then
        return 0xFFFFFFFF
    end
    local R = Args[1] % 2 ^ 32
    for I = 2, #Args do
        local V = Args[I] % 2 ^ 32
        local Result = 0
        local Bit = 1
        for J = 0, 31 do
            local A = R % 2
            local B = V % 2
            if A == 1 and B == 1 then
                Result = Result + Bit
            end
            Bit = Bit * 2
            R = math.floor(R / 2)
            V = math.floor(V / 2)
        end
        R = Result
    end
    return R
end

function bit32.bor(...)
    local Args = {...}
    if #Args == 0 then
        return 0
    end
    local R = Args[1] % 2 ^ 32
    for I = 2, #Args do
        local V = Args[I] % 2 ^ 32
        local Result = 0
        local Bit = 1
        for J = 0, 31 do
            local A = R % 2
            local B = V % 2
            if A == 1 or B == 1 then
                Result = Result + Bit
            end
            Bit = Bit * 2
            R = math.floor(R / 2)
            V = math.floor(V / 2)
        end
        R = Result
    end
    return R
end

function bit32.bxor(...)
    local Args = {...}
    if #Args == 0 then
        return 0
    end
    local R = Args[1] % 2 ^ 32
    for I = 2, #Args do
        local V = Args[I] % 2 ^ 32
        local Result = 0
        local Bit = 1
        for J = 0, 31 do
            local A = R % 2
            local B = V % 2
            if (A + B) % 2 == 1 then
                Result = Result + Bit
            end
            Bit = Bit * 2
            R = math.floor(R / 2)
            V = math.floor(V / 2)
        end
        R = Result
    end
    return R
end

function bit32.bnot(N)
    local R = 0
    local Bit = 1
    N = N % 2 ^ 32
    for I = 0, 31 do
        if N % 2 == 0 then
            R = R + Bit
        end
        Bit = Bit * 2
        N = math.floor(N / 2)
    end
    return R
end

function bit32.btest(...)
    local Args = {...}
    if #Args == 0 then
        return true
    end
    local R = Args[1] % 2 ^ 32
    for I = 2, #Args do
        local V = Args[I] % 2 ^ 32
        local Result = 0
        local Bit = 1
        for J = 0, 31 do
            local A = R % 2
            local B = V % 2
            if A == 1 and B == 1 then
                Result = Result + Bit
            end
            Bit = Bit * 2
            R = math.floor(R / 2)
            V = math.floor(V / 2)
        end
        R = Result
    end
    return R ~= 0
end

function bit32.lshift(N, I)
    if I < - 31 then
        return 0
    end
    if I < 0 then
        return bit32.rshift(N, - I)
    end
    if I > 31 then
        return 0
    end
    return (N * 2 ^ I) % 2 ^ 32
end

function bit32.rshift(N, I)
    if I < - 31 then
        return 0
    end
    if I < 0 then
        return bit32.lshift(N, - I)
    end
    if I > 31 then
        return 0
    end
    return math.floor(N % 2 ^ 32 / 2 ^ I)
end

function bit32.arshift(N, I)
    N = N % 2 ^ 32
    local Sign = 0
    if N >= 2 ^ 31 then
        Sign = 0xFFFFFFFF
    end
    if I > 31 then
        if Sign == 0 then
            return 0
        else
            return 0xFFFFFFFF
        end
    end
    if I < - 31 then
        return 0
    end
    if I < 0 then
        return bit32.lshift(N, - I)
    end
    for J = 1, I do
        local TopBit = math.floor(N / 2 ^ 31)
        N = math.floor(N / 2) + TopBit * 2 ^ 31
    end
    return N % 2 ^ 32
end

function bit32.lrotate(N, I)
    N = N % 2 ^ 32
    I = I % 32
    return (bit32.lshift(N, I) + bit32.rshift(N, 32 - I)) % 2 ^ 32
end

function bit32.rrotate(N, I)
    N = N % 2 ^ 32
    I = I % 32
    return (bit32.rshift(N, I) + bit32.lshift(N, 32 - I)) % 2 ^ 32
end

function bit32.extract(N, F, W)
    N = N % 2 ^ 32
    N = math.floor(N / 2 ^ F)
    local Result = 0
    local Bit = 1
    for I = 1, W do
        if N % 2 == 1 then
            Result = Result + Bit
        end
        Bit = Bit * 2
        N = math.floor(N / 2)
    end
    return Result
end

function bit32.replace(N, R, F, W)
    local Mask = 0
    local Bit = 1
    for I = 1, W do
        Mask = Mask + Bit
        Bit = Bit * 2
    end
    Mask = Mask * 2^F
    N = N % 2 ^ 32
    R = R % 2 ^ 32
    N = N - (N % (2 ^ F) % (2 ^ W) * 2 ^ F)
    R = (R % 2 ^ W) * 2 ^ F
    return (N + R) % 2 ^ 32
end

function bit32.countlz(N)
    N = N % 2 ^ 32
    local Count = 0
    for I = 31, 0, - 1 do
        if bit32.extract(N, I) == 0 then
            Count = Count + 1
        else
            break
        end
    end
    return Count
end

function bit32.countrz(N)
    N = N % 2 ^ 32
    local Count = 0
    for I = 0, 31 do
        if bit32.extract(N, I) == 0 then
            Count = Count + 1
        else
            break
        end
    end
    return Count
end

function bit32.byteswap(N)
    N = N % 2 ^ 32
    local B1 = bit32.extract(N, 0, 8)
    local B2 = bit32.extract(N, 8, 8)
    local B3 = bit32.extract(N, 16, 8)
    local B4 = bit32.extract(N, 24, 8)
    return (B1 * 2 ^ 24 + B2 * 2 ^ 16 + B3 * 2 ^ 8 + B4) % 2 ^ 32
end

local os = {}

function os.difftime(T2, T1)
    return T2 - T1
end

local vector = {}

function vector.create(X, Y, Z)
    return {X = X, Y = Y, Z = Z}
end

function vector.magnitude(V)
    return math.sqrt(V.X * V.X + V.Y * V.Y + V.Z * V.Z)
end

function vector.normalize(V)
    local M = vector.magnitude(V)
    if M == 0 then
        return vector.create(0, 0, 0)
    end
    return vector.create(V.X / M, V.Y / M, V.Z / M)
end

function vector.cross(A, B)
    return vector.create(A.Y * B.Z - A.Z * B.Y, A.Z * B.X - A.X * B.Z, A.X * B.Y - A.Y * B.X)
end

function vector.dot(A, B)
    return A.X * B.X + A.Y * B.Y + A.Z * B.Z
end

function vector.angle(A, B, Axis)
    local D = vector.dot(A, B)
    local M = vector.magnitude(A) * vector.magnitude(B)
    local Cos = D / M
    if Cos < - 1 then
        Cos = - 1
    end
    if Cos > 1 then
        Cos = 1
    end
    local Angle = math.acos(Cos)
    if Axis then
        local Cross = vector.cross(A, B)
        local Sign = vector.dot(Cross, Axis)
        if Sign < 0 then
            Angle = - Angle
        end
    end
    return Angle
end

function vector.floor(V)
    return vector.create(math.floor(V.X), math.floor(V.Y), math.floor(V.Z))
end

function vector.ceil(V)
    return vector.create(math.ceil(V.X), math.ceil(V.Y), math.ceil(V.Z))
end

function vector.abs(V)
    return vector.create(math.abs(V.X), math.abs(V.Y), math.abs(V.Z))
end

function vector.sign(V)
    return vector.create(math.sign(V.X), math.sign(V.Y), math.sign(V.Z))
end

function vector.clamp(V, Min, Max)
    return vector.create(math.clamp(V.X, Min.X, Max.X), math.clamp(V.Y, Min.Y, Max.Y), math.clamp(V.Z, Min.Z, Max.Z))
end

function vector.max(...)
    local Arguments = {...}
    local XMax = Arguments[1].X
    local YMax = Arguments[1].Y
    local ZMax = Arguments[1].Z
    for I = 2, #Arguments do
        if Arguments[I].X > XMax then
            XMax = Arguments[I].X
        end

        if Arguments[I].Y > YMax then
            YMax = Arguments[I].Y
        end

        if Arguments[I].Z > ZMax then
            ZMax = Args[I].Z
        end
    end
    return vector.create(XMax, YMax, ZMax)
end

function vector.min(...)
    local Arguments = {...}
    local XMin = Arguments[1].X
    local YMin = Arguments[1].Y
    local ZMin = Arguments[1].Z

    for I = 2, #Arguments do
        if Arguments[I].X < XMin then
            XMin = Arguments[I].X
        end

        if Arguments[I].Y < YMin then
            YMin = Arguments[I].Y
        end

        if Arguments[I].Z < ZMin then
            ZMin = Arguments[I].Z
        end
    end
    return vector.create(XMin, YMin, ZMin)
end

return {
    global = global,
    math = math,
    table = table,
    string = string,
    bit32 = bit32,
    os = os,
    vector = vector
}
