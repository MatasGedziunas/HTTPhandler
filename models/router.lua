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
                -- local success, response = middleware:handle_request(response, request)
            -- if not success then
            --     endpoint.send(response)
            --     return
            -- end
    local check_url_fail = 0
    for i, route in ipairs(routes) do
        local check_method, check_url = check_url_and_method(request:get_method(), request:parsed_url(), route.method, route.path)
        if check_url and check_method then
            print(request:get_method(), route.path)
            endpoint.send(route:handler(response, request))
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
                :set_data("Route not found"))
    end
end


return router