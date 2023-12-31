local routes = {
    {method = "GET", path = "/test", handler = "test"},
    -- GET
    {
        method = "GET",
        path = "/user/show/{id?}",
        handler = "user_controller.show",
    },
    {
        method = "GET",
        path = "/user/shows/{id}",
        handler = "user_controller.show",
    },
    {
        method = "GET",
        path = "/user/index",
        handler = "user_controller.index",
    },
    -- {
    --     method = "GET",
    --     path = "/user/{id}",
    --     handler = "user_controller.show",
    -- },
    {
        method = "GET",
        path = "/res/{id}",
        handler = "user_controller"
    },
    {
        method = "GET",
        path = "/users/{id}",
        handler = "user_controller.show"
    },
    {
        method = "GET",
        path = "/users",
        handler = "user_controlersara.as"
    },
    
    -- POST
    {
        method = "POST",
        path = "/user/create",
        handler = "user_controller",
        midleware = {"auth"}
    },
    {
        method = "POST",
        path = "/user/delete/{id}",
        handler = "user_controller.delete",
        midleware = {"auth"}
    },
    {
        method = "POST",
        path = "/user/login",
        handler = "authentication_controller.login",
    },
    {
        method = "POST",
        path = "/user/logout",
        handler = "authentication_controller.logout",
        midleware = {"auth"}
    },
    {
        method = "GET",
        path = "/user",
        handler = "user_controller.index",
    },
    {
        method = "POST",
        path = "/user",
        handler = "user_controller.create",
        midleware = {"auth"}
    },
}

return routes