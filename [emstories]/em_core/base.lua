function base_spawnPlayer(spawnNumber)
    if (not spawnNumber) then return end
    local player = Players.fromId(tostring(source))
    if (not player) then return end
    TriggerClientEvent("em_core_client:spawnPlayer",source,spawnNumber,player.skin,player.money)
end
RegisterNetEvent("em_core:spawnPlayer")
AddEventHandler("em_core:spawnPlayer",base_spawnPlayer)