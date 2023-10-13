local cjson = require("cjson")
local parser = {}

function parser:parse_request_url(url)
    local path = string.match(url, "/api/(.*)")
    if path then
        return path
    else
        return nil
    end
end

-- RETURNS A TABLE WITH THE PARSED PARTS
function parser:parse_url_query(parsed_url)
    local data = {}
    for part in parsed_url:gmatch("([^&]+)") do
        local key, value = string.match(part, "([^=]+)=(.+)")
        if key and value then
            data[key] = value
        end
    end
    return data
end

function parser:get_request_method(env)
    return env.REQUEST_METHOD
end

function parser:parse_json(json)
    if json and not json == "\n" then
        return cjson.decode(json)
    end
end 

return parser
