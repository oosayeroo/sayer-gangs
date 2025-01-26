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
    local Player = QBCore.Functions.GetPlayer(source)
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