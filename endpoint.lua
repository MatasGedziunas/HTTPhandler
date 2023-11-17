package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local endpoint = {}
require("utils.helper")
local parser = require("utils.parser")
local content_type = require("utils.content_type")
local status_code = require("utils.status_code")
local validator = require("utils.validation")
local user_controller = require("controllers.user_controller")
local router = require("routes.router")
local request = require("models.request")
local response = require("models.response")

function endpoint:handle_request()
    local missingHeaders = validator:requiredHeaders(endpoint.env.headers)
    if #missingHeaders ~= 0 then        
        self.send(response:set_error("Missing headers: " .. table_concat(missingHeaders)):set_status_code(status_code.BAD_REQUEST))
        return
    end
    local validationHeaders = validator:validateHeaders(endpoint.env)
    if #validationHeaders ~= 0 then
        self.send(response:set_error("Failed header validations: " .. table_concat(validationHeaders)):set_status_code(status_code.BAD_REQUEST))
        return
    end
    endpoint.request = request:add_body(parser:parse_request_data(self))
        :add_headers(endpoint.env.headers)
        :add_param(parser:parse_request_parametres(endpoint.env.headers.URL))
        :add_query(parser:parse_url_query(request:parsed_url()))
        :add_method(parser:get_request_method(endpoint.env))

    router:route(self)
end


return endpoint
