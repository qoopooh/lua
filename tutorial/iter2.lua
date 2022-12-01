#!/usr/bin/env lua
-- Iterators with Complex State
-- https://www.lua.org/pil/7.4.html
-- https://www.lua.org/pil/11.5.html

local function Set (list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end -- Set

local function iterator(state)
    local SPECIAL_WORDS = Set{"bye", "while", "end", "function", "local",}
    local SPECIAL_ENDING_CHARS = Set{'.', '?'}

    while state.line do     -- repeat while there are lines
        local s, e = string.find(state.line, "%w+", state.pos)
        if s then
            -- update next position
            state.pos = e + 1
            local word = string.sub(state.line, s, e)

            if SPECIAL_WORDS[word] then
                -- ending with special word
                state.line = nil
            end

            return word
        else

            if SPECIAL_ENDING_CHARS[string.sub(state.line, -1)] then
                -- ending with special character
                return nil
            end

            state.line = io.read()      -- try next line...
            state.pos = 1
        end
    end
    return nil
end -- iterator

local function allwords()
    local state = {line = io.read(), pos = 1}
    return iterator, state
end -- allwords

for word in allwords() do
    print(word)
end
