#!/usr/bin/env lua
-- https://www.lua.org/pil/14.1.html

local function getfield (f)
    local v = _G    -- start with the table of globals
    for w in string.gfind(f, "[%w_]+") do
        v = v[w]
    end
    return v
end -- getfield

local function setfield(f, v)
    local t = _G
    for w, d in string.gfind(f, "([%w_]+)(.?)") do
        if d == "." then
            t[w] = t[w] or {}
            t = t[w]
        else
            t[w] = v
        end
    end
end -- setfield


setfield("t.x.y", 10)
print(t.x.y)
print(getfield("t.x.y"))
