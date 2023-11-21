package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local content_type = require("utils.content_type")
local status_code = require("utils.status_code")
local responses = {}
local response = require("models.response")

function responses:parameter_not_found(param_name)
    response.status_code = status_code.BAD_REQUEST
    response.content_type = content_type.JSON
    response:set_error("Parameter "  .. param_name ..  " not found")
    return response
end

function responses:invalid_parameter_data_type(data_type)
    response.status_code = status_code.BAD_REQUEST
    response.content_type = content_type.JSON
    response:set_error("Parameter id is not of type " .. data_type)
    return response
end

function responses:method_not_found()
    response.status_code = status_code.INTERNAL_SERVER_ERROR
    response.content_type = content_type.JSON
    response:set_error("Controller method not implemented yet")
    return response
end

function responses:failed_ubus_connnection()
    return response:set_error(status_code.INTERNAL_SERVER_ERROR):set_error("There has been a problem connecting to UBUS")
end

return responses