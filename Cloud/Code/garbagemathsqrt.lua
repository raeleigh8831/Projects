-- Vm memeory sufficient i think with more debugs the orignal math sqrt uses some werid shit

local function squareroot(args)
    if type(args) ~= "number" then
        error("math2.squareroot: argument must be a number", 2)
    end
    if args < 0 then
        error("math2.squareroot: cannot compute square root of negative number", 2)
    end
    return args ^ 0.5
end

--[[ Example usage:
print(squareroot(16)) -- Output: 4
print(squareroot(-4)) -- Error: cannot compute square root of negative number
print(squareroot("text")) -- Error: argument must be a number
--]]
return squareroot
