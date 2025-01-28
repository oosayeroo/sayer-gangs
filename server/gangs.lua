RegisterNetEvent('sayer-gangs:InitialiseGang', function()
    local Player = QBCore.functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    MySQL.query('SELECT * FROM sayer_gangs WHERE citizenid = ?', {citizenid}, function(exisitingdata)
        if not exisitingdata then
            local initData = {
                name = 'none',
                label = 'None',
                grade = 0,
            }

            MySQL.insert('INSERT INTO sayer_gangs (citizenid, data) VALUES (?, ?)', {
                citizenid,
                json.encode(initData),
            })
        end
    end)
end)

function GetGangsConfig()
    return Gangs
end
exports('GetGangsConfig', GetGangsConfig)

function RemovePlayerGang(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    MySQL.query('SELECT * FROM sayer_gangs WHERE citizenid = ?', {citizenid}, function(exisitingdata)
        if exisitingdata then
            local Gangdata = json.decode(result[1].data)
            Gangdata = {
                name = 'none',
                label = 'None',
                grade = 0,
            }

            MySQL.update('UPDATE sayer_gangs SET data = ? WHERE citizenid = ?', { json.encode(Gangdata), citizenid }, function(affectedRows)
                if affectedRows > 0 then
                    DebugCode("Gang Removed for CID: ["..citizenid.."]")
                    TriggerClientEvent('sayer-gangs:OnGangUpdate', src)
                else
                    DebugCode("Failed to set gang, sql issue")
                end
            end)
        end
    end)
end
exports('RemovePlayerGang', RemovePlayerGang)

function SetPlayerGang(src, gang, grade)
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    MySQL.query('SELECT * FROM sayer_gangs WHERE citizenid = ?', {citizenid}, function(exisitingdata)
        if exisitingdata then
            local Gangdata = json.decode(result[1].data)
            Gangdata = {
                name = gang,
                label = Gangs[gang].label,
                grade = grade,
            }

            MySQL.update('UPDATE sayer_gangs SET data = ? WHERE citizenid = ?', { json.encode(Gangdata), citizenid }, function(affectedRows)
                if affectedRows > 0 then
                    DebugCode("Gang ["..gang.."] and Grade ["..grade.."] Set for CID: ["..citizenid.."]")
                    TriggerClientEvent('sayer-gangs:OnGangUpdate', src)
                else
                    DebugCode("Failed to set gang, sql issue")
                end
            end)
        end
    end)
end
exports('SetPlayerGang', SetPlayerGang)

function GetGang(src)
    local Player = QBCore.Functions.GetPlayer(src)
    local citizenid = Player.PlayerData.citizenid
    local retval = nil
    MySQL.query('SELECT * FROM sayer_gangs WHERE citizenid = ?', {citizenid}, function(Gangdata)
        if Gangdata and Gangdata[1] then
            local FormattedData = json.decode(Gangdata[1].data)
            if FormattedData then
                retval = FormattedData
            else
                retval = nil
            end
        else
            retval = nil
        end
    end)
    return retval
end
exports('GetGang',GetGang)

--for client side GetGang
QBCore.Functions.CreateCallback('sayer-gangs:GetGang', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    MySQL.query('SELECT * FROM sayer_gangs WHERE citizenid = ?', {citizenid}, function(Gangdata)
        if Gangdata and Gangdata[1] then
            local FormattedData = json.decode(Gangdata[1].data)
            if FormattedData then
                cb(FormattedData)
            else
                cb(nil)
            end
        else
            cb(nil)
        end
    end)
end)

function HasGangPermission(gangname, ganggrade, action)
    local retval = false
    if action == 'recruit' or action == 'promote' or action == 'demote' or action == 'remove' then
        if Gangs[gangname].grades[ganggrade].isBoss or Gangs[gangname].grades[ganggrade].canRecruit then
            retval = true
        end
    elseif action == 'someotherbullshit' then
        -- do something else
    end
    return retval
end

function CheckGrade(gangname, ganggrade)
    if Gangs[gangname].grades[ganggrade] ~= nil then
        return ganggrade
    else
        return false
    end
end

function GangRecruit(src, args)
    if not args[1] or not tonumber(args[1]) then SendNotify(src, "Invalid Player ID (Argument#1)", 'error') return end
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if not Player then SendNotify(src, "Player Not Online", 'error') return end
    local SourceGang = GetGang(src)
    local PlayerGang = GetGang(tonumber(args[1]))

    if not SourceGang then SendNotify(src, "No Gang Info", 'error') return end
    if not PlayerGang then SendNotify(src, "No Gang Info", 'error') return end
    if SourceGang.name == 'none' then SendNotify(src, "You Have No Gang", 'error') return end
    if PlayerGang.name ~= 'none' then SendNotify(src, "You Cannot Recruit Someone In a Gang", 'error') return end

    if not HasGangPermission(SourceGang.name, SourceGang.grade, 'recruit') then SendNotify(src, "You Dont Have That Permission", 'error') return end
    
    SetPlayerGang(tonumber(args[1]), SourceGang.name, 0)
end
exports('GangRecruit',GangRecruit)

function GangPromote(src, args)
    if not args[1] or not tonumber(args[1]) then SendNotify(src, "Invalid Player ID (Argument#1)", 'error') return end
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if not Player then SendNotify(src, "Player Not Online", 'error') return end
    local SourceGang = GetGang(src)
    local PlayerGang = GetGang(tonumber(args[1]))

    if not SourceGang then SendNotify(src, "No Gang Info", 'error') return end --should never happen but here just incase
    if not PlayerGang then SendNotify(src, "No Gang Info", 'error') return end
    if SourceGang.name == 'none' then SendNotify(src, "You Have No Gang", 'error') return end
    if PlayerGang.name ~= SourceGang.name then SendNotify(src, "You Cannot Promote Someone Outside Your Gang", 'error') return end

    if not HasGangPermission(SourceGang.name, SourceGang.grade, 'promote') then SendNotify(src, "You Don't Have That Permission", 'error') return end

    local nextGrade = CheckGrade(SourceGang.name, PlayerGang.grade + 1)
    if nextGrade then
        SetPlayerGang(tonumber(args[1]), SourceGang.name, nextGrade)
    else
        SendNotify(src, "Cannot Promote Further", 'error')
    end
end
exports('GangPromote',GangPromote)

function GangDemote(src, args)
    if not args[1] or not tonumber(args[1]) then SendNotify(src, "Invalid Player ID (Argument#1)", 'error') return end
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if not Player then SendNotify(src, "Player Not Online", 'error') return end
    local SourceGang = GetGang(src)
    local PlayerGang = GetGang(tonumber(args[1]))

    if not SourceGang then SendNotify(src, "No Gang Info", 'error') return end --should never happen but here just incase
    if not PlayerGang then SendNotify(src, "No Gang Info", 'error') return end
    if SourceGang.name == 'none' then SendNotify(src, "You Have No Gang", 'error') return end
    if PlayerGang.name ~= SourceGang.name then SendNotify(src, "You Cannot Demote Someone Outside Your Gang", 'error') return end

    if not HasGangPermission(SourceGang.name, SourceGang.grade, 'demote') then SendNotify(src, "You Don't Have That Permission", 'error') return end

    local previousGrade = CheckGrade(SourceGang.name, PlayerGang.grade - 1)
    if previousGrade then
        SetPlayerGang(tonumber(args[1]), SourceGang.name, previousGrade)
    else
        SendNotify(src, "Cannot Demote Further", 'error')
    end
end
exports('GangDemote',GangDemote)

function GangRemove(src, args)
    if not args[1] or not tonumber(args[1]) then SendNotify(src, "Invalid Player ID (Argument#1)", 'error') return end
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if not Player then SendNotify(src, "Player Not Online", 'error') return end
    local SourceGang = GetGang(src)
    local PlayerGang = GetGang(tonumber(args[1]))

    if not SourceGang then SendNotify(src, "No Gang Info", 'error') return end --should never happen but here just incase
    if not PlayerGang then SendNotify(src, "No Gang Info", 'error') return end
    if SourceGang.name == 'none' then SendNotify(src, "You Have No Gang", 'error') return end
    if PlayerGang.name ~= SourceGang.name then SendNotify(src, "You Cannot Remove Someone Outside Your Gang", 'error') return end

    if not HasGangPermission(SourceGang.name, SourceGang.grade, 'remove') then SendNotify(src, "You Don't Have That Permission", 'error') return end

    RemovePlayerGang(tonumber(args[1]))
end
exports('GangRemove',GangRemove)

-- [COMMANDS]

RegisterCommand('gang',function(source)
    local src = source
    local result = GetGang(src)
    local Text = "Gang: ["..result.label.."]  Grade: ["..result.grade.."]"
    SendNotify(src, Text, 'primary', 8000)
end, false)

RegisterCommand('setgang',function(source, args)
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if not Gangs[tostring(args[2])] then SendNotify(source, "Not a Valid Gang", 'error') return end
    if not Gangs[tostring(args[2])][tonumber(args[3])] then SendNotify(source, "Not a Valid Gang Grade", 'error') return end
    if Player then
        SetPlayerGang(tonumber(args[1]), tostring(args[2]), tonumber(args[3]))
    else
        SendNotify(source, "Player not Online", 'error')
    end
end, Config.AdminPermission )

RegisterCommand('removegang',function(source, args)
    local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        RemovePlayerGang(tonumber(args[1]))
    else
        SendNotify(source, "Player not Online", 'error')
    end
end, Config.AdminPermission )

RegisterCommand('gang_recruit',function(source, args)
    if not args[1] or not tonumber(args[1]) then SendNotify(source, "Invalid Player ID (Argument#1)", 'error') return end
    GangRecruit(source, args)
end, false )

RegisterCommand('gang_promote',function(source, args)
    if not args[1] or not tonumber(args[1]) then SendNotify(source, "Invalid Player ID (Argument#1)", 'error') return end
    GangPromote(source, args)
end, false)

RegisterCommand('gang_demote',function(source, args)
    if not args[1] or not tonumber(args[1]) then SendNotify(source, "Invalid Player ID (Argument#1)", 'error') return end
    GangDemote(source, args)
end, false)

RegisterCommand('gang_remove',function(source, args)
    if not args[1] or not tonumber(args[1]) then SendNotify(source, "Invalid Player ID (Argument#1)", 'error') return end
    GangRemove(source, args)
end, false)