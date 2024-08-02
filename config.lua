Config = {
    GroupSystem = {
        enabled = true,
        maxGroupSize = 5,
    },
    VehicleKeys = {
        enabled = true,
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
        fakePlateRemoval = true,
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