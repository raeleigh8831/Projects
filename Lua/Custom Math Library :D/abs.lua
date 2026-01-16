local function abs(args)
    if type(args) ~= "number" then
        error("argument is not a number")
    elseif args ~= args then
        return args           -- NaN case
    elseif args == 0 then
        error("argument is zero will return 0")
        return 0
    elseif args == -0 then
        error("argument is negative zero will return 0")
        return 0
    else
        return args < 0 and -args or args
    end
end
