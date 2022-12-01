#!/usr/bin/env lua
-- 16.3 – Multiple Inheritance
-- https://www.lua.org/pil/16.3.html

local oop = require "oop"

local function search(k, plist)
    for i=1, table.getn(plist) do
        local v = plist[i][k]
        if v then return v end
    end
end

local function createClass (...)
    local c = {}
    setmetatable(c, {__index = function(t, k)
        local v = search (k, arg)
        t[k] = v    -- save for nex access
        return v
    end})

    -- prepare `c' to be the metatable of its instances
    c.__index = c

    -- define a new constructor for this new class
    function c:new(o)
        o = o or {}
        setmetatable(o, c)
        return o
    end

    -- return new class
    return c
end -- createClass

local Named = {}

function Named:getname()
    return self.name
end

function Named:setname(n)
    self.name = n
end

local NamedAccount = createClass(oop.Account, Named)

local account = NamedAccount:new{name = "Paul"}
print(account:getname())
