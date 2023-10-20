package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require("utils.helper")
local parser = require("utils.parser")
local content_type = require("utils.content_type")
local status_code = require("utils.status_code")
local validator = require("utils.validation")
local user_controller = require("controllers.user_controller")
local responses = require("utils.responses")
local routes = require("utils.routes")

local router = {}
function router:route(endpoint)
    local response = {status_code = status_code.OK, 
    content_type = content_type.JSON,
    } 
    local found = 0
    for i, route in ipairs(routes) do
        if check_path(endpoint.request_method, endpoint.parsed_url, route.method, route.path) then
            if route.data == "parameter" then
                local params = parser:parse_request_parametres(endpoint.parsed_url)             
                if params then
                    endpoint.send(route:handler(response, params))
                else    
                    endpoint.send(responses:parameter_not_found(response))
                end
            elseif route.data == "body" then
                endpoint.send(route:handler(response, endpoint.content))
            elseif route.data == "query" then
                local params = parser:parse_url_query(endpoint.parsed_url)
                if params then
                    endpoint.send(route:handler(response, params))
                else    
                    endpoint.send(responses:parameter_not_found(response))
                end
            else
                endpoint.send(route:handler(response))
            end
            found = 1
            break
        end
    end
    if found ~= 1 then
        endpoint.send(set_response(status_code.NOT_FOUND, content_type.HTML, "Route not found", response))
    end
end


return router