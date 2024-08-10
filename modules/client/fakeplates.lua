local Locales = require 'locales'
local Bridge = exports.kmack_bridge:GetBridge()
RegisterNetEvent('kmack_utils:fakeplate:syncPlateChange', function(vehNet, plate)
    local veh = NetworkGetEntityFromNetworkId(vehNet)
    SetVehicleNumberPlateText(veh, plate)
end)

local function putOnFakePlate()
    local veh = lib.getClosestVehicle(GetEntityCoords(cache.ped), 5.0, false)
    if veh == nil then
        Bridge.Noti.Error(Locales.FakePlates.NoVehNearby)
        return
    end
    local plate = GetVehicleNumberPlateText(veh)
    local input = lib.inputDialog(Locales.FakePlates.PlateChangeTitle, {
        {type = 'input', label = Locales.FakePlates.PlateChangeTitle, description =  Locales.FakePlates.PlateChangeTitle, required = true, min = 2, max = 8},
      })
    if not input then return end
    local isPlateTaken = lib.callback.await('kmack_utils:checkIfPlateIsTaken', false, input[1])
    if isPlateTaken then
        Bridge.Noti.Error(Locales.FakePlates.PlateTaken)
        return
    end
    TriggerServerEvent('kmack_utils:fakeplate:putOnFakePlate', plate, input[1], NetworkGetNetworkIdFromEntity(veh))
end

local function removeFakePlate()
    local Player = Bridge.Framework.PlayerDataC()
    for k,v in pairs(Config.FakePlates.RemovalJobs) do
        if Player.Job.name == v then
            return
        end
    end 
    local veh = lib.getClosestVehicle(GetEntityCoords(cache.ped), 5.0, false)
    if veh == 0 then
        Bridge.Noti.Error(Locales.FakePlates.NoVehNearby)
        return
    end
    local plate = GetVehicleNumberPlateText(veh)
    local isFakePlate = lib.callback.await('kmack_utils:checkIfFakePlateIsOn', false, plate)
    if not isFakePlate then
        Bridge.Noti.Error(Locales.FakePlates.NoFakePlate)
        return
    end
    Bridge.Noti.Info(Locales.FakePlates.PlateRemoved)
    TriggerServerEvent('kmack_utils:fakeplate:removeFakePlate', plate, NetworkGetNetworkIdFromEntity(veh))
end

local function takeOffFakePlate()
    local veh = lib.getClosestVehicle(GetEntityCoords(cache.ped), 5.0, false)
    if veh == 0 then
        Bridge.Noti.Error(Locales.FakePlates.NoVehNearby)
        return
    end
    local plate = GetVehicleNumberPlateText(veh)
    plate = plate:gsub("^%s*(.-)%s*$", "%1")
    local isFakePlate = lib.callback.await('kmack_utils:checkIfPlateIsAFake', false, plate)
    if not isFakePlate then
        Bridge.Noti.Error(Locales.FakePlates.NoFakePlate)
        return
    end
    Bridge.Noti.Info(Locales.FakePlates.PlateRemoved)
    TriggerServerEvent('kmack_utils:fakeplate:removeFakePlate', plate, NetworkGetNetworkIdFromEntity(veh))
end

CreateThread(function()
    local options = {
        label = Locales.FakePlates.RemoveFakePlate,
        canInteract = function(entity)
            local cloestestVeh = lib.getClosestVehicle(GetEntityCoords(cache.ped), 5.0, false)
            local vehiclePlate = GetVehicleNumberPlateText(cloestestVeh)
            vehiclePlate = vehiclePlate:gsub("^%s*(.-)%s*$", "%1")
            local isFakePlate = lib.callback.await('kmack_utils:checkIfPlateIsAFake', false, vehiclePlate)
            local Player = Bridge.Framework.PlayerDataC()
            for k,v in pairs(Config.FakePlates.RemovalJobs) do
                if Player.Job.name == v then
                    return false
                end
            end 
            if isFakePlate then
                return true
            end
        end,
        onSelect = function()
            takeOffFakePlate()
        end,
        bones = {'boot', 'bonnet', 'exhaust'},
    }
    exports.ox_target:addGlobalVehicle(options)
end)

exports('removeFakePlate', removeFakePlate)
exports('putOnFakePlate', putOnFakePlate)