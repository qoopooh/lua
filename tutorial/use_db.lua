#!/usr/bin/env lua
-- 10.1 – Data Description
-- https://www.lua.org/pil/10.1.html
-- https://www.lua.org/pil/12.html

local users = {}

local function print_name(obj)
    print(obj.name .. " (" .. obj.username .. ")")
end -- print_name

local function print_info(obj)
    print_name(obj)
    print(obj.name .. " is " .. obj.age .. " years old.")
    print(obj.description .. "\n")

    if obj.username then users[obj.username] = true end
end -- print_info

local function print_users()
    local count = 0

    for _ in pairs(users) do
        count = count + 1
    end
    print("\n" .. count .. " user(s):")
    for username, _ in pairs(users) do
        print("\t- " .. username)
    end
end -- print_users


user = print_info
dofile("db.lua")

print_users()
