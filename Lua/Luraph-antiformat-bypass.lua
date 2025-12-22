local old_pcall; old_pcall = hookfunction(pcall, newcclosure(function(...)
    local results = {old_pcall(...)}
    local first = results[1]
    if type(first) == "boolean" and first == false then
        local second = results[2]
        if type(second) == "string" then
            results[2] = (second:gsub(":(%d+)([:\r\n])", ":1%2"))
        end
    end
    return unpack(results)
end))
