# Software Rasterizer – From Scratch!

# 📁 Project Struture

├── main.cpp          → SDL window + render loop


├── rasterizer.h      → Core triangle rasterizer + depth buffer


├── math.h            → Simple Vec2/Vec3 helpers


├── Makefile          → Easy build


└── README.md         → You're here

<div align="center">

![C++](https://img.shields.io/badge/C%2B%2B-17-blue?logo=c%2B%2B&style=for-the-badge)
![SDL2](https://img.shields.io/badge/SDL2-2.0-orange?logo=sdl&style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)
![Status](https://img.shields.io/badge/status-active-brightgreen?style=for-the-badge)

<img src="https://raw.githubusercontent.com/yourusername/software-rasterizer/main/screenshot.gif" alt="Spinning colorful triangle" width="600"/>

**A tiny, educational software rasterizer written in pure C++**  
Perspective-correct interpolation • Depth buffering • Vertex color shading

</div>

---

## 🌟 Features

- **100% software rendering** – no GPU, no OpenGL, just CPU and math  
- **Perspective-correct attribute interpolation** (colors look right even when close to camera)  
- **Z-buffer** for proper depth sorting  
- **Bounding box optimization** + barycentric rasterization  
- Simple rotating rainbow triangle demo (hypnotic asf lol)  

---

## 🎥 Demo

<img src=""/>

*(Yes, it's actually running in real-time on the CPU)*

---

## 🛠️ Build & Run

### Prerequisites
- SDL2 development libraries

```bash
# Ubuntu/Debian
sudo apt install libsdl2-dev

# macOS (with Homebrew)
brew install sdl2

# Windows
# Download SDL2 devel package from https://www.libsdl.org and add to your IDE
```

# Compile

make                # or
g++ -O2 -o rasterizer main.cpp -lSDL2

# Run


./rasterizer

# 📜 License

MIT License – feel free to use, modify, and share.

