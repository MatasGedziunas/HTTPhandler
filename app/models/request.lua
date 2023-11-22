package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local parser = require("utils.parser")
local request = {}

function request:add_body(body)
    self.body = body
    return self
end

function request:add_query(query)
    self.query = query
    return self
end

function request:add_param(param)
    self.param = param
    return self
end

function request:add_headers(headers)
    self.headers = headers
    return self
end

function request:add_method(method)
    self.method = method
    return self
end

function request:option(option)
    if self.body then
        return self.body[option]
    end
end

function request:query(option)
    if self.query then
        return self.query[option]
    end
end

function request:header(option)
    if self.headers then
        return self.headers[option]
    end
end

function request:param()
    return self.param
end 

function request:parsed_url()
    if self.headers then
        local parsed_url = parser:parse_request_url(self.headers.URL)
        if parsed_url then
            return parsed_url    
        else
            return ""
        end
         
    end
end

function request:get_method()
    return self.method
end

return request