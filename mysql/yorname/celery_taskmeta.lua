#!/usr/bin/env lua
-- Delete celery tasks results from database
--
-- SDDB_HOST=sdv2prdsql02.simdif.local ./celery_taskmeta.lua -d 2022-12-01 -D
--

local argparse = require "argparse"
local sddb = require "sddb"

local parser = argparse("Celery Task", "Monitor / Cleaner")
parser:option("-d --date", "Query tasks before this `date` e.g. 2022-12-02")
parser:flag("-D --delete", "Delete tasks")


local function query(date, delete)
    if not date then
        local last60days = os.time{year=1970, month=1, day=60}
        date = os.date("%Y-%m-%d", os.time() - last60days)
    end

    local conn = assert(sddb())
    local sql = string.format([[SELECT COUNT(*) AS count FROM celery_taskmeta
WHERE date_done < '%s';]], date)

    local cursor, err = conn:execute(sql)
    if err then
        print(err)
        os.exit()
    end
    local row = cursor:fetch ({}, "a")
    cursor:close()

    local msg = string.format("Total %d tasks before %s", row.count, date)
    print(msg)

    if delete and row.count ~= "0" then
        sql = string.format([[DELETE FROM celery_taskmeta
WHERE date_done < '%s']], date)
        local result = conn:execute(sql)
        print("Deleted " .. result)
        cursor:close()
    end

    conn:close()
end -- query


local args = parser:parse()
--for k,v in pairs(args) do print(k,v) end
query(args.date, args.delete)
