ControlledZones = {}
PlayerZones = {} --tracks which zones players are in on server side

RegisterNetEvent('sayer-gangs:ZoneUpdate', function(zone, action)
    local src = source
    if not Config.Zones[zone] then 
        DebugCode("No Zone") 
        return 
    end
    
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then 
        DebugCode("No Player") 
        return 
    end
    
    local citizenid = Player.PlayerData.citizenid

    if action == "enter" then
        PlayerZones[citizenid] = PlayerZones[citizenid] or {}
        PlayerZones[citizenid].zone = zone
        PlayerZones[citizenid].timer = 0
        DebugCode("Zone [" .. zone .. "] Stored For: " .. citizenid)
    elseif action == "exit" then
        PlayerZones[citizenid] = PlayerZones[citizenid] or {}
        if PlayerZones[citizenid].zone ~= nil then
            if PlayerZones[citizenid].zone == zone then
                PlayerZones[citizenid] = nil
                DebugCode("Zone [" .. zone .. "] Removed For: " .. citizenid)
            end
        end
    else
        DebugCode("Invalid Action: " .. action)
    end
end)

RegisterNetEvent('sayer-gangs:InitialiseZones', function()
    MySQL.query('SELECT id FROM sayer_zones', {}, function(existingZones)
        -- Convert the existing zones into a lookup table for faster checks
        local existingZoneIds = {}
        for _, zone in ipairs(existingZones) do
            existingZoneIds[zone.id] = true
        end

        -- Loop through Config.Zones and add missing zones
        for zoneName, _ in pairs(Config.Zones) do
            if not existingZoneIds[zoneName] then
                MySQL.insert('INSERT INTO sayer_zones (id, owner, rep) VALUES (?, ?, ?)', {
                    zoneName,
                    'none',
                    0,
                })
            end
        end
    end)
end)

QBCore.Functions.CreateCallback('sayer-gangs:GetAllZonesInfo', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    MySQL.query('SELECT * FROM sayer_zones', {}, function(Zones)
        local FormattedZonesInfo = {}
        for _, zone in ipairs(Zones) do
            FormattedZonesInfo[zone.id] = {
                rep = zone.rep,
                owner = zone.owner,
                war = false,
            }
            if Wars[zone.id] ~= nil then
                FormattedZonesInfo[zone.id].war = true
            end
        end
        cb(FormattedZonesInfo)
    end)
end)

-- Helper Function for Adjusting Reputation
function AdjustZoneRep(currentRep, repToGive, sourceGang, ownedGang)
    if sourceGang == ownedGang then
        currentRep = math.min(currentRep + repToGive, Config.MaxRepInZones)
    else
        currentRep = currentRep - repToGive
        if currentRep <= 0 then
            currentRep = 0
            return currentRep, true -- Zone will be taken over
        end
    end
    return currentRep, false -- No takeover
end

function UpdateZoneRepCount(zone, amount, gang)
    if gang == nil then gang = 'none' end
    MySQL.update('UPDATE sayer_zones SET rep = ? WHERE id = ?', { amount, zone }, function(affectedRows)
        if affectedRows > 0 then
            DebugCode(string.format("Zone '%s' reputation updated to %d", zone, amount))
        else
            DebugCode(string.format("Failed to update reputation for zone '%s'", zone))
        end
    end)
    local discordData = {
        title = "Reputation Updated",
        message = "Reputation Updated For Zone: "..zone..", Gang: "..gang..", New Amount: "..amount,
    }
    SendDiscordMessage(discordData)
end

function TakeOverZone(zone, gang, points)
    DebugCode(string.format("Attempting to take over zone '%s' by gang '%s'", zone, gang))

    if not Gangs[gang] then
        DebugCode(string.format("Gang '%s' is not valid", gang))
        return
    end

    if not Config.Zones[zone] then
        DebugCode(string.format("Zone '%s' is not valid", zone))
        return
    end

    MySQL.update('UPDATE sayer_zones SET owner = ?, rep = ? WHERE id = ?', { gang, points, zone }, function(affectedRows)
        if affectedRows > 0 then
            -- Notify all clients about the zone change
            TriggerClientEvent('sayer-gangs:UpdateZoneBlip', -1, zone, gang, false)
            DebugCode(string.format("Zone '%s' successfully taken over by gang '%s'", zone, gang))
        else
            DebugCode(string.format("Failed to take over zone '%s'", zone))
        end
    end)
    local discordData = {
        title = "Zone Takeover",
        message = "Zone Takeover For Zone: "..zone..", Gang: "..gang..", Starting Reputation: "..points,
    }
    SendDiscordMessage(discordData)
end

function TriggerWar(zone, gang, points)
    if not Gangs[gang] then return end
    if not Config.Zones[zone] then return end

    local startTime = os.time()
    local editTime = Config.Wars.WarsLength * 60 -- Convert minutes to seconds
    local endTime = startTime + editTime
    Wars[zone] = {active = true, startTime = startTime, endTime = endTime, gangs = {}}
    Wars[zone].gangs[gang] = points
    TriggerClientEvent('sayer-gangs:UpdateZoneBlip', -1, zone, gang, true)
    TriggerClientEvent('sayer-gangs:NotifyWarStarted', -1, zone)
    DebugCode("zone war started")
    local discordData = {
        title = "War Started",
        message = "War Started For Zone: "..zone..", Gang: "..gang..", Starting War Points: "..points,
    }
    SendDiscordMessage(discordData)
end


