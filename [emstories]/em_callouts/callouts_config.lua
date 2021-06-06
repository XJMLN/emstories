CALLOUTS = {
    [1]={
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
            sprite=665,
            colour=1
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
            sprite=665,
            colour=1
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
            sprite=665,
            colour=1
        }
    },
    [2]={
        {
            id=13,
            title="Upadek w stacji metra",
            locations = {
                [2]={
                    {x=-481.08,y=-687.36,z=20.03,heading=277.06}
                },
                [3]={
                    {x=-481.08,y=-687.36,z=20.03,heading=277.06}
                },
                [4]={
                    {x=-481.08,y=-687.36,z=20.03,heading=277.06}
                },
            },
            code=3,
            sprite=665,
            colour=1,
            pedData = {
                taskList = "Podaj poszkodowanemu środki przeciwbólowe, ustabilizuj zranioną kończynę. Następnie przewieź osobę do szpitala.",
                tasksIDs = {[1]=true,[2]=true,[3]=true},
                diagnose = {"Zwichnięta lewa kostka","Zwichnięta prawa kostka","Złamana lewa noga", "Złamana prawa noga","Złamana lewa ręka","Złamana prawa ręka"},
                pulseFrom=65,
                pulseTo = 95,
                temperatureFrom=36.4,
                temperatureTo=40.3,
                animationDict="amb@world_human_picnic@female@idle_a",
                animationName="idle_a"
            }
        },
        {
            id=14,
            title="Upadek z schodów",
            locations = {
                [2]={
                    {x=-579.1,y=-995.88,z=22.37,heading=227.96},
                },
                [3]={},
                [4]= {
                    {x=-427.57,y=6325.51,z=21.7,heading=263.5},
                    {x=-766.87,y=5584.18,z=33.61,heading=97.93},
                    {x=-560.27,y=5351.52,z=70.54,heading=66.95},
                    {x=-572.32,y=5328.48,z=70.21,heading=90.25},
                    {x=-550.26,y=5280.85,z=73.76,heading=207.76}
                }
            },
            code=3,
            sprite=665,
            colour=1,
            pedData = {
                taskList = "Podaj poszkodowanemu środki przeciwbólowe, ustabilizuj zranioną kończynę. Następnie przewieź osobę do szpitala.",
                tasksIDs = {[1]=true,[2]=true,[3]=true},
                diagnose = {"Zwichnięta lewa kostka","Zwichnięta prawa kostka","Złamana lewa noga", "Złamana prawa noga","Złamana lewa ręka","Złamana prawa ręka"},
                pulseFrom=65,
                pulseTo = 95,
                temperatureFrom=36.4,
                temperatureTo=40.3,
                animationDict="amb@world_human_picnic@female@idle_a",
                animationName="idle_a"
            }
        },
        {
            id=15,
            title="Transport krwi",
            locations = {
                [2]={
                    {x=1148.97,y=-1513.04,z=34.69},
                },
                [3]={},
                [4]={},
            },
            code=4,
            sprite=665,
            colour=1,
        }
    },
    [3]={
        {
            id=4,
            title="Pożar burdelu",
            locations = {
                [1] = {
                    {x=118.81,y=-1286.82,z=28.27,spread=25,spreadChance=95}
                }
            },
            code=3,
            sprite=665,
            colour=1,
            fire=true
        },
        {
            id=5,
            title="Pożar transformatora",
            locations = {
                [1] = {
                    {x=1569.49,y=858.06,z=77.49,spread=10,spreadChance=95}
                }
            },
            code=3,
            sprite=665,
            colour=1,
            fire=true
        },
        {
            id=6,
            title="Pożar opuszczonego składowiska",
            locations = {
                [1] = {
                    {x=952.26,y=-1508.96,z=30.88,spread=25,spreadChance=95}
                }
            },
            code=3,
            sprite=665,
            colour=1,
            fire=true
        },
        {
            id=7,
            title="Pożar domu",
            locations = {
                [1] = {
                    {x=-803.66,y=172.76,z=72.84,spread=25,spreadChance=95}
                }
            },
            code=3,
            sprite=665,
            colour=1,
            fire=true
        },
        {
            id=8,
            title="Pożar przytułka dla bezdomnych",
            locations = {
                [1] = {
                    {x=7.84,y=-1232.11,z=29.3,spread=25,spreadChance=95}
                }
            },
            code=3,
            sprite=665,
            colour=1,
            fire=true
        },
        {
            id=9,
            title="Pożar złomowiska",
            locations = {
                [1] = {
                    {x=-496.02,y=-1752.18,z=18.33,spread=20,spreadChance=95}
                }
            },
            code=3,
            sprite=665,
            colour=1,
            fire=true
        },
        {
            id=10,
            title="Pożar w dokach",
            locations = {
                [1] = {
                    {x=17.03,y=-2677.56,z=6.03,spread=25,spreadChance=95}
                }
            },
            code=3,
            sprite=665,
            colour=1,
            fire=true
        },
        {
            id=11,
            title="Pożar lasu",
            locations = {
                [1] = {
                    {x=-1493.14,y=4438.14,z=19,spread=20,spreadChance=95}
                }
            },
            code=3,
            sprite=665,
            colour=1,
            fire=true
        },
        {
            id=12,
            title="Wypadek: Uderzenie w słup energetyczny",
            locations = {
                [1] = {
                    {x=496.95,y=-1769.79,z=27.96,heading=316.15},
                },
            },
            code=3,
            sprite=665,
            colour=1,
        },
    },
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
