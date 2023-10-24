package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local parser = require("utils.parser")
local request = {}

function request:add_body(body)
    self.body_table = body
    return self
end

function request:add_query(query)
    self.query_table = query
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
    if self.body_table then
        return self.body_table.option
    end
end

function request:query(option)
    if self.query_table then
        return self.query_table.option
    end
end

function request:header(option)
    if self.headers then
        return self.headers.option
    end
end

function request:param()
    return self.param
end 

function request:parsed_url()
    if self.headers then
        return parser:parse_request_url(self.headers.URL)
    end
end

function request:get_method()
    return self.method
end

return request