#!/usr/bin/env lua
-- https://www.tutorialspoint.com/lua/lua_database_access.htm
-- http://lunarmodules.github.io/luasql/manual.html#mysql_extensions
-- http://sdbeadm02.simdif.local/phpmyadmin/index.php?db=yorname
--

local sddb = require "sddb"

local function print_prices()
    local conn = assert(sddb())
    local cursor, err = conn:execute([[SELECT * FROM price WHERE currency='EUR']])

    if err then
        print(err)
        os.exit()
    end

    local row = cursor:fetch ({}, "a")
    local count = 1
    while row do
       print(string.format("%s. %s: %s EUR", count, row.tld, row.amount))
       -- reusing the table of results
       row = cursor:fetch(row, "a")
       count = count + 1
    end
end -- print_prices


print_prices()
