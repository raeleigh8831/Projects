// logic is mid

#include <SDL2/SDL.h>
#include "rasterizer.h"
#include <cmath>
#include <iostream>

int main() {
    if (SDL_Init(SDL_INIT_VIDEO) < 0) {
        std::cout << "sdl init failed: " << SDL_GetError() << std::endl;
        return 1;
    }

    SDL_Window* window = SDL_CreateWindow("software rasterizer", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 600, 0);
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    SDL_Texture* texture = SDL_CreateTexture(renderer, SDL_PIXELFORMAT_RGB888, SDL_TEXTUREACCESS_STREAMING, 800, 600);

    Rasterizer rast(800, 600);

    bool running = true;
    float angle = 0.0f;
    while (running) {
        SDL_Event event;
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) running = false;
        }

        rast.Clear();

        // simple rotating triangle
        Vertex v0 = {{sin(angle), cos(angle), 1.0f}, {1.0f, 0.0f, 0.0f}};
        Vertex v1 = {{sin(angle + 2.094f), cos(angle + 2.094f), 1.0f}, {0.0f, 1.0f, 0.0f}};
        Vertex v2 = {{sin(angle + 4.189f), cos(angle + 4.189f), 1.0f}, {0.0f, 0.0f, 1.0f}};

        rast.DrawTriangle(v0, v1, v2);

        // copy to sdl texture
        void* pixels;
        int pitch;
        SDL_LockTexture(texture, NULL, &pixels, &pitch);
        for (int y = 0; y < 600; ++y) {
            Uint32* row = (Uint32*)((Uint8*)pixels + y * pitch);
            for (int x = 0; x < 800; ++x) {
                Vec3 c = rast.colorBuffer[y * 800 + x];
                row[x] = SDL_MapRGB(SDL_PIXELFORMAT_RGB888, c.x * 255, c.y * 255, c.z * 255);
            }
        }
        SDL_UnlockTexture(texture);

        SDL_RenderClear(renderer);
        SDL_RenderCopy(renderer, texture, NULL, NULL);
        SDL_RenderPresent(renderer);

        angle += 0.01f;
        SDL_Delay(16);
    }

    SDL_DestroyTexture(texture);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
