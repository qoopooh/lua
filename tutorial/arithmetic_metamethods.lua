#!/usr/bin/env lua
-- https://www.lua.org/pil/13.1.html
-- https://www.lua.org/pil/13.2.html
-- https://www.lua.org/pil/13.3.html

local Set = {}

Set.mt = {}

function Set.new(t)
    local set = {}
    setmetatable(set, Set.mt)
    for _, l in ipairs(t) do set[l] = true end
    return set
end -- new

function Set.union(a, b)
    local res = Set.new{}
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = true end
    return res
end -- union

function Set.intersection(a, b)
    local res = Set.new{}
    for k in pairs(a) do
        res[k] = b[k]
    end
    return res
end -- intersection

function Set.tostring(set)
    local s = "{"
    local sep = ""
    for e in pairs(set) do
        s = s .. sep .. e
        sep = ", "
    end
    return s .. "}"
end -- tostring

function Set.print(s)
    print(Set.tostring(s))
end -- print

Set.mt.__tostring = Set.tostring
Set.mt.__metatable = "hiding"       -- protect setmetatable
Set.mt.__add = Set.union
Set.mt.__mul = Set.intersection

Set.mt.__le = function(a,b)
    for k in pairs(a) do
        if not b[k] then return false end
    end
    return true
end -- __le

Set.mt.__lt = function(a,b)
    return a <= b and not (b <= a)
end -- __lt

Set.mt.__eq = function(a,b)
    return a <= b and b <= a
end -- __eq

local s1 = Set.new{10, 20, 30, 50}
local s2 = Set.new{30, 1, 2, 3, 4, 5}
local s3 = s1 + s2

--print(getmetatable(s1))

Set.print(s3)
print(getmetatable(s3))
Set.print(s1 * s2)
Set.print((s1 + s2) * s1)
print(s1 <= s2)

--
-- error cannot set metatable twice if we set a __metatable field
--
--setmetatable(s1, {})
