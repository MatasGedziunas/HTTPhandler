package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require("utils.helper")
local parser = require("utils.parser")
local content_type = require("utils.content_type")
local status_code = require("utils.status_code")
local validator = require("utils.validation")
local user_controller = require("controllers.user_controller")
local responses = require("utils.responses")
local routes = require("utils.routes")
local middleware = require("models.middleware")
local response = require("models.response")

local router = {}
function router:route(endpoint)
    local found = 0
    local request = endpoint.request
     -- print(response, request)
    for i, route in ipairs(routes) do
        local splited_handler_string = split_string(route.handler, ".")
        local controller, method = splited_handler_string[1], splited_handler_string[2]
        if check_path(request:get_method(), request:parsed_url(), route.method, route.path) then
            local success, error_response = middleware:handle_request(response, request)
            if not success then
                endpoint.send(error_response)
                return
            end
            local controller_path = "/www/cgi-bin/controllers/" .. controller .. ".lua"
            --endpoint.send(response:set_data(controller_path))
            local user_controller = loadfile(controller_path)()
            if user_controller[method] and type(user_controller[method]) == "function" then
                print(response, request)
                endpoint.send(user_controller[method](0, response, request)) -- do not change 0 must be passed
            else
                endpoint.send(responses:method_not_found())
            end 
            found = 1
            break
        end
        
    end
    if found ~= 1 then
        endpoint.send(response:set_status_code(status_code.NOT_FOUND)
                :set_data("Route not found"))
    end
end


return router