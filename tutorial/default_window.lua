#!/usr/bin/env lua
-- The __index Metamethod
-- https://www.lua.org/pil/13.4.1.html

-- create a namespace
local Window = {}
-- create the prototype with default values
Window.prototype = {x=0, y=0, width=100, height=100}
-- create a metatable
Window.mt = {}
-- declare the constructor function
function Window.new(o)
    setmetatable(o, Window.mt)
    return o
end

Window.mt.__index = function(_, key)
    return Window.prototype[key]
end -- __index

Window.mt.__tostring = function(o)
    local s = "{"
    local sep = ""
    for k in pairs(Window.prototype) do
        s = s .. sep .. k .. "=" .. o[k]
        sep = ", "
    end
    return s .. "}"
end -- __tostring


local w = Window.new{x=10, y=20}
print(w)
