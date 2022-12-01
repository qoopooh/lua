#!/usr/bin/env lua
-- Notice that, unfortunately, this scheme does not allow us
-- to traverse tables. The pairs function will operate on the proxy,
-- not on the original table.
-- https://www.lua.org/pil/13.4.4.html

local table_id = require "table_id"
local index = {}    -- create private index

local mt = {
    __index = function(t,k)
        print("*access " .. tostring(k) .. " of " .. table_id(t))
        return t[index][k]    -- access the original table
    end,

    __newindex = function(t,k,v)
        local old = t[index][k]
        local msg = "*update "..tostring(k).." of "..table_id(t)

        if old then
            print(msg .. " " .. old .. " -> " .. tostring(v))
        else
            print(msg .. " to " .. tostring(v))
        end
        t[index][k] = v       -- update original table
    end
}

local function track(t)
    local proxy = {}
    proxy[index] = t
    setmetatable(proxy, mt)
    return proxy
end -- track

local function main()
    local t1 = {}    -- original table (created somewhere)
    t1 = track(t1)
    t1[2] = 'hello'
    print(t1[2])
    t1['a'] = 'world'
    t1['a'] = 'world2'
    print(t1.a)

    local t2 = {}    -- another original table (created somewhere)
    t2 = track(t2)
    t2[2] = 'hello'
    print(t2[2])
    t2['a'] = 'world'
    print(t2.a)
end -- main

if not package.loaded['proxy'] then
    main()
end

return track
