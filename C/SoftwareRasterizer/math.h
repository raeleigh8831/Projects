#ifndef MATH_H
#define MATH_H

struct Vec2 {
    float x;
    float y;
};

struct Vec3 {
    float x;
    float y;
    float z;
};

struct Vec4 {
    float x;
    float y;
    float z;
    float w;
};

Vec3 AddVec3(Vec3 a, Vec3 b) {
    Vec3 result;
    result.x = a.x + b.x;
    result.y = a.y + b.y;
    result.z = a.z + b.z;
    return result;
}

Vec3 ScaleVec3(Vec3 v, float s) {
    Vec3 result;
    result.x = v.x * s;
    result.y = v.y * s;
    result.z = v.z * s;
    return result;
}

float DotVec3(Vec3 a, Vec3 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

#endif
