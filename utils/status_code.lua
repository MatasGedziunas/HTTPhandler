local http_status = {}

-- Define HTTP status codes and their messages
http_status.OK = { code = 200, message = "OK" }
http_status.CREATED = { code = 201, message = "Created" }
http_status.ACCEPTED = { code = 202, message = "Accepted" }
http_status.NO_CONTENT = { code = 204, message = "No Content" }
http_status.MOVED_PERMANENTLY = { code = 301, message = "Moved Permanently" }
http_status.FOUND = { code = 302, message = "Found" }
http_status.SEE_OTHER = { code = 303, message = "See Other" }
http_status.NOT_MODIFIED = { code = 304, message = "Not Modified" }
http_status.TEMPORARY_REDIRECT = { code = 307, message = "Temporary Redirect" }
http_status.BAD_REQUEST = { code = 400, message = "Bad Request" }
http_status.UNAUTHORIZED = { code = 401, message = "Unauthorized" }
http_status.FORBIDDEN = { code = 403, message = "Forbidden" }
http_status.NOT_FOUND = { code = 404, message = "Not Found" }
http_status.INTERNAL_SERVER_ERROR = { code = 500, message = "Internal Server Error" }

-- You can add more status codes as needed
-- ...

return http_status

