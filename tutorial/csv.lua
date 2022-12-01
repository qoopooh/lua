#!/usr/bin/env lua
-- https://www.lua.org/pil/20.4.html

local function escapeCSV (s)
    if s:find('[,"]') then
        s = '"' .. s:gsub('"', '""') .. '"'
    end
    return s
end

local function toCSV (t)
    local s = ""
    for _, p in pairs(t) do
        s = s .. "," .. escapeCSV(p)
    end
    return s:sub(2)
end -- toCSV

local function fromCSV (s)
    s = s .. ','    -- ending comma
    local t = {}
    local fieldstart = 1
    repeat
        if s:find('^"', fieldstart) then
            -- next field is quoted
            local a, c
            local i = fieldstart
            repeat
                -- find closing quote
                a, i, c = s:find('"("?)', i+1)
                if not a then
                    error("double quoted")
                end
            until c ~= '"'
            if not i then error('unmatched "') end
            local f = s:sub(fieldstart+1, i-1)
            table.insert(t, (f:gsub('""', '"')))
            fieldstart = s:find(',', i) + 1
        else
            local nexti = s:find(',', fieldstart)
            table.insert(t, s:sub(fieldstart, nexti-1))
            fieldstart = nexti + 1
        end
    until fieldstart > s:len()

    return t
end -- fromCSV

local t = {'a b', 'a,b', ' a,"b"c', 'hello "world"!', ''}
print(toCSV(t))

local csv = '"hello "" hello", "",""'
print(csv)
t = fromCSV(csv)
for i,s in ipairs(t) do print(i,s) end
