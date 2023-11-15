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
        response:set_status_code(status_code.BAD_REQUEST)
        :set_error(missing_fields)
        return response
    end
    local fields = {data.username, data.password}
    local validation_fields = {DEFAULT_VALIDATIONS, DEFAULT_VALIDATIONS}
    local fails = validations:validate_env(fields, REQUIRED_FIELDS, validation_fields)
    if is_two_dimensional_table_empty(fails) then
        local user = User({
            username = data.username,
            password = data.password,
        })
        user:save()
        response:set_status_code(status_code.CREATED)
        :set_sucess("Created User " .. data.username)
    else
        response:set_status_code(status_code.BAD_REQUEST)
        :set_error(construct_error(fails))
    end
    return response
end

function user:index(response, request)
    return response:set_sucess(User.get:all())
end

function user:show(response, request)
    local id = request.param
    if not id then
        id = "something"
    end
    return response:set_status_code(status_code.ACCEPTED):set_content_type(content_type.JSON):set_sucess(User.get:where({username = id}):all())
end

function user:delete(response, request)  
    local id = request.param
    if not id then
        return responses:parameter_not_found("id")
    end
    User.get:where({username = id}):delete()
    return response:set_status_code(status_code.ACCEPTED):set_content_type(content_type.JSON):set_sucess("A USER WITH ID " .. id .. " HAS BEEN DELETED")         
end 

function user:login(response, request)

end

return user

