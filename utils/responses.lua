package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local content_type = require("utils.content_type")
local status_code = require("utils.status_code")

local responses = {}

function responses:parameter_not_found(response)
    response.status_code = status_code.BAD_REQUEST
    response.content_type = content_type.HTML
    response.data = "Parameter not found"
    return response
end

function responses:invalid_parameter_data_type(response, data_type)
    response.status_code = status_code.BAD_REQUEST
    response.content_type = content_type.HTML
    response.data = "Parameter id is not of type " .. data_type
    return response
end

return responses