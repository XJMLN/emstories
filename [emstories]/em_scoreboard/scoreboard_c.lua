local isVisible = false
function ScoreboardToggle()
    if (isVisible) then
        SetNuiFocusKeepInput(false)
        SetNuiFocus(false)
        isVisible = false
    else
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true,true)
        isVisible = true
    end
    SendNUIMessage({type='toggle'})
end

RegisterCommand("toggleScoreboard",ScoreboardToggle)
RegisterKeyMapping("toggleScoreboard","Pokaż scoreboard","keyboard","f3")
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        TriggerServerEvent("em_scoreboard:getConnectedPlayers")
    end
end)
function updatePlayerTable(connectedPlayers)
    local players = 0
    for k,v in pairs(connectedPlayers) do
        players = players + 1
    end
    SendNUIMessage({type='updatePlayerList',data=connectedPlayers})
end
RegisterNetEvent("em_scoreboard:updateConnectedPlayers")
AddEventHandler("em_scoreboard:updateConnectedPlayers",updatePlayerTable)