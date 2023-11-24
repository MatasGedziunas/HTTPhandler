# HTTPhandler

# Getting started

## Dependencies used: 

uhttpd, ubus, rpcd, uci(https://openwrt.org/docs/techref/uci),  cjson (https://luarocks.org/modules/openresty/lua-cjson).

## Launching

Navigate to /www folder on your local computer and pull this git repository, lastly launch you uhttpd server to establish a connection to the API.

# Routes

By default, to call the API on your local server all routes must start with: **http://localhost/api**

By default, to call any route in the API "host", "user-agent", "content-type" headers are required. Supported "content-type" are "multipart/form-data", "application/x-www-form-urlencoded", "application/json".  

All routes are defined in routes/route folder where each route has these fields:

**method** = Supports "GET" or "POST",  

**path** = path to which the router should match the request URL, parametres can be defined: {id} ; optional parameter: {id?}. If a controller method requires a parameter, it is then parsed and passed to the method.

**handler** = what is the handler for this route. Should be of structure: **"controller.method"** , where controller is a file in app/controllers and method is a method in that controller. Currently 2 controllers are implemented: *user_controller*, *auth_controller*. If you don't provide a method for the controller, by default, it looks for a method depending on your request method: "GET" - index ; "POST" - create

**midleware (optional)** = a table for which midleware to run before going to the handler, - curently supported midleware = {"auth"}

In the request body, data can be passed by 3 types: json, multipart/form

## Examples
Many example routes are already provided in routes/route file:

~~~lua 
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

If a route's middleware table has an element "auth",  in that case, the api looks for an Authentication header value and validates the ubus_rpc_session key. Key validation happens in security/authentication_checker.lua file.

# Database models

The api uses the UCI system for storing data. New models can be created in utils/orm.lua file, with the imported varaible **Table** and the created tables must be global.

## Fields in the table

All tables **must** have a field `__tablename__` which is the name of the config file in which information about this table will be stored. All config files are created in /etc/config.

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

There are already 2 controllers created: user_controller and authentication controller.

## user_controller

Makes queries and searches for users in the Users table (Users config file). The username is treated as the id for this table. This controller has the following methods:

**index** - lists all users,

**show** - shows a user by its given id,

if we create a route: 

~~~
{
        method = "GET",
        path = "/user/show/{id?}",
        handler = "user_controller.show",
}
~~~

Then, if a parameter (id) is passed in the url it will a user with that username, otherwise, default value for username is "something" .

**delete** - deletes a user by its given id,

**create** - creates a user by the given data in the body of the request.

## authentication_controller

Is responsible for the authentication of the user via Ubus. Contains following methods:

**login** - tries to log the user in given username, password in the request body, returns an rpc_session_key if data is valid.

**logout** - makes the given rpc_session_key (in the Authorization header) invalid.

## Validation

Before creating an instance of an object in the table, you can validate data via validations/validation.lua file.

You can validate missing fields with the `has_fields` method, where one parameter is a table with the data and the other is all the required fields which should be in that table.

Other validations for the data columns can also be made:

**min_length** - by default should be greater than 6,

**max_length** - by default should be smaller than 20,

**no_numbers** - checks if a column value doesn't contain numbers,

**is_email** - checks if a column value conains @ symbol,

**is_phone_number** - checks if a column value is a valid Lithuanian phone number,

**is_date** - checks if a column value is a valid date in format (y/m/d). Can be seperated by - or . or /    (2023-11-24) or (2023.11.24) or (2023/11/24)

To call these validations in the controller, you can use `validate_env` method. The first parameter should be a table with the column fields, the second should be a table that contains tables which contains validations to do for the the column field, where validations[i] is a table which contains validations for fields[i] value.

Example:

~~~
local fields = {data.username, data.password}
local validation_fields = {{"min_length", "max_length", "no_numbers"}, {"min_length", "max_length"}}
~~~

Here field data.username will "min_length", "max_length", "no_numbers" validations performed on it, and field data.password field will have "min_length", "max_length".



 

















