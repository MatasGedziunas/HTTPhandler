local http_status = {}

-- Define HTTP status codes and their messages
http_status.OK = { code = 200, message = "OK" }
http_status.BAD_REQUEST = { code = 400, message = "Bad Request" }
http_status.NOT_FOUND = { code = 404, message = "Not Found" }
-- Add more status codes as needed
-- ...

return http_status
