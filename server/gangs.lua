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

--for client side
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