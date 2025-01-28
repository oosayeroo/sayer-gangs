 # an example of graffiti resources

## RCORE GRAFFITI - [LINK](https://store.rcore.cz/package/4519966)

 - go to rcore-spray/server/server.lua and find event `rcore_spray:addSpray`

 - add export under the AddSpray function like this 

 ```lua
 RegisterNetEvent('rcore_spray:addSpray')
AddEventHandler('rcore_spray:addSpray', function(spray)
    local Source = source
    
    if spray.text or spray.image then
        if Framework == FW_OTHER then
            AddSpray(Source, spray)
            return
        end

        local itemCount = GetItemCount(Source, "spray")

        if itemCount > 0 then
            RemoveInventoryItem(Source, "spray", 1)
            spray.identifier = GetPlayerIdentifier(Source)
            SendMessageToWebhook(
                GetPlayerNameForWebhook(Source, spray.identifier) .. ': Created graffiti "' .. (spray.text or spray.image) .. '" at vector3(' .. FormatSimplePos(spray.location) .. ')'
            )
            AddSpray(Source, spray)
            exports['sayer-gangs']:AddZoneRep(Source, 'graffiti', false)
        else
            ShowNotification(Source, Config.Text.NEED_SPRAY)
        end
    end
end)
```

## QB-GRAFFITI - [LINK](https://github.com/Kalajiqta/qb-graffiti)
 - go to qb-graffiti/server/server_main.lua and find event `qb-graffiti:client:addServerGraffiti` and add export like this 

 ```lua
 RegisterServerEvent('qb-graffiti:client:addServerGraffiti', function(model, coords, rotation)
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)

    if Player and isLoaded then
        MySQL.insert('Insert into `graffitis` (owner, model, `coords`, `rotation`) values (@owner, @model, @coords, @rotation)', {
            ['@owner'] = Player.PlayerData.citizenid,
            ['@model'] = tostring(model),
            ['@coords'] = json.encode(vector3(QBCore.Shared.Round(coords.x, 2), QBCore.Shared.Round(coords.y, 2), QBCore.Shared.Round(coords.z, 2))),
            ['@rotation'] = json.encode(vector3(QBCore.Shared.Round(rotation.x, 2), QBCore.Shared.Round(rotation.y, 2), QBCore.Shared.Round(rotation.z, 2)))
        }, function(key)
            Config.Graffitis[tonumber(key)] = {
                key = tonumber(key),
                model = tonumber(model),
                coords = vector3(QBCore.Shared.Round(coords.x, 2), QBCore.Shared.Round(coords.y, 2), QBCore.Shared.Round(coords.z, 2)),
                rotation = vector3(QBCore.Shared.Round(rotation.x, 2), QBCore.Shared.Round(rotation.y, 2), QBCore.Shared.Round(rotation.z, 2)),
                entity = nil,
                blip = nil
            }

            exports['sayer-gangs']:AddZoneRep(source, 'graffiti', false)
            UpdateGraffitiData()
        end)
    end
end)
```