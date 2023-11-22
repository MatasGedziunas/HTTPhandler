package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
--require "models.user"
require("uci")
x = uci.cursor()

local Table = require("uci_orm.table")

-- Table of object
User = Table({
    __tablename__ = "user",
    username = "",
    password = "",
    items = {},
})

-- -- Instance of an object
-- local user_instance = User({
--     username = "Helloses",
--     password = "Pleases",
--     items = 1
-- })
-- -- Object gets created in database
-- user_instance:save()
-- -- Get all users
-- local all_users = User.get:all()
-- for key, tbl in pairs(all_users) do
--     for k, val in pairs(tbl) do
--         if(type(val) == "string") then
--             print(k .. " " .. val)
--         end
--     end
-- end
-- -- Get first user by its password
-- User.get:where({password = "Test"}):first()
-- -- Delete user
-- User.get:where({username = "Helloses"}):delete()
-- User.get:where({password = "pasw"}):limit(1):delete()


