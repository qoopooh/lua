#!/usr/bin/env lua
-- Check sum
-- https://memo8.com/check-digit-thai-citizen-id-validator/

local function calculate(id)
    local sum = 0
    for i = 1, 12 do
        sum = sum + (14 - i) * id:sub(i, i)
    end
    local remainder = 11 - (sum % 11)
    if remainder > 9 then
        return 0
    end
    return remainder
end -- calculate

local function trim(s)
   return (s:gsub("%D", ""))
end -- trim

local function load()

    local id = arg[1]
    if not id or id:len() < 12 then
        io.write("Please type your ID card number: ")
        id = io.read()
    end

    id = trim(id)
    if id:len() < 12 then
        print("Need Thai ID card number")
        os.exit()
    end

    local remainder = calculate(id)
    if id:len() > 12 then
        if remainder == tonumber(id:sub(13, 13)) then
            print("OK")
            os.exit()
        end
        print("FAILED")
    end
    print("Sum: " .. remainder)
end -- load

load()
