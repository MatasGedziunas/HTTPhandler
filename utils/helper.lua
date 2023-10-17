package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local parser = require("utils.parser")

function split_string(inputstr, sep, init) 
    if init == nil then
        init = 0
    end
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)", init) do
            table.insert(t, str)
    end
    return t
end

function check_path(request_method, parsed_url, desired_request_method, desired_url)
    -- print(string.sub(parsed_url, 1, string.len(desired_url)), desired_url, "what")
    if parsed_url and request_method == desired_request_method and string.sub(parsed_url, 1, string.len(desired_url)) == desired_url then
        return true
    end
    return false
end

function table_concat(table) 
    local str = ""
    for i, elem in ipairs(table) do
        if i == 1 then
            str = elem
        else
            str = str .. ", " .. elem
        end              
    end
    return str
end

function set_response(status_code, content_type, data, response)
    response.status_code = status_code
    response.content_type = content_type
    response.data = data
    return response
end

function is_two_dimensional_table_empty(table)
    for _, subtable in ipairs(table) do
        if next(subtable) ~= nil then
            return false  -- Subtable is not empty
        end
    end
    return true  -- All subtables are empty
end