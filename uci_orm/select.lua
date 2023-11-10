require("uci")
x = uci.cursor()

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

        get = function(self)
            local data = x:get_all(self.own_table.__tablename__)
            -- table(user)
            --     option(username)
            --     value(tom)
            return data
        end,

        first = function(self)
            self.rules.limit = 1
            return self
        end,
    }
    
end

print(x:get_all("example").general.netmask)

return Select