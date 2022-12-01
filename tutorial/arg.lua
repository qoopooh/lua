#!/usr/bin/env lua
-- https://www.lua.org/pil/5.2.html

local function g (a, b, ...)
  print('a', a)
  print('b', b)

  print('arg.n', arg.n)
  if arg.n > 0 then
    for i,v in ipairs(arg) do
      print('arg', i, v)
    end
  end
end


g(1, 2)
g(3, 4, 5)
g(6, 7, 8, 9, 10)
