#!/usr/bin/env lua

local json = require "json"
local sha2 = require "sha2"

local function load_ipn()
    local fp = io.open(arg[1])
    local json_string = fp:read("*all")
    --
    -- Parse number to string for 5.1, 5.2
    -- since .0 decimal is eliminated in tostring()
    --
    -- gsub(": ([0-9.]+)", ": \"%1\"")
    -- gsub("([%w]+)\\\": ([%w]+)", "%1\\\": \\\"%2\\\"")
    json_string = json_string:gsub("([%w]+)\": ([0-9.]+)", "%1\": \"%2\"")
    --print(json_string)
    local ipn = json.decode(json_string)

    fp:close()

    return ipn
end -- load_ipn

local function get_secret(shop_id)
    local json_string = os.getenv("SECRET_KEYS")
    if not json_string then
        print('Required SECRET_KEYS')
        os.exit()
    end
    local secrets = json.decode(json_string)
    local secret = secrets[tostring(shop_id)]

    return secret
end -- get_secret

local function create_sign(ipn)
    local keys, values = {}, {}
    local secret = get_secret(ipn.shop_id)

    for key in pairs(ipn) do
        if key ~= "sign" then
            table.insert(keys, key)
        end
    end
    table.sort(keys)

    for _, key in ipairs(keys) do
        local val = ipn[key]
        if val ~= nil and val ~= "" then
            table.insert(values, val)
        end
    end

    local text = table.concat(values, ":") .. secret
    local sign = sha2.sha256(text)

    return sign
end -- create_sign

local function verify()
    local ipn = load_ipn()
    local ipn_sign = ipn.sign

    local sign = create_sign(ipn)

    if sign == ipn_sign then
        print("OK")
    else
        print(ipn_sign .. " -> " .. sign)
    end
end -- verify

verify()
