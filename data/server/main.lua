local Config = require 'config'

if Config.GroupSystem.enabled then
    require 'modules.server.groupsystem'
end
if Config.VehicleKeys.enabled then
    require 'modules.server.vehiclekeys'
end

if Config.FakePlates.enabled then
    require 'modules.server.fakeplates'
end
if Config.xpSystem.enabled then
    require 'modules.server.xp'
end
if Config.Elevators.enabled then
    print('^4 [kmack_utils] ^5Loaded Elevators System^7')
    --- Elevators is all client sided, so we dont need to load anything on server, but put this here so it shows with other prints
end
lib.versionCheck('Kmack710/kmack_utils')