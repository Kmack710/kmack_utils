local Elevators = require 'modules.shared.elevators'
local Bridge = exports.kmack_bridge:GetBridge()
local Config = require 'config'

local function takeElevator(id, tofloor, fromfloor)
    DoScreenFadeOut(2500)
    Wait(2500)
    local coords = Elevators[id].floors[tofloor].exitCoords
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, false, false, false, false)
    SetEntityHeading(cache.ped, coords.w)
    DoScreenFadeIn(2500)
end

local function createElevatorTarget(id, floor)
    local menuOptions = {}

    for k,v in pairs(Elevators[id].floors) do
        local disabled = false
        if k == floor then
            disabled = true
        end
        table.insert(menuOptions, {
            title = v.label,
            icon = 'elevator',
            onSelect = function()
                takeElevator(id, k, floor)
            end,
            disabled = disabled
        })
    end
    local parameters = {
        coords = Elevators[id].floors[floor].coords,
        radius = 2.0,
        debug = false,
        options = {
            {
                onSelect = function()
                    lib.registerContext({
                        id = 'elevator_cmenu',
                        title = 'Elevator',
                        options = menuOptions
                    })
                    lib.showContext('elevator_cmenu')
                end,
                label = 'Elevator',
                icon = 'elevator'
            }
        }
    }
    exports.ox_target:addSphereZone(parameters)
end

local function onEnter(id, floor)
    local radialItems = {}
    for k,v in pairs(Elevators[id].floors) do
        if k == floor then
            v.label = 'Current Floor'
        end
        table.insert(radialItems, {
            label = v.label,
            icon = 'elevator',
            onSelect = function()
                takeElevator(id, k, floor)
            end
        })
    end
    lib.registerRadial({
        id = 'elevator_menu',
        items = radialItems
      })
    lib.addRadialItem({
        {
            id = 'elevators',
            label = 'Elevator',
            icon = 'elevator',
            menu = 'elevator_menu'
        }
    })
end

local function onExit()
    lib.removeRadialItem('elevators')
end

local function createElevatorZone(id, floor)
    local poly = lib.zones.poly({
        points = Elevators[id].floors[floor].zone,
        thickness = 2,
        debug = false,
        onEnter = function()
            onEnter(id, floor)
        end,
        onExit = onExit
    })
end
local isPlayerLoaded = false
AddEventHandler('kmack_bridge:playerLoaded', function(source)
    isPlayerLoaded = true
end)

CreateThread(function()
    while not isPlayerLoaded do
        Wait(100)
    end
    for k,v in pairs(Elevators) do
        for k2, v2 in pairs(v.floors) do 
            if Config.Elevators.method == 'target' then
                createElevatorTarget(k, k2)
            elseif Config.Elevators.method == 'radial' then
                createElevatorZone(k, k2)
            end
        end
    end
end)