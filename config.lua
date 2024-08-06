Config = {
    GroupSystem = {
        enabled = true,
        maxGroupSize = 5,
    },
    VehicleKeys = {
        enabled = true,
        keybind = 'U', -- keybind to lock/unlock vehicle
        disableAutoOnOff = true, -- disables auto on/off for vehicles
        engineToggle = 'G',
    },
    xpSystem = {
        enabled = true,
        --- if enabled look at modules/shared/xpSystem.lua
        --- to add ranks / new xp levels
    },
    FakePlates = {
        enabled = true,
        keepPlateInGarage = true,
        --- Keeping the plate in garage requires adding an export to your garage resource
        --- see the docs for info on how to do this.       
        fakePlateRemoval = true, --- by a job or item below
        RemovalJob = 'police',
        RemovalItem = 'fscrewdriver',
    },
    Elevators = { --- Simple elevator system with fade in/out
        enabled = true,
        method = 'radial', -- radial or target
        --- if enabled look at modules/shared/elevator.lua
        --- to add new elevators
    },

    --- future updates
    --- MultiJob?
    --- NPC Hostage system
    --- 
}

return Config