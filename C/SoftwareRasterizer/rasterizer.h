#ifndef RASTERIZER_H
#define RASTERIZER_H

#include "math.h"
#include <vector>
#include <algorithm>
#include <cmath>

struct Vertex {
    Vec3 position;
    Vec3 color;
    float oneOverZ;  // for perspective correct
};

class Rasterizer {
public:
    int width;
    int height;
    std::vector<float> depthBuffer;
    std::vector<Vec3> colorBuffer;

    Rasterizer(int w, int h) : width(w), height(h) {
        depthBuffer.resize(w * h, 1.0f);  // init to far plane
        colorBuffer.resize(w * h, {0.0f, 0.0f, 0.0f});
    }

    void Clear() {
        std::fill(depthBuffer.begin(), depthBuffer.end(), 1.0f);
        std::fill(colorBuffer.begin(), colorBuffer.end(), {0.0f, 0.0f, 0.0f});
    }

    void DrawTriangle(const Vertex& v0, const Vertex& v1, const Vertex& v2) {
        // project to screen space (assume already transformed)
        Vec2 p0 = {v0.position.x / v0.position.z * width / 2 + width / 2, v0.position.y / v0.position.z * height / 2 + height / 2};
        Vec2 p1 = {v1.position.x / v1.position.z * width / 2 + width / 2, v1.position.y / v1.position.z * height / 2 + height / 2};
        Vec2 p2 = {v2.position.x / v2.position.z * width / 2 + width / 2, v2.position.y / v2.position.z * height / 2 + height / 2};

        // bounding box
        int minX = std::max(0, (int)std::min({p0.x, p1.x, p2.x}));
        int maxX = std::min(width - 1, (int)std::max({p0.x, p1.x, p2.x}));
        int minY = std::max(0, (int)std::min({p0.y, p1.y, p2.y}));
        int maxY = std::min(height - 1, (int)std::max({p0.y, p1.y, p2.y}));

        // precompute 1/w
        float invW0 = 1.0f / v0.position.z;
        float invW1 = 1.0f / v1.position.z;
        float invW2 = 1.0f / v2.position.z;

        for (int y = minY; y <= maxY; ++y) {
            for (int x = minX; x <= maxX; ++x) {
                Vec2 p = {(float)x + 0.5f, (float)y + 0.5f};

                // barycentric weights
                float area = EdgeFunction(p0, p1, p2);
                if (area <= 0) continue;

                float w0 = EdgeFunction(p1, p2, p) / area;
                float w1 = EdgeFunction(p2, p0, p) / area;
                float w2 = EdgeFunction(p0, p1, p) / area;

                if (w0 < 0 || w1 < 0 || w2 < 0) continue;

                // perspective correct depth
                float invDepth = w0 * invW0 + w1 * invW1 + w2 * invW2;
                float depth = 1.0f / invDepth;

                int idx = y * width + x;
                if (depth > depthBuffer[idx]) continue;
                depthBuffer[idx] = depth;

                // interpolate color perspective correct
                Vec3 color = ScaleVec3(v0.color, w0 * invW0);
                color = AddVec3(color, ScaleVec3(v1.color, w1 * invW1));
                color = AddVec3(color, ScaleVec3(v2.color, w2 * invW2));
                color = ScaleVec3(color, invDepth);

                colorBuffer[idx] = color;
            }
        }
    }

private:
    float EdgeFunction(const Vec2& a, const Vec2& b, const Vec2& c) {
        return (c.x - a.x) * (b.y - a.y) - (c.y - a.y) * (b.x - a.x);
    }
};

#endif
