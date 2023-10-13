package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
require "utils.orm"
local validations = require "utils.validation"
local user = {}
local DEFAULT_VALIDATIONS = {"min_length", "max_length"}
function user:login(token)

end

function user:create(data)
    local fields = {data.username, data.password}
    local validation_fields = {DEFAULT_VALIDATIONS, DEFAULT_VALIDATIONS}
    if #validations:validate_env(fields, validation_fields) == 0 then
        local user = User({
            username = data.username,
            password = data.password,
            time_modified = os.time()
        })
        user:save()
        print("User " .. user.username .. " has id " .. user.id)
    end
end