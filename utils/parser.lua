package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local cjson = require("cjson")
local content_types = require("utils.content_type")
local Multipart = require("multipart")
local parser = {}

function parser:parse_request_parametres(url)
    local capturedValue = url:match(".*/([^/]+)$")
    if capturedValue then
        return capturedValue
    else
        return nil
    end
end

function parser:parse_request_url(url)
    local path = string.match(url, "/api/(.*)")
    if path then
        return path
    else
        return nil
    end
end

function parser:parse_model(fields, data_body)
    local table = {}

    for _, instance in ipairs(data_body) do
        local user = {}
        print(fields)
        for _, field in ipairs(fields) do
            print(field)
            user[field] = instance[field]
        end
        table.insert(table, user)
    end
    return table
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
    if json and string.len(json) > 1 then
        local success, result = pcall(cjson.decode, json)
        if success then
            return result
        else 
            return nil
        end
    end
end 

function parser:parse_formdata(body)
        local parsed_data = {}
        if body:sub(-1) ~= "\r\n" then body = body .. "\r\n" end
        local counter = 0
        local keys, values = {}, {}
        for k in body:gmatch("(.-)\r\n") do
            counter = counter + 1
            if string.match(k, "name=") then
    
                table.insert(keys, string.match(k, 'name="(.+)"'))
    
            end
            if counter % 4 == 0 then table.insert(values, k) end
        end 
        for k, v in ipairs(keys) do parsed_data[v] = values[k] end
        return parsed_data
end

function parser:parse_formurlencoded(body)
    local fields = {}
    for field in body:gmatch("([^&]+)") do
        local key, value = field:match("([^=]+)=(.+)")
        fields[key] = value
    end
    return fields
end 

function parser:parse_request_data(endpoint)
    local data = io.stdin:read("*all")
    local content_type = endpoint.env.headers["content-type"]
    if content_type == content_types.JSON then
        print(table_concat(parser:parse_json(data)))
        return parser:parse_json(data)
    elseif content_type and string.match(content_type, "multipart/form%-data") then
        return parser:parse_formdata(data)
    elseif content_type == content_types.FORM_URLENCODED then
        return parser:parse_formurlencoded(data)
    end
end 

return parser
