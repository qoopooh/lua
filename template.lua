#!/usr/bin/env lua
-- script template

local argparse = require "argparse"
local parser = argparse("My script", "will do something")
parser:argument("file_path", "File path")
parser:option("-l --level", "optional level")

local args = parser:parse()
for k,v in pairs(args) do
    print(k,v)
end
