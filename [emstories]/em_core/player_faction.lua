function faction_playerDataInit(factionID, departmentID,UID,playerData)
    local playerData = playerData
    MySQL.Async.execute("INSERT INTO em_users_departments (user_id,faction_id,department_id,rank_id,xp) VALUES (@UID,@factionID,@departmentID,0,0)",{
        ['@UID']=UID,
        ['@factionID']=factionID,
        ['@departmentID']=departmentID
    },function(result)
        MySQL.Async.fetchAll("SELECT name FROM em_departments_ranks WHERE rank_id=0 AND department_id=@departmentID",{['@departmentID']=departmentID},function(result)
            if (result and result[1]) then
                local row = result[1]
                playerData.rankName = row.name
            end
        end)
    end)
end

Players.setPlayerFaction = function(factionID, departmentID)
    local playerId = source
    local playerData = Players.all[tostring(playerId)]
    local factionID = factionID
    local departmentID = departmentID
    local UID = playerData.UID
    MySQL.Async.fetchAll("SELECT d.rank_id,d.xp,dr.name FROM em_users_departments d LEFT JOIN em_departments_ranks dr ON dr.rank_id=d.rank_id AND dr.department_id=@departmentID WHERE d.faction_id=@factionID AND d.department_id=@departmentID AND d.user_id=@UID",{
        ['@factionID']=factionID,
        ['@departmentID']=departmentID,
        ['@UID']=UID,
    },function(result)
        if (result and result[1]) then
            local row = result[1]
            playerData.xp = row.xp
            playerData.rankID = row.rank_id
            playerData.rankName = row.name
        else
            faction_playerDataInit(factionID,departmentID,UID,playerData)
            playerData.xp = 0
            playerData.rankID = 0
        end
        playerData.factionID = factionID
        playerData.departmentID = departmentID
        TriggerClientEvent("em_core_client:playerFactionChange",playerId,playerData)
    end)
end

RegisterNetEvent("em_core:setPlayerFaction")
AddEventHandler("em_core:setPlayerFaction",Players.setPlayerFaction)