--[[
	MISSIONS = {
		{title=TYTUŁ, location=MIEJSCE_BLIPA, code=3 lub 4, systemData={type=ped/, id=id kolejne}, pedData={taskList="String z taskami do zrobienia",tasksIds={ID taskow do sprawdzenia}, diagnose={string z diagnozami},pulseFrom=losowanie pulsu od, pulseTo=losowanie pulsu do, temperatureFrom=losowanie temp od, temperatureTo=losowanie temperatury do, location=miejsce peda, heading=rotacja peda}}
	}

]]

MISSIONS = {
    {title="Upadek w stacji metra", location=vector3(-481.08,-687.36,20.03),code=3, systemData={type="ped",id=1},pedData={taskList="Podaj poszkodowanemu środki przeciwbólowe, ustabilizuj zranioną kończynę. Następnie przewieź osobę do szpitala.",tasksIDs={[1]=true,[2]=true,[3]=true},diagnose={"Zwichnięta lewa kostka","Zwichnięta prawa kostka","Złamana lewa noga", "Złamana prawa noga","Złamana lewa ręka","Złamana prawa ręka"}, pulseFrom=65, pulseTo=95,temperatureFrom=36.4, temperatureTo=40.3,location=vector3(-481.08,-687.36,20.03),heading=277.06}},
}

function table.random(t)
	if not t or type(t) ~= "table" or next(t) == nil then
		return false
	end

	local randomPosition = math.random(1, table.length(t))
	local currentPosition = 0
	local randomKey = nil

	for k, v in pairs(t) do -- Select a random registered fire
		currentPosition = currentPosition + 1

		if currentPosition == randomPosition then
			randomKey = k
			break
		end
	end

	return randomKey, t[randomKey]
end
function table.length(t)
	if not t or type(t) ~= "table" then
		return
	end

	local count = 0

	for k, v in pairs(t) do count = count + 1 end

	return count
end