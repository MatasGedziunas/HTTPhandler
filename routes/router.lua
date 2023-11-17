package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require("utils.helper")
local parser = require("utils.parser")
local content_type = require("utils.content_type")
local status_code = require("utils.status_code")
local validator = require("utils.validation")
local user_controller = require("controllers.user_controller")
local responses = require("utils.responses")
local routes = require("routes.routes")
local middleware = require("middleware.middleware")
local response = require("models.response")

local router = {}
function router:route(endpoint)
    local found = 0
    local request = endpoint.request
                -- local success, response = middleware:handle_request(response, request)
            -- if not success then
            --     endpoint.send(response)
            --     return
            -- end
    local check_url_fail = 0
        
    for i, route in ipairs(routes) do
        local splited_handler_string = split_string(route.handler, ".")
        local controller, method = splited_handler_string[1], splited_handler_string[2]
        local check_method, check_url = check_method_and_url(request:get_method(), request:parsed_url(), route.method, route.path)
        if check_method and check_url then
            local success, error_response = middleware:handle_request(request, route.midleware)
            if not success then
                endpoint.send(error_response)
                return
            end
            
            local controller_path = "/www/cgi-bin/controllers/" .. controller .. ".lua"
            local user_controller = loadfile(controller_path)()
            if user_controller[method] and type(user_controller[method]) == "function" then
                endpoint.send(user_controller[method](0, response, request)) -- do not change 0 must be passed
            else
                endpoint.send(responses:method_not_found())
            end 
            found = 1
            break
        elseif check_url then
            check_url_fail = 1
        end     
    end

    if check_url_fail == 1 and found ~= 1 then
        endpoint.send(response:set_error("Url exists, however request method not supported"))
    elseif found ~= 1 then
        endpoint.send(response:set_status_code(status_code.NOT_FOUND)
                :set_error("Route not found"))
    end
end


return router