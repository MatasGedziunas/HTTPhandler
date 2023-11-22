# HTTPhandler

# Getting started

## Dependencies used: 
uhttpd, ubus, rpcd, cjson (https://luarocks.org/modules/openresty/lua-cjson).
## Launching
Navigate to /www folder on your local computer and pull this git repository, lastly launch you uhttpd server to establish a connection to the API.

# Routes

By default, to call the API on your local server all routes must start with: **http://localhost/__api__**
All routes are defined in routes/route folder where each route has these fields:
**method** = Supports "GET" or "POST",
**path** = path to which the router should match the request URL, parametres can be defined: {id} ; optional parameter: {id?}. 
**handler** = what is the handler for this route. Should be of structure: **"controller.method"** , where controller is a file in app/controllers and method is a method in that controller. Currently 2 controllers are implemented: *user_controller*, *auth_controller*. If you don't provide a method for the controller, by default, it looks for a method depending on your request method: "GET" - index ; "POST" - create
**midleware (optional)** = a table for which midleware to run before going to the handler, - curently supported midleware = {"auth"}

## Examples
Many example routes are already provided in routes/route file:

``` 
{
        method = "GET",
        path = "/user/index",
        handler = "user_controller.index",
},
{
        method = "POST",
        path = "/user/create",
        handler = "user_controller",
        midleware = {"auth"}
},
{
        method = "GET",
        path = "/user/show/{id?}",
        handler = "user_controller.show",
},
{
        method = "POST",
        path = "/user/delete/{id}",
        handler = "user_controller.delete",
        midleware = {"auth"}
}
```



