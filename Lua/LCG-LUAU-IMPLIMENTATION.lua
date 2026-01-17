local function Lcg(Seed)
    local MulOne = 1103515245;
    local MulTwo = 1664525;
    local AddOne = 12345;
    local AddTwo = 1013904223;
    local ModOne = 4294967296;
    local ModTwo = 2147483648;

    local Temp = Seed;
    Temp = (Temp * MulOne + AddOne) % ModTwo;
    Temp = (Temp * MulTwo + AddTwo) % ModOne;
    Temp = (Temp * (MulOne - AddOne) + (AddTwo - MulTwo)) % ModOne;
    Temp = (Temp + (Temp % 65537) * 48271) % ModOne;

    return Temp;
end
