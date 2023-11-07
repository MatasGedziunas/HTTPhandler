package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
--require "models.user"
DB = {
    DEBUG = false,
    new = true,
    backtrace = false,
    name = "/www/cgi-bin/database.db",
    type = "sqlite3",
}

local Table = require("orm.model")
local fields = require("orm.tools.fields")

User = Table({
    __tablename__ = "user",
    username = fields.CharField({max_length = 100, unique = true}),
    password = fields.CharField({max_length = 50, unique = true}),
    time_modified = fields.DateTimeField({null = true})
})

