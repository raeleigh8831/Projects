local Globallib = {};

-- Orignal Credits ; lunar
-- Variables and stuff renamed by ai for copyright stuff
-- :3
function Globallib.Rawequal(A, B)
    return A == B;
end

function Globallib.Tostring(O)
    return O .. "";
end

function Globallib.Tonumber(O)
    return O + 0;
end

function Globallib.Next(T, K)
    local S = K == nil;
    for X, V in T do
        if S then
            return X, V;
        end
        if X == K then
            S = true;
        end
    end
    return nil;
end

function Globallib.Pairs(T)
    return function(_, K)
        return Globallib.Next(T, K);
    end, nil, nil;
end

local Mathlib = {};

function Mathlib.Abs(X)
    if X < 0 then
        return -X;
    end
    return X;
end

function Mathlib.Clampangle(A, Min, Max)
    local TwoPi = 6.283185307179586;

    while A < 0 do
        A = A + TwoPi;
    end
    while A > TwoPi do
        A = A - TwoPi;
    end

    while Min < 0 do
        Min = Min + TwoPi;
    end
    while Min > TwoPi do
        Min = Min - TwoPi;
    end

    while Max < 0 do
        Max = Max + TwoPi;
    end
    while Max > TwoPi do
        Max = Max - TwoPi;
    end

    if A < Min then
        A = Min;
    elseif A > Max then
        A = Max;
    end

    return A;
end

function Mathlib.Acos(X)
    if X > 1 then
        X = 1;
    elseif X < -1 then
        X = -1;
    end

    local Pi = 3.141592653589793;
    local HalfPi = Pi * 0.5;

    local Y = 1 - X * X;
    local G = Y > 0 and Y or 0;

    for I = 1, 8 do
        if G == 0 then
            break;
        end
        G = 0.5 * (G + Y / G);
    end

    local A = (((- 0.0187293 * X + 0.0742610) * X - 0.2121144) * X + 1.5707288);

    local Asin = HalfPi - A * G;

    if X < 0 then
        Asin = -Asin;
    end

    return HalfPi - Asin;
end

function Mathlib.Asin(X)
    if X > 1 then
        X = 1;
    elseif X < -1 then
        X = -1;
    end

    local Pi = 3.141592653589793;
    local HalfPi = Pi * 0.5;

    local Y = 1 - X * X;
    local G = Y > 0 and Y or 0;

    for I = 1, 8 do
        if G == 0 then
            break;
        end
        G = 0.5 * (G + Y / G);
    end

    local A = (((- 0.0187293 * X + 0.0742610) * X - 0.2121144) * X + 1.5707288);

    local Result = HalfPi - A * G;

    if X < 0 then
        Result = -Result;
    end

    return Result;
end

function Mathlib.Atan2(Y, X)
    local Pi = 3.141592653589793;
    local HalfPi = Pi * 0.5;

    if X == 0 then
        if Y > 0 then
            return HalfPi;
        elseif Y < 0 then
            return -HalfPi;
        end
        return 0;
    end

    local AbsY = Y;
    if AbsY < 0 then
        AbsY = -AbsY;
    end

    local R;
    if X > 0 then
        local T = AbsY / (X + AbsY);
        R = (((- 0.0464964749 * T + 0.15931422) * T - 0.327622764) * T + 1) * T;
    else
        local T = AbsY / (AbsY - X);
        R = Pi - (((- 0.0464964749 * T + 0.15931422) * T - 0.327622764) * T + 1) * T;
    end

    if Y < 0 then
        return -R;
    end

    return R;
end

function Mathlib.Atan(X)
    local Pi = 3.141592653589793;
    local HalfPi = Pi * 0.5;

    local Sign = 1;
    if X < 0 then
        X = -X;
        Sign = -1;
    end

    local Result;

    if X > 1 then
        local T = 1 / X;
        Result = (((- 0.0464964749 * T + 0.15931422) * T - 0.327622764) * T + 1) * T;
        Result = HalfPi - Result;
    else
        local T = X;
        Result = (((- 0.0464964749 * T + 0.15931422) * T - 0.327622764) * T + 1) * T;
    end

    return Result * Sign;
end

function Mathlib.Ceil(X)
    local I = X - (X % 1);

    if X > I then
        return I + 1;
    end

    return I;
end

function Mathlib.Floor(N)
    local I = N - (N % 1);
    if I > N then
        return I - 1;
    end
    return I;
end

