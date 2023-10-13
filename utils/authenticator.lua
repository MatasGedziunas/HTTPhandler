local jwt = require "luajwt"
local auth = {}
local KEY = "sample"

function auth:encode()   
    local payload = {
        iss = "12345678",
        nbf = os.time(),
        exp = os.time() + 3600,
    }

    local alg = "HS256"
    local token, err = jwt.encode(payload, KEY, alg)
    if token then
        return token
    else
        return nil
    end
end

function auth:decode(token)
    local validate = true
    local decoded, err = jwt.decode(token, KEY, validate)
    if decoded then
        return decoded
    else
        return nil
    end
end

-- local function validate(payload) 
--     local time_now = os.time()
--     if payload.nbf <= time_now and payload.exp > time_now then
--         return true
--     end
--     return false
-- end 