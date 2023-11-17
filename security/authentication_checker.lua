package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require("ubus")
local conn = ubus.connect()
if not conn then
    error("Failed to connect to ubus")
end
local status_codes = require("utils.status_code")

local checker = {}

function checker:check_auth(key)
    local data = conn:call("session", "list", {ubus_rpc_session = key})
    -- local s = ""
    -- for k, v in pairs(data) do
    --     s = k .. " "
    -- end
    -- print(s)
    if data and data.ubus_rpc_session == key then
        return true
    end
    return false
end

return checker