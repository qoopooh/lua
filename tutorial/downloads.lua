#!/usr/bin/env lua
-- 9.4 – Non-Preemptive Multithreading
-- https://www.lua.org/pil/9.4.html

local socket = require "socket"
local threads = {}      -- list of all live threads

local function receive(conn)
    --conn:timeout(0)     -- does not work
    local s, status = conn:receive(2^10)

    --if status == "timeout" then
        coroutine.yield(conn)
    --end

    return s, status
end -- receive

local function download(host, file)
    local c = assert(socket.connect(host, 80))
    local count = 0     -- counts number of bytes read

    c:send("GET "..file.." HTTP/1.0\r\n\r\n")
    while true do
        local s, status = receive(c)

        if status == "closed" then
            -- s is nil
            break
        end
        count = count + string.len(s)
    end
    c:close()
    print(file, count)
end -- download

local function get(host, file)
    -- create coroutine
    local co = coroutine.create(function()
        download(host, file)
    end)

    -- insert it in the list
    table.insert(threads, co)
end

local function dispatcher()
    while true do
        local n = table.getn(threads)
        --print("dispatching "..n)
        if n == 0 then break end    -- no more thrreads to run
        for i=1,n do
            local _, res = coroutine.resume(threads[i])
            if not res then
                -- thread finished its task
                table.remove(threads, i)
                break
            end
        end -- for i=1,n
    end -- while
end -- dispatcher


local host = "www.w3.org"

get(host, "/TR/1999/REC-html401-19991224/html40.txt")
get(host, "/TR/2002/REC-xhtml1-20020801/xhtml1.pdf")
get(host, "/TR/2018/SPSD-html32-20180315/")
get(host, "/TR/2000/REC-DOM-Level-2-Core-20001113/DOM2-Core.txt")

dispatcher()   -- main loop
