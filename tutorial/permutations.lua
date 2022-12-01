#!/usr/bin/env lua
-- Coroutines as Iterators
-- create, wrap, resume, yield
-- https://www.lua.org/pil/9.3.html


local function printResult (a)
    for _,v in ipairs(a) do
        io.write(v, " ")
    end
    io.write("\n")
end -- printResult

local function permgen (a, n)
    if n == 0 then
        --printResult(a)
        coroutine.yield(a)
    else
        for i=1,n do

            -- put i-th element as the last one
            a[n], a[i] = a[i], a[n]

            -- generate all permutations of the other elements
            permgen(a, n - 1)

            -- restore i-th element
            a[n], a[i] = a[i], a[n]

        end
    end
end -- permgen

--permgen ({1,2,3,4}, 4)

local function perm(a)
    local n = table.getn(a)

    --return coroutine.wrap(function () permgen(a, n) end)

    local co = coroutine.create(function () permgen(a, n) end)
    return function()  -- iterator
        local _, res = coroutine.resume(co)
        return res
    end

end -- perm

--permgen({'a','b','c'}, 3)
for p in perm{"a", "b", "c"} do
    printResult(p)
end
