local xpConfig = require 'modules.shared.xpSystem'
local Config = require 'config'
local Locales = require 'locales'
local Bridge = exports.kmack_bridge:GetBridge()

AddEventHandler('kmack_bridge:playerLoaded', function()
    TriggerServerEvent('kmack_lib:initXP') --- Get current xp and add any new xps if any added.
end)

local function GetXpLevel(xptype)
    return lib.callback.await('kmack_lib:getXpLevel', false, xptype)
end

exports('GetXpLevel', GetXpLevel)

local function convertXpToPercent(xptype, xp)
    -- check for if xp doubles per level then figure out what the % of the current level they are away from the next
    local xpDoublesAmountPerLevel = xpConfig[xptype].doubleXpReqPerLevel
    local currentLevel = GetXpLevel(xptype)

    if xpDoublesAmountPerLevel then
        --- calculate the xp needed to get to next level remember, it doubles each level example: level 1 = 100xp, level 2 = 200xp, level 3 = 400xp
        --- so we need to calculate the xp needed to get to the next level
        local xpNeeded = xpConfig[xptype].xpPerLevel
        local lastLvlXp = 0
        for i=1, currentLevel do
            xpNeeded = xpNeeded * 2
            if i == currentLevel - 1 then
                lastLvlXp = i
            end
        end
        print('XP needed: '..xpNeeded..' - Last level xp: '..lastLvlXp)
        --- use lastlvlxp and xpneeded to calculate the % of the current level the person is through
        local percent = ((xp - lastLvlXp) / (xpNeeded - lastLvlXp)) * 100
        print(percent)
        percent = math.floor(percent)
        return percent
    else
        --- calculate the xp needed to get to next level
        local xpNeeded = xpConfig[xptype].xpPerLevel * currentLevel
        --- use lastlvlxp and xpneeded to calculate the % of the current level the person is through
        local percent = (xp / xpNeeded) * 100
        percent = math.floor(percent)
        print(percent)
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

RegisterNetEvent('kmack_lib:xp:menu', function()
    local Player = Bridge.Framework.PlayerDataC()
    local myXPData = lib.callback.await('kmack_lib:getMyXpData', false)
    local menuOptions = {}
    print(Player.Job.name)
    for k,v in pairs(myXPData) do
        local percent = convertXpToPercent(k, v.xp)
        print(percent)
        --- check the jobs from config and dont add ones that are set to criminal
        --- if they are criminal then we dont want to show them in the xp menu for the jobs in Config.
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