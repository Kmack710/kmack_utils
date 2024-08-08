local Utils = {}
local Bridge = exports.kmack_bridge:GetBridge()
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

--- if your owned vehicles are stored somewhere else you will have to change this
function Utils.CheckIfVehicleIsOwned(plate)
    local currentFramework = Bridge.Config.Framework
    if currentFramework == 'ox' then
        local dbVehicles = MySQL.query.await('SELECT * FROM vehicles WHERE plate = @plate', {
            ['@plate'] = plate
        })
        if dbVehicles[1] then
            return true
        end
    elseif currentFramework == 'qbx' or currentFramework == 'qb' then
        local dbVehicles = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = @plate', {
            ['@plate'] = plate
        })
        if dbVehicles[1] then
            return true
        end

    elseif currentFramework == 'esx' then
        local dbVehicles = MySQL.query.await('SELECT * FROM owned_vehicles WHERE plate = @plate', {
            ['@plate'] = plate
        })
        if dbVehicles[1] then
            return true
        end
    end
    return false
end

return Utils