function dispatch_displayForFaction(factionID,missionData)
    local source = source
    TriggerClientEvent("em_dispatch_client:showRender",source, missionData)
end

function dispatch_accepted(missionData)
    local systemData = missionData['systemData']
    local player = exports.em_core:PlayersGetPlayerFromId(source)
    local FactionID = player.factionID
    local departmentID = player.departmentID
    local callsign = player.callsign
    exports.em_callouts:callouts_start(missionData,source)
    exports.em_discord:onDispatchAccept(FactionID,departmentID,callsign,missionData)
end

RegisterNetEvent("em_dispatch_init")
AddEventHandler("em_dispatch_init",dispatch_displayForFaction)
RegisterNetEvent("em_dispatch_accepted")
AddEventHandler("em_dispatch_accepted",dispatch_accepted)
