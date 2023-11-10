Table = {
    -- database table name
    __tablename__ = nil,
}

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
    local file_path = "etc/config/" .. file_name .. ".config"
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
    local cols = {}

    for key, val in pairs(args) do
        if key ~= "__tablename__" then
            cols[key] = val
        end
    end

    local table_instance = {
        __tablename__ = args.__tablename__,
        cols = cols,
        create = function(self, data)
            return Query(self, data)
        end,
        __index = function(self, key)
            if(key == "get") then
                return Select(self)
            end
            print("Method not found")
        end
    }
    setmetatable(table_instance, {__call = table_instance.create,
                                __index = table_instance.__index})
    return table_instance
end

setmetatable(Table, {__call = Table.create_table})

return Table