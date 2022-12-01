#!/usr/bin/env lua
-- https://www.lua.org/pil/6.html

local network = {
  {name = "grauna",  IP = "210.26.30.34"},
  {name = "arraial", IP = "210.26.30.23"},
  {name = "lua",     IP = "210.26.23.12"},
  {name = "derain",  IP = "210.26.23.20"},
}

local function print_network()
  for _, node in ipairs(network) do
    print(node.name, node.IP)
  end
  print()
end
print_network()

--
-- Sort table
--
local order = function (a, b)
  --return a.name < b.name
  return a.IP < b.IP
end
table.sort(network, order)
print_network()
