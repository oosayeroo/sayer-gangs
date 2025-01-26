# for admin commands please follow these steps

## removing base qbcore commands
 - make sure to go to `qb-core/server/commands.lua` and find these 2 commands
 - `gang` and `setgang` and comment them out. 

## SNIPE ADMIN MENU

 - to add setgang command to snipe menu go to server/open.jobgang.lua

 ### replace the SetGang event `snipe-menu:server:setGang` with the below event
```lua
RegisterServerEvent("snipe-menu:server:setGang", function(playerid, gang, grade)
    local src = source
    if src ~= 0 and onlineAdmins[src] then
        SendLogs(src, "triggered", Config.Locales["set_gang_used"]..GetPlayerName(playerid).." "..gang.." "..grade)
        -- these lines were removed for sayer-gangs

        -- local otherPlayer = QBCore.Functions.GetPlayer(playerid)
        -- otherPlayer.Functions.SetGang(gang, grade)

        -- this line for added for sayer-gangs
        exports['sayer-gangs']:SetPlayerGang(src, gang, grade)
    else
        SendLogs(src, "exploit", Config.Locales["set_gang_exploit_event"])
    end
end)
```

## PS-ADMINMENU
 - to replace setgang command in ps-adminmenu go to `ps-adminmenu/server/players.lua` 
 - find event `ps-adminmenu:server:SetGang` and replace with the below event

 ```lua
 RegisterNetEvent('ps-adminmenu:server:SetGang', function(data, selectedData)
    local data = CheckDataFromKey(data)
    if not data or not CheckPerms(source, data.perms) then return end
    local src = source
    local playerId, Gang, Grade = selectedData["Player"].value, selectedData["Gang"].value, selectedData["Grade"].value
    local Player = QBCore.Functions.GetPlayer(playerId)
    local name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    local Gangs = exports['sayer-gangs']:GetGangsConfig()
    local GangInfo = Gangs[Gang]
    local grade = GangInfo["grades"][selectedData["Grade"].value]

    if not GangInfo then
        TriggerClientEvent('QBCore:Notify', source, "Not a valid Gang", 'error')
        return
    end

    if not grade then
        TriggerClientEvent('QBCore:Notify', source, "Not a valid grade", 'error')
        return
    end

    exports['sayer-gangs']:SetPlayerGang(playerId, tostring(Gang), tonumber(Grade))
    -- Player.Functions.SetGang(tostring(Gang), tonumber(Grade))
    QBCore.Functions.Notify(src, locale("gangset", name, Gang, Grade), 'success', 5000)
end)
```