package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
--require "models.user"
require("uci")
x = uci.cursor()
DB = {
    DEBUG = false,
    new = true,
    backtrace = false,
    name = "/www/cgi-bin/database.db",
    type = "sqlite3",
}

local Table = require("uci_orm.table")
-- local field = ...

User = Table({
    __tablename__ = "user",
    username = "",
    password = "",
})

-- local user_instance = User({
--     username = "Hello",
--     password = "Please"
-- })
-- user_instance:save()
local all_users = User.get:all()
for key, val in pairs(all_users) do
    print(key)
end


