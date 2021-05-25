playersOnMission = {}
playersMission = {
    [1]={},
}

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local function dispatch_getRandomPlayer(factionID,dispatchPlayers)
    local n = math.random(1,tablelength(dispatchPlayers[factionID]))
    return dispatchPlayers[factionID][n]
end

function pdCallout_create(missionData, player)
    local player = player
    local missionData = missionData
    local calloutID = missionData.id
    playersOnMission[calloutID] = {}
    table.insert(playersOnMission[calloutID],player)
    TriggerClientEvent("pdCallout:create",player,missionData)
end

function pdCallout_end(missionID, success)
    if (playersOnMission[missionID]) then
        for i,v in ipairs(playersOnMission[missionID]) do
            playersMission[1][v] = nil
            playersOnMission[missionID] = nil
			if (success) then
            	exports.em_core:givePlayerXP(40, v)
            	TriggerClientEvent("3dtext:DrawNotification",v,"SYSTEM","SYSTEM","Otrzymujesz ~g~40~w~ XP za wykonane wezwanie.",true)
			end
        end
    end
end
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(5000)
		local randomMission = 3
		if (randomMission) then
			if (playersOnMission[MISSIONS[randomMission].id]) then return end
			local allPlayers = exports.em_core:PlayersGetAllPlayers()
    		local dispatchPlayers = {[1]={},[2]={},[3]={}}
			local factionID = 1
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
				    TriggerClientEvent("pdCallout_initCallout",player,MISSIONS[randomMission])
        	    end
    	    end
		end
		Citizen.Wait(300000)
	end
end)
exports("pdCallout_create",pdCallout_create)
RegisterNetEvent("pdCallout:end")
AddEventHandler("pdCallout:end",pdCallout_end)