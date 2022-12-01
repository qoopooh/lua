#!/usr/bin/env lua
-- https://www.lua.org/pil/13.4.5.html

local function readOnly(t)
    local proxy = {}
    local mt = {
        __index = t,
        __newindex = function(_, _, _)
            error("attempt to update a read-only table", 2)
        end
    }

    setmetatable(proxy, mt)
    return proxy
end -- readOnly

local function main()
    local t1 = readOnly{"Sunday", "Monday"}
    t1 = readOnly(t1)
    print(t1[1])

    local t2 = readOnly{["a"]=1, ["b"]="OK"}
    t2 = readOnly(t2)
    print(t2.a)
    print(t2.b)
    t2.c = "NG"     -- error
end -- main

if not package.loaded['proxy'] then
    main()
end

return readOnly
