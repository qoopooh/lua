#!/usr/bin/env lua
-- https://www.lua.org/pil/9.2.html


local function receive(prod)
    local _, value = coroutine.resume(prod)
    return value
end -- receive

local function send(x)
    coroutine.yield(x)
end -- send

local function producer()
    return coroutine.create(function()
        while true do
            local x = io.read()
            send(x)
        end -- while
    end) -- return
end -- producer

local function filter (prod)
    return coroutine.create(function()
        local line = 1
        while true do
            local x = receive(prod) -- get new value
            x = string.format("%d %s", line, x)
            send(x)
            line = line + 1
        end -- while
    end) -- return
end -- filter

local function consumer(prod)
    while true do
        local x = receive(prod)
        io.write(x, "\n")
        if string.find(x, 'exit') then
            break
        end
    end
end -- consumer


-- p = producer()
-- f = filter(p)
-- consumer(f)
-- or ...
consumer(filter(producer()))
