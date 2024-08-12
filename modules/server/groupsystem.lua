print('^4 [kmack_utils] ^6Loaded Group System^7')
local Config = require 'config'
local Bridge = exports.kmack_bridge:GetBridge()
local Locales = require 'locales'
local Groups = {}

local function GetGroupLeader(GroupId)
    if Groups[GroupId] then
        local Leader = Bridge.Framework.GetPlayerFromPidS(Groups[GroupId][1])
        return Leader.Source
    end
    return false
end

local function GetGroupMembers(GroupId)
    if Groups[GroupId] then
        local Members = {}
        for k,v in pairs(Groups[GroupId]) do
            local Member = Bridge.Framework.GetPlayerFromPidS(v)
            table.insert(Members, Member.Source)
        end
        return Members
    end
    return false
end

local function FindGroupByMember(source)
    local Player = Bridge.Framework.PlayerDataS(source)
    for k,v in pairs(Groups) do
        for i,j in pairs(v) do
            if j == Player.Pid then
                return k
            end
        end
    end
    return false
end

local function GetGroupMembersCount(GroupId)
    local count = 0
    if Groups[GroupId] then
        for k,v in pairs(Groups[GroupId]) do
            if v then
                count = count + 1
            end
        end
    end
end

local function CreateBlipForGroup(groupId, name, data)
    if Groups[groupId] then
        for k,v in pairs(Groups[groupId]) do
            local Player = Bridge.Framework.GetPlayerFromPidS(v)
            if Player then
                TriggerClientEvent('kmack_utils:group:blip', Player.Source, name, data)
            end
        end
    end
end

local function RemoveBlipForGroup(groupId, name)
    if Groups[groupId] then
        for k,v in pairs(Groups[groupId]) do
            local Player = Bridge.Framework.GetPlayerFromPidS(v)
            if Player then
                TriggerClientEvent('kmack_utils:group:removeBlip', Player.Source, name)
            end
        end
    end
end

local function SendGroupClientEvent(groupId, event, args)
    if Groups[groupId] then
        for k,v in pairs(Groups[groupId]) do
            local Player = Bridge.Framework.GetPlayerFromPidS(v)
            if Player then
                TriggerClientEvent(event, Player.Source, args)
            end
        end
    end
end

local function SendGroupServerEvent(groupId, event, args)
    if Groups[groupId] then
        table.insert(args, 1, groupId)
        TriggerEvent(event, args)
    end
end

local function NotifyGroup(groupId, message)
    if Groups[groupId] then
        for k,v in pairs(Groups[groupId]) do
            local Player = Bridge.Framework.GetPlayerFromPidS(v)
            if Player then
                Bridge.Noti.Info(Player.Source, message)
            end
        end
    end
end

lib.callback.register('kmack_utils:group:getMyGroup', function(source)
    local myGroup = FindGroupByMember(source)
    return myGroup
end)
lib.callback.register('kmack_utils:group:isGroupLeader', function(source)
    local Player = Bridge.Framework.PlayerDataS(source)
    local myGroup = FindGroupByMember(source)
    if myGroup then
        if Groups[myGroup][1] == Player.Pid then
            return true
        end
    end
    return false
end)

lib.callback.register('kmack_utils:groups:getGroupMembers', function(source, groupId)
    if Groups[groupId] == nil then return false end
    return Groups[groupId]
end)

lib.callback.register('kmack_utils:getPlayerName', function(source, Pid)
    local Player = Bridge.Framework.GetPlayerFromPidS(Pid)
    if not Player then return false end
    return Player.Name
end)


RegisterNetEvent('kmack_utils:group:createGroup', function()
    local source = source
    local Player = Bridge.Framework.PlayerDataS(source)
    local GroupId = #Groups + 1
    Groups[GroupId] = {}
    table.insert(Groups[GroupId], Player.Pid)
    Bridge.Noti.Info(source, Locales.Groups.Created)
end)

RegisterNetEvent('kmack_utils:group:invitePlayer', function(target)
    local source = source
    local GroupId = FindGroupByMember(source)
    if GroupId then
        if #Groups[GroupId] >= Config.GroupSystem.maxGroupSize then
            Bridge.Noti.Error(source, Locales.Groups.GroupIsFull)
            return
        end
        TriggerClientEvent('kmack_utils:group:invite', target, source, GroupId)
    end
end)

RegisterNetEvent('kmack_utils:group:acceptInvite', function(groupLeader)
    local source = source
    local Player = Bridge.Framework.PlayerDataS(source)
    local GroupId = FindGroupByMember(groupLeader)
    if GroupId then
        if #Groups[GroupId] >= Config.GroupSystem.maxGroupSize then
            Bridge.Noti.Error(source, Locales.Groups.GroupIsFull)
            Bridge.Noti.Error(groupLeader, Player.Name..Locales.Groups.GroupIsFull)
            return
        end
        table.insert(Groups[GroupId], Player.Pid)
        Bridge.Noti.Info(source, Locales.Groups.JoinedGroup)
        Bridge.Noti.Info(groupLeader, Player.Name..Locales.Groups.HasJoinedGroup)
    end
end)

RegisterNetEvent('kmack_utils:group:leaveGroup', function()
    local source = source
    local Player = Bridge.Framework.PlayerDataS(source)
    local GroupId = FindGroupByMember(source)
    if GroupId then
        if Groups[GroupId][1] == Player.Pid then
            table.remove(Groups, GroupId)
            Bridge.Noti.Success(source, Locales.Groups.DisbandedGroup)
        else
            for k,v in pairs(Groups[GroupId]) do
                if v == Player.Pid then
                    table.remove(Groups[GroupId], k)
                    Bridge.Noti.Info(source, Locales.Groups.LeftGroup)
                    return
                end
            end
        end
    end
end)

exports('GetGroupLeader', GetGroupLeader)
exports('GetGroupMembers', GetGroupMembers)
exports('FindGroupByMember', FindGroupByMember)
exports('GetGroupMembersCount', GetGroupMembersCount)
exports('CreateBlipForGroup', CreateBlipForGroup)
exports('RemoveBlipForGroup', RemoveBlipForGroup)
exports('SendGroupClientEvent', SendGroupClientEvent)
exports('SendGroupServerEvent', SendGroupServerEvent)
exports('NotifyGroup', NotifyGroup)