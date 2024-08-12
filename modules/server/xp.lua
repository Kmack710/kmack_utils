print('^4 [kmack_utils] ^2Loaded XP System^7')
local xpConfig = require 'modules.shared.xpSystem'
local Config = require 'config'
local Bridge = exports.kmack_bridge:GetBridge()
local Locales = require 'locales'

RegisterNetEvent('kmack_utils:initXP', function()
    local source = source
    local Player = Bridge.Framework.PlayerDataS(source)
    local Pid = Player.Pid
    local currentXPdata = {}
    local result = MySQL.query.await('SELECT * FROM kmack_xp WHERE pid = @pid', {
        ['@pid'] = Pid
    })
    if result[1] then
        currentXPdata = json.decode(result[1].data)
        local newXpsToAdd = false
        for k,v in pairs(xpConfig) do
            if currentXPdata[k] == nil then
                newXpsToAdd = true
                currentXPdata[k] = {level = 0, xp = 0}
            end
        end
        if newXpsToAdd then
            MySQL.query('UPDATE kmack_xp SET data = @data WHERE pid = @pid', {
                ['@pid'] = Pid,
                ['@data'] = json.encode(currentXPdata)
            })
        end
    else
        for k,v in pairs(xpConfig) do
            currentXPdata[k] = {level = 0, xp = 0}
        end
        MySQL.query('INSERT INTO kmack_xp (pid, data) VALUES (@pid, @data)', {
            ['@pid'] = Pid,
            ['@data'] = json.encode(currentXPdata)
        })
    end
end)

local function getLevelFromXP(xp, xptype)
    local level = 0
    if xpConfig[xptype] == nil then 
        print('^4 [kmack_utils] ^1Error: ^7'..xptype..' is not a valid xp type')
        return false
    end
    local xpNeededPerLevel = xpConfig[xptype].xpPerLevel
    local doubleXpReqPerLvl = xpConfig[xptype].doubleXpReqPerLvl
    local xpNeeded = xpNeededPerLevel
    if doubleXpReqPerLvl then
        for i=1, xp do
            xpNeeded = xpNeeded * 2
            if xpNeeded <= xp then
                level = level + 1
            else
                break
            end
        end
    else
        level = math.floor(xp / xpNeededPerLevel)
        if level < 1 then
            level = 0
        end
    end
    return level
end

local function AddXp(source, xptype, amount)
    local Player = Bridge.Framework.PlayerDataS(source)
    local Pid = Player.Pid
    local currentXPdata = {}
    if xpConfig[xptype] == nil then 
        print('^4 [kmack_utils] ^1Error: ^7'..xptype..' is not a valid xp type')
        return false
    end
    local result = MySQL.query.await('SELECT * FROM kmack_xp WHERE pid = @pid', {
        ['@pid'] = Pid
    })
    local levelChanged = false
    if result[1] then
        currentXPdata = json.decode(result[1].data)
        if currentXPdata[xptype] == nil then
            currentXPdata[xptype] = {level = 0, xp = 0}
        end
        local currentXp = currentXPdata[xptype].xp
        local currentLevel = currentXPdata[xptype].level
        currentXPdata[xptype].xp = currentXp + amount
        local newLevel = getLevelFromXP(currentXPdata[xptype].xp, xptype)
        if newLevel > currentLevel then
            levelChanged = true
            currentXPdata[xptype].level = newLevel
        end
        MySQL.query('UPDATE kmack_xp SET data = @data WHERE pid = @pid', {
            ['@pid'] = Pid,
            ['@data'] = json.encode(currentXPdata)
        })
        if levelChanged then
            if xpConfig[xptype].notifyOnLevelUp then
                Bridge.Noti.Success(source, 'You have leveled up in '..xptype..' to '..xpConfig[xptype].ranks[newLevel])
            end
        end
    end
end

local function RemoveXp(source, xptype, amount)
    local Player = Bridge.Framework.PlayerDataS(source)
    local Pid = Player.Pid
    local currentXPdata = {}
    if xpConfig[xptype] == nil then 
        print('^4 [kmack_utils] ^1Error: ^7'..xptype..' is not a valid xp type')
        return
    end
    local result = MySQL.query.await('SELECT * FROM kmack_xp WHERE pid = @pid', {
        ['@pid'] = Pid
    })
    if result[1] then
        currentXPdata = json.decode(result[1].data)
        local levelChange = false
        
        if currentXPdata[xptype] == nil then
            currentXPdata[xptype] = {level = 0, xp = 0}
        end
        local currentXp = currentXPdata[xptype].xp
        local currentLevel = currentXPdata[xptype].level
        currentXPdata[xptype].xp = currentXp - amount
        local newLevel = getLevelFromXP(currentXPdata[xptype].xp, xptype)
        if newLevel < currentLevel then
            levelChange = true
            if newLevel < 1 then
                newLevel = 0
            end
            currentXPdata[xptype].level = newLevel
        end
    end

end

local function GetXpLevel(source, xptype)
    local Player = Bridge.Framework.PlayerDataS(source)
    local Pid = Player.Pid
    local currentXPdata = {}
    if xpConfig[xptype] == nil then 
        print('^4 [kmack_utils] ^1Error: ^7'..xptype..' is not a valid xp type')
        return 0
    end
    local result = MySQL.query.await('SELECT * FROM kmack_xp WHERE pid = @pid', {
        ['@pid'] = Pid
    })
    if result[1] then
        currentXPdata = json.decode(result[1].data)
        
        if not currentXPdata[xptype] and xpConfig[xptype] ~= nil then
            currentXPdata[xptype] = {level = 0, xp = 0}
        end
        return currentXPdata[xptype].level
    end
    return 0
end

lib.callback.register('kmack_utils:getXpLevel', function(source, xptype)
    return GetXpLevel(source, xptype)
end)
lib.callback.register('kmack_utils:getMyXpData', function(source)
    local Player = Bridge.Framework.PlayerDataS(source)
    local Pid = Player.Pid
    local currentXPdata = {}
    local result = MySQL.query.await('SELECT * FROM kmack_xp WHERE pid = @pid', {
        ['@pid'] = Pid
    })
    if result[1] then
        currentXPdata = json.decode(result[1].data)
        return currentXPdata
    end
    return false
end)

exports('AddXp', AddXp)
exports('RemoveXp', RemoveXp)
exports('GetXpLevel', GetXpLevel)



lib.addCommand(Locales.XpSystem.OpenXpMenu, {
    help = Locales.XpSystem.OpenXpMenuDesc,
}, function(source, args, raw)
    TriggerClientEvent('kmack_utils:xp:menu', source)
end)


--- Create sql table if not already made.
MySQL.query('CREATE TABLE IF NOT EXISTS kmack_xp (pid VARCHAR(250), data LONGTEXT)')
