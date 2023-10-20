package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
local user_controller = require("controllers.user_controller")

local routes = {
    {
        method = "GET",
        path = "user/show/",
        handler = user_controller.show,
        data = "parameter"
    },
    {
        method = "GET",
        path = "user/index",
        handler = user_controller.index,
        data = "",
    },
    {
        method = "POST",
        path = "user/create",
        handler = user_controller.create,
        data = "body",
    },
    {
        method = "POST",
        path = "user/delete",
        handler = user_controller.delete,
        data = "parameter",
    },
    {
        method = "POST",
        path = "user/",
        handler = user_controller.create,
        data = "body",
    }
}

return routes