function Mathlib.Round(N)
    if N >= 0 then
        return Mathlib.Floor(N + 0.5);
    end
    return Mathlib.Ceil(N - 0.5);
end

function Mathlib.Sign(N)
    if N > 0 then
        return 1;
    elseif N < 0 then
        return -1;
    end
    return 0;
end

function Mathlib.Clamp(N, Min, Max)
    if N < Min then
        return Min;
    end
    if N > Max then
        return Max;
    end
    return N;
end

function Mathlib.Deg(N)
    return N * 57.29577951308232;
end

function Mathlib.Rad(N)
    return N * 0.017453292519943295;
end

function Mathlib.Lerp(A, B, T)
    if T == 1 then
        return B;
    end
    return A + (B - A) * T;
end

function Mathlib.Map(X, Imin, Imax, Omin, Omax)
    return Omin + (X - Imin) * (Omax - Omin) / (Imax - Imin);
end

function Mathlib.Sqrt(N)
    if N < 0 then
        return 0 / 0;
    end
    local G = N;
    for I = 1, 8 do
        if G == 0 then
            break;
        end
        G = 0.5 * (G + N / G);
    end
    return G;
end

function Mathlib.Exp(N)
    local Sum = 1;
    local Term = 1;
    for I = 1, 20 do
        Term = Term * N / I;
        Sum = Sum + Term;
    end
    return Sum;
end

function Mathlib.Sinh(N)
    local Ep = Mathlib.Exp(N);
    local En = Mathlib.Exp(-N);
    return (Ep - En) * 0.5;
end

function Mathlib.Cosh(N)
    local Ep = Mathlib.Exp(N);
    local En = Mathlib.Exp(-N);
    return (Ep + En) * 0.5;
end

function Mathlib.Tanh(N)
    local Ep = Mathlib.Exp(N);
    local En = Mathlib.Exp(-N);
    return (Ep - En) / (Ep + En);
end

function Mathlib.Sin(N)
    local X = N % 6.283185307179586;
    local X2 = X * X;
    return X - X * X2 * 0.16666666666666666 + X * X2 * X2 * 0.008333333333333333 - X * X2 * X2 * X2 * 0.0001984126984126984;
end

function Mathlib.Cos(N)
    local X = N % 6.283185307179586;
    local X2 = X * X;
    return 1 - X2 * 0.5 + X2 * X2 * 0.041666666666666664 - X2 * X2 * X2 * 0.001388888888888889;
end

function Mathlib.Tan(N)
    local C = Mathlib.Cos(N);
    if C == 0 then
        return 0;
    end
    return Mathlib.Sin(N) / C;
end

function Mathlib.Pow(X, Y)
    if Y == 0 then
        return 1;
    end

    local R = 1;
    local N = Y;
    if N < 0 then
        X = 1 / X;
        N = -N;
    end

    for I = 1, N do
        R = R * X;
    end

    return R;
end

function Mathlib.Modf(N)
    local I = N - (N % 1);
    return I, N - I;
end

function Mathlib.Fmod(X, Y)
    if Y == 0 then
        return 0 / 0;
    end
    return X - (X / Y - (X / Y) % 1) * Y;
end

function Mathlib.Log(N, Base)
    if N < 0 then
        return 0 / 0;
    end

    if N == 0 then
        return -1 / 0;
    end

    local X = (N - 1) / (N + 1);
    local X2 = X * X;
    local Sum = 0;
    local Term = X;
    for I = 1, 15, 2 do
        Sum = Sum + Term / I;
        Term = Term * X2;
    end

    local Ln = 2 * Sum;

    if Base then
        return Ln / Mathlib.Log(Base);
    end

    return Ln;
end

function Mathlib.Log10(N)
    return Mathlib.Log(N) / 2.302585092994046;
end

function Mathlib.Frexp(N)
    if N == 0 then
        return 0, 0;
    end
    local E = 0;
    local S = N;
    while S >= 1 or S <= -1 do
        S = S * 0.5;
        E = E + 1;
    end
    while S > -0.5 and S < 0.5 do
        S = S * 2;
        E = E - 1;
    end
    return S, E;
end

function Mathlib.Ldexp(S, E)
    if E > 0 then
        for I = 1, E do
            S = S * 2;
        end
    else
        for I = 1, -E do
            S = S * 0.5;
        end
    end
    return S;
end

local Tablelib = {};

function Tablelib.Concat(A, Sep, F, T)
    local S = "";
    local Start = F or 1;
    local Stop = T or #A;
    local Sepvalue = Sep or "";
    for I = Start, Stop do
        local V = A[I];
        if V ~= nil then
            if S ~= "" then
                S = S .. Sepvalue;
            end
            S = S .. V;
        end
    end
    return S;
