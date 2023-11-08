package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
--require "models.user"
DB = {
    DEBUG = false,
    new = true,
    backtrace = false,
    name = "/www/cgi-bin/database.db",
    type = "sqlite3",
}

local Table = require("uci.table")
-- local field = ...

User = Table({
    __tablename__ = "user",
    __columns__ = {
        username = "",
        password = "",
        time_modified = "",
        info = {}
    }
})

