package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local cjson = require("cjson")
local Multipart = require('multipart')
local file_manager = require("utils.file_manager")
local content_types = require("utils.content_type")
local parser = {}

function parser:parse_request_parametres(url, path)
    url = string.gsub(url, remove_trailing_slash(self:replace_pathParam_with_pattern(path)), "")
    local capturedValue = url:match(".*/([^/]+)$")
    if capturedValue then
        return capturedValue
    else
        return nil
    end
end

function parser:remove_url_params(url, path)
    -- Remove trailing slash from the path
    -- print("cleanedPath: " .. path)
    -- Find the starting index of the path in the URL
    local _, finishIndex = path:find("{", 1, true)
    -- If the path is found, keep everything before it
    if finishIndex and #url >= finishIndex then
        return url:sub(1, finishIndex-1)
    else
        return url
    end
end


function parser:parse_request_url(url)
    local path = string.match(url, "/api/(.*)")
    if path then
        if path:sub(-1) == "/" and #path > 1 then
            path = path:sub(1, #path-1)
        end        
        return "/"..path
    else
        return nil
    end
end

function parser:parse_model(fields, data_body)
    local table = {}

    for _, instance in ipairs(data_body) do
        local user = {}
        for _, field in ipairs(fields) do
            user[field] = instance[field]
        end
        table.insert(table, user)
    end
    return table
end


function parser:replace_pathParam_with_pattern(path)
    local pattern = string.gsub(path, "{(.+)}", function(param)
        -- if param:sub(-1) == "?" then
        --     param = param:sub(1, -2) -- Remove the trailing "?"
        --     return "([^/]-)"
        -- end
        return ""
    end)
    return pattern
end
-- RETURNS A TABLE WITH THE PARSED PARTS
function parser:parse_url_query(parsed_url)
    local data = {}
    if parsed_url then
        for part in parsed_url:gmatch("([^&]+)") do
            local key, value = string.match(part, "([^=]+)=(.+)")
            if key and value then
                data[key] = value
            end
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

function parser:parse_formdata(body, content_type)
    local parts = Multipart(body, content_type)
    local parsed_data = parts:get_all_with_arrays()
    local data = {}
    for k, v in pairs(parsed_data) do
        local param = parts:get(k)
        if(param ~= nil and string.match(param.headers[2], "Content-Type")) then
            
        end
    end
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
        return parser:parse_json(data)
    elseif content_type and string.match(content_type, "multipart/form%-data") then
        return parser:parse_formdata(data, content_type)
    elseif content_type == content_types.FORM_URLENCODED then
        return parser:parse_formurlencoded(data)
    end
end 

return parser
