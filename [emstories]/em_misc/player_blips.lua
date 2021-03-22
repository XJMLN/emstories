local isRadarExtended = false
local isBlipRotating = true

local colors = {28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		for _, player in ipairs(GetActivePlayers()) do
			if PlayerPedId() ~= GetPlayerPed(player) then
				ped = GetPlayerPed(player)
				blip = GetBlipFromEntity(ped)
				if not DoesBlipExist(blip) then
					blip = AddBlipForEntity(ped)
					SetBlipSprite(blip, 1)
					

					SetBlipNameToPlayerName(blip, player) 
                    SetBlipColour(blip, 0)
                    SetBlipCategory(blip,7)
                    SetBlipDisplay(blip,6)
                    ShowHeadingIndicatorOnBlip(blip, true)
                    if (not IsPedInAnyHeli(ped)) then 
                        SetBlipRotation(blip, GetEntityHeading(ped))
                    end
				end
				
			end	
		end
	end
end)
