local factionNames = {
    [1]="PD",
    [2]="MC",
    [3]="FD"
}
local Chars = {}
for Loop = 0, 255 do
   Chars[Loop+1] = string.char(Loop)
end
local String = table.concat(Chars)

local Built = {['.'] = Chars}

local AddLookup = function(CharSet)
   local Substitute = string.gsub(String, '[^'..CharSet..']', '')
   local Lookup = {}
   for Loop = 1, string.len(Substitute) do
       Lookup[Loop] = string.sub(Substitute, Loop, Loop)
   end
   Built[CharSet] = Lookup

   return Lookup
end

function string.random(Length, CharSet)
   local CharSet = CharSet or '.'

   if CharSet == '' then
      return ''
   else
      local Result = {}
      local Lookup = Built[CharSet] or AddLookup(CharSet)
      local Range = #Lookup

      for Loop = 1,Length do
         Result[Loop] = Lookup[math.random(1, Range)]
      end

      return table.concat(Result)
   end
end

function faction_createCallsign(factionID)
    local callsign = factionNames[factionID].."-"
    callsign = callsign ..string.upper(string.random(4,"%l%d"))
    return callsign
end
function faction_playerDataInit(factionID,departmentID,UID,playerData)
    local callsign = faction_createCallsign(factionID)
    local playerData = playerData
    MySQL.Async.execute("INSERT INTO em_users_departments (user_id,faction_id,department_id,rank_id,xp,callsign) VALUES (@UID,@factionID,@departmentID,0,0,@callsign)",{
        ['@UID']=UID,
        ['@factionID']=factionID,
        ['@departmentID']=departmentID,
        ['@callsign']=callsign
    },function(result)
        playerData.callsign = callsign
        MySQL.Async.fetchAll("SELECT name FROM em_departments_ranks WHERE rank_id=0 AND department_id=@departmentID",{['@departmentID']=departmentID},function(result)
            if (result and result[1]) then
                local row = result[1]
                playerData.rankName = row.name
            end
        end)
    end)
end

Players.setPlayerFaction = function(factionID, departmentID,player)
    local playerId = source
    if (player) then
        playerId = player
    end
    local playerData = Players.all[tostring(playerId)]
    local factionID = factionID
    local departmentID = departmentID
    local UID = playerData.UID
    MySQL.Async.fetchAll("SELECT d.rank_id,d.xp,dr.name,d.callsign FROM em_users_departments d LEFT JOIN em_departments_ranks dr ON dr.rank_id=d.rank_id AND dr.department_id=@departmentID WHERE d.faction_id=@factionID AND d.department_id=@departmentID AND d.user_id=@UID",{
        ['@factionID']=factionID,
        ['@departmentID']=departmentID,
        ['@UID']=UID,
    },function(result)
        if (result and result[1]) then
            local row = result[1]
            playerData.xp = row.xp
            playerData.rankID = row.rank_id
            playerData.rankName = row.name
            playerData.callsign = row.callsign
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

Players.givePlayerXP = function(xp, player)
    local playerId = source
    if (player) then
        playerId = player
    end
    local playerData = Players.all[tostring(playerId)]
    local factionID = playerData.factionID
    local departmentID = playerData.departmentID
    local newvalue = playerData.xp + xp
    playerData.xp = newvalue

    MySQL.Async.execute("UPDATE em_users_departments SET xp=@xp WHERE user_id=@UID AND faction_id=@factionID AND department_id=@departmentID",{
        ['@xp']=playerData.xp,
        ['@UID']=playerData.UID,
        ['@factionID']=factionID,
        ['@departmentID']=departmentID
    },function(result)
    end)
    exports.em_discord:onXPAdd(GetPlayerName(player).." [UID: "..playerData.UID.."] dostaje +"..xp.."XP. Nowa wartość: "..newvalue.."XP")
    TriggerClientEvent("em_core_client:playerXPChange",playerId,playerData.xp)
    return true
end

exports("givePlayerXP",Players.givePlayerXP)
RegisterNetEvent("em_core:setPlayerFaction")
AddEventHandler("em_core:setPlayerFaction",Players.setPlayerFaction)