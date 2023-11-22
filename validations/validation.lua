package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local content_type = require("utils.content_type")
local validator = {}
local MIN_LENGTH = 6
local MAX_LENGTH = 20
local ALL_VALIDATIONS = {"min_length", "max_length", "no_numbers", "is_email", "is_phone_number"}
local VALID_CONTENT_TYPES = {content_type.FORM_DATA, content_type.FORM_URLENCODED, content_type.JSON}
local VALID_REQUEST_METHODS = {"GET", "POST", "PUT", "PATCH", "DELETE"}

function validator:requiredHeaders(headers)
    local requiredHeaders = {"host", "user-agent", "content-type"}
    local missingHeaders = {}
    for _, header in pairs(requiredHeaders) do
        if not headers[header] then
            table.insert(missingHeaders, header)
        end
    end
    return missingHeaders
end

function validator:validateHeaders(env)
    local headers = env.headers
    local failed_validations = {}
    if not table_contains(VALID_CONTENT_TYPES, headers["content-type"]) then
        local pattern = string.gsub(content_type.FORM_DATA, "([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
        if not string.match(headers["content-type"], pattern) then
            table.insert(failed_validations, "Invalid content type")
        end
    end
    if not table_contains(VALID_REQUEST_METHODS, env.REQUEST_METHOD) then
        table.insert(failed_validations, "Request method not supported")
    end
    return failed_validations
end

function validator:validate_content(data, expected_content_type)

end

function validator:validate_env(fields, required_fields, validations)
    local fails = {}
    -- fails["Field_not_defined"] = self:has_fields(fields, required_fields)
    -- if not #fails["Field_not_defined"] == 0 then
    --     return fails
    -- end
    for _, validation in ipairs(ALL_VALIDATIONS) do
        fails[validation] = {}
    end

    for i, field in ipairs(fields) do
        for _, validation_type in ipairs(validations[i]) do
            local success = false
            if validation_type == "min_length" then
                success = self:min_length(field)
                if not success then
                    table.insert(fails["min_length"], field) 
                end
            elseif validation_type == "max_length" then
                success = self:max_length(field)
                if not success then
                    table.insert(fails["max_length"], field)
                end
            elseif validation_type == "no_numbers" then
                success = self:no_numbers(field)
                if not success then
                    table.insert(fails["no_numbers"], field)
                end
            elseif validation_type == "is_email" then
                success = self:is_email(field)
                if not success then
                    table.insert(fails["is_email"], field)
                end
            elseif validation_type == "is_phone_number" then
                success = self:is_phone_number(field)
                if not success then
                    table.insert(fails["is_phone_number"], field)
                end
            elseif validation_type == "is_date" then
                success = self:is_date(field)
                if not success then
                    table.insert(fails["is_date"], field)
                end
            end      
        end
    end
    return fails
end

function validator:has_fields(fields, required_fields)
    if fields == nil then
        return required_fields
    end
    local empty_fields = {}
    for _, required_field in ipairs(required_fields) do
        if(fields[required_field] == nil) then
            table.insert(empty_fields, required_field)
        end
    end
    return empty_fields
end

function validator:min_length(field, min_length)
    if not min_length then
        min_length = MIN_LENGTH
    end
    if(string.len(field) < MIN_LENGTH) then
        return false
    end
    return true
end

function validator:max_length(field, max_length)
    if not max_length then
        max_length = MAX_LENGTH
    end
    if(string.len(field) > MAX_LENGTH) then
        return false
    end
    return true
end

function validator:no_numbers(field)
    return not string.match(field, "%d")
end

function validator:is_email(field)
    if(string.match(field, "@") == nil) then
        return false
    end
    return true
end

function validator:is_phone_number(field)
    return ((not string.match(field, "%a")) and self.min_length(field, 8) and self.max_length(field, 20))
end 

local function check_date_pattern(field, pattern)
    local year, month, day = string.match(field, pattern)    
    if year and month and day then
        if string.sub(year, 1, 1) == "0" then
            print("Invalid year (leading 0)")
            return false
        end
        year = tonumber(year)
        month = tonumber(month)
        day = tonumber(day)
        -- Check if the parsed values are valid
        if year and month and day then
            if month > 12 and day > 31 then
                return false
            end
            print("Year:", year)
            print("Month:", month)
            print("Day:", day)
            return true
        else
            print("Invalid date components (not integers)")
            return false
        end
    else
        print("Date does not match the expected format")
        return false
    end
end

function validator:is_date(field)
    local pattern = "(%d?%d?%d?%d)/(%d?%d)/(%d?%d)"
    if check_date_pattern(field, pattern) then
        return true
    end
    local pattern = "(%d?%d?%d?%d)-(%d?%d)-(%d?%d)"
    if check_date_pattern(field, pattern) then
        return true
    end
    local pattern = "(%d?%d?%d?%d).(%d?%d).(%d?%d)"
    if check_date_pattern(field, pattern) then
        return true
    end
    return false
end

function validator:is_int(field)
    return (tostring(field)):match("^%-?%d+$")
end

return validator