#!/usr/bin/env lua
-- Check Lua reserved words
-- https://www.lua.org/pil/21.2.html

local function trim(s)
    local out = {}

    for w in s:gmatch("(%w+)") do
        table.insert(out, w)
    end

    return out[1]
    --return (s:gsub("^%s*(.-)%s*$", "%1"))
end -- trim

local function loadReservedWords()
    local words = {}
    local fp = io.open("reserved_words.txt", "r")
    for w in string.gmatch(fp:read("*all"), "%w+") do
        words[w] = true
    end
    fp:close()

    return words
end -- loadReservedWords

local function loadInput()

    local words = loadReservedWords()
    local word = arg[1]
    if not word then
        io.write("Please type a word: ")
        word = io.read()
    end

    word = trim(word)

    if words[word] then
        print("`" .. word .. "` is a reserved word.")
    else
        print("`" .. word .. "` is not reserved word.")
    end
end -- loadInput

loadInput()
