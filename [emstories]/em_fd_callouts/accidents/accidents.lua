
function accident_create(missionData,player)
    local player = player
    local missionData = missionData
    local accidentID = missionData.systemData['id']
    playersOnMission[accidentID] = {}
    table.insert(playersOnMission[accidentID],player)
    playersMission[3][player] = true
    TriggerClientEvent("accidentSystem_create",player,missionData)
end

function accident_end(steps, ID)
    if (playersOnMission[ID]) then
        for i,v in ipairs(playersOnMission[ID]) do
            local factionID = 3
            playersMission[factionID][v] = nil
            exports.em_core:givePlayerXP(steps*10,v)
        end
    end
end
exports("accidentSystem_create",accident_create)
--TriggerServerEvent("accidentSystem_endCallout",missionElements[player].completedSteps,ID)
RegisterNetEvent("accidentSystem_endCallout")
AddEventHandler("accidentSystem_endCallout",accident_end)