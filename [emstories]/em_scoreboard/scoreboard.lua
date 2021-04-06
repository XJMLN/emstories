local connectedPlayers = {}

local departmentNames = {
    [1]="LSFD",
    [2]="LSMC",
    [3]="SSMC",
    [4]="PBMC",
    [5]="LSPD",
    [6]="BCPD",
    [7]="SAHP",
}
function AddPlayerToScoreboard(player,update)
    connectedPlayers[tostring(player.playerId)] = {}
    connectedPlayers[tostring(player.playerId)].id = player.playerId
    connectedPlayers[tostring(player.playerId)].name = player.name
    connectedPlayers[tostring(player.playerId)].departmentName = departmentNames[player.departmentID]
    if (update) then
        TriggerClientEvent('em_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
    end
end

function AddPlayersToScoreboard()
    local players = exports.em_core:PlayersGetAllPlayers()
    for k,v in pairs(players) do
        AddPlayerToScoreboard(players[k],false)
    end

    TriggerClientEvent('em_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end

AddEventHandler("em_core:playerLoaded",function(source)
    local player = exports.em_core:PlayersGetPlayerFromId(source)
    AddPlayerToScoreboard(player,true)
end)
AddEventHandler("em_core:playerDropped",function(source)
    connectedPlayers[tostring(source)] = nil
    TriggerClientEvent('em_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

RegisterNetEvent("em_scoreboard:getConnectedPlayers")
AddEventHandler("em_scoreboard:getConnectedPlayers",function()
    TriggerClientEvent("em_scoreboard:updateConnectedPlayers",source,connectedPlayers)
end)

AddEventHandler("onResourceStart", function(resource)
    if (resource == GetCurrentResourceName()) then
        Citizen.CreateThread(function()
            Citizen.Wait(1000)
            AddPlayersToScoreboard()
        end)
    end
end)