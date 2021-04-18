playersOnMission = {}
playersMission = {
    [2]={},
}

function mcSystem_endMission(missionID,taskCounter)
    if (playersOnMission[missionID]) then
        for i,v in ipairs(playersOnMission[missionID]) do
            playersMission[2][v] = nil
            exports.em_core:givePlayerXP(10*taskCounter,v)
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

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(5000)
		local randomMission = table.random(MISSIONS)
		if (randomMission) then
			if (playersOnMission[MISSIONS[randomMission].systemData.id]) then return end
			local allPlayers = exports.em_core:PlayersGetAllPlayers()
    		local dispatchPlayers = {[1]={},[2]={},[3]={}}
			local factionID = 2
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
				print(GetPlayerName(player))
				TriggerClientEvent("mcSystem_initCallout",player,MISSIONS[randomMission])
        	end
    	end
		end
		Citizen.Wait(300000)
	end
end)
RegisterNetEvent("mcMission:endMission")
AddEventHandler("mcMission:endMission",mcSystem_endMission)