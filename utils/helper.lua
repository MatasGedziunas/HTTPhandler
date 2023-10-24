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
    if parsed_url and request_method == desired_request_method and string.sub(parsed_url, 1, string.len(desired_url)) == desired_url then
        return true
    end
    return false
end

function table_concat(table) 
    local str = ""
    local i = 1
    for key, elem in ipairs(table) do
        if i == 1 then
            str = elem
            i = 2
        else
            str = str .. ", " .. elem
        end              
    end
    return str
end

function construct_error_message(fails) 
    local err = "Invalid data given (failed validations):<br>"
        for type_of_fail, fields in pairs(fails) do
            if #fields ~= 0 then
                err = err .. type_of_fail .. ": "
                for _, field in ipairs(fields) do
                    err = err .. field .. ", "
                end
                err = err .. "<br>"
            end 
        end
    return err
end

function set_response(status_code, content_type, data, response)
    if not response then
        response = {}
    end
    response.status_code = status_code
    response.content_type = content_type
    response.data = data
    return response
end

function is_two_dimensional_table_empty(table)
    for key, subtable in pairs(table) do
        if #subtable ~= 0 then
            return false
        end
    end
    return true
end

function table_contains(table, value)
    return table[value] ~= nil
end

function print_table(table)
    for key, val in pairs(table) do
        print(key .. " : " .. val)
    end
end 
