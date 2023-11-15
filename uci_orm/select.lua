require("uci")
x = uci.cursor()

local function removeFieldsStartingWithDot(data)
    local newData = {}
    for _, tbl in pairs(data) do
        local temp = {}
        for key, val in pairs(tbl) do
            if not string.match(key, "^%s*%.") then
                temp[key] = val
            end
        end    
        table.insert(newData, temp)        
    end
    return newData
end

local function filter_data(self)
    local all_data = x:get_all(self.own_table.__tablename__)
    -- table(user)
    --     option(username)
    --     value(tom)
    local count = 0
    for _, _ in pairs(self._rules.where) do
        count = count + 1
    end
    
    if(count == 0) then
        return all_data
    end
    -- print(count)
    local filtered_data = {}
    for _, instance in pairs(all_data) do
        local flag = 0
        for col, val in pairs(self._rules.where) do
            if (instance[col] ~= val) then
                flag = 1
                -- print(instance.col)
            else
                
            end
        end
        if flag == 0 then
            table.insert(filtered_data, instance)
        end
    end
    return filtered_data
end

local Select = function(table)
    return {
        own_table = table,
        _rules = {
            where = {},
            limit = -1
        },
        where = function(self, args)
            for col, value in pairs(args) do
                self._rules.where[col] = value
            end
            return self
        end,

        all = function(self)
            return removeFieldsStartingWithDot(filter_data(self))
        end,

        first = function(self)
            local all_data = filter_data(self)
            return removeFieldsStartingWithDot(all_data[next(all_data)])
        end,

        limit = function(self, count)
            self._rules.limit = count
            return self
        end,

        delete = function(self, primary_keys)
            local filtered_data = filter_data(self)
            local counter = 0
            
            for key, val in pairs(filtered_data) do
                if(self._rules.limit ~= -1 and counter >= self._rules.limit) then
                   break
                end
                x:delete(self.own_table.__tablename__, val['.name'])
                counter = counter + 1
            end
            x:save(self.own_table.__tablename__)
            x:commit(self.own_table.__tablename__)
        end,
    }

end


return Select
