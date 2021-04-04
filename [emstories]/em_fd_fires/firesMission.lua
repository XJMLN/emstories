local playersOnMission = {}
function fireSystem_endMission(FireID)
    if (playersOnMission[FireID]) then
        for i,v in ipairs(playersOnMission[FireID]) do
            print(GetPlayerName(v)..' dostaje nagrode')
            TriggerClientEvent("fireSystem_destroyRoute",v)
        end
    end
end

function system_createFire(ID,player)
	local player = player
	local missionData = FIRE_MISSIONS[ID]
	local coords = missionData.fireLocation
	local FireID = Fire:create(coords,math.random(10,12),90)
	playersOnMission[FireID] = {}
	table.insert(playersOnMission[FireID],player)
	TriggerClientEvent("fireSystem_createRoute",player,coords)
end


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		print("random fire event started")
		local randomFire = table.random(FIRE_MISSIONS)
		if (randomFire) then
			print(FIRE_MISSIONS[randomFire].title.. " init")
			TriggerClientEvent("fireSystem_initCallout",-1,FIRE_MISSIONS[randomFire])
		end
		Citizen.Wait(300000)
	end
end)
exports("fireSystem_createFire",system_createFire)

RegisterNetEvent("fireMission:endMission")
AddEventHandler("fireMission:endMission",fireSystem_endMission)