package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require("utils.helper")
local parser = require("utils.parser")
local content_type = require("utils.content_type")
local status_code = require("utils.status_code")
local validator = require("validations.validation")
local user_controller = require("app.controllers.user_controller")
local responses = require("utils.responses")
local routes = require("routes.routes")
local middleware = require("middleware.middleware")
local response = require("app.models.response")

local router = {}
function router:route(endpoint)
    local found = 0
    local request = endpoint.request
    local check_url_fail = 0     
    local param_not_found
    local method_not_found = 0
    for i, route in ipairs(routes) do
        local check_method, check_url = check_method_and_url(request.get_method(), request.parsed_url(), route.method, route.path)
        if check_method and check_url then
            if route.handler == nil then
                endpoint.send(response:set_status_code(status_code.INTERNAL_SERVER_ERROR):set_error("Route has no handler function set"))
                found = 1
                break
            end
            local success, error_response = middleware:handle_request(request, route.midleware)
            if not success then
                endpoint.send(error_response)
                return
            end
            local splited_handler_string = split_string(route.handler, ".")
            local controller, method = splited_handler_string[1], splited_handler_string[2]
            if method == nil then
                method = set_default_function(request.get_method())
            end
            local controller_path = "/www/app/controllers/" .. controller .. ".lua"
            local controller_file = loadfile(controller_path)
            if controller_file then
                local user_controller = loadfile(controller_path)()
                if user_controller and user_controller[method] and type(user_controller[method]) == "function" then
                    local param_needed, param_name = is_route_id_needed(route.path)
                    if param_needed then
                        local param = parser:parse_request_parametres(request.parsed_url(), route.path)
                        if param == nil then
                            if not param_not_found then
                                param_not_found = param_name
                            end
                            -- endpoint.send(responses:parameter_not_found(param_name))
                        else
                            endpoint.send(user_controller[method](0, response, request, param))
                            return
                        end
                    else
                        endpoint.send(user_controller[method](0, response, request)) -- do not change 0 must be passed
                        return
                    end
                else
                    endpoint.send(responses:method_not_found())
                    return
                end 
            else
                endpoint.send(responses:controller_not_found())
                return
            end
        elseif check_url then
            check_url_fail = 1
        end     
    end

    if found ~= 1 and param_not_found then
        endpoint.send(responses:parameter_not_found(param_not_found))
    -- elseif found ~= 1 and method_not_found then
    --     endpoint.send(responses:method_not_found())
    elseif check_url_fail == 1 and found ~= 1 then
        endpoint.send(response:set_error("Url exists, however request method not supported"):set_status_code(status_code.BAD_REQUEST))
    elseif found ~= 1 then
        endpoint.send(response:set_status_code(status_code.NOT_FOUND)
                :set_error("Route not found"))
    end
    
    
end

function set_default_function(request_method)
    if request_method == "GET" then
        return "index"
    elseif request_method == "POST" then
        return "create"
    elseif request_method == "PUT" or request_method == "PATCH" then
        return "update"
    end
end

function is_route_id_needed(path)
    local param_name = string.match(path, "{(%w+)}")
    if param_name then
        return true, param_name
    end

    return false
end


return router