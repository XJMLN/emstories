MISSIONS = {
    {
        id=1,
        title="Pojazd jadący na wstecznym",
        locations={
            [5] = {
                {x=789.99,y=-1391.68,z=26.68,heading=180.82},

            },
            [6] = {
                {},
            },
            [7] = {
                {},
            }
        },
        code=3,
    },
	{
		id=2,
		title="Eskorta pojazdu",
		locations={
			[5] = {
				{x=397.83,y=-1597.92,z=28.87,heading=228.75,escortID=2},
				{x=228.79,y=-1417.14,z=28.95,heading=58.91,escortID=2},
				{x=-40.96,y=-685.21,z=32,heading=94.73,escortID=1},
				{x=-1033.21,y=-2731.17,z=19.71,heading=242.57,escortID=3},
			},
			[6] = {
				{},
			},
			[7] = {

			}
		},
		code=3,
	},
	{
		id=3,
		title="Rowerzysta na autostradzie",
		locations={
			[5] = {
				{x=-412.49,y=-489.38,z=24.83,heading=92.49},

			},
			[6] = {
				{},
			},
			[7] = {
				{},
			}
		},
		code=3,
	}
}

VEHICLES = {"mule","mule2","mule3","mule4","blista","club","dilettante","panto","oracle","felon2","felon","dloader","baller","huntley","landstalker","granger","gresley","bjxl","xls","serrano","emperor2","primo","premier","regina","stratum","sadler","speedo4","minivan","burrito","journey","surfer","rumpo"}
PEDS = {"a_f_o_genstreet_01","a_f_y_genhot_01","a_m_m_genfat_02","a_m_m_genfat_01","u_m_m_filmdirector","a_f_y_fitness_02","a_f_y_hipster_01","a_m_y_hikey_01","a_f_y_hiker_01"}


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