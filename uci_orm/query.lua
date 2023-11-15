require("uci")
x = uci.cursor()

local function check_type(data, expected_type)
    if(type(data) ~= "string" and type(data) ~= "table") then
        return false 
    elseif type(data) == "table" then
        
    end
end 

function Query(own_table, data)
    local query = {
        own_table = own_table,
        _data = {},
        -- Get column value
        -----------------------------------------
        -- @colname {string} column name in table
        --
        -- @return {string|boolean|number|nil} column value
        -----------------------------------------
        _get_col = function (self, colname)
            if self._data[colname] then
                return self._data[colname].new
            else
                print("Column does not exist")
            end
        end,
        select_object = own_table.get,

        -- Set column new value
        -----------------------------------------
        -- @colname {string} column name in table
        -- @colvalue {string|number|boolean} new column value
        -----------------------------------------
        _set_col = function (self, colname, colvalue)
            local coltype

            if self._data[colname].new then
                coltype = self.own_table:get_column(colname)

                if coltype then
                    self._data[colname] = {
                        old = self._data.new,
                        new = colvalue
                    }
                else
                    print("Not valid column value for update")
                end
            end
        end,
        -- Add new row to table
        _add = function (self)
            local section = x:add(self.own_table.__tablename__, "interface")
            for key, val in pairs(self._data) do
                -- Cursor:set (config, section, option, value)
                if(self.own_table:has_column(key)) then
                    local column = self.own_table:get_column(key)
                    x:set(self.own_table.__tablename__, section, key, val.new)               
                end
            end
            self._data['section_id'] = {
                new = section
            }
            x:save(self.own_table.__tablename__)
            x:commit(self.own_table.__tablename__)
        end,

        -- Update data in database
        _update = function (self, section_name)
            x:foreach(self.own_table.__tablename__, "interface", function(instance)
                if(instance['.name'] == section_name) then
                    for key, val in pairs(self._data) do
                        if(self.own_table:has_column(key)) then
                            local column = self.own_table:get_column(key)
                            x:set(self.own_table.__tablename__, section_name, key, val.new)               
                        end                  
                    end
                end
            end)
            x:save(self.own_table.__tablename__)
            x:commit(self.own_table.__tablename__)
        end,

        ------------------------------------------------
        --             User methods                   --
        ------------------------------------------------

        -- save row
        save = function (self)
            local rules = {}
            for colname, values in pairs(self._data) do
                rules[colname] = values.new
            end
            local instance = self.select_object:where(rules):all()    
            if #instance ~= 0 then
                local section_name = instance['.name']
                self:_update(section_name)
                self._data['section_id'] = {
                    new = section_name
                }
            else
                self:_add()
            end
        end,
    }
    if data then
        for colname, colvalue in pairs(data) do 
            if query.own_table:has_column(colname) then
                local column = query.own_table:get_column(colname)
                if((type(colvalue) == "number" or type(colvalue) == "boolean") and column.type == "string") then
                    colvalue = tostring(colvalue)
                elseif((type(colvalue) == "number" or type(colvalue) == "boolean") and column.type == "table") then
                    colvalue = {colvalue}
                elseif(type(colvalue) ~= "string" and type(colvalue) ~= "table") then
                    error("Data of invalid type given: column " .. colname .. " expected type: " .. column.type .. " got type: " .. type(colvalue)) 
                elseif type(colvalue) == "table" and column.type == "string" then
                    colvalue = ""
                    for _, val in ipairs(colvalue) do
                        colvalue = colvalue .. " " .. val 
                    end
                end
                query._data[colname] = {
                    old = query._data.new,
                    new = colvalue
                }                    
            end
        end
    else
        print("No data given: creating empty row instance for table '" ..
                        self.own_table.__tablename__ .. "'")
    end
    setmetatable(query, {__index = query._get_col,
    __newindex = query._set_col})
    return query
end

return Query