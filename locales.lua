local Locales = {
    VehicleKeys = {
        NoVehKeys = 'You do not have the keys to this vehicle',
        Unlocked = 'Vehicle Unlocked',
        Locked = 'Vehicle Locked',
        EngineOff = 'Turn off Vehicle',
        EngineOn = 'Turned on Vehicle',
        KeysGiven = 'Keys Given',
        KeysReceived = 'Keys Received',
        Hotwired = 'Vehicle Hotwired',
        HotwireFailed = 'Hotwire Failed',
        AlreadyHasKey = 'You already have the keys to this vehicle?',
        NoVehNearby = 'No vehicle nearby',
        LockpickFailed = 'Lockpick Failed',
        NoLockpicks = 'You do not have any lockpicks',

    },
    Commands = {
        GiveKeys = 'givekey',
        GiveKeysDesc = 'Give keys to a vehicle',
        GiveKeysIdOfPerson = '(Optional) ID of the person you want to give keys to',
        GiveKeysPerm = 'givepermkey',
        GiveKeysPermDesc = 'Give permanent keys to a vehicle',
        GiveKeysPermIdOfPerson = '(Optional) ID of the person you want to give permanent keys to',
    },
    Dispatch = {
        CarJackingTitle = 'Car Jacking',
        CarJackingCode = '10-16',
        CarJackingMessage = 'Car Jacking in progress',
    },
    XpSystem = {
        Level = 'Level: ',
        XpMenuTitle = 'XP Menu',

        OpenXpMenuDesc = 'Open the XP Menu',
        OpenXpMenu = 'xp', --- Command name to open 
    }
}

return Locales