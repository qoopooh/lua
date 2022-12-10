#!/usr/bin/env lua
-- https://www.lua.org/pil/20.3.html

local function escape (s)
    s = string.gsub(s, "([&=+%c])", function (c)
            return string.format("%%%02X", string.byte(c))
        end)
    s = string.gsub(s, " ", "+")
    return s
end -- escape

local function unescape (s)
    s = string.gsub(s, "+", " ")
    s = string.gsub(s, "%%(%x%x)", function (h)
            return string.char(tonumber(h, 16))
        end)
    return s
end -- unescape

local function encode (t)
    local s = ""
    for k,v in pairs(t) do
        s = s .. "&" .. escape(k) .. "=" .. escape(v)
    end
    return s:sub(2)
end -- encode

local function decode (s)
    local cgi = {}
    for name, value in string.gmatch(s, "([^&=]+)=([^&=]+)") do
        name = unescape(name)
        value = unescape(value)
        cgi[name] = value
    end
    return cgi
end -- decode

local url = 'name=al&query=a%2Bb+%3D+c&q=yes+or+no'
local cgi = decode(url)
for k,v in pairs(cgi) do print(k,v) end

print(encode(cgi))