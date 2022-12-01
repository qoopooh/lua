#!/usr/bin/env lua
-- https://www.tutorialspoint.com/lua/lua_database_access.htm
-- http://lunarmodules.github.io/luasql/manual.html#mysql_extensions
-- http://sdbeadm02.simdif.local/phpmyadmin/index.php?db=yorname
--

local function get_connection()
    local driver = require "luasql.mysql"
    local env = driver.mysql()

    local user = os.getenv("SDDB_USER") or "root"
    local password = os.getenv("SDDB_PASS") or "123456"
    local database = os.getenv("SDDB_YORNAME") or "yornamedb"
    local hostname = os.getenv("SDDB_HOST") or "sdv2labsql02.simdif.local"

    return env:connect(database, user, password, hostname)
end -- get_connection

local function print_prices()
    local conn = assert(get_connection())
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
