local templates = {
    ['global']={
        [1]='<div class="msg multiline" style="background: linear-gradient(90deg,rgba(33, 33, 33, 0.69) 60%%,rgba(255,255,255,0) 100%%) !important;"><span><span><b><span style="color: rgb(255, 255, 255) font-size:20px;"><i style="margin-left: 15px;margin-right: 15px;" class="fas fa-globe"></i>%s: </span></b><span>%s</span></span></span></div>'
    },
    ['local']={
        [1]='<div class="msg multiline" style="background: linear-gradient(90deg,rgba(56, 94, 152, 0.69) 60%%,rgba(255,255,255,0) 100%%) !important;"><span><span><b><span style="color: rgb(255, 255, 255) font-size:20px;">%s: </span></b><span>%s</span></span></span></div>',
        [2]='<div class="msg multiline" style="background: linear-gradient(90deg,rgba(183,87,255, 0.69) 60%%,rgba(255,255,255,0) 100%%) !important;"><span><span><b><span style="color: rgb(255, 255, 255) font-size:20px;">* %s </span></b><span>%s</span></span></span></div>',
        [3]='<div class="msg multiline" style="background: linear-gradient(90deg,rgba(77,8,140, 0.69) 60%%,rgba(255,255,255,0) 100%%) !important;"><span><span><b><span style="color: rgb(255, 255, 255) font-size:20px;">* %s </span></b><span>%s</span></span></span></div>',
    }
}

function chat_globalMessage(id, name, message,type)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    TriggerEvent('chat:addMessage', {
        template = string.format(templates['global'][type],name,message)
    })
end

function chat_sendDistanceMessage(id,name,message,distance,type)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)
    if (pid == myId) then
        TriggerEvent('chat:addMessage', {
            template = string.format(templates['local'][type],name,message)
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)),true) < distance then
        TriggerEvent('chat:addMessage', {
            template = string.format(templates['local'][type],name,message)
        })
    end
end
RegisterNetEvent("sendRangedMessage")
RegisterNetEvent("sendGlobalMessage")
AddEventHandler("sendRangedMessage",chat_sendDistanceMessage)
AddEventHandler("sendGlobalMessage",chat_globalMessage)