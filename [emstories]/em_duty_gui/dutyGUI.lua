function duty_checkPlayerFaction()
    local playerId = source
    local playerData = exports.em_core:PlayersGetPlayerFromId(source)
    local factionID = playerData.factionID
    local departmentID = playerData.departmentID
    local onDuty = playerData.factionDuty
    if (onDuty and departmentID>0 and factionID>0) then
        print('retVal send')
        TriggerClientEvent("em_duty_gui:showGUI",source,{factionID=factionID,departmentID=departmentID,onDuty=onDuty})
    end
end

RegisterNetEvent("em_duty_gui:checkPlayerFaction")
AddEventHandler("em_duty_gui:checkPlayerFaction",duty_checkPlayerFaction)