Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(823545595637661729)
        SetRichPresence("Wersja developerska")
		SetDiscordRichPresenceAsset('discord_ems')
        SetDiscordRichPresenceAssetText('EmergencyStories.pl')
        SetDiscordRichPresenceAction(0, "Dołącz do gry", "fivem://connect/localhost:30120")
		Citizen.Wait(60000)
	end
end)