function AddZoneWarPoints(gang,zone,points)
    DebugCode("reached war points")
    if not Gangs[gang] then return end
    if not Config.Zones[zone] then return end
    if not Wars[zone] then return end
    DebugCode("all things correct, adding")
    if Wars[zone].gangs[gang] then
        local currentPoints = Wars[zone].gangs[gang]
        local newPoints = currentPoints + points
        Wars[zone].gangs[gang] = newPoints
        DebugCode("Points Added for zone war, total: "..newPoints)
    else
        Wars[zone].gangs[gang] = points
        DebugCode("first entry points for zone war")
    end
    local discordPoints = Wars[zone].gangs[gang]
    local discordData = {
        title = "War Points Gained",
        message = "War Points Gained For Zone: "..zone..", Gang: "..gang..", New Points: "..discordPoints,
    }
    SendDiscordMessage(discordData)
end

function EndZoneWar(zone, gangs)
    if not Wars[zone] then return end

    local highestPoints = 0
    local controllingGang = nil
    local newGang = 'none'

    for gang, points in pairs(Wars[zone].gangs) do
        if points > highestPoints then
            highestPoints = points
            controllingGang = gang
        end
    end

    -- controllingGang will now hold the gang with the highest points
    if controllingGang then
        DebugCode(("Gang %s controls zone %s with %d points"):format(controllingGang, zone, highestPoints))
        -- Perform additional actions, such as rewarding the gang or updating the zone owner
        newGang = controllingGang
    else
        DebugCode(("No controlling gang for zone %s"):format(zone))
    end

    -- Reset the war for this zone
    Wars[zone] = nil
    TriggerClientEvent('sayer-gangs:UpdateZoneBlip', -1, zone, newGang, false)
    TriggerClientEvent('sayer-gangs:NotifyWarFinished', -1, newGang, zone)
    TakeOverZone(zone, newGang, highestPoints)
end

-- [EXPORTS]

function GetZoneDetails(zone)
    local retval = nil
    if not Config.Zones[zone] then return end
    MySQL.rawExecute('SELECT * FROM sayer_zones WHERE id = ?', { zone }, function(result)
        if result and result[1] then
            retval = {
                rep = result[1].rep,
                owner = result[1].owner,
                label = Config.Zones[zone].label
            }
        else
            retval = nil
        end
    end)
    return retval
end

exports('GetZoneDetails',GetZoneDetails)

function GetZoneOwner(zone)
    local retval = nil
    if not Config.Zones[zone] then return end
    MySQL.rawExecute('SELECT * FROM sayer_zones WHERE id = ?', { zone }, function(result)
        if result and result[1] then
            retval = result[1].owner
        else
            retval = nil
        end
    end)
    return retval
end

exports('GetZoneOwner',GetZoneOwner)

function GetZoneOwnerWithCID(citizenid, cb)
    local zone = PlayerZones[citizenid].zone
    if not Config.Zones[zone] then
        cb(nil)
        return
    end
    
    MySQL.rawExecute('SELECT * FROM sayer_zones WHERE id = ?', { zone }, function(result)
        if result and result[1] then    
            cb(result[1].owner)
        else
            cb(nil)
        end
    end)
end

exports('GetZoneOwnerWithCID', GetZoneOwnerWithCID)


function GetZoneRep(zone)
    local retval = nil
    if not Config.Zones[zone] then return end
    MySQL.rawExecute('SELECT * FROM sayer_zones WHERE id = ?', { zone }, function(result)
        if result and result[1] then
            retval = result[1].rep
        else
            retval = nil
        end
    end)
    return retval
end

exports('GetZoneRep',GetZoneRep)

function IsZoneOwned(zone)
    local retval = false
    if not Config.Zones[zone] then return end
    MySQL.rawExecute('SELECT * FROM sayer_zones WHERE id = ?', { zone }, function(result)
        if result and result[1] then
            local owner = result[1].owner
            if owner ~= 'none' then
                retval = true
            else
                retval = false
            end
        else
            retval = nil
        end
    end)
    return retval
end

exports('IsZoneOwned',IsZoneOwned)

function GetPlayerCountForZone(zone)
    if not Config.Zones[zone] then return end
    local PlayersInThisZone = 0
    if PlayerZones ~= nil then
        for k,v in pairs(PlayerZones) do
            if v.zone == zone then
                PlayersInThisZone = PlayersInThisZone + 1
            end
        end
    end
    return PlayersInThisZone
end

exports('GetPlayerCountForZone',GetPlayerCountForZone)

function GetPlayersInZone(zone)
    if not Config.Zones[zone] then return end
    local PlayersTable = {}
    if PlayerZones ~= nil then
        for k,v in pairs(PlayerZones) do
            if v.zone == zone then
                local Player = QBCore.Functions.GetPlayerByCitizenId(k)
                if Player ~= nil then
                    table.insert(PlayersTable, Player)
                end
            end
        end
    end
    return PlayersTable
end

exports('GetPlayersInZone',GetPlayersInZone)

function IsValidZone(zone)
    if Config.Zones[zone] ~= nil then
        return true
    else
        return false
    end
end

exports('IsValidZone',IsValidZone)

function IsValidGang(gang)
    if Gangs[gang] ~= nil then
        return true
    else
        return false
    end
end

exports('IsValidGang',IsValidGang)

function IsZoneWarActive(zone)
    if Config.Zones[zone] == nil then return nil end
    
    if Wars[zone] ~= nil then
        return true
    else
        return false
    end
end

exports('IsZoneWarActive',IsZoneWarActive)