local playersOnMission = {}
local playersMission = {
	[1]={},
    [2]={},
    [3]={},
}
function fireSystem_endMission(FireID)
	Fire:remove(FireID)
    if (playersOnMission[FireID]) then
        for i,v in ipairs(playersOnMission[FireID]) do
            exports.em_core:givePlayerXP(50,v)
            TriggerClientEvent("fireSystem_destroyRoute",v)
        end
    end
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local function dispatch_getRandomPlayer(factionID,dispatchPlayers)
    local n = math.random(1,tablelength(dispatchPlayers[factionID]))
    return dispatchPlayers[factionID][n]
end

function system_createFire(ID,player)
	local player = player
	local missionData = FIRE_MISSIONS[ID]
	local coords = missionData.fireLocation
	local FireID = Fire:create(coords,missionData.spread,missionData.spreadChance)
	playersOnMission[FireID] = {}
	table.insert(playersOnMission[FireID],player)
	TriggerClientEvent("fireSystem_createRoute",player,coords,FireID)
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local randomFire = table.random(FIRE_MISSIONS)
		if (randomFire) then
			if (playersOnMission[FIRE_MISSIONS[randomFire].systemData.id]) then return end
			local allPlayers = exports.em_core:PlayersGetAllPlayers()
    		local dispatchPlayers = {[1]={},[2]={},[3]={}}
			local factionID = 3
    		for i,v in pairs(allPlayers) do
        		if v.factionID == factionID then
            		if (not playersMission[factionID][v.playerId]) then
                	table.insert(dispatchPlayers[factionID],v.playerId)
            	end
        	end
    	end
    	if (tablelength(dispatchPlayers[factionID])>0) then
        	local player = dispatch_getRandomPlayer(factionID,dispatchPlayers)
        	if (player) then
            	print(GetPlayerName(player).." dispatch")
				TriggerClientEvent("fireSystem_initCallout",player,FIRE_MISSIONS[randomFire])
        	end
    	end
		end
		Citizen.Wait(300000)
	end
end)
exports("fireSystem_createFire",system_createFire)

RegisterNetEvent("fireMission:endMission")
AddEventHandler("fireMission:endMission",fireSystem_endMission)

RegisterCommand("callout",function(source)
	TriggerClientEvent("fireSystem_initCallout",source,FIRE_MISSIONS[8])
end)