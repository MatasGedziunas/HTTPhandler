package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local endpoint = {}
require("utils.helper")
local parser = require("utils.parser")
local content_type = require("utils.content_type")
local status_code = require("utils.status_code")
local validator = require("validations.validation")
local router = require("routes.router")
local request = require("app.models.request")
local response = require("app.models.response")

function endpoint:handle_request()
    local missingHeaders = validator:requiredHeaders(endpoint.env.headers)
    if #missingHeaders ~= 0 then
        self.send(response:set_error("Missing headers: " .. table_concat(missingHeaders)):set_status_code(
            status_code.BAD_REQUEST))
        return
    end
    local validationHeaders = validator:validateHeaders(endpoint.env)
    if #validationHeaders ~= 0 then
        self.send(response:set_error("Failed header validations: " .. table_concat(validationHeaders)):set_status_code(
            status_code.BAD_REQUEST))
        return
    end

    -- endpoint.request = request.add_body(parser:parse_request_data(self))
    --     :add_headers(endpoint.env.headers)
    --     :add_query(parser:parse_url_query(request.parsed_url()))
    --     :add_method(parser:get_request_method(endpoint.env))
    local parsed_url
    if endpoint.env.headers then
        parsed_url = parser:parse_request_url(endpoint.env.headers.URL)
        if not parsed_url then
            parsed_url = ""
        end
    end
    endpoint.request = request(parser:parse_request_data(self), parser:parse_url_query(parsed_url),
        endpoint.env.headers, parser:get_request_method(endpoint.env))
    router:route(self)
end

return endpoint
