# HTTPhandler
__Getting started__

Dependencies used: uhttpd, ubus, rpcd, cjson (https://luarocks.org/modules/openresty/lua-cjson).
Navigate to /www folder on your local computer and pull this git repository, lastly launch you uhttpd server to establish a connection to the API.

**Routes**

By default, to call the API on your local server all routes must start with: **http://localhost/__api__**
All routes are defined in routes/route folder where each route has these fields:
method = Supports "GET" or "POST",
path = path to which the router should match the request URL, parametres can be defined: {id} ; optional parameter: {id?}. 
handler = what is the handler for this route. Should be of structure: **"controller.method"** , where controller is a file in app/controllers and method is a method in that controller.
midleware (optional) = a table for which midleware to run before going to the handler, - curently supported midleware = {"auth"}