end

function Tablelib.Foreach(T, F)
    for K, V in T do
        local R = F(K, V);
        if R ~= nil then
            return R;
        end
    end
end

function Tablelib.Foreachi(T, F)
    local N = #T;
    for I = 1, N do
        local R = F(I, T[I]);
        if R ~= nil then
            return R;
        end
    end
end

function Tablelib.Getn(T)
    return #T;
end

function Tablelib.Maxn(T)
    local M = 0;
    for K, V in T do
        if K > M then
            M = K;
        end
    end
    return M;
end

function Tablelib.Insert(T, I, V)
    local N = #T;
    if V == nil then
        T[N + 1] = I;
        return;
    end
    for J = N, I, -1 do
        T[J + 1] = T[J];
    end
    T[I] = V;
end

function Tablelib.Remove(T, I)
    local N = #T;
    if N == 0 then
        return nil;
    end
    local Idx = I or N;
    local V = T[Idx];
    for J = Idx, N - 1 do
        T[J] = T[J + 1];
    end
    T[N] = nil;
    return V;
end

function Tablelib.Sort(T, F)
    local N = #T;
    for I = 1, N - 1 do
        for J = I + 1, N do
            local Swap;
            if F then
                Swap = F(T[J], T[I]);
            else
                Swap = T[J] < T[I];
            end
            if Swap then
                T[I], T[J] = T[J], T[I];
            end
        end
    end
end

function Tablelib.Move(A, F, T, D, Tt)
    local Dest = Tt or A;
    if D > F then
        for I = T, F, -1 do
            Dest[D + I - F] = A[I];
        end
    else
        for I = F, T do
            Dest[D + I - F] = A[I];
        end
    end
    return Dest;
end

function Tablelib.Create(N, V)
    local T = {};
    if V ~= nil then
        for I = 1, N do
            T[I] = V;
        end
    end
    return T;
end

function Tablelib.Find(T, V, Init)
    local I = Init or 1;
    while true do
        local X = T[I];
        if X == nil then
            return nil;
        end
        if X == V then
            return I;
        end
        I = I + 1;
    end
end

function Tablelib.Clear(T)
    for K, V in T do
        T[K] = nil;
    end
end

function Tablelib.Clone(T)
    local C = {};
    for K, V in T do
        C[K] = V;
    end
    return C;
end

local Stringlib = {};

function Stringlib.Char(...)
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
    };

    local Args = {...};
    local S = "";
    for I = 1, #Args do
        local N = Args[I];
        S = S .. Bytes[N];
    end
    return S;
end

function Stringlib.Len(S)
    return #S;
end

function Stringlib.Rep(S, N)
    local Result = "";
    for I = 1, N do
        Result = Result .. S;
    end
    return Result;
end

local Bit32lib = {};

function Bit32lib.Band(...)
    local Args = {...};
    if #Args == 0 then
        return 0xFFFFFFFF;
    end
    local R = Args[1] % 2 ^ 32;
    for I = 2, #Args do
        local V = Args[I] % 2 ^ 32;
        local Result = 0;
        local Bit = 1;
        for J = 0, 31 do
            local A = R % 2;
            local B = V % 2;
            if A == 1 and B == 1 then
                Result = Result + Bit;
            end
            Bit = Bit * 2;
            R = Mathlib.Floor(R / 2);
            V = Mathlib.Floor(V / 2);
        end
        R = Result;
    end
    return R;
end

function Bit32lib.Bor(...)
    local Args = {...};
    if #Args == 0 then
        return 0;
    end
    local R = Args[1] % 2 ^ 32;
    for I = 2, #Args do
        local V = Args[I] % 2 ^ 32;
        local Result = 0;
        local Bit = 1;
        for J = 0, 31 do
            local A = R % 2;
            local B = V % 2;
            if A == 1 or B == 1 then
                Result = Result + Bit;
            end
            Bit = Bit * 2;
            R = Mathlib.Floor(R / 2);
            V = Mathlib.Floor(V / 2);
        end
        R = Result;
    end
    return R;
end

