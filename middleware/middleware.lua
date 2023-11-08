package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require("utils.helper")
local status_codes = require("utils.status_code")
local content_types = require("utils.content_type")
local auth_checker = require("security.authentication_checker")
local response = require("models.response")
local middleware = {}

function middleware:handle_request(request, route_middleware) 
    if(table_contains(route_middleware, "auth")) then
        if not request:header("rpc-key") then
            return false, response:set_status_code(status_codes.BAD_REQUEST):set_error("Missing authentication key")
        end 
        if(not auth_checker:check_auth(request:header("rpc-key"))) then
            return false, response:set_status_code(status_codes.BAD_REQUEST):set_error("Failed authentication")
        end
    end
    return true
end

return middleware