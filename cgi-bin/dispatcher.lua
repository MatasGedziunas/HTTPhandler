package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local cjson = require("cjson")
local parser = require("utils.parser")
local validator = require("validations.validation")
local responses = require("utils.responses")
require("utils.helper")

local function send_response(response)
    if not response then
        response = responses:no_response()
    end
    uhttpd.send("Status:" .. response.status_code.code .. " " .. response.status_code.message .. "\r\n")
    uhttpd.send("Content-Type:" .. response.content_type .. "\r\n\r\n")
    -- for key, val in pairs(response.headers) do
    --     uhttpd.send(key..":" .. val .. "\r\n")
    -- end
    if (response.error_message ~= nil) then
        uhttpd.send(cjson.encode(response.error_message))
    else
        uhttpd.send(cjson.encode(response.data))
    end
    uhttpd.send("\r\n")

end

-- Main body required by uhhtpd-lua plugin
function handle_request(env)
    -- uhttpd.send("Status: 200\r\n")
    -- uhttpd.send("Content-Type: text/html\r\n\r\n")
    -- for k, v in pairs(env) do
    --     if type(v) == "table" then
    --         uhttpd.send("Table. Key -> " .. k .. "<br><br>")
    --         for key, value in pairs(v) do
    --             uhttpd.send(key .. " " .. value .. "<br><br>\r\n")
    --         end
    --     else
    --         uhttpd.send(k .. " " .. v .. "<br><br>\r\n")
    --     end
    -- end
    -- uhttpd.send("------------------------\n")

    -- Injected uhttpd method
    local endpoint = require("www/cgi-bin/endpoint")
    endpoint.send = send_response
    endpoint.env = env
    endpoint:handle_request()
end
