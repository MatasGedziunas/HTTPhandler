package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require("ubus")
local conn = ubus.connect()
if not conn then
    Fail = 1
end
local status_codes = require("utils.status_code")
local responses = require("utils.responses")
local checker = {}

function checker:check_auth(key)
    if Fail == 1 then
        return responses:failed_ubus_connnection()
    end
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