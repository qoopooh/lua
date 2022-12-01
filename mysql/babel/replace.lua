#!/usr/bin/env lua
-- Replace text for tp_key
--
-- e.g. ./replace.lua grp_yorname__pnl_qiwi__payment_summary_title
--      -p '%%__amount%% บาท' -r 'RUB %%__amount%%'

local argparse = require "argparse"
local parser = argparse("Text replace", "for Babel tp_key")
parser:argument("tp_key", "babel key (tp_key)")
parser:option("-p --pattern", "Search pattern")
parser:option("-r --repl", "Replaced pattern")
parser:flag("-v --verbose", "Print more data")


local function get_connection()
    local driver = require "luasql.mysql"
    local env = driver.mysql()

    local user = os.getenv("SDDB_USER") or "root"
    local password = os.getenv("SDDB_PASS") or "123456"
    local database = os.getenv("SDDB_BABEL") or "babel"
    local hostname = "sdv2prdsql02.simdif.local"

    return env:connect(database, user, password, hostname)
end -- get_connection

local function get_text_id(conn, tp_key)

    local cursor, err = conn:execute("SELECT text_id FROM text_panel WHERE tp_key='".. tp_key.. "'")
    if err then
        print(err)
        os.exit()
    end

    local row = cursor:fetch ({}, "a")
    cursor:close()
    if not row then
        print(tp_key .. " not found")
        os.exit()
    end

    return row.text_id
end -- get_text_id

local function search_text_table(conn, text_id, pattern)
    local sql = string.format("SELECT text FROM text WHERE id = %s", text_id)
    local cursor, err = conn:execute(sql)
    if err then
        print(err)
        os.exit()
    end

    local row = cursor:fetch ({}, "a")
    cursor:close()

    local text = row.text
    local count = 0
    local msg = "Found " .. pattern .. ": "
    for w in string.gmatch(text, pattern) do
        if count > 0 then
            msg = msg .. ", " .. w
        else
            msg = msg .. w
        end
        count = count + 1
    end

    if count == 0 then
        return "Cannot find `" .. pattern .. "` in `" .. text .. "`"
    end

    return msg .. " (" .. count .. ")"
end -- search_text_table

local function replace_text_table(conn, text_id, pattern, repl)
    local sql = string.format("SELECT text FROM text WHERE id = %s", text_id)
    local cursor, err = conn:execute(sql)
    if err then
        print(err)
        os.exit()
    end

    local row = cursor:fetch ({}, "a")
    cursor:close()

    local text = row.text:gsub(pattern, repl)
    if text == row.text then
        return "\n"
    end

    return string.format("UPDATE text SET text = '%s' WHERE id = %s;\n",
                         text, text_id)
end -- replace_text_table

--
-- Array to query string e.g. "'xx', 'xx'"
--
local function codesToString(arr)
    local msg = nil

    for _, code in ipairs(arr) do
        if msg then
            msg = msg .. ", '" .. code .. "'"
        else
            msg = "'" .. code .. "'"
        end
    end

    return msg
end -- codesToString

--
-- Search / Replace in entry table
--
local function entry_table(conn, text_id, pattern, repl, verbose)
    local sql = string.format([[SELECT entry.id, entry, language.code
FROM entry, language
WHERE entry.text_id = %s
AND entry.language_id = language.id
AND approve_id IS NOT NULL
]], text_id)
    local cursor, err = conn:execute(sql)
    if err then
        print(err)
        os.exit()
    end

    local msg = ''
    local row = cursor:fetch ({}, "a")
    local results = {}
    local approved_languages = {}
    local patt_count = {}
    while row do

        if row.entry then
            for _ in string.gmatch(row.entry, pattern) do
                if patt_count[row.code] then
                    patt_count[row.code] = patt_count[row.code] + 1
                else
                    patt_count[row.code] = 1
                end
            end
        end

        table.insert(results, {
            id = row.id,
            entry = row.entry,
            code = row.code,
        })
        table.insert(approved_languages, row.code)

        row = cursor:fetch(row, "a")
    end
    cursor:close()

    -- Non approved languages
    sql = string.format([[SELECT entry.id, entry, language.code
FROM entry, language
WHERE entry.text_id = %s
AND entry.language_id = language.id
AND language.code NOT IN (%s)
]], text_id, codesToString(approved_languages))
    --print(sql)

    cursor = conn:execute(sql)
    row = cursor:fetch ({}, "a")
    local duplicated_languages = {}
    while row do
        local found = false

        for _, code in ipairs(duplicated_languages) do
            if code == row.code then
                found = true
                break
            end
        end

        if not found then

            if row.entry then
                for _ in string.gmatch(row.entry, pattern) do
                    if patt_count[row.code] then
                        patt_count[row.code] = patt_count[row.code] + 1
                    else
                        patt_count[row.code] = 1
                    end
                end
            end

            table.insert(results, {
                id = row.id,
                entry = row.entry,
                code = row.code,
            })
            table.insert(duplicated_languages, row.code)
            --print(row.code)
        end

        row = cursor:fetch(row, "a")
    end
    cursor:close()

    for _, obj in ipairs(results) do
        if repl then
            if patt_count[obj.code] and patt_count[obj.code] > 0 then
                local text = obj.entry:gsub(pattern, repl)
                msg = msg .. string.format([[UPDATE entry SET entry = '%s'
WHERE id = %s;
]], text, obj.id)
            end
        else
            if not patt_count[obj.code] or patt_count[obj.code] == 0 then
                msg = msg .. string.format("%s: 0\n", obj.code)
                if verbose and obj.entry then
                    msg = msg .. string.format("  (%s)\n", obj.entry)
                end
            else
                msg = msg .. string.format("%s: %s\n", obj.code, patt_count[obj.code])
            end
        end
    end

    return msg
end -- entry_table

local function replace(tp_key, pattern, repl, verbose)
    local conn = assert(get_connection())

    local text_id = get_text_id(conn, tp_key)
    if not pattern then
        print(tp_key .. " exists (" .. text_id .. ")")
        os.exit()
    end

    if not repl then
        local text = search_text_table(conn, text_id, pattern)
        print(text)
        local entries = entry_table(conn, text_id, pattern, nil, verbose)
        print(entries)
        os.exit()
    end

    local sql = replace_text_table(conn, text_id, pattern, repl)
    print(sql)

    sql = entry_table(conn, text_id, pattern, repl, verbose)
    print(sql)
end -- replace


local args = parser:parse()
replace(args.tp_key, args.pattern, args.repl, args.verbose)