function Bit32lib.Bxor(...)
    local Args = {...};
    if #Args == 0 then
        return 0;
    end
    local R = Args[1] % 2 ^ 32;
    for I = 2, #Args do
        local V = Args[I] % 2 ^ 32;
        local Result = 0;
        local Bit = 1;
        for J = 0, 31 do
            local A = R % 2;
            local B = V % 2;
            if (A + B) % 2 == 1 then
                Result = Result + Bit;
            end
            Bit = Bit * 2;
            R = Mathlib.Floor(R / 2);
            V = Mathlib.Floor(V / 2);
        end
        R = Result;
    end
    return R;
end

function Bit32lib.Bnot(N)
    local R = 0;
    local Bit = 1;
    N = N % 2 ^ 32;
    for I = 0, 31 do
        if N % 2 == 0 then
            R = R + Bit;
        end
        Bit = Bit * 2;
        N = Mathlib.Floor(N / 2);
    end
    return R;
end

function Bit32lib.Btest(...)
    local Args = {...};
    if #Args == 0 then
        return true;
    end
    local R = Args[1] % 2 ^ 32;
    for I = 2, #Args do
        local V = Args[I] % 2 ^ 32;
        local Result = 0;
        local Bit = 1;
        for J = 0, 31 do
            local A = R % 2;
            local B = V % 2;
            if A == 1 and B == 1 then
                Result = Result + Bit;
            end
            Bit = Bit * 2;
            R = Mathlib.Floor(R / 2);
            V = Mathlib.Floor(V / 2);
        end
        R = Result;
    end
    return R ~= 0;
end

function Bit32lib.Lshift(N, I)
    if I < -31 then
        return 0;
    end
    if I < 0 then
        return Bit32lib.Rshift(N, -I);
    end
    if I > 31 then
        return 0;
    end
    return (N * 2 ^ I) % 2 ^ 32;
end

function Bit32lib.Rshift(N, I)
    if I < -31 then
        return 0;
    end
    if I < 0 then
        return Bit32lib.Lshift(N, -I);
    end
    if I > 31 then
        return 0;
    end
    return Mathlib.Floor(N % 2 ^ 32 / 2 ^ I);
end

function Bit32lib.Arshift(N, I)
    N = N % 2 ^ 32;
    local Sign = 0;
    if N >= 2 ^ 31 then
        Sign = 0xFFFFFFFF;
    end
    if I > 31 then
        if Sign == 0 then
            return 0;
        else
            return 0xFFFFFFFF;
        end
    end
    if I < -31 then
        return 0;
    end
    if I < 0 then
        return Bit32lib.Lshift(N, -I);
    end
    for J = 1, I do
        local Topbit = Mathlib.Floor(N / 2 ^ 31);
        N = Mathlib.Floor(N / 2) + Topbit * 2 ^ 31;
    end
    return N % 2 ^ 32;
end

function Bit32lib.Lrotate(N, I)
    N = N % 2 ^ 32;
    I = I % 32;
    return (Bit32lib.Lshift(N, I) + Bit32lib.Rshift(N, 32 - I)) % 2 ^ 32;
end

function Bit32lib.Rrotate(N, I)
    N = N % 2 ^ 32;
    I = I % 32;
    return (Bit32lib.Rshift(N, I) + Bit32lib.Lshift(N, 32 - I)) % 2 ^ 32;
end

function Bit32lib.Extract(N, F, W)
    N = N % 2 ^ 32;
    N = Mathlib.Floor(N / 2 ^ F);
    local Result = 0;
    local Bit = 1;
    for I = 1, W do
        if N % 2 == 1 then
            Result = Result + Bit;
        end
        Bit = Bit * 2;
        N = Mathlib.Floor(N / 2);
    end
    return Result;
end

function Bit32lib.Replace(N, R, F, W)
    local Mask = 0;
    local Bit = 1;
    for I = 1, W do
        Mask = Mask + Bit;
        Bit = Bit * 2;
    end
    Mask = Mask * 2 ^ F;
    N = N % 2 ^ 32;
    R = R % 2 ^ 32;
    N = N - (N % (2 ^ F) % (2 ^ W) * 2 ^ F);
    R = (R % 2 ^ W) * 2 ^ F;
    return (N + R) % 2 ^ 32;
end

function Bit32lib.Countlz(N)
    N = N % 2 ^ 32;
    local Count = 0;
    for I = 31, 0, -1 do
        if Bit32lib.Extract(N, I) == 0 then
            Count = Count + 1;
        else
            break;
        end
    end
    return Count;
end

function Bit32lib.Countrz(N)
    N = N % 2 ^ 32;
    local Count = 0;
    for I = 0, 31 do
        if Bit32lib.Extract(N, I) == 0 then
            Count = Count + 1;
        else
            break;
        end
    end
    return Count;
