#!/usr/bin/env lua
-- https://www.lua.org/pil/7.1.html

local function list_iter (t)
  local i = 0
  local n = table.getn(t)
  return function()
    i = i+1
    if i <= n then return t[i] end
  end
end

local t = {10, 20, 30}

-- full process
local iter = list_iter(t)
while true do
  local element = iter()
  if element == nil then break end
  print(element)
end

-- easy way
for element in list_iter(t) do
  print(element)
end

--
-- Word splitter
--
local function allwords()
  local SPECIAL_WORDS = {
    ['end']=true,
    ['bye']=true,
  }
  local SPECIAL_ENDING_CHARS = {
    ['.']=true,
    ['?']=true,
  }
  local line = io.read()
  local pos = 1

  return function()
    while line do
      local s, e = string.find(line, "%w+", pos)
      --print('s', s, 'e', e)

      if s then
        pos = e + 1
        local word = string.sub(line, s, e)

        if SPECIAL_WORDS[word] then
          -- ending with special word
          line = nil
        end

        return word
      else

        if SPECIAL_ENDING_CHARS[string.sub(line, -1)] then
          -- ending with special character
          return nil
        end

        line = io.read()
        pos = 1
      end
    end
    return nil
  end
end

for word in allwords() do
  print(word)
end

