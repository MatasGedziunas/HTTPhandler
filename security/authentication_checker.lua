package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require("ubus")
local conn = ubus.connect()
if not conn then
    error("Failed to connect to ubus")
end
local status_codes = require("utils.status_code")

local checker = {}

function checker:check_auth(key)
    local data = conn:call("session", "get", {ubus_rpc_session = key})
    if not data then
        return status_codes.BAD_REQUEST.code
    end
    return true
end

return checker