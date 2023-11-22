package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local content_type = require("utils.content_type")
local status_code = require("utils.status_code")

local response = {
    status_code = status_code.ACCEPTED,
    content_type = content_type.JSON,
    headers = {},
    data = {},
    } 

function response:set_status_code(code)
    self["status_code"] = code
    return self
end

function response:set_content_type(type)
    self["content-type"] = type
    return self
end

function response:set_sucess(data)
    self.data.results = data
    return self
end 

function response:set_error(data)
    self.data.error = data
    return self
end 

function response:add_header(key, val)
    self.headers[key] = val
    return self
end

return response
