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
    },
    FakePlates = {
        NoVehNearby = 'No vehicle nearby',
        PlateTaken = 'You cannot use that plate try another, or remove the fake plate on currently',
        PlateChanged = 'Plate Changed',
        PlateRemoved = 'Plate Removed',
        PlateChangeTitle = 'Change Plate',
        PlateChangeDesc = 'Change the plate on the vehicle',
        NoFakePlate = 'There is no fake plate on this vehicle',
        RemoveFakePlate = 'Remove Fake Plate',
    },
    Groups = {
        Created = 'Group Created',
        JoinedGroup = 'You have joined the group',
        HasJoinedGroup = ' has joined the group',
        GroupIsFull = 'Group is full',
        GroupMenu = 'Group Menu',
        InviteAMember = 'Invite a member to the group',
        IdOfMemberToInvite = 'ID of the member to invite',
        LeaveGroup = 'Leave Group',
        GroupInvite = 'Group Invite',
        BeenInvited = 'You have been invited to a group',
        Accept = 'Accept',
        Decline = 'Decline',
        LeftGroup = 'You have left the group',
        DisbandedGroup = 'Group has been disbanded',
        CommandName = 'groups',
        CommandDesc = 'Join or make a group!',
    }
}

return Locales