local departmentNames = {
    [1]="Los Santos Fire Department",
    [2]="Los Santos Medical Center",
    [3]="Sandy Shores Medical Center",
    [4]="Paleto Bay Medical Center",
    [5]="Los Santos Police Department",
    [6]="Blaine County Police Department",
    [7]="San Andreas Highway Patrol"
}

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
    if (not pFID) then
        pFID = factionID
    end
    local pDID = player.departmentID
    if (not pDID) then
        pDID = departmentID
    end
    
    if (pFID~=factionID or pDID ~= departmentID) then
        TriggerClientEvent("em_duty_client:callbackGetPlayerFaction",source,"Nie należysz do tego departamentu.")
        return
    else
        local pRank = player.rankID
        if (not pRank) then
            TriggerEvent("em_core:setPlayerFaction",pFID,pDID,source)
            duty_getDepartmentData(source,pFID,pDID,0,sex)
            return
        else
            duty_getDepartmentData(source,pFID,pDID,pRank,sex)
        end
    end
end

function faction_startPlayerDuty(factionID, departmentID)
    local source = source
    local player = exports.em_core:PlayersGetPlayerFromId(source)
    local callsign = player.callsign
    local playerName = player.name
    local departmentName = departmentNames[departmentID]
    player.factionDuty = true
    exports.em_discord:onDutyMessage(playerName, callsign, departmentName,departmentID)
end
RegisterNetEvent("em_duty:getPlayerFaction")
RegisterNetEvent("em_duty:startPlayerDuty")
RegisterNetEvent("em_duty:ghost")
AddEventHandler("em_duty:startPlayerDuty",faction_startPlayerDuty)
AddEventHandler("em_duty:ghost",function(state)
    exports.simplepassive:setOverride(source,state)
end)
AddEventHandler("em_duty:getPlayerFaction",duty_getPlayerFaction)