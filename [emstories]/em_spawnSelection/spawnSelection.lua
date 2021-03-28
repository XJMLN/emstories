function spawnSelection_getData(source)
    local player = exports.em_core:PlayersGetPlayerFromId(source)
    local UID = player.UID
    MySQL.Async.fetchAll("SELECT u.newplayer, d.department_id,d.rank_id,d.xp FROM em_users_departments d LEFT JOIN em_users u ON u.id=@UID WHERE d.user_id=@UID",{['@UID']=UID},function(result)
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