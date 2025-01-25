function DebugCode(msg)
    if Config.DebugCode then
        print(msg)
    end
end

--notify configuration
function SendNotify(msg,type,time,title)
    if Config.NotifyScript == nil then DebugCode("Sayer Gangs: Config.NotifyScript Not Set!") return end
    if not title then title = "Gang" end
    if not time then time = 5000 end
    if not type then type = 'success' end
    if not msg then DebugCode("SendNotify Client Triggered With No Message") return end
    if Config.NotifyScript == 'qb' then
        QBCore.Functions.Notify(msg,type,time)
    elseif Config.NotifyScript == 'okok' then
        exports['okokNotify']:Alert(title, msg, time, type, false)
    elseif Config.NotifyScript == 'qs' then
        exports['qs-notify']:Alert(msg, time, type)
    elseif Config.NotifyScript == 'other' then
        -- add your notify here
        exports['yournotifyscript']:Notify(msg,time,type)
    end
end