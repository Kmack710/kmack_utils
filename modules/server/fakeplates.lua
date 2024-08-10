print('^4 [kmack_utils] ^9Loaded Fakeplates System^7')
local Utils = require 'modules.server.utils'
local Bridge = exports.kmack_bridge:GetBridge()
local function checkIfFakePlateIsOn(plate)
    local result = MySQL.query.await('SELECT * FROM kmack_fakeplates WHERE plate = @plate', {
        ['@plate'] = plate
    })
    if result[1] then
        return result[1].fakeplate
    end
    return false
end

lib.callback.register('kmack_utils:checkIfFakePlateIsOn', function(source, plate)
    return checkIfFakePlateIsOn(plate)
end)

lib.callback.register('kmack_utils:checkIfPlateIsAFake', function(source, plate)
    local result = MySQL.query.await('SELECT * FROM kmack_fakeplates WHERE fakeplate = @fakeplate', {
        ['@fakeplate'] = plate
    })
    if result[1] then
        return true
    end
    return false

end)

local function checkForFakePlate(plate, vehicle)
    local fakePlate = checkIfFakePlateIsOn(plate)
    if fakePlate then
        SetVehicleNumberPlateText(vehicle, fakePlate)
        local vehNet = NetworkGetNetworkIdFromEntity(vehicle)
        TriggerClientEvent('kmack_utils:fakeplate:syncPlateChange', -1, vehNet, fakePlate)
    end
end

RegisterNetEvent('kmack_utils:fakeplate:checkForFakePlate', function(plate, vehNet)
    local source = source
    local fakePlate = checkIfFakePlateIsOn(plate)
    if fakePlate then
        local veh = NetworkGetEntityFromNetworkId(vehNet)
        SetVehicleNumberPlateText(veh, fakePlate)
        TriggerClientEvent('kmack_utils:fakeplate:syncPlateChange', -1, vehNet, fakePlate)
    end
end)

lib.callback.register('kmack_utils:checkIfPlateIsTaken', function(source, plate)
    local isPlateOwned = Utils.CheckIfVehicleIsOwned(plate)
    if isPlateOwned then
        return true
    end
    local fakePlateTaken = MySQL.query.await('SELECT * FROM kmack_fakeplates WHERE fakeplate = @fakeplate', {
        ['@fakeplate'] = plate
    })
    if fakePlateTaken[1] then
        return true
    end
    return false
end)

RegisterNetEvent('kmack_utils:fakeplate:putOnFakePlate', function(source, plate, vehNet)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(vehNet)
    local oldPlate = GetVehicleNumberPlateText(vehicle)
    SetVehicleNumberPlateText(vehicle, plate)
    TriggerClientEvent('kmack_utils:fakeplate:syncPlateChange', -1, vehNet, plate)
    Bridge.Inventory.RemoveItem(source, 'fakeplate', 1)
    if not Utils.CheckIfVehicleIsOwned(oldPlate) then
        return --- dont save the plate to database if its not owned
    end
    MySQL.query('INSERT INTO kmack_fakeplates (plate, fakeplate) VALUES (@plate, @fakeplate)', {
        ['@plate'] = oldPlate,
        ['@fakeplate'] = plate
    })
end)


RegisterNetEvent('kmack_utils:fakeplate:removeFakePlate', function(fakeplate, vehNet)
    local source = source
    local vehicle = NetworkGetEntityFromNetworkId(vehNet)
    local orgPlate = MySQL.query.await('SELECT * FROM kmack_fakeplates WHERE fakeplate = @fakeplate', {
        ['@fakeplate'] = fakeplate
    })
    if orgPlate[1] then
        SetVehicleNumberPlateText(vehicle, orgPlate[1].plate)
        TriggerClientEvent('kmack_utils:fakeplate:syncPlateChange', -1, vehNet, orgPlate[1].plate)
        MySQL.query('DELETE FROM kmack_fakeplates WHERE fakeplate = @fakeplate', {
            ['@fakeplate'] = fakeplate
        })
    end
end)

exports('checkForFakePlate', checkForFakePlate)

--- we use the database to store the plates, so if players put it in a garage you can utilize it later
MySQL.query('CREATE TABLE IF NOT EXISTS kmack_fakeplates (plate VARCHAR(10), fakeplate VARCHAR(10), PRIMARY KEY (plate, fakeplate))')