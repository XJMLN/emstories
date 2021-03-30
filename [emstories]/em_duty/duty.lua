function duty_getDepartmentData(plr,fid,did,rid,sex)
    local plr = plr
    MySQL.Async.fetchAll("SELECT s.skin_data,s.skin_id,s.name,v.vehicle_desc,v.vehicle_hash,v.vehicle_extras,v.vehicle_livery,v.vehicle_type FROM em_departments_skins s LEFT JOIN em_departments_vehicles v ON v.department_id=@did AND v.rank_id=@rid WHERE s.department_id=@did AND s.rank_id<=@rid AND s.skin_sex=@sex",{
        ['@did']=did,
        ['@rid']=rid,
        ['@did']=did,
        ['@rid']=rid,
        ['@sex']=sex,
    },function(result)
        if (result and result[1]) then
            TriggerClientEvent("em_duty_client:returnDepartmentData",plr,result,fid,did)
        end
    end)
end

function duty_getPlayerFaction(factionID, departmentID,model)
    local source = source
    local sex = 1
    if (model ~= "-1667301416") then
        sex = 0
    end
    local player = exports.em_core:PlayersGetPlayerFromId(source)
    local pFID = player.factionID
    local pDID = player.departmentID
    if (pFID~=factionID or pDID ~= departmentID) then
        TriggerClientEvent("em_duty_client:callbackGetPlayerFaction",source,"Nie należysz do tego departamentu.")
        return
    else
        local pRank = player.rankID
        duty_getDepartmentData(source,pFID,pDID,pRank,sex)
    end
end
RegisterNetEvent("em_duty:getPlayerFaction")
RegisterNetEvent("em_duty:ghost")
AddEventHandler("em_duty:ghost",function(state)
    exports.simplepassive:setOverride(source,state)
end)
AddEventHandler("em_duty:getPlayerFaction",duty_getPlayerFaction)