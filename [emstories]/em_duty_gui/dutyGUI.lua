

function duty_checkPlayerFaction()
    local playerId = source
    local playerData = exports.em_core:PlayersGetPlayerFromId(source)
    local factionID = playerData.factionID
    local departmentID = playerData.departmentID
    local onDuty = playerData.factionDuty
    if (onDuty and departmentID>0 and factionID>0) then
        TriggerClientEvent("em_duty_gui:showGUI",source,{factionID=factionID,departmentID=departmentID,onDuty=onDuty})
    end
end

function duty_endPlayerDuty()
    local playerId = source
    exports.em_core:unsetPlayerDuty(playerId)
    exports.em_spawnSelection:spawnSelection_server_init(playerId)
end

RegisterNetEvent("em_duty_gui:checkPlayerFaction")
AddEventHandler("em_duty_gui:checkPlayerFaction",duty_checkPlayerFaction)
RegisterNetEvent("em_duty_gui:endDuty")
AddEventHandler("em_duty_gui:endDuty",duty_endPlayerDuty)
