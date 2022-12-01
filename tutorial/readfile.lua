#!/usr/bin/env lua
-- 11.6 – String Buffers
-- https://www.lua.org/pil/11.6.html

local infile = arg[1]
if not infile then
    print("Please add file to read")
    os.exit()
end


local function simple_read()
    local file = io.open(infile, "r")
    local buff = ""

    for line in file:lines() do
        buff = buff .. line .. "\n"
    end

    return string.len(buff)
end -- simple_read


local function read_all()
    local file = io.open(infile, "r")
    local buff = file:read("*all")

    return string.len(buff)
end -- read_all


local function newStack()
    return {""}
end -- newStack

local function addString(stack, s)
    table.insert(stack, s)
    --for i=table.getn(stack) - 1, 1, -1 do
    for i=#stack - 1, 1, -1 do
        if string.len(stack[i]) > string.len(stack[i+1]) then
            break
        end
        stack[i] = stack[i] .. table.remove(stack)
    end
end -- addString

local function string_buffer()
    local file = io.open(infile, "r")
    local stack = newStack()

    for line in file:lines() do
        addString(stack, line .. "\n")
    end

    return string.len(table.concat(stack))
end -- string_buffer


local function get_seconds(clock_diff)
    return clock_diff
end -- get_seconds


local function measure()
    print('Reading ' .. infile)

    local start_time = os.clock()
    local out = simple_read()
    local end_time = os.clock()
    print("simple_read " .. out .. ": " .. get_seconds(end_time - start_time) .. " seconds")

    start_time = os.clock()
    out = read_all()
    end_time = os.clock()
    print("read_all " .. out .. ": " .. get_seconds(end_time - start_time) .. " seconds")

    start_time = os.clock()
    out = string_buffer()
    end_time = os.clock()
    print("string_buffer " .. out .. ": " .. get_seconds(end_time - start_time) .. " seconds")

end -- measure

measure()
