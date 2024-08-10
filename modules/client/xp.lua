local xpConfig = require 'modules.shared.xpSystem'
local Config = require 'config'
local Locales = require 'locales'
local Bridge = exports.kmack_bridge:GetBridge()

AddEventHandler('kmack_bridge:playerLoaded', function()
    TriggerServerEvent('kmack_utils:initXP') --- Get current xp and add any new xps if any added.
end)

local function GetXpLevel(xptype)
    return lib.callback.await('kmack_utils:getXpLevel', false, xptype)
end

local function convertXpToPercent(xptype, xp)
    local xpDoublesAmountPerLevel = xpConfig[xptype].doubleXpReqPerLevel
    local currentLevel = GetXpLevel(xptype)

    if xpDoublesAmountPerLevel then
        local xpNeeded = xpConfig[xptype].xpPerLevel
        local lastLvlXp = 0
        for i=1, currentLevel do
            xpNeeded = xpNeeded * 2
            if i == currentLevel - 1 then
                lastLvlXp = i
            end
        end
        local percent = ((xp - lastLvlXp) / (xpNeeded - lastLvlXp)) * 100
        percent = math.floor(percent)
        return percent
    else
        local xpNeeded = xpConfig[xptype].xpPerLevel * currentLevel
        local percent = (xp / xpNeeded) * 100
        percent = math.floor(percent)
        return percent
    end
end

local function checkIfHasJobFromConfig(job)
    for k,v in pairs(Config.xpSystem.nonCriminalJobs) do
        if v == job then
            return true
        end
    end
    return false
end

RegisterNetEvent('kmack_utils:xp:menu', function()
    local Player = Bridge.Framework.PlayerDataC()
    local myXPData = lib.callback.await('kmack_utils:getMyXpData', false)
    local menuOptions = {}
    for k,v in pairs(myXPData) do
        local percent = convertXpToPercent(k, v.xp)
        if Config.xpSystem.hideCriminalXpFromJobs then
            if xpConfig[k].criminal then 
                if not checkIfHasJobFromConfig(Player.Job.name) then
                    table.insert(menuOptions, {
                        title = k.." "..Locales.XpSystem.Level..v.level..' - ('..xpConfig[k].ranks[v.level]..')',
                        icon = xpConfig[k].xpImage,
                        progress = percent,
                        colorScheme = 'teal',
                        onSelect = function()
                            lib.hideContext(true)
                        end,
                    }) 
                end
            else
                table.insert(menuOptions, {
                    title = k.." "..Locales.XpSystem.Level..v.level..' - ('..xpConfig[k].ranks[v.level]..')',
                    icon = xpConfig[k].xpImage,
                    progress = percent,
                    colorScheme = 'teal',
                    onSelect = function()
                        lib.hideContext(true)
                    end,
                })
            end
        else
            table.insert(menuOptions, {
                title = k.." "..Locales.XpSystem.Level..v.level..' - ('..xpConfig[k].ranks[v.level]..')',
                icon = xpConfig[k].xpImage,
                progress = percent,
                colorScheme = 'teal',
                onSelect = function()
                    lib.hideContext(true)
                end,
            })
        end
    end
    lib.registerContext(({
        id = 'xpMenu'..Player.Pid,
        title = Locales.XpSystem.XpMenuTitle,
        options = menuOptions
    }))
    lib.showContext('xpMenu'..Player.Pid)
end)

exports('GetXpLevel', GetXpLevel)