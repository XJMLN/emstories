function spawnSelection_getData(source)
    local player = exports.em_core:PlayersGetPlayerFromId(source)
    local UID = player.UID
    MySQL.Async.fetchAll("SELECT newplayer FROM em_users WHERE id=@UID",{['@UID']=UID},function(result)
        local retVal = result[1].newplayer
        TriggerClientEvent("em_spawnSelection:loadData",source,retVal)
    end)
    
end
AddEventHandler("em_core:playerLoaded",spawnSelection_getData)

RegisterCommand("wybor.spawnu",spawnSelection_getData)