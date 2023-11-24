package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require "utils.orm"
local cjson = require("cjson")
local parser = require("utils.parser")
local content_type = require("utils.content_type")
local status_code = require("utils.status_code")
local validations = require "validations.validation"
local responses = require("utils.responses")
local user = {}
local DEFAULT_VALIDATIONS = {"min_length", "max_length"}
local REQUIRED_FIELDS = {"username", "password"}

function user:create(response, request)
    local data = request.body
    local missing_fields = validations:has_fields(data, REQUIRED_FIELDS) 
    if not (#missing_fields == 0) then
        response:set_status_code(status_code.BAD_REQUEST)
        :set_error("Missing fields: " .. table_concat(missing_fields))
        return response
    end
    local fields = {data.username, data.password}
    local validation_fields = {DEFAULT_VALIDATIONS, DEFAULT_VALIDATIONS}
    local fails = validations:validate_env(fields, validation_fields)
    if is_two_dimensional_table_empty(fails) then
        if user_exists(data.username) then
            response:set_error("User with username " .. data.username .. " has already been created, usernames have to be unique"):set_status_code(status_code.BAD_REQUEST)
        else
            local user = User({
                username = data.username,
                password = data.password,
            })
            user:save()
            if user_exists(data.username) then
                response:set_status_code(status_code.BAD_REQUEST)
                :set_sucess("Created User " .. data.username)
            else   
                response:set_status_code(status_code.INTERNAL_SERVER_ERROR)
                :set_error("There has been a problem creating user " .. data.username)
            end 
        end
    else
        response:set_status_code(status_code.BAD_REQUEST)
        :set_error(construct_error(fails))
    end
    return response
end

function user_exists(id)
    return table_count(User.get:where({username = id}):all()) ~= 0
end

function user:index(response, request)
    return nil
end

function user:show(response, request, id)
    if not id then
        id = "something"
    end
    return response:set_status_code(status_code.ACCEPTED):set_content_type(content_type.JSON):set_sucess(User.get:where({username = id}):all())
end

function user:delete(response, request, id)  
    if not id then
        return responses:parameter_not_found("id")
    end
    if(not user_exists(id)) then
        return response:set_sucess("User with username " .. id .. " does not exist")
    end
    User.get:where({username = id}):delete()
    return response:set_status_code(status_code.ACCEPTED):set_content_type(content_type.JSON):set_sucess("A USER WITH ID " .. id .. " HAS BEEN DELETED")         
end 

return user

