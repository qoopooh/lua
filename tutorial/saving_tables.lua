#!/usr/bin/env lua
-- 12.1.2 – Saving Tables with Cycles
-- https://www.lua.org/pil/12.1.2.html

local function basicSerialize(o)
    if type(o) == "number" then
        return tostring(o)
    else
        return string.format("%q", o)
    end
end -- basicSerialize

local function save (name, value, saved)
    saved = saved or {}     -- initial value
    io.write(name, " = ")
    if type(value) == "number" or type(value) == "string" then
        io.write(basicSerialize(value), "\n")
    elseif type(value) == "table" then
        if saved[value] then
            io.write(saved[value], "\n")
        else
            saved[value] = name     -- save name for next time
            io.write("{}\n")           -- create a new table
            for k,v in pairs(value) do  -- save its fields
                local fieldname = string.format("%s[%s]", name,
                                                basicSerialize(k))
                save(fieldname, v, saved)
            end
        end
    end
end -- save

local t = {}
local a = {x=1, y=2; {3, 4, 5}}
a[1] = {}
a[1][1] = "one"
a[1][2] = "two"
a[2] = a        -- cycle
a.z = a[1]      -- shared sub-table
local b = {}
b["k"] = {}
b["k"][1] = "one"
b["k"][1] = "two"

save('a', a, t)
print(b)
