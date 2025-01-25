
Discord - https://discord.gg/3WYz3zaqG5

# SAYER-GANGS FRAMEWORK

## Install Instructions

 - run `sayer_gangs.sql` file
 - add any gang from your `qb-core/shared/gangs.lua` to the `Config.Gangs` table
 - customise script as you see fit for your server

## AddRep Export (Server Side)
 - replace `src` with the source of the player doing the activity
 - replace `'drugselling'` with the activity from your `Config.Zones[zone].activities` tables

```lua
exports['sayer-gangs']:AddZoneRep(src,'drugselling')
```
### or trigger event from (client side) with 
```lua
TriggerServerEvent('sayer-gangs:AddRepClient', 'drugselling')
```

### Drug Selling Export (SERVER SIDE EXAMPLE)

 - in `qb-drugs/server/cornerselling.lua` find the event named `qb-drugs:server:sellCornerDrugs` and add the export. 
 - should look like this if base qb-drugs (as of 25/1/25)
 ```lua
 RegisterNetEvent('qb-drugs:server:sellCornerDrugs', function(drugType, amount, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local availableDrugs = getAvailableDrugs(src)
    if not availableDrugs or not Player then return end
    local item = availableDrugs[drugType].item
    local hasItem = Player.Functions.GetItemByName(item)
    if hasItem.amount >= amount then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.offer_accepted'), 'success')
        exports['qb-inventory']:RemoveItem(src, item, amount, false, 'qb-drugs:server:sellCornerDrugs')
        Player.Functions.AddMoney('cash', price, 'qb-drugs:server:sellCornerDrugs')
        TriggerClientEvent('qb-inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'remove')
        TriggerClientEvent('qb-drugs:client:refreshAvailableDrugs', src, getAvailableDrugs(src))
        exports['sayer-gangs']:AddZoneRep(src,'drugselling')
    else
        TriggerClientEvent('qb-drugs:client:cornerselling', src)
    end
end)
```

## AddRep Event (CLIENT SIDE Triggerred) (qb-ambulancejob example for when player is killed)
 - player source is not needed for client export
 - only parameter to trigger is the activity. 

### the event
```lua
TriggerServerEvent('sayer-gangs:AddZoneRep',GetPlayerServerId(killerId), 'killing', false)
```
### where to place it (client/dead.lua)
```lua
AddEventHandler('gameEventTriggered', function(event, data)
    if event == 'CEventNetworkEntityDamage' then
        local victim, attacker, victimDied, weapon = data[1], data[2], data[4], data[7]
        if not IsEntityAPed(victim) then return end
        if victimDied and NetworkGetPlayerIndexFromPed(victim) == PlayerId() and IsEntityDead(PlayerPedId()) then
            if not InLaststand then
                SetLaststand(true)
            elseif InLaststand and not isDead then
                SetLaststand(false)
                local playerid = NetworkGetPlayerIndexFromPed(victim)
                local playerName = GetPlayerName(playerid) .. ' ' .. '(' .. GetPlayerServerId(playerid) .. ')' or Lang:t('info.self_death')
                local killerId = NetworkGetPlayerIndexFromPed(attacker)
                TriggerServerEvent('sayer-gangs:AddZoneRep',GetPlayerServerId(killerId), 'killing', false) --HERE ... PLACE IT HERE
                local killerName = GetPlayerName(killerId) .. ' ' .. '(' .. GetPlayerServerId(killerId) .. ')' or Lang:t('info.self_death')
                local weaponLabel = (QBCore.Shared.Weapons and QBCore.Shared.Weapons[weapon] and QBCore.Shared.Weapons[weapon].label) or 'Unknown'
                local weaponName = (QBCore.Shared.Weapons and QBCore.Shared.Weapons[weapon] and QBCore.Shared.Weapons[weapon].name) or 'Unknown'
                TriggerServerEvent('qb-log:server:CreateLog', 'death', Lang:t('logs.death_log_title', { playername = playerName, playerid = GetPlayerServerId(playerid) }), 'red', Lang:t('logs.death_log_message', { killername = killerName, playername = playerName, weaponlabel = weaponLabel, weaponname = weaponName }))
                deathTime = Config.DeathTime
                OnDeath()
                DeathTimer()
            end
        end
    end
end)
```

## GetZoneDetails (SERVER SIDE)

 - returns the owner and rep and label of a specific zone
 - replace `ROCKF` with the zone you want to get details of.

```lua
exports['sayer-gangs']:GetZoneDetails('ROCKF')
```

 - usage example
 ```lua
 local zone = "ROCKF"
 local ZoneDetails = exports['sayer-gangs']:GetZoneDetails(zone)
 if ZoneDetails ~= nil then
    print("Owner of zone: "..ZoneDetails.owner)
    print("Rep in zone: "..ZoneDetails.rep)
 end
 ```

 ## GetPlayerCountForZone (SERVER SIDE)

 - returns the number of gang players in the zone

```lua
exports['sayer-gangs']:GetPlayerCountForZone(zone)
```

 - usage example
 ```lua
 local zone = "ROCKF"
 local playersInZone = exports['sayer-gangs']:GetPlayerCountForZone(zone)
 print(playersInZone.." Players in zone : "..zone)
 ```

## GetPlayersInZone (SERVER SIDE)

 - returns all players in specific zone. so you can access their qb-core player data

```lua
exports['sayer-gangs']:GetPlayersInZone(zone)
```

 - usage example
```lua
    local zone = "ROCKF"
    local playersInZone = exports['sayer-gangs']:GetPlayersInZone(zone)
    if playersInZone ~= nil then
        for k,v in pairs(playersInZone) do
            print("Player citizenid : "..v.PlayerData.citizenid)
            print("Player name : "..v.PlayerData.charinfo.firstname.." / "..v.PlayerData.charinfo.lastname)
        end
    end
```