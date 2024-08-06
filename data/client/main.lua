--- Loads all enabled client-side modules
local Config = require 'config'

if Config.GroupSystem.enabled then
    require 'modules.client.groupsystem'
end
if Config.VehicleKeys.enabled then
    require 'modules.client.vehiclekeys'
end

if Config.FakePlates.enabled then
    require 'modules.client.fakeplates'
end
if Config.xpSystem.enabled then
    require 'modules.client.xp'
end
if Config.Elevators.enabled then
    require 'modules.client.elevators'
end