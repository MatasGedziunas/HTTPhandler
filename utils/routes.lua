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
        path = "/user/$",
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
        path = "/user/delete/{id}",
        handler = "user_controller.delete",
    },
    {
        method = "POST",
        path = "/user/$",
        handler = "user_controller.create",
    },
}

return routes