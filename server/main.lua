
Cooldowns = {}
Wars = {}

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end
    TriggerEvent('sayer-gangs:InitialiseZones')
end)

AddEventHandler('onResourceStop', function(resource) 
    if resource ~= GetCurrentResourceName() then 
        return 
    end
    
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    print("playerDropped: Citizenid: "..citizenid)
    PlayerZones[citizenid] = nil
end)

AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    print("playerUnloaded: Citizenid: "..citizenid)
    PlayerZones[citizenid] = nil
end)

-- trigger from client
RegisterNetEvent('sayer-gangs:AddRepClient',function(activity)
    local src = source
    AddZoneRep(src, activity,false)
end)

--trigger from server
RegisterNetEvent('sayer-gangs:AddZoneRep',function(src,activity, isInternal)
    AddZoneRep(src,activity,isInternal)
end)

function AddZoneRep(src, activity, isInternal)
    local Player
    local citizenid
    local playerTable

    -- Check if the call is internal or external
    if isInternal then
        citizenid = src -- `src` will be the citizen ID in this case
        playerTable = PlayerZones[citizenid]
        Player = QBCore.Functions.GetPlayerByCitizenId(citizenid)
    else
        Player = QBCore.Functions.GetPlayer(src)
        if not Player then return end

        citizenid = Player.PlayerData.citizenid
        playerTable = PlayerZones[citizenid]
    end

    local zone = playerTable and playerTable.zone
    if not zone then
        DebugCode("No Valid Zone")
        return
    end

    Config.Zones[zone].lastRepUpdate = os.time()

    local zoneConfig = Config.Zones[zone]
    local activityConfig = zoneConfig and zoneConfig.activities[activity]

    if not zoneConfig or not activityConfig then return end

    local activityCooldown = GetCooldownState(citizenid, zone, activity)
    if activityCooldown then
        return
    end

    local SourceGang

    SourceGang = GetGang(src)

    if not SourceGang then return end

    if not Gangs[SourceGang.name] then return end

    local RepToGive = activityConfig.RepAmount
    if Config.RepBooster[activity] and type(Config.RepBooster[activity]) == 'number' then
        RepToGive = RepToGive * Config.RepBooster[activity]
    end

    if Wars[zone] ~= nil then
        AddZoneWarPoints(SourceGang.name,zone,RepToGive)
    else
        if activityConfig.WarOnly then
            return 
        end

        MySQL.rawExecute('SELECT * FROM sayer_zones WHERE id = ?', { zone }, function(result)
            if result and result[1] then
                local currentRep = result[1].rep
                local ownedGang = result[1].owner

                local newRep, takeover = AdjustZoneRep(currentRep, RepToGive, SourceGang.name, ownedGang)
                if takeover then
                    if Config.Wars.Enable then
                        if (Wars ~= nil and #Wars < Config.Wars.MaxWars) or Wars == nil then
                            TriggerWar(zone, SourceGang.name, RepToGive)
                        end
                    else
                        TakeOverZone(zone, SourceGang.name, RepToGive)
                    end
                else
                    UpdateZoneRepCount(zone, newRep, SourceGang.name)
                end

                -- Start cooldown after success
                StartCooldown(citizenid, zone, activity)
            else
                DebugCode("Error: Could not fetch zone data for ID: " .. tostring(zone))
            end
        end)
    end
end

exports('AddZoneRep', AddZoneRep)

function StartCooldown(citizenid, zone, activity)
    local cooldownTime = os.time() -- Save the current time
    Cooldowns[citizenid] = Cooldowns[citizenid] or {}
    Cooldowns[citizenid][zone] = Cooldowns[citizenid][zone] or {}
    Cooldowns[citizenid][zone][activity] = cooldownTime -- Save the cooldown start time
end

function GetCooldownState(citizenid, zone, activity)
    local currentTime = os.time()
    local CooldownTimer = Config.Zones[zone].activities[activity].Cooldown
    if not CooldownTimer or CooldownTimer < 1 then return false end

    local cooldownStart = Cooldowns[citizenid] 
        and Cooldowns[citizenid][zone] 
        and Cooldowns[citizenid][zone][activity]

        DebugCode("Cooldown Start:", cooldownStart, "Current Time:", currentTime, "Timer:", CooldownTimer)

    if cooldownStart and currentTime < cooldownStart + (CooldownTimer*60) then
        local timeLeft = cooldownStart + (CooldownTimer*60) - currentTime
        DebugCode("Cooldown Active, Time Left:", timeLeft)
        return timeLeft
    end

    return false
end

CreateThread(function()
    while true do
        Wait(1000)
        if Wars ~= nil then
            local currentTime = os.time()
            for k,v in pairs(Wars) do
                if v.endTime ~= nil then
                    if currentTime > v.endTime then
                        EndZoneWar(k)
                    end
                end
            end
        end
    end
end)

-- hang around system

CreateThread(function()
    while true do
        Wait(1000) -- Check every second

        -- Ensure table exists and is not empty
        if not IsTableEmpty(PlayerZones) then
            for citizenid, zoneData in pairs(PlayerZones) do
                local zoneConfig = Config.Zones[zoneData.zone]
                if zoneConfig then
                    local zoneActivity = zoneConfig.activities and zoneConfig.activities['hangaround']
                    if zoneActivity ~= nil then
                        -- Time needed in the zone before adding reputation
                        local timeNeededInZone = Config.HangAroundTimeNeededInZone * 60 * 1000 -- Convert to milliseconds

                        -- Increment the timer for the citizen
                        zoneData.timer = (zoneData.timer or 0) + 1000

                        -- Check if the timer has exceeded the required time
                        if zoneData.timer >= timeNeededInZone then
                            local activityCooldown = GetCooldownState(citizenid, zoneData.zone, 'hangaround')

                            if not activityCooldown then
                                DebugCode("Not In Cooldown and Adding HangAround Rep")
                                -- Add reputation to the zone for the citizen
                                AddZoneRep(citizenid, 'hangaround', true)

                                -- Reset the timer after successfully adding reputation
                                zoneData.timer = 0
                                TriggerClientEvent('sayer-gangs:TirggerUpdateFromServer', -1)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- zone rep decay 


-- Server-Side Thread for Decay
CreateThread(function()
    while true do
        Wait(1000) -- Check every second

        -- Skip decay logic if disabled
        if not Config.EnableDecay then
            goto continue
        end

        -- Loop through zones to handle decay
        MySQL.query('SELECT id, owner, rep FROM sayer_zones', {}, function(zones)
            for _, zone in ipairs(zones) do
                local zoneId = zone.id
                local zoneOwner = zone.owner
                local zoneRep = zone.rep

                local zoneConfig = Config.Zones[zoneId]

                -- Decay logic only applies to zones with an owner and decay settings
                if zoneOwner ~= "none" and zoneConfig and zoneConfig.decay then
                    local decayTime = zoneConfig.decay.time * 60 -- Convert minutes to seconds
                    local decayAmount = zoneConfig.decay.amount

                    -- Check if the zone should decay
                    if not ControlledZones[zoneId] then
                        ControlledZones[zoneId] = { lastUpdate = os.time() }
                    end

                    local lastUpdate = ControlledZones[zoneId].lastUpdate
                    if os.time() - lastUpdate >= decayTime then
                        local newRep = math.max(zoneRep - decayAmount, 0) -- Prevent rep from going below 0

                        -- Update the database
                        UpdateZoneRepCount(zoneId, newRep, nil)

                        -- Reset owner if rep is 0
                        if newRep == 0 then
                            MySQL.update('UPDATE sayer_zones SET owner = ? WHERE id = ?', { 'none', zoneId }, function()
                                TriggerClientEvent('sayer-gangs:UpdateZoneBlip', -1, zoneId, 'none', false)
                                TriggerClientEvent('sayer-gangs:NotifyLostZone',-1,zoneOwner, zoneId)
                                DebugCode(string.format("Zone '%s' has reset to no owner due to decay.", zoneId))
                            end)
                        end

                        -- Update last decay time
                        ControlledZones[zoneId].lastUpdate = os.time()
                    end
                end
            end
        end)

        ::continue::
    end
end)

-- ONLY FOR DEBUG AND TESTING (comment these commands when in live server)
QBCore.Commands.Add('swapgangzone', "Swap Zone of gang", { { name = "zone", help = "Name of zone" }, { name = "gang", help = "Name of gang" } }, true, function(source, args)
    TakeOverZone(args[1],args[2],10)
end, Config.AdminPermission)

QBCore.Commands.Add('getmyplayerzone', "get current stored zone", { }, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid

    if PlayerZones[citizenid] ~= nil then
        if PlayerZones[citizenid].zone ~= nil then
            DebugCode("Current Stored Zone of "..citizenid.." is "..PlayerZones[citizenid].zone)
        else
            DebugCode("No Stored Zone For "..citizenid)
        end
    else
        DebugCode("No Stored Zone For "..citizenid)
    end
end, Config.AdminPermission)