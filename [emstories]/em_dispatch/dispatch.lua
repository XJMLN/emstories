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
    if (FactionID == 3) then
        if (systemData.type == 'fire') then
            exports.em_fd_callouts:fireSystem_createFire(systemData.id,source)
        end
        if (systemData.type == 'vehicle') then
            exports.em_fd_callouts:accidentSystem_create(missionData, source)
        end
    end
    if (FactionID == 2) then
        if (systemData.type == 'ped') then
            exports.em_mc_callouts:pedSystem_create(missionData, source)
        end
    end
    exports.em_discord:onDispatchAccept(FactionID,departmentID,callsign,missionData)
end

RegisterNetEvent("em_dispatch_init")
AddEventHandler("em_dispatch_init",dispatch_displayForFaction)
RegisterNetEvent("em_dispatch_accepted")
AddEventHandler("em_dispatch_accepted",dispatch_accepted)
