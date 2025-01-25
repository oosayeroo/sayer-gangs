function DebugCode(msg)
    if Config.DebugCode then
        print(msg)
    end
end

function SendNotify(src, msg, type, time, title)
    if not title then title = "Chop Shop" end
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

--WEBHOOK STUFF

-- RegisterNetEvent('sayer-gangs:SendDiscordMessageFromClient',function(data)
--     SendDiscordMessage(data)
-- end)

local webhookUrl = Config.Webhooks.URL 
function SendDiscordMessage(data)
    local title = data.title or "Sayer Gangs"
    local message = data.message
    if Config.Webhooks.Enable then
        local embedData = {
            {
                ['title'] = title,
                ['color'] = 5763719,
                ['footer'] = {
                    ['text'] = os.date('%c'),
                },
                ['description'] = message,
                ['author'] = {
                    ['name'] = 'Sayer Gangs',
                    ['icon_url'] = 'https://cdn.discordapp.com/attachments/1310667787244671096/1312441786823737364/square.png?ex=67795529&is=677803a9&hm=3c223595c06818f341939edb31d24a50f29d41120c16d51da6480de375f45d4c&',
                },
            }
        }
        PerformHttpRequest(webhookUrl, function() end, 'POST', json.encode({ username = 'Sayer Gangs', embeds = embedData}), { ['Content-Type'] = 'application/json' })
    end
end