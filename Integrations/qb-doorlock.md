# To Integrate Sayer-Gangs into qb-doorlock to lock doors to zone owners follow here

## qb-doorlock/client/main.lua
 - find function called `isAuthorized` and add this chunk to it before the return node
 ```lua
 if door.lockToZoneOwner then
    local p = promise.new()
    QBCore.Functions.TriggerCallback('qb-doorlock:server:checkZoneOwner', function(result)
        p:resolve(result)
    end, PlayerData.citizenid, PlayerData.gang.name)
    if Citizen.Await(p) then
        return true
    end
end
```

## qb-doorlock/server/main.lua
 - find the function again called `isAuthorized` and add this chunk before the return node
 ```lua
 if door.lockToZoneOwner then
    local p = promise.new()
    exports['sayer-gangs']:GetZoneOwnerWithCID(Player.PlayerData.citizenid, function(zoneOwner)
        if zoneOwner == Player.PlayerData.gang.name then
            p:resolve(true) -- Player is authorized
        else
            p:resolve(false) -- Player is not authorized
        end
    end)
    return Citizen.Await(p)
end
```

## qb-doorlock/server/main.lua
 - add this callback underneath the `isAuthorized` function
 ```lua
 QBCore.Functions.CreateCallback('qb-doorlock:server:checkZoneOwner', function(source, cb, citizenid, playerGang)
    exports['sayer-gangs']:GetZoneOwnerWithCID(citizenid, function(zoneOwner)
        if zoneOwner == playerGang then
            cb(true)
        else
            cb(false)
        end
    end)
end)
```

 - when youve made a door make sure to go into Config folder and find the door and add `lockToZoneOwner = true`
 so a door should look something like this 
 ```lua
 Config.DoorList['GANGDOORS-RANCHOSAFEHOUSE'] = {
    objYaw = 38.633026123046,
    objName = -710818483,
    fixText = false,
    doorRate = 1.0,
    objCoords = vec3(443.767944, -1899.377442, 31.884112),
    locked = true,
    distance = 2,
    doorType = 'door',
    lockToZoneOwner = true,
}
```