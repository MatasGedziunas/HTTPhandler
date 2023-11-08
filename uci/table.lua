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
        BACKTRACE("Error opening file: " .. err)
    else
        -- You can write content to the file here
        -- Example: file:write("This is the content of the file")

        -- Close the file when you're done
        file:close()
        BACKTRACE("File created: " .. file_path)
    end
end

function Table:create_table(table_instance)
    -- table information
    local tablename = table_instance.__tablename__
    local columns = table_instance.__colnames
    create_config_file(tablename)
end

function Table.new(self, args)
    print(args.__columns__.username)
    self.__tablename__ = args.__tablename__
    local colnames = {}
    for colname, _type in pairs(args) do
        if colname ~= self.__table__name then
            
        end
    end
end

setmetatable(Table, {__call = Table.new})

return Table