local nametags = {}
Citizen.CreateThread(function()
    while true do
        local localCoords = GetEntityCoords(PlayerPedId())
        for _, i in ipairs(GetActivePlayers()) do
            --if (i ~= PlayerId()) then
                local playerPed = GetPlayerPed(i)
                local isPlayerTalking = NetworkIsPlayerTalking(i)
                local isPlayerTyping,isPlayerTypingState = DecorGetInt(playerPed,"isTypingInChat"), false
                if (isPlayerTyping == 2) then
                    isPlayerTypingState = true
                else
                    isPlayerTypingState = false
                end
                if (not nametags[i]) then
                    nametags[i] = {}
                end
                local ID = GetPlayerServerId(i)
                nametags[i].tag = CreateMpGamerTag(playerPed,"["..ID.."] "..GetPlayerName(i),false,false,"",0)
                local color = 0
                local targetCoords = GetEntityCoords(playerPed)
                local distance = #(targetCoords - localCoords)

                SetMpGamerTagName(nametags[i].tag,"["..ID.."] "..GetPlayerName(i))
                
                SetMpGamerTagColour(nametags[i].tag,0,color)
                SetMpGamerTagColour(nametags[i].tag,4,color)
                SetMpGamerTagColour(nametags[i].tag,16,color)
                SetMpGamerTagColour(nametags[i].tag,7,color)
                if (distance < 50 and HasEntityClearLosToEntity(PlayerPedId(), playerPed, 17)) then
                    
                    SetMpGamerTagAlpha(nametags[i].tag,7,255)
                    SetMpGamerTagAlpha(nametags[i].tag,16,255)
                    SetMpGamerTagAlpha(nametags[i].tag,3,255)
                    SetMpGamerTagAlpha(nametags[i].tag,0,255)
                    SetMpGamerTagAlpha(nametags[i].tag,4,255)
                    SetMpGamerTagVisibility(nametags[i].tag,0,true)
                    SetMpGamerTagVisibility(nametags[i].tag,7,true)
                    SetMpGamerTagVisibility(nametags[i].tag,4,isPlayerTalking)
                    SetMpGamerTagVisibility(nametags[i].tag,16,isPlayerTypingState)
                else
                    SetMpGamerTagVisibility(nametags[i].tag,0,false)
                    SetMpGamerTagVisibility(nametags[i].tag,4,false)
                    SetMpGamerTagVisibility(nametags[i].tag,16,false)
                    SetMpGamerTagVisibility(nametags[i].tag,7,false)
                end

            --end
        end
        Citizen.Wait(0)
    end
end)
AddEventHandler("onResourceStop",function(name)
    if (GetCurrentResourceName() == name) then
        for _,v in pairs(nametags) do
            RemoveMpGamerTag(v.tag)
        end
    end
end)
