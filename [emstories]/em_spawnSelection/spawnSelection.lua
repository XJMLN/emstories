function spawnSelection_getData(source)
    local player = exports.em_core:PlayersGetPlayerFromId(source)
    local UID = player.UID
    MySQL.Async.fetchAll("SELECT department_id,rank_id,xp FROM em_users_departments WHERE user_id=@UID",{['@UID']=UID},function(result)
        local row = result[1]
        local retVal = {}
        if (row) then
            retVal = row
        else
            retVal = false
        end

        TriggerClientEvent("em_spawnSelection:loadData",source,retVal)
    end)
end
AddEventHandler("em_core:playerLoaded",spawnSelection_getData)