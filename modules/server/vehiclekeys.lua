local Locales = require "locales"
print('^4 [kmack_lib] ^4Loaded Vehicle Keys System^7')
local Config = require "config"
local vehicleKeys = {}
local Bridge = exports.kmack_bridge:GetBridge()
--- vehicleKeys[plate] = {Pid,Pid,Pid} --- holds all the keyholders for a plate

local function hasKeys(source, plate)
    local Player = Bridge.Framework.PlayerDataS(source)
    if vehicleKeys[plate] then
        for k,v in pairs(vehicleKeys[plate]) do
            if v == Player.Pid then
                return true
            end
        end
    end
    return false
end
exports('hasKeys', hasKeys)

lib.callback.register('kmack_lib:vehicleKeys:hasKeys', function(source, plate)
    return hasKeys(source, plate)
end)

local function giveKeysPerm(source, plate)
    local Player = Bridge.Framework.PlayerDataS(source)
    if not vehicleKeys[plate] then
        vehicleKeys[plate] = {}
    end
    table.insert(vehicleKeys[plate], Player.Pid)
    --- get sql table first so we dont add temp keys to the database
    --- then add the keys to the database for permanent storage
    local currentDBKeys = MySQL.query.await('SELECT * FROM kmack_vehpermkeys WHERE plate = @plate', {
        ['@plate'] = plate
    })
    if currentDBKeys[1] then
        currentDBKeys = json.decode(currentDBKeys[1].keyholders)
    else
        currentDBKeys = {}
    end
    table.insert(currentDBKeys, Player.Pid)
    if currentDBKeys[1] then
        MySQL.query('UPDATE kmack_vehpermkeys SET keyholders = @keyholders WHERE plate = @plate', {
            ['@plate'] = plate,
            ['@keyholders'] = json.encode(currentDBKeys)
        })
    else
        MySQL.query('INSERT INTO kmack_vehpermkeys (plate, keyholders) VALUES (@plate, @keyholders)', {
            ['@plate'] = plate,
            ['@keyholders'] = json.encode(currentDBKeys)
        })
    end
end
exports('giveKeysPerm', giveKeysPerm)

local function giveKeys(source, plate)
    local Player = Bridge.Framework.PlayerDataS(source)
    if not vehicleKeys[plate] then
        vehicleKeys[plate] = {}
    end
    table.insert(vehicleKeys[plate], Player.Pid)
end
exports('giveKeys', giveKeys)

lib.addCommand(Locales.Commands.GiveKeys, {
    help = Locales.VehicleKeys.GiveKeysDesc,
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = Locales.Commands.GiveKeysIdOfPerson,
            optional = true,
        },
    },
}, function(source, args, raw)
    local cloestVeh = lib.getClosestVehicle(GetEntityCoords(GetPlayerPed(source)), 5, true)
    local plate = GetVehicleNumberPlateText(cloestVeh)
    local target = args.target
    if not target then
        local ltarget, ab, abc = lib.getClosestPlayer(GetEntityCoords(GetPlayerPed(source)), 5)
        target = ltarget
    end
    if hasKeys(source, plate) then
        giveKeys(target, plate)
        Bridge.Noti.Success(source, Locales.VehicleKeys.KeysGiven)
        Bridge.Noti.Success(target, Locales.VehicleKeys.KeysReceived)
    else
        Bridge.Noti.Error(source, Locales.VehicleKeys.NoVehKeys)
    end
end)
local function removeKeys(source, plate)
    local Player = Bridge.Framework.PlayerDataS(source)
    if vehicleKeys[plate] then
        for k,v in pairs(vehicleKeys[plate]) do
            if v == Player.Pid then
                table.remove(vehicleKeys[plate], k)
            end
        end
    end
    local currentDBKeys = MySQL.query.await('SELECT * FROM kmack_vehpermkeys WHERE plate = @plate', {
        ['@plate'] = plate
    })
    if currentDBKeys[1] then
        currentDBKeys = json.decode(currentDBKeys[1].keyholders)
    else
        currentDBKeys = {}
    end
    for k,v in pairs(currentDBKeys) do
        if v == Player.Pid then
            table.remove(currentDBKeys, k)
        end
    end
    MySQL.query('UPDATE kmack_vehpermkeys SET keyholders = @keyholders WHERE plate = @plate', {
        ['@plate'] = plate,
        ['@keyholders'] = json.encode(currentDBKeys)
    })
end
exports('removeKeys', removeKeys)




MySQL.query('CREATE TABLE IF NOT EXISTS kmack_vehpermkeys (plate VARCHAR(10), keyholders LONGTEXT)')