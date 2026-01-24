--// They can check closure using debug info or use simple detections to detect this, this is only for some stuff i do not recommend using this for production :3

local Oldloadstring;
local Counter = 0;

pcall(makefolder, "Results");

Oldloadstring = hookfunction(loadstring, function(Source)
    Counter = Counter + 1;

    local Filename = string.format(
        "Results/loadstring_%d_%d.lua",
        time(),
        Counter
    );

    writefile(Filename, Source);

    return Oldloadstring(Source);
end);
-- print("Works")
