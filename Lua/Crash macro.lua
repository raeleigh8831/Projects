local function CRASH()
    local TableOne;
    local TableTwo;
    while true do
        TableOne = { [{}] = {} };
        TableTwo = {};
        TableOne[TableTwo] = 0/0;
    end;
    local Result = "Done";
    if Result == "Done" then
        repeat
        until false;
    end;
    return Result;
end;

CRASH();
