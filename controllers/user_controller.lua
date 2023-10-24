package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require "utils.orm"
local cjson = require("cjson")
local parser = require("utils.parser")
local user_model = require("models.user")
local content_type = require("utils.content_type")
local status_code = require("utils.status_code")
local validations = require "utils.validation"
local responses = require("utils.responses")
local user = {}
local DEFAULT_VALIDATIONS = {"min_length", "max_length"}
local REQUIRED_FIELDS = {"username", "password"}

function user:create(response, request)
    local data = request.body
    local missing_fields = validations:has_fields(data, REQUIRED_FIELDS) 
    if not (#missing_fields == 0) then
        response = set_response(status_code.BAD_REQUEST, content_type.HTML, "Missing fields: " .. table_concat(missing_fields), response)
        return response
    end
    local fields = {data.username, data.password}
    local validation_fields = {DEFAULT_VALIDATIONS, DEFAULT_VALIDATIONS}
    local fails = validations:validate_env(fields, REQUIRED_FIELDS, validation_fields)
    if is_two_dimensional_table_empty(fails) == 0 then
        local user = User({
            username = data.username, -- encrypt
            password = data.password,
            time_modified = os.time()
        })
        user:save()
        response = set_response(status_code.CREATED, content_type.HTML, "Created User " .. user.username, response)
    else
        local err = construct_error_message(fails)
        response = set_response(status_code.BAD_REQUEST, content_type.HTML, err, response)
    end
    return response
end

function user:index(response, request)
    local users = User.get:all()
    -- print("We get " .. users:count() .. " users")
    -- -- We get 2 users
    -- print("Second user name is: " .. users[1].username)
    -- print_table(parser:parse_model(user_model.fields, users))
    -- response:with_status(201):with_headers({}):data()
    return set_response(status_code.ACCEPTED, content_type.JSON, "List of users")
end

function user:show(response, request)
    -- local name = request.option('name')
    -- local search = request.query('q')
    -- local content_type = request.header('content-type')
    local id = request.param
    if validations:is_int(id) then
        return set_response(status_code.ACCEPTED, content_type.JSON, "A USER WITH ID " .. id, response)
    else
        return responses:invalid_parameter_data_type(response, "int")
    end   
end

function user:delete(response, request)  
    local id = request.param
        if validations:is_int(id) then
            return set_response(status_code.ACCEPTED, content_type.JSON, "A USER WITH ID " .. id .. " has been deleted", response)
        else
            return responses:invalid_parameter_data_type(response, "int")
        end 
end 

function user:login(response, request)

end

return user

