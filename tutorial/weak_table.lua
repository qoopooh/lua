#!/usr/bin/env lua
-- https://www.lua.org/pil/17.html

local a = {}
local b = {}
setmetatable(a, b)
b.__mode = "k"         -- now `a' has weak keys
local key = {}         -- creates first key
a[key] = 1
key = {}               -- creates second key
a[key] = 2
collectgarbage()       -- forces a garbage collection cycle
for k, v in pairs(a) do print(k, v) end
