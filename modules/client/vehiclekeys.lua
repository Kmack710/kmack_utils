local Config = require 'config'
local Bridge = exports.kmack_bridge:GetBridge()
local Locales = require 'locales'
--- kmack_lib:vehicleKeys:hasKeys

local function hasKeys(plate)
    return lib.callback.await('kmack_lib:vehicleKeys:hasKeys', false, plate)
end

RegisterKeyMapping('+vehlock', 'Lock / Unlock Vehicle', 'keyboard', Config.VehicleKeys.keybind)
RegisterKeyMapping('+engine', 'Toggle Engine', 'keyboard', Config.VehicleKeys.engineToggle)

RegisterCommand('+engine', function()
    local Player = Bridge.Framework.PlayerDataC()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local vehicle, vehcoords = lib.getClosestVehicle(pedCoords, 1, true)
    if vehicle ~= 0 then
        local plate = GetVehicleNumberPlateText(vehicle)
        if hasKeys(plate) then
            local engine = GetIsVehicleEngineRunning(vehicle)
            if engine then
                Bridge.Noti.Warn(Locales.VehicleKeys.EngineOff)
                SetVehicleEngineOn(vehicle, false, false, true)
            else
                Bridge.Noti.Info(Locales.VehicleKeys.EngineOn)
                SetVehicleEngineOn(vehicle, true, false, true)
            end
        else
            Bridge.Noti.Error(Locales.VehicleKeys.NoVehKeys)
        end
    end
end, false)

RegisterCommand('+vehlock', function()
    local Player = Bridge.Framework.PlayerDataC()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local vehicle, vehcoords = lib.getClosestVehicle(pedCoords, 7, true)
    if vehicle ~= 0 then
        local plate = GetVehicleNumberPlateText(vehicle)
        if hasKeys(plate) then
            local locked = GetVehicleDoorLockStatus(vehicle)
            if locked == 1 or locked == 0 then
                Bridge.Noti.Success(Locales.VehicleKeys.Locked)
                SetVehicleDoorsLocked(vehicle, 2)
                local ped = PlayerPedId()
                if IsPedInAnyVehicle(ped, false) then return end
                lib.requestAnimDict('anim@mp_player_intmenu@key_fob@')
                TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 8.0, 8.0, -1, 52, 0, false, false, false)
                --TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, Config.LockAnimSound, 0.5)
                Wait(1500)
                ClearPedTasks(ped)
                RemoveAnimDict('anim@mp_player_intmenu@key_fob@')
            else
                Bridge.Noti.Warn(Locales.VehicleKeys.Unlocked)
                SetVehicleDoorsLocked(vehicle, 0)
                local ped = PlayerPedId()
                if IsPedInAnyVehicle(ped, false) then return end
                lib.requestAnimDict('anim@mp_player_intmenu@key_fob@')
                TaskPlayAnim(ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 8.0, 8.0, -1, 52, 0, false, false, false)
                --TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, Config.LockAnimSound, 0.5)
                Wait(1500)
                ClearPedTasks(ped)
                RemoveAnimDict('anim@mp_player_intmenu@key_fob@')
            end            
        else
            Bridge.Noti.Error(Locales.VehicleKeys.NoVehKeys)
        end
    end
end, false)

if Config.VehicleKeys.disableAutoOnOff then
    CreateThread(function()
        while true do
            SetPedConfigFlag(cache.ped, 429, 1) -- disable vehicle engine auto on
            SetPedConfigFlag(cache.ped, 241, 1)  -- disable vehicle engine auto off
            Wait(5000)
        end
    end)
end