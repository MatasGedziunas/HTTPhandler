package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require("ubus")
local conn = ubus.connect()
if not conn then
    error("Failed to connect to ubus")
end
local status_codes = require("utils.status_code")
local validations = require("utils.validation")
local REQUIRED_FIELDS = {"username", "password"}
local auth = {}

function auth:login(response, request)
    local data = request.body
    local missing_fields = validations:has_fields(data, REQUIRED_FIELDS) 
    if not (#missing_fields == 0) then
        response:set_status_code(status_codes.BAD_REQUEST)
        :set_error("Missing fields: " .. table_concat(missing_fields))
        return response
    end
    local username = request:option("username")
    local password = request:option("password")
    local login_info = conn:call("session", "login", {username = username, password = password})
    if not login_info then
        response:set_status_code(status_codes.BAD_REQUEST):set_error("Invalid login credentials")
    else 
        local temp = {}
        temp.ubus_rpc_session = login_info.ubus_rpc_session
        response:set_sucess(temp)
    end
    return response
end

function auth:destroy(key)
    local destroy = conn:call("session", "destroy", {ubus_rpc_session = key})
    if not destroy then
        return status_codes.BAD_REQUEST.code
    end
    return destroy
end 

-- print(auth:login("admin", "admin01"))
-- print(auth:destroy("4a22a74f67656dfd96481ed44ee61b0c"))

return auth
