--
-- Get database connection
--
local driver = require "luasql.mysql"

local function get_connection()
    local env = driver.mysql()

    local user = os.getenv("SDDB_USER") or "root"
    local password = os.getenv("SDDB_PASS") or "123456"
    local database = os.getenv("SDDB_YORNAME") or "yornamedb"
    local hostname = os.getenv("SDDB_HOST") or "sdv2labsql02.simdif.local"

    return env:connect(database, user, password, hostname)
end -- get_connection

return get_connection
