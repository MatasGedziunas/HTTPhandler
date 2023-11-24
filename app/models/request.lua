package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local parser = require("utils.parser")

function newRequest(body, query, headers, method)
    local self = {
        _body = body,
        _query = query,
        _headers = headers,
        _method = method,
    }

    local option = function(option)
        if self._body then
            return self._body[option]
        end
    end

    local query = function(option)
        if self._query then
            return self._query[option]
        end
    end

    local header = function(option)
        if self._headers then
            return self._headers[option]
        end
    end

    local parsed_url = function()
        if self._headers then
            local parsed_url = parser:parse_request_url(self._headers.URL)
            if parsed_url then
                return parsed_url    
            else
                return ""
            end
        end
    end

    local get_method = function()
        return self._method
    end

    local get_body = function()
        return self._body
    end

    return {
        option = option,
        query = query,
        header = header,
        parsed_url = parsed_url,
        get_method = get_method,
        get_body = get_body
    }
end

return newRequest