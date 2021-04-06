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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local ply = GetPlayerPed(-1)
        if GetSelectedPedWeapon(ply) == GetHashKey("WEAPON_FIREEXTINGUISHER") then
            SetPedInfiniteAmmo(ply, true, GetHashKey("WEAPON_FIREEXTINGUISHER"))
			GiveDelayedWeaponToPed(ply,GetHashKey("WEAPON_FIREEXTINGUISHER"),0,false)
        end
    end
end)