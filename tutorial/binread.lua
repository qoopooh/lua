#!/usr/bin/env lua
-- https://www.lua.org/pil/21.2.2.html

local f = assert(io.open(arg[1], "rb"))
local block = 10
while true do
    local bytes = f:read(block)
    if not bytes then break end
    for b in string.gmatch(bytes, ".") do
        io.write(string.format("%02X ", string.byte(b)))
    end
    io.write(string.rep("    ", block - string.len(bytes) + 1))
    io.write(string.gsub(bytes, "%c", "."), "\n")
end