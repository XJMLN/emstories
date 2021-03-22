Citizen.CreateThread(function()
	while true do
	    SetVehicleDensityMultiplierThisFrame(0.6)
	    SetPedDensityMultiplierThisFrame(0.6)
	    SetRandomVehicleDensityMultiplierThisFrame(0.6)
	    SetParkedVehicleDensityMultiplierThisFrame(0.6)
	    SetScenarioPedDensityMultiplierThisFrame(0.6,0.6)
		SetMaxWantedLevel(0)
        SetPlayerWantedLevel(PlayerId(), 0, false)
        SetPlayerWantedLevelNow(PlayerId(), false)
	Citizen.Wait(0)
	end
end)