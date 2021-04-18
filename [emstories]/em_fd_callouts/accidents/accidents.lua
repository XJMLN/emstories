
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

function accident_cancel(ID)
    if (playersOnMission[ID]) then
        for i,v in ipairs(playersOnMission[ID]) do
            playersMission[factionID][v] = nil
        end
    end
end

exports("accidentSystem_create",accident_create)
RegisterNetEvent("accidentSystem_endCallout")
RegisterNetEvent("accidentSystem_cancelCallout")
AddEventHandler("accidentSystem_cancelCallout",accident_cancel)
AddEventHandler("accidentSystem_endCallout",accident_end)