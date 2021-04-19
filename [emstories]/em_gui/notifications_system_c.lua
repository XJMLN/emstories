Notification_FadeOut = 4000

function notifications_show(title,msg,time, sound)
    if msg == nil or msg == "" or title == nil or title == "" then return end
    if time == nil then
        time = Notification_FadeOut
    end
    SendNUIMessage({type="message", data={display = true, title = title,message = msg, sound = sound}})

    Wait(time)

    SendNUIMessage({type="message", data={display=false}})
end

RegisterNetEvent("em_gui:showNotification")
AddEventHandler("em_gui:showNotification", notifications_show)
exports("showNotification",notifications_show)
