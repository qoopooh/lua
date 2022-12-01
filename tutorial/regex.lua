#!/usr/bin/env lua
-- https://www.lua.org/pil/20.4.html

local function code (s)
    return (string.gsub(s, "\\(%A)", function (x)
        return string.format("\\%03d", string.byte(x))
    end))
end -- code

local function decode (s)
    return (string.gsub(s, "\\(%d%d%d)", function (d)
        return "\\" .. string.char(d)
    end))
end

local s = [[follows a typical string: "This is \"great\"!".]]
s = string.gsub(s, '(".-")', string.upper)
print(s)
print(decode(string.gsub(code(s), '(".-")', string.upper)))

s = [[a \emph{command} is written as \\command\{text\}.]]
s = code(s)
s = string.gsub(s, "\\(%a+){(.-)}", "<%1>%2</%1>")
print(decode(s))
