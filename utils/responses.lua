package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local content_type = require("utils.content_type")
local status_code = require("utils.status_code")

local responses = {}

function responses:parameter_not_found()
    local response = {}
    response.status_code = status_code.BAD_REQUEST
    response.content_type = content_type.JSON
    response.data = "Parameter not found"
    return response
end

function responses:invalid_parameter_data_type(data_type)
    local response = {}
    response.status_code = status_code.BAD_REQUEST
    response.content_type = content_type.JSON
    response.data = "Parameter id is not of type " .. data_type
    return response
end

function responses:method_not_found()
    local response = {}
    response.status_code = status_code.INTERNAL_SERVER_ERROR
    response.content_type = content_type.JSON
    response.data = "Controller method not implemented yet"
    return response
end

return responses