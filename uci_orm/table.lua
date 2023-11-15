package.path = package.path .. ";/www/cgi-bin/?.lua;/www/?.lua"
Table = {
    -- database table name
    __tablename__ = nil,
}
local Query = require("uci_orm.query")
local Select = require("uci_orm.select")
-- This method create new table
-------------------------------------------
-- @table_instance {table} class Table instance
--
-- @table_instance.__tablename__ {string} table name
-- @table_instance.__colnames {table} list of column instances
-- @table_instance.__foreign_keys {table} list of foreign key
--                                        column instances
-------------------------------------------

local function create_config_file(file_name)
    local file_path = "etc/config/" .. file_name
    local file, err = io.open(file_path, "w") 
    if not file then
        -- Handle the error, for example, print an error message
        print("Error opening file: " .. err)
    else
        -- You can write content to the file here
        -- Example: file:write("This is the content of the file")

        -- Close the file when you're done
        file:close()
    end
end

function Table.create_table(self, args)
    -- table information
    local table_instance = {
        __tablename__ = args.__tablename__,
        __columns = {},
        create = function(self, data)
            return Query(self, data)
        end,
        __index = function(self, key)
            if(key == "get" or key == "delete") then
                return Select(self)
            end
        end,
        has_column = function(self, colname)
            for _, col in ipairs(self.__columns) do
                if col.name == colname then
                    return true
                end
            end
            print("Can't find column '" .. tostring(colname) ..
            "' in table '" .. self.__tablename__ .. "'")
        end,
        get_column = function (self, colname)
            for _, col in ipairs(self.__columns) do
                if col.name == colname then
                    return col
                end
            end

            print("Can't find column '" .. tostring(colname) ..
                               "' in table '" .. self.__tablename__ .. "'")
        end
    }
    
    local cols = {}

    for key, val in pairs(args) do
        if key ~= "__tablename__" then
            local column = {}
            column.__table__ = table_instance
            column.name = key
            column.type = type(val)
            if(column.type ~= "table" and column.type ~= "string") then
                error("Invalid column type of column " .. column.name .. " has type " .. column.type .. " ; only table and string are supported")
            end
            table.insert(table_instance.__columns, column)
        end
    end

    setmetatable(table_instance, {__call = table_instance.create,
                                __index = table_instance.__index})
    return table_instance
end

setmetatable(Table, {__call = Table.create_table})

return Table