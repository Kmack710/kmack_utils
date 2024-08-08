Config = {
    GroupSystem = {
        enabled = true,
        maxGroupSize = 5,
    },
    VehicleKeys = {
        enabled = true,
        keybind = 'U', -- keybind to lock/unlock vehicle
        disableAutoOnOff = true, -- disables auto on/off for vehicles
        lockAllLocalVehicles = true, -- lock all vehicles 
        engineToggle = 'G', --- engine off/on key
        carjackingAlertChance = 10, -- percent chance of alerting police when carjacking set 0 for none
        advancedLockpick = 'advancedlockpick', -- Item name or false for just normal lockpicks
        lockpickItem = 'lockpick', -- Item name (required)
        lockpickDiff = 'easy', -- easy, medium, hard
        hotwireDiff = 'easy', -- easy, medium, hard
        chanceToRemoveLockpick = 50, -- percent chance to remove lockpick on fails
        chanceToRemoveAdvLockpick = 5, -- percent chance to remove advanced lockpick on fails
    },
    xpSystem = {
        enabled = true,
        hideCriminalXpFromJobs = true, --- hides criminal xp from jobs listed below
        nonCriminalJobs = {'police', 'ambulance', 'judge', 'sheriff'},
        --- if enabled look at modules/shared/xpSystem.lua
        --- to add ranks / new xp levels
    },
    FakePlates = {
        enabled = true,
        keepPlateInGarage = true,
        --- Keeping the plate in garage requires adding an export to your garage resource
        --- see the docs for info on how to do this.       
        fakePlateRemoval = true, --- by a job or item below
        RemovalJobs ={'police', 'sheriff'},
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