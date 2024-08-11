local Config = require 'config'
local Locales = require 'locales'
local Bridge = exports.kmack_bridge:GetBridge()
local function openGroupMenu()
    local myGroup = lib.callback.await('kmack_utils:group:getMyGroup', false)
    if not myGroup then
        TriggerServerEvent('kmack_utils:group:createGroup')
        return
    else
        local isGroupLeader = lib.callback.await('kmack_utils:group:isGroupLeader', false)
        local MenuOptions = {}
        local GroupMembers = lib.callback.await('kmack_utils:groups:getGroupMembers', false, myGroup)
        local groupSize = #GroupMembers
        print(groupSize)
        print(isGroupLeader)
        local Player = Bridge.Framework.PlayerDataC()
        if isGroupLeader then
            for k, v in pairs(GroupMembers) do
                if v == GroupMembers[1] then
                    table.insert(MenuOptions, {
                        title = Player.Name,
                        icon = 'crown',
                        onSelect = function()
                            lib.hideContext(true)
                        end,
                    })
                else
                    table.insert(MenuOptions, {
                        title = lib.callback.await('kmack_utils:getPlayerName', false, v),
                        icon = 'people-group',
                        onSelect = function()
                            lib.hideContext(true)
                        end,
                    })
                end
                
                end
                if groupSize < Config.GroupSystem.maxGroupSize then
                    table.insert(MenuOptions, {
                        title = Locales.Groups.InviteAMember,
                        icon = 'paper-plane',
                        onSelect = function()
                            local input = lib.inputDialog(Locales.Groups.InviteAMember, {
                                {type = 'number', label = Locales.Groups.IdOfMemberToInvite,  icon = 'hashtag'},
                              })
                            if not input then return end
                            TriggerServerEvent('kmack_utils:group:invitePlayer', input[1])
                            lib.hideContext(true)
                        end,
                    })
                end
            end
            table.insert(MenuOptions, {
                title = Locales.Groups.LeaveGroup,
                icon = 'door-open',
                onSelect = function()
                    TriggerServerEvent('kmack_utils:group:leaveGroup')
                    lib.hideContext(true)
                end,
            })
            lib.registerContext(({
                id = 'groupMenuc',
                title = Locales.Groups.GroupMenu,
                options = MenuOptions
            }))
            lib.showContext('groupMenuc')
        end

end

exports('openGroupMenu', openGroupMenu)

RegisterNetEvent('kmack_utils:group:invite', function(leadersrc, groupId)
    local alert = lib.alertDialog({
        header =  Locales.Groups.GroupInvite,
        content = Locales.Groups.BeenInvited,
        centered = true,
        cancel = true,
        labels = {
            cancel = Locales.Groups.Decline,
            confirm = Locales.Groups.Accept
        }
    })
    if alert == 'confirm' then
        TriggerServerEvent('kmack_utils:group:acceptInvite', leadersrc, groupId)
    end
end)

if Config.GroupSystem.addGroupsToRadial then
    lib.addRadialItem({
        id = 'groupMenu',
        label = Locales.Groups.GroupMenu,
        icon = 'people-group',
        onSelect = function()
            openGroupMenu()
        end,
    })
end
if Config.GroupSystem.useCommand then
    RegisterCommand(Locales.Groups.CommandName, function()
        openGroupMenu()
    end, false)
    TriggerEvent('chat:addSuggestion', '/'..Locales.Groups.CommandName, Locales.Groups.CommandDesc, {})
end