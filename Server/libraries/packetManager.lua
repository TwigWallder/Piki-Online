local serialize  = require("libraries.ser")

local pm = {}

-- conversion en string pour envoyer en ligne
function pm:serialize(data)
    return serialize(data)
end

function pm:deserialize(data)
    -- conversion en table lua
    local deserialize = load(data)

    -- verificqtion que la table existe
    if deserialize then
        local table = deserialize()
        return table
    else
        return nil
    end
end

-- cette fonction creer
function pm:createPacket(type, data)
    return {
        -- pour eviter de faire de la merde
        -- le type sera toujous en minuscule
        type = string.lower(type),
        data = data
    }
end

return pm
