package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local user_controller = require("controllers.user_controller")

local routes = {
    -- GET
    {
        method = "GET",
        path = "/user/show/{id?}",
        handler = "user_controller.show",
    },
    {
        method = "GET",
        path = "/user/index",
        handler = "user_controller.index",
    },
    {
        method = "GET",
        path = "/user/{id}",
        handler = "user_controller.show",
    },
    {
        method = "GET",
        path = "/user/",
        handler = "user_controller.index",
    },
    -- POST
    {
        method = "POST",
        path = "/user/create",
        handler = "user_controller.create",
    },
    {
        method = "POST",
        path = "/user/delete",
        handler = "user_controller.delete",
        
    },
    {
        method = "POST",
        path = "/user/",
        handler = user_controller.create,
    },
}

return routes