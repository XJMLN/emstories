local playersOnMission = {
    [1]={},
    [2]={},
    [3]={},
}

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local function dispatch_getRandomPlayer(factionID,dispatchPlayers)
    local n = math.random(1,tablelength(dispatchPlayers[factionID]))
    return dispatchPlayers[factionID][n]
end
function dispatch_displayForFaction(factionID,missionData)
    local allPlayers = exports.em_core:PlayersGetAllPlayers()
    local dispatchPlayers = {[1]={},[2]={},[3]={}}
    for i,v in pairs(allPlayers) do
        if v.factionID == factionID then
            if (not playersOnMission[factionID][v.playerId]) then
                table.insert(dispatchPlayers[factionID],v.playerId)
            end
        end
    end
    if (tablelength(dispatchPlayers[factionID])>0) then
        local player = dispatch_getRandomPlayer(factionID,dispatchPlayers)
        if (player) then
            print(GetPlayerName(player).." dispatch")
            TriggerClientEvent("em_dispatch_client:showRender",player,missionData)
        end
    end
end

function dispatch_accepted(missionData)
    local systemData = missionData['systemData']
    local player = exports.em_core:PlayersGetPlayerFromId(source)
    local FactionID = player.factionID
    local departmentID = player.departmentID
    local callsign = player.callsign
    if (systemData.type == 'fire') then
        exports.em_fd_fires:fireSystem_createFire(systemData.id,source)
    end
    exports.em_discord:onDispatchAccept(FactionID,departmentID,callsign,missionData)
end
exports("dispatch_displayForFaction",dispatch_displayForFaction)

RegisterNetEvent("em_dispatch_init")
AddEventHandler("em_dispatch_init",dispatch_displayForFaction)
RegisterNetEvent("em_dispatch_accepted")
AddEventHandler("em_dispatch_accepted",dispatch_accepted)
