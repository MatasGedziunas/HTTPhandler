package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local parser = require("utils.parser")

function check_path(env, desired_request_method, desired_url)
    if env.REQUEST_METHOD == desired_request_method and env.URL == desired_url then
        return true
    end
    return false
end

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

function check_path(parsed_url, request_method, desired_url, desired_request_method)
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