# HTTPhandler

# Getting started

## Dependencies used: 
uhttpd, ubus, rpcd, uci(https://openwrt.org/docs/techref/uci),  cjson (https://luarocks.org/modules/openresty/lua-cjson).
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

~~~ 
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
},
~~~

# Authentication

If a route's middleware table has an element "auth",  in that case the api looks for an Authentication header value and validates the ubus_rpc_session key 

# Database models

The api uses the UCI system for storing data. New models can be created in utils/orm.lua file, with the imported varaible **Table** and the created tables must be global.

## Fields in the table

All tables **must** have a field `__tablename__` with the name of the config file in which information about this table will be stored. All config files are created in /etc/config.

Other table columns are fields in the table and can be two types:

"" - for an option,

{} - for an option list.

## Examples
Examples of how to use the created orm (can be found in utils/orm.lua file):

~~~
local Table = require("uci_orm.table")

-- Table of object
User = Table({
    __tablename__ = "user",
    username = "",
    password = "",
    items = {},
})

-- Instance of an object
local user_instance = User({
    username = "Helloses",
    password = "Pleases",
    items = 1
})
-- Object gets created in database
user_instance:save()
-- Get all users
local all_users = User.get:all()
for key, tbl in pairs(all_users) do
    for k, val in pairs(tbl) do
        if(type(val) == "string") then
            print(k .. " " .. val)
        end
    end
end
-- Get first user by its password
User.get:where({password = "Test"}):first()
-- Delete user
User.get:where({username = "Helloses"}):delete()
User.get:where({password = "pasw"}):limit(1):delete()
~~~

# Controllers

You can create your own controllers and add methods to them in **app/controllers** folder.

## Validation

Before creating an 



