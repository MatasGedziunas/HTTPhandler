local openssl = require("openssl")
local ENCRYPTION_KEY = "SECRET"
function encrypt(value)
    return openssl.aes_256_cbc_encrypt(ENCRYPTION_KEY, value)
end

print(encrypt("hello"))