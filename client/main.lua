local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local ZoneBlip = {}
local BoxZones = {}
local PlayerGang = {}
local PlayerLoaded = false
local myZone = nil

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end
    PlayerGang = QBCore.Functions.GetPlayerData().gang
    UpdateGangBlips()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerGang = QBCore.Functions.GetPlayerData().gang
    UpdateGangBlips()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerGang = QBCore.Functions.GetPlayerData().gang
    UpdateGangBlips()
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(InfoGang)
    PlayerGang = InfoGang

    UpdateGangBlips()
end)

AddEventHandler('onResourceStop', function(t) if t ~= GetCurrentResourceName() then return end
    
end)

-- RegisterCommand('testAddRep',function()
--     TriggerServerEvent('sayer-gangs:AddRepClient')
-- end)

function GetGang()
    local gang = QBCore.Functions.GetPlayerData().gang
    return gang
end

RegisterNetEvent('sayer-gangs:UpdateZoneBlip',function(zone,gang,war)
    local colour = 0
    if war then
        colour = 1
    else
        if gang == 'none' then 
            colour = 0
        else 
            colour = Gangs[gang].colour
        end
    end
    if not colour then return end
    if ZoneBlip[zone] then
        for _, blip in pairs(ZoneBlip[zone]) do
            SetBlipColour(blip,colour)
            if war then
                SetBlipFlashes(blip, true)
                SetBlipFlashInterval(blip, 500)
            else
                SetBlipFlashes(blip, false)
            end
        end
    end
end)

RegisterNetEvent('sayer-gangs:NotifyLostZone',function(previousGang, zoneId)
    if not Config.NotifyLostZone then return end
    if PlayerGang == nil or PlayerGang.name == 'none' then RemoveGangBlips() return end
    if PlayerGang.name ~= previousGang then return end
    local zoneLabel = Config.Zones[zoneId].label
    SendNotify("Your Gang Lost Control of "..zoneLabel, 'error')
end)

RegisterNetEvent('sayer-gangs:NotifyWarStarted',function(zoneId)
    if not Config.NotifyWarStarted then return end
    if PlayerGang == nil or PlayerGang.name == 'none' then RemoveGangBlips() return end
    local zoneLabel = Config.Zones[zoneId].label
    SendNotify(zoneLabel.." is now vulnerable", 'primary')
end)

RegisterNetEvent('sayer-gangs:NotifyWarFinished',function(controllingGang, zoneId)
    if not Config.NotifyWarFinished then return end
    if PlayerGang == nil or PlayerGang.name == 'none' then RemoveGangBlips() return end
    local zoneLabel = Config.Zones[zoneId].label
    local gangLabel = Gangs[controllingGang].label
    SendNotify(gangLabel.." now control "..zoneLabel, 'primary')
end)

function RemoveGangBlips()
    for k,v in pairs(ZoneBlip) do
        if v ~= nil then
            for d,j in pairs(v) do
                if DoesBlipExist(j) then
                    RemoveBlip(j)
                end
            end
        end
    end
end

function UpdateGangBlips()
    if PlayerGang == nil or PlayerGang.name == 'none' then RemoveGangBlips() return end

    ZoneBlip = {} -- Clear the blip table to ensure no leftover blips
    BoxZones = {} -- To keep track of all the box zones
    QBCore.Functions.TriggerCallback('sayer-gangs:GetAllZonesInfo', function(result)
        if result then
            for zoneName, zoneData in pairs(Config.Zones) do
                if zoneData.coords then
                    ZoneBlip[zoneName] = {} -- Initialize a subtable for the zone's blips
                    BoxZones[zoneName] = {} -- Initialize a subtable for the zone's boxes
                    local zoneColour = 0
                    if result[zoneName] and result[zoneName].owner ~= 'none' then
                        zoneColour = Gangs[result[zoneName].owner].colour
                    end
                    if result[zoneName].war then
                        zoneColour = 1
                    end

                    for index, part in ipairs(zoneData.coords) do
                        -- Calculate the center of the rectangle
                        local centerX = (part.startX + part.endX) / 2
                        local centerY = (part.startY + part.endY) / 2
                        local centerZ = 28.0 -- Adjust the Z-coordinate as needed

                        -- Calculate the width and height of the rectangle
                        local width = math.abs(part.endX - part.startX)
                        local height = math.abs(part.endY - part.startY)

                        -- Create the blip
                        local blipKey = index
                        ZoneBlip[zoneName][blipKey] = AddBlipForArea(centerX, centerY, 0.0, width, height)
                        SetBlipRotation(ZoneBlip[zoneName][blipKey], 0)
                        SetBlipColour(ZoneBlip[zoneName][blipKey], zoneColour)
                        SetBlipAlpha(ZoneBlip[zoneName][blipKey], 64)
                        SetBlipDisplay(ZoneBlip[zoneName][blipKey], 3)
                        SetBlipAsShortRange(ZoneBlip[zoneName][blipKey], true)
                        if result[zoneName].war then
                            SetBlipFlashes(ZoneBlip[zoneName][blipKey], true)
                            SetBlipFlashInterval(ZoneBlip[zoneName][blipKey], 500)
                        else
                            SetBlipFlashes(ZoneBlip[zoneName][blipKey], false)
                        end

                        -- Create a box zone
                        BoxZones[zoneName][blipKey] = lib.zones.box({
                            coords = vec3(centerX, centerY, centerZ),
                            size = vec3(width, height, 800), -- Adjust the height if necessary
                            rotation = 0, -- Adjust rotation if needed
                            debug = false,
                            inside = function()
                                InsideZone(zoneName)
                            end,
                            onEnter = function()
                                OnEnterZone(zoneName)
                            end,
                            onExit = function()
                                OnExitZone(zoneName)
                            end,
                        })
                    end
                end
            end
        else
            DebugCode("Error returning zone info")
        end
    end)
end

function OnEnterZone(zoneName)
    DebugCode('entered zone '..zoneName)
    local gang = GetGang()
    if not Gangs[gang.name] then return end
    TriggerServerEvent('sayer-gangs:ZoneUpdate',zoneName, 'enter')
    myZone = zoneName
end
 
function OnExitZone(zoneName)
    DebugCode('exited zone '..zoneName)
    local gang = GetGang()
    if not Gangs[gang.name] then return end
    TriggerServerEvent('sayer-gangs:ZoneUpdate',zoneName, 'exit')
    myZone = nil
end
 
function InsideZone(zoneName) --happens every frame for player in zone
    -- print('you are inside zone ' .. zoneName)
end

function AmIZoneOwner()
    local retval = false
    if PlayerGang == nil or PlayerGang.name == 'none' then return false end
    local zone = nil
    if myZone == nil then return false end
    zone = myZone
    QBCore.Functions.TriggerCallback('sayer-gangs:GetAllZonesInfo', function(result)
        if result then
            if result[zone].owner == PlayerGang.name then
                retval = true
            else
                retval = false
            end
        else
            DebugCode("Error returning zone info")
            retval = false
        end
    end)
    return retval
end

exports('AmIZoneOwner',AmIZoneOwner)
