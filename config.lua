Config = {
    GroupSystem = {
        enabled = true,
        maxGroupSize = 5,
        addGroupsToRadial = true, -- adds groups to radial menu
    },
    VehicleKeys = {
        enabled = true,
        keybind = 'U', -- keybind to lock/unlock vehicle
        disableAutoOnOff = true, -- disables auto on/off for vehicles
        lockAllLocalVehicles = true, -- lock all vehicles 
        engineToggle = 'G', --- engine off/on key (this is just default, each client can change in fivem keybinds after)
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
        hideCriminalXpFromJobs = false, --- hides criminal xp from jobs listed below
        nonCriminalJobs = {'police', 'ambulance', 'judge', 'sheriff'},
        --- if enabled look at modules/shared/xpSystem.lua
        --- to add ranks / new xp levels
    },
    FakePlates = {
        enabled = true,
        fakePlateRemoval = true, --- by a job with item below
        RemovalJobs = {'police', 'sheriff'},
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