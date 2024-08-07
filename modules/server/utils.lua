local Utils = {}

function Utils.SendDispatch(source, title, code, message)
    local data = {
        offense = title,
        code = code,
        blip = 162,
        coords = GetEntityCoords(GetPlayerPed(source)),
        info = {
            label = message,
            icon = 'exclamation-circle',
        }
    }
end


return Utils