local Config = require 'config'
local Bridge = exports.kmack_bridge:GetBridge()
local Locales = require 'locales'
local Utils = require 'modules.client.utils'
--- kmack_utils:vehicleKeys:hasKeys

local function hasKeys(plate)
    return lib.callback.await('kmack_utils:vehicleKeys:hasKeys', false, plate)
end

RegisterKeyMapping('+vehlock', 'Lock / Unlock Vehicle', 'keyboard', Config.VehicleKeys.keybind)
RegisterKeyMapping('+engine', 'Toggle Engine', 'keyboard', Config.VehicleKeys.engineToggle)

RegisterCommand('+engine', function()
    local Player = Bridge.Framework.PlayerDataC()
    local pedCoords = GetEntityCoords(cache.ped)
    local vehicle, vehcoords = lib.getClosestVehicle(pedCoords, 1, true)
    local hasLockpick = lib.callback.await('kmack_utils:hasLockpick', false)
    local hasAdvLockpick = lib.callback.await('kmack_utils:hasAdvancedLockpick', false)
    
    if vehicle ~= 0 then
        if GetPedInVehicleSeat(vehicle, -1) ~= cache.ped then return end
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
        elseif hasLockpick or hasAdvLockpick then
           local success =  Utils.HotWireMinigame(Config.VehicleKeys.hotwireDiff, hasAdvLockpick)
              if success then
                 Bridge.Noti.Success(Locales.VehicleKeys.Hotwired)
                 SetVehicleEngineOn(vehicle, true, false, true)
                 TriggerServerEvent('kmack_utils:vehicleKeys:giveKeys', plate)
              else
                 Bridge.Noti.Error(Locales.VehicleKeys.HotwireFail)
              end

        else
            Bridge.Noti.Error(Locales.VehicleKeys.NoVehKeys)
        end
    end
end, false)

RegisterCommand('+vehlock', function()
    local Player = Bridge.Framework.PlayerDataC()
    local pedCoords = GetEntityCoords(cache.ped)
    local vehicle, vehcoords = lib.getClosestVehicle(pedCoords, 7, true)
    if vehicle ~= 0 then
        local plate = GetVehicleNumberPlateText(vehicle)
        if hasKeys(plate) then
            local locked = GetVehicleDoorLockStatus(vehicle)
            if locked == 1 or locked == 0 then
                Bridge.Noti.Success(Locales.VehicleKeys.Locked)
                SetVehicleDoorsLocked(vehicle, 2)
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5, "lock", 0.5)
                if IsPedInAnyVehicle(cache.ped, false) then return end
                lib.requestAnimDict('anim@mp_player_intmenu@key_fob@')
                TaskPlayAnim(cache.ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 8.0, 8.0, -1, 52, 0, false, false, false)
                Wait(500)
                ClearPedTasks(cache.ped)
                RemoveAnimDict('anim@mp_player_intmenu@key_fob@')
            else
                Bridge.Noti.Warn(Locales.VehicleKeys.Unlocked)
                SetVehicleDoorsLocked(vehicle, 0)
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5, "lock", 0.5)

                if IsPedInAnyVehicle(cache.ped, false) then return end
                lib.requestAnimDict('anim@mp_player_intmenu@key_fob@')
                TaskPlayAnim(cache.ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 8.0, 8.0, -1, 52, 0, false, false, false)
                Wait(500)
                ClearPedTasks(cache.ped)
                RemoveAnimDict('anim@mp_player_intmenu@key_fob@')
            end            
        else
            Bridge.Noti.Error(Locales.VehicleKeys.NoVehKeys)
        end
    end
end, false)

local function tryVehLockpick()
    local nearbyVeh = lib.getClosestVehicle(GetEntityCoords(cache.ped), 2, false)
    if nearbyVeh == 0 then
        Bridge.Noti.Error(Locales.VehicleKeys.NoVehNearby)
        return
    end
    local plate = GetVehicleNumberPlateText(nearbyVeh)
    if hasKeys(plate) then
        Bridge.Noti.Error(Locales.VehicleKeys.AlreadyHasKey)
        return
    end
    local hasLockpick = lib.callback.await('kmack_utils:hasLockpick', false)
    local hasAdvLockpick = lib.callback.await('kmack_utils:hasAdvancedLockpick', false)
    if hasLockpick or hasAdvLockpick then
        CreateThread(function()
            --- lockpick animation without props for time above 
            local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
            local animName = "machinic_loop_mechandplayer"
            RequestAnimDict(animDict)
            while not HasAnimDictLoaded(animDict) do
                Wait(100)
            end
            TaskPlayAnim(cache.ped, animDict, animName, 8.0, 8.0, -1, 1, 0, false, false, false)
            --
        end)
        local success = Utils.SkillBarMinigame(Config.VehicleKeys.lockpickDiff, hasAdvLockpick)
        ClearPedTasks(cache.ped)
        if success then
            -- set doors unlocked
            SetVehicleDoorsLocked(nearbyVeh, 0)
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'lock', 0.5)
        else
            TriggerServerEvent('kmack_utils:vehicleKeys:failedLockpick', hasAdvLockpick)
            Bridge.Noti.Error(Locales.VehicleKeys.LockpickFailed)
        end
    else
        Bridge.Noti.Error(Locales.VehicleKeys.NoLockpicks)
    end

end

RegisterNetEvent('kmack_utils:vehicleKeys:tryVehLockpick', function()
    tryVehLockpick()
end)

if Config.VehicleKeys.disableAutoOnOff then
    CreateThread(function()
        while true do
            SetPedConfigFlag(cache.ped, 429, 1) -- disable vehicle engine auto on
            SetPedConfigFlag(cache.ped, 241, 1)  -- disable vehicle engine auto off
            Wait(5000)
        end
    end)
end

exports('tryVehLockpick', tryVehLockpick)