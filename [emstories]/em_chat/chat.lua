AddEventHandler("chatMessage", function(source, name, message)
    if (string.sub(message,1, string.len("/")) ~= "/") then
        local name = GetPlayerName(source)
        TriggerClientEvent("sendRangedMessage",-1,source,name,message,20,1)
    end
    CancelEvent()
end)

RegisterCommand("g",function(source, args, rawCommand)
    local pName = GetPlayerName(source)
    local msg = rawCommand:sub(3)
    TriggerClientEvent("sendGlobalMessage",-1,source,pName,msg,1)
end,false)

RegisterCommand("me",function(source,args,rawCommand)
    local pName = GetPlayerName(source)
    local msg = rawCommand:sub(4)
    TriggerClientEvent("sendRangedMessage",-1,source,pName,msg,20,2)
end,false)

RegisterCommand("do",function(source,args,rawCommand)
    local pName = GetPlayerName(source)
    local msg = rawCommand:sub(4)
    TriggerClientEvent("sendRangedMessage",-1,source,pName,msg,20,3)
end,false)