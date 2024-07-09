local serialize  = require "libraries/ser"

local funcs = {}

funcs.serialize = function(data)
    return serialize(data)
end

funcs.deserialize = function(data)
    -- conversion en table lua
    local deserialize = load(data)

    -- verificqtion que la table existe
    if deserialize then
        local table = deserialize()

        -- on debug la table
        --for key, value in pairs(table) do
        --    print(key, value)
        --end

        return table

    else
        return nil
    end
end

return funcs