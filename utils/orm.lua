package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
--require "models.user"
local Table = require("orm.model")
local fields = require("orm.tools.fields")

DB = {
    DEBUG = true,
    new = true,
    backtrace = true,
    name = "database.db",
    type = "sqlite3",
}

local User = Table({
    __tablename__ = "user",
    username = fields.CharField({max_length = 100, unique = true}),
    password = fields.CharField({max_length = 50, unique = true}),
    time_modified = fields.DateTimeField({null = true})
})

