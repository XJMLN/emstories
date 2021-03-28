function base_spawnPlayer(spawnNumber,faction,newplayer)
    if (not spawnNumber) then return end
    local player = Players.fromId(tostring(source))
    if (not player) then return end
    if (newplayer) then
        MySQL.Async.execute("UPDATE em_users SET newplayer=0 WHERE id=@UID",{['@UID']=player.UID},function(result) end)
    end
    TriggerClientEvent("em_core_client:spawnPlayer",source,spawnNumber,faction,player.skin,{money=player.money,level=player.level})
end
RegisterNetEvent("em_core:spawnPlayer")
AddEventHandler("em_core:spawnPlayer",base_spawnPlayer)