end

function Bit32lib.Byteswap(N)
    N = N % 2 ^ 32;
    local B1 = Bit32lib.Extract(N, 0, 8);
    local B2 = Bit32lib.Extract(N, 8, 8);
    local B3 = Bit32lib.Extract(N, 16, 8);
    local B4 = Bit32lib.Extract(N, 24, 8);
    return (B1 * 2 ^ 24 + B2 * 2 ^ 16 + B3 * 2 ^ 8 + B4) % 2 ^ 32;
end

local Oslib = {};

function Oslib.Difftime(T2, T1)
    return T2 - T1;
end

local Vectorlib = {};

function Vectorlib.Create(X, Y, Z)
    return {X = X, Y = Y, Z = Z};
end

function Vectorlib.Magnitude(V)
    return Mathlib.Sqrt(V.X * V.X + V.Y * V.Y + V.Z * V.Z);
end

function Vectorlib.Normalize(V)
    local M = Vectorlib.Magnitude(V);
    if M == 0 then
        return Vectorlib.Create(0, 0, 0);
    end
    return Vectorlib.Create(V.X / M, V.Y / M, V.Z / M);
end

function Vectorlib.Cross(A, B)
    return Vectorlib.Create(A.Y * B.Z - A.Z * B.Y, A.Z * B.X - A.X * B.Z, A.X * B.Y - A.Y * B.X);
end

function Vectorlib.Dot(A, B)
    return A.X * B.X + A.Y * B.Y + A.Z * B.Z;
end

function Vectorlib.Angle(A, B, Axis)
    local D = Vectorlib.Dot(A, B);
    local M = Vectorlib.Magnitude(A) * Vectorlib.Magnitude(B);
    local Cos = D / M;
    if Cos < -1 then
        Cos = -1;
    end
    if Cos > 1 then
        Cos = 1;
    end
    local Angle = Mathlib.Acos(Cos);
    if Axis then
        local Cross = Vectorlib.Cross(A, B);
        local Sign = Vectorlib.Dot(Cross, Axis);
        if Sign < 0 then
            Angle = -Angle;
        end
    end
    return Angle;
end

function Vectorlib.Floor(V)
    return Vectorlib.Create(Mathlib.Floor(V.X), Mathlib.Floor(V.Y), Mathlib.Floor(V.Z));
end

function Vectorlib.Ceil(V)
    return Vectorlib.Create(Mathlib.Ceil(V.X), Mathlib.Ceil(V.Y), Mathlib.Ceil(V.Z));
end

function Vectorlib.Abs(V)
    return Vectorlib.Create(Mathlib.Abs(V.X), Mathlib.Abs(V.Y), Mathlib.Abs(V.Z));
end

function Vectorlib.Sign(V)
    return Vectorlib.Create(Mathlib.Sign(V.X), Mathlib.Sign(V.Y), Mathlib.Sign(V.Z));
end

function Vectorlib.Clamp(V, Min, Max)
    return Vectorlib.Create(Mathlib.Clamp(V.X, Min.X, Max.X), Mathlib.Clamp(V.Y, Min.Y, Max.Y), Mathlib.Clamp(V.Z, Min.Z, Max.Z));
end

function Vectorlib.Max(...)
    local Args = {...};
    local Xmax = Args[1].X;
    local Ymax = Args[1].Y;
    local Zmax = Args[1].Z;
    for I = 2, #Args do
        if Args[I].X > Xmax then
            Xmax = Args[I].X;
        end

        if Args[I].Y > Ymax then
            Ymax = Args[I].Y;
        end

        if Args[I].Z > Zmax then
            Zmax = Args[I].Z;
        end
    end
    return Vectorlib.Create(Xmax, Ymax, Zmax);
end

function Vectorlib.Min(...)
    local Args = {...};
    local Xmin = Args[1].X;
    local Ymin = Args[1].Y;
    local Zmin = Args[1].Z;

    for I = 2, #Args do
        if Args[I].X < Xmin then
            Xmin = Args[I].X;
        end

        if Args[I].Y < Ymin then
            Ymin = Args[I].Y;
        end

        if Args[I].Z < Zmin then
            Zmin = Args[I].Z;
        end
    end
    return Vectorlib.Create(Xmin, Ymin, Zmin);
end

return {
    global = Globallib,
    math = Mathlib,
    table = Tablelib,
    string = Stringlib,
    bit32 = Bit32lib,
    os = Oslib,
    vector = Vectorlib
};
