RegisterCommand('gang',function(source)
    local PlayerGang = Players[source].gang
    SendNotify(source, "Gang Info: Gang: ["..PlayerGang.label.."] Grade: ["..PlayerGang.grade.name.."]", 'success', 8000)
end, false )

RegisterCommand('setgang',function(source,args)
    local Player = Players[tonumber(args[1])]
    if Player then
        SetPlayerGang(tonumber(args[1]), tostring(args[2]), tonumber(args[3]))
    else
        SendNotify(source, "No Player Exists", 'error')
    end
end, 'admin')

-- QBCore.Commands.Add('getmyplayerzone', "get current stored zone", { }, true, function(source, args)
--     local Player = QBCore.Functions.GetPlayer(source)
--     local citizenid = Player.PlayerData.citizenid

--     if PlayerZones[citizenid] ~= nil then
--         if PlayerZones[citizenid].zone ~= nil then
--             DebugCode("Current Stored Zone of "..citizenid.." is "..PlayerZones[citizenid].zone)
--         else
--             DebugCode("No Stored Zone For "..citizenid)
--         end
--     else
--         DebugCode("No Stored Zone For "..citizenid)
--     end
-- end, 'admin')

function SendNotify(src, msg, type, time, title)
    if not title then title = "Gangs" end
    if not time then time = 5000 end
    if not type then type = 'success' end
    if not msg then DebugCode("SendNotify Server Triggered With No Message") return end
    if Config.NotifyScript == 'qb' then
        TriggerClientEvent('QBCore:Notify', src, msg, type, time)
    elseif Config.NotifyScript == 'okok' then
        TriggerClientEvent('okokNotify:Alert', src, title, msg, time, type, false)
    elseif Config.NotifyScript == 'qs' then
        TriggerClientEvent('qs-notify:Alert', src, msg, time, type)
    elseif Config.NotifyScript == 'other' then
        --add your notify event here
    end
end