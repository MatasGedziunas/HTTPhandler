package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require("utils.helper")
local status_codes = require("utils.status_code")
local content_types = require("utils.content_type")
local middleware = {}
local AUTH_METHODS = {"POST", "PUT", "DELETE"}

function middleware:handle_request(request) 
    if table_contains(AUTH_METHODS, request.method) then
        if self:auth(request) then
            return false, set_response(status_codes.UNAUTHORIZED, content_types.HTML, "Failed authentication")
        end   
    end
    return true
end

function middleware:auth(request)
    -- do auth
    return true
end

return middleware