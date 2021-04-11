function pedSystem_init(missionData, player)
    local player = player
    local missionData = missionData
    local accidentID = missionData.systemData['id']
    playersOnMission[accidentID] = {}
    table.insert(playersOnMission[accidentID],player)
    playersMission[2][player] = true
    print('trigger')
    TriggerClientEvent("mcSystem_createPedEnvironment",player,missionData)
end

exports("pedSystem_create",pedSystem_init)