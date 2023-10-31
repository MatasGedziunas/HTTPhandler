require("uci")
x = uci.cursor()

local function print_callback(s)
    print("-------------------")
    for key, value in pairs(s) do 
        print(key .. ': ' .. tostring(value))
    end
end

function get_section_content(config, section)
    if not config then
        config = "config"
    end
    x:foreach(config, section, print_callback)
end

function set_section(config, section, type)
    if not config then
        config = "config"
    end
    x:set(config, section, type)
    x:commit(config)
end

function delete_section(config, section)
    if not config then
        config = "config"
    end
    x:delete(config, section)
    x:commit(config)
end

function set_option_value(config, section, option, value)
    if not config then
        config = "config"
    end
    x:set(config, section, option, value)
    x:commit(config)
end

function delete_option(config, section, option)
    if not config then
        config = "config"
    end
    x:delete(config, section, option)
    x:commit(config)
end

print(set_section(""))
print("wat")