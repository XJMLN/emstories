MENUS = {}
GUI_PlayerCanOpenVehicleMenu = {}
GUI_PlayerCanOpenPedMenu = {}
MENUS.MainMenu = RageUI.CreateMenu("Główne Menu","Wybierz kategorie")
MENUS.dispatch = RageUI.CreateSubMenu(MENUS.MainMenu, "Centrala","Wybierz jedna z opcji")
MENUS.speed = RageUI.CreateSubMenu(MENUS.MainMenu,"Strefa prędkości","Wybierz jedna z opcji")
MENUS.pullover = RageUI.CreateMenu("Menu zatrzymania","Wybierz opcje")
MENUS.questions = RageUI.CreateSubMenu(MENUS.pullover,"Pytania","Wybierz jedno z pytan")
MENUS.ped = RageUI.CreateMenu("Menu zatrzymania","Wybierz opcje")
MENUS['pullover']:DisplayGlare(false)
MENUS['ped']:DisplayGlare(false)
MENUS['ped'].EnableMouse = true 
MENUS['pullover'].EnableMouse = true
MENUS['MainMenu']:DisplayGlare(false)
MENUS['MainMenu'].Closed = function() 
    
    if (chatHidden) then 
        chatHidden = false
	    TriggerEvent("chat:toggleChat")
	    TriggerEvent("chat:clear")
    end
end 
MENUS['MainMenu'].EnableMouse = true 
local chatHidden = false
menuVariables = {
    pulloverPeds = {
        list = 1,
        Dlist = 1,
        valDocument = 1,
        Plist = 1,
        valPed = 1,
    },
    peds = {
        Dlist =1,
        valDocument =1,
        Slist = 1,
        valSearch = 1,
        Flist = 1,
        valFollow =1,
        cuff = "~y~Zakuj",
        canCuffs = true,
    },
    speed = {
        list = 2,
        listRange = 1,
        valSpeed = 10,
        valRange = 5,
        deleteBtn = false,
    },
    documents = {
        list = 1,
        valDocument = 1,
    },
    services = {
        tow = "Wezwij lawetę",
        isTowing=false,
        isEMS=false,
        ambulance="Wezwij ambulans",
        isCoroner=false,
        coroner="Wezwij koronera",
        isAnimal=false,
        animal="Wezwij hycla"
    }
}

function fpdSystem_guiDrawHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0,0,1,-1)
end
function fpdSystem_guiCancelService(service)
    if (service == 'towing') then 
        menuVariables['services']['tow']="Wezwij lawetę"
        menuVariables['services']['isTowing'] = false
    end
    if (service == 'ambulance') then 
        menuVariables['services'].isEMS = false
        menuVariables['services']['ambulance'] = "Wezwij ambulans"
    end
    if (service == 'coroner') then 
        menuVariables['services'].isCoroner = false
        menuVariables['services']['coroner']="Wezwij koronera"
    end
    if (service == 'animal') then 
        menuVariables['services'].isAnimal = false
        menuVariables['services']['animal']="Wezwij hycla"
    end
end
TimerBarProgress = 0
function DrawTimerBar(endT,text)
    local value = TimerBarProgress
	local maxvalue = math.floor(endT*0.001)
	local width = 0.1
	local height = 0.015
	local xvalue = 0.885
	local yvalue = 0.965
	local outlinecolour = {0, 0, 0, 150}
    local outlinePos = {0.9,0.965}
    local outlineSize = {0.19, 0.025}
	local barcolour = {0, 48, 105}
    if (value<5.0) then 
	    DrawRect(outlinePos[1], outlinePos[2], outlineSize[1] + 0.004, outlineSize[2] + 0.006705, outlinecolour[1], outlinecolour[2], outlinecolour[3], outlinecolour[4]) -- Box that creates outline
	    drawHelpTxt(outlinePos[1]-0.075,outlinePos[2]+0.0025, 0.02, 0.05, 0.5, text, 255, 255, 255, 255, 4) -- Text display of timer
	    DrawRect(xvalue + (width/2), yvalue, width, height, barcolour[1], barcolour[2], barcolour[3], 75) --  Static full bar
	    DrawRect(xvalue + ((value/(maxvalue/width))/2), yvalue, value/(maxvalue/width), height, barcolour[1], barcolour[2], barcolour[3], 255) -- Moveable Bar  
    end
end

function drawHelpTxt(x,y ,width,height,scale, text, r,g,b,a,font)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1.0)
        -- Ped Stop & Pullover ped menu
        RageUI.IsVisible(MENUS['ped'], function()
            RageUI.List('Sprawdź', {
                { Name = "Dowód osobisty", Value = 0 },
                { Name = "Prawo jazdy", Value = 1 },
                { Name = "Licencja na broń", Value = 2  },
                { Name = "Karta wędkarska", Value = 3 },
                { Name = "Licencja łowiecka", Value = 4 },

            }, menuVariables.peds.Dlist, "Wybierz dokument", {}, true, {
                onListChange = function(Index, Item)
                    menuVariables.peds.Dlist = Index;
                    menuVariables['peds']['valDocument'] = Item.Value
                end,
                onSelected = function(Index, Item)
                    menuVariables['peds']['valDocument'] = Item.Value
                    client_fpdSystem_prepareDocumentsData(menuVariables['peds']['valDocument'],GUI_PlayerCanOpenPedMenu.ped)
                end,
            })
            RageUI.Button("Zadaj pytanie", "Zadaj pytanie",{RightLabel =">>>"},true,{onSelected = function() end},MENUS['questions'])
            RageUI.Button("Wykonaj badanie alkomatem","Wykonaj badanie alkomatem",{},true,{onSelected=function() 
                client_fpdSystem_pullover_alcohol(GUI_PlayerCanOpenPedMenu.ped)
            end})
            RageUI.Button("Wykonaj test narkotykowy","Wykonaj test narkotykowy",{},true,{onSelected=function() 
                client_fpdSystem_pullover_drug(GUI_PlayerCanOpenPedMenu.ped)
            end})
            RageUI.List('Przeszukaj',GUI_PlayerCanOpenPedMenu.SearchList, menuVariables.peds.Slist, "Przeszukaj", {}, true, {
                onListChange = function(Index, Item)
                    menuVariables.peds.Slist = Index;
                    menuVariables['peds']['valSearch'] = Item.Value
                end,
                onSelected = function(Index, Item)
                    menuVariables['peds']['valSearch'] = Item.Value
                    client_fpdSystem_pullover_search(Item.Value,GUI_PlayerCanOpenPedMenu.ped)
                end,
            })
            RageUI.List("Tryb poruszania",{
                {Name="Podążanie", Value=0},
                {Name="Złap", Value=1},
            }, menuVariables.peds.Flist, "Wybierz tryb poruszania się zatrzymanego",{},true,{
                onListChange = function(Index, Item)
                    menuVariables.peds.Flist = Index;
                    menuVariables['peds']['valFollow'] = Item.Value
                end,
                onSelected = function(Index, Item)
                    menuVariables['peds']['valFollow'] = Item.Value
                    client_fpdSystem_followMode(GUI_PlayerCanOpenPedMenu.pedID,GUI_PlayerCanOpenPedMenu.ped,Item.Value)
                end,
            })
            RageUI.Button(menuVariables['peds']['cuff'],"Zakuj zatrzymanego",{},menuVariables['peds']['canCuffs'],{onSelected=function() 
                if (isPedCuffed(GUI_PlayerCanOpenPedMenu.pedID)) then
                    menuVariables['peds']['cuff'] = "~y~Zakuj"
                else
                    menuVariables['peds']['cuff'] = "~y~Rozkuj"
                end
                client_fpdSystem_cuff(GUI_PlayerCanOpenPedMenu.ped,GUI_PlayerCanOpenPedMenu.pedID) 
            end})
            if (GUI_PlayerCanOpenPedMenu.vehStop) then
                RageUI.Button("~r~Wróć do pojazdu","Rozkazuje zatrzymanemu powrócić do pojazdu",{},true,{onSelected=function() 
                    client_fpdSystem_returnToVehicle(GUI_PlayerCanOpenPedMenu.ped,GUI_PlayerCanOpenPedMenu.pedID,GUI_PlayerCanOpenPedMenu.vehID)
                    RageUI.Visible(MENUS['ped'],false)
                end})
            else
                RageUI.Button("~r~Zakończ zatrzymanie","Zakończ zatrzymanie",{},true,{onSelected=function() 
                client_fpdSystem_stopPedCancel(GUI_PlayerCanOpenPedMenu.ped,GUI_PlayerCanOpenPedMenu.pedID)
                RageUI.Visible(MENUS['ped'],false)
                end})
            end
        end)
        -- Pullover Menu
        RageUI.IsVisible(MENUS['pullover'], function()
            RageUI.List("Interakcja z ", {
                {Name = "Kierowcą", Value=0}
            },menuVariables.pulloverPeds.list,"Wybierz osobę do interakcji", {},true, {
                onListChange = function(Index, Item)
                    menuVariables.pulloverPeds.list = Index;
                    menuVariables['pulloverPeds']['valPed'] = Item.Value
                end,
                onSelected = function(Index, Item)
                    menuVariables['pulloverPeds']['valPed'] = Item.Value
                end,
            })
            RageUI.List('Sprawdź', {
                { Name = "Dowód osobisty", Value = 0 },
                { Name = "Prawo jazdy", Value = 1 },
                { Name = "Licencja na broń", Value = 2  },
                { Name = "Karta wędkarska", Value = 3 },
                { Name = "Licencja łowiecka", Value = 4 },

            }, menuVariables.pulloverPeds.Dlist, "Wybierz dokument", {}, true, {
                onListChange = function(Index, Item)
                    menuVariables.pulloverPeds.Dlist = Index;
                    menuVariables['pulloverPeds']['valDocument'] = Item.Value
                end,
                onSelected = function(Index, Item)
                    menuVariables['pulloverPeds']['valDocument'] = Item.Value
                    client_fpdSystem_prepareDocumentsData(menuVariables['pulloverPeds']['valDocument'],GUI_PlayerCanOpenVehicleMenu.ped)
                end,
            })
            RageUI.Button("Zadaj pytanie", "Zadaj pytanie",{RightLabel =">>>"},true,{onSelected = function() end},MENUS['questions'])
            RageUI.Button("Wykonaj badanie alkomatem","Wykonaj badanie alkomatem",{},true,{onSelected=function() 
                client_fpdSystem_pullover_alcohol(GUI_PlayerCanOpenVehicleMenu.ped)
            end})
            RageUI.Button("Wykonaj test narkotykowy","Wykonaj test narkotykowy",{},true,{onSelected=function() 
                client_fpdSystem_pullover_drug(GUI_PlayerCanOpenVehicleMenu.ped)
            end})
            RageUI.List('Rozkaż wyjście z pojazdu', {
                { Name = "Kierowcy", Value = 0 },
                { Name = "Pasażerowi #1", Value = 1 },
                { Name = "Pasażerowi #2", Value = 2  },
                { Name = "Pasażerowi #3", Value = 3 },
                { Name = "Pasażerowi #4", Value = 4 },

            }, menuVariables.pulloverPeds.Plist, "Wybierz dokument", {}, true, {
                onListChange = function(Index, Item)
                    menuVariables.pulloverPeds.Plist = Index;
                    menuVariables['pulloverPeds']['valPed'] = Item.Value
                end,
                onSelected = function(Index, Item)
                    menuVariables['pulloverPeds']['valPed'] = Item.Value
                    client_fpdSystem_pullover_stepOut(Item.Value,GUI_PlayerCanOpenVehicleMenu.vehID)
                end,
            })
            RageUI.Button("~r~Zakończ zatrzymanie","Zakończ zatrzymanie",{},true,{onSelected=function() client_fpdSystem_cancelPullover(GUI_PlayerCanOpenVehicleMenu.vehID) RageUI.Visible(MENUS['pullover'],false) end})
        end)

        --Questions
        RageUI.IsVisible(MENUS['questions'], function()
            for i,v in ipairs(QUESTIONS) do
                RageUI.Button(v.question,"Zadaj pytanie",{},true,{onSelected=function() client_fpdSystem_question(v,GUI_PlayerCanOpenVehicleMenu.ped) end})
            end
        end)
        -- MainMenu 
        RageUI.IsVisible(MENUS['MainMenu'], function()
            RageUI.Button("Centrala","Przejdź do centrali",{RightLabel = ">>>"},true,{onSelected = function() end}, MENUS['dispatch'])
            RageUI.Button("Strefa ograniczenia prędkości","Przejdź do menu stref prędkości",{RightLabel = ">>>"},true,{onSelected= function() end}, MENUS['speed'])
        end)

        --dispatch
        RageUI.IsVisible(MENUS['dispatch'], function()
            RageUI.List('Sprawdź', {
                { Name = "Dowód osobisty", Value = 0 },
                { Name = "Prawo jazdy", Value = 1 },
                { Name = "Licencja na broń", Value = 2  },
                { Name = "Karta wędkarska", Value = 3 },
                { Name = "Licencja łowiecka", Value = 4 },

            }, menuVariables.documents.list, "Wybierz dokument", {}, true, {
                onListChange = function(Index, Item)
                    menuVariables.documents.list = Index;
                    menuVariables['documents']['valDocument'] = Item.Value
                end,
                onSelected = function(Index, Item)
                    menuVariables['documents']['valDocument'] = Item.Value
                    client_fpdSystem_prepareDocumentsData(menuVariables['documents']['valDocument'])
                end,
            })

            RageUI.Button("Sprawdź tablice rejestracyjne","Sprawdź tablice rejestracyjne auta przed Tobą",{},true,{onSelected = function() 
                client_fpdSystem_prepareVehicleLicenseCheck()
            end})
            RageUI.Button("Wezwij transport więzienny","Wezwij transport więzienny do miejsca w którym przebywasz",{},true,{onSelected = function() 
                
            end})
            RageUI.Button(menuVariables['services']['ambulance'],"Wezwij ambulans do miejsca w którym przebywasz",{},true,{onSelected = function() 
                if (menuVariables['services'].isEMS) then 
                    menuVariables['services'].isEMS = false 
                    menuVariables['services']['ambulance'] = "Wezwij ambulans"
                    client_fpdSystem_cancelService(2)
                    return
                end
                if (menuVariables['services'].isEMS == false) then
                    menuVariables['services'].isEMS = true
                    menuVariables['services']['ambulance'] = "~r~Anuluj ambulans"
                    client_fpdSystem_callService(2)
                    return
                end
            end})
            RageUI.Button(menuVariables['services']['coroner'],"Wezwij koronera do miejsca w którym przebywasz",{},true,{onSelected = function() 
                if (menuVariables['services'].isCoroner) then 
                    menuVariables['services'].isCoroner = false 
                    menuVariables['services']['coroner'] = "Wezwij koronera"
                    client_fpdSystem_cancelService(4)
                    return
                end
                if (menuVariables['services'].isCoroner == false) then
                    menuVariables['services'].isCoroner = true
                    menuVariables['services']['coroner'] = "~r~Anuluj koronera"
                    client_fpdSystem_callService(4)
                    return
                end
                
            end})
            RageUI.Button("Wezwij hycla","Wezwij hycla do miejsca w którym przebywasz",{},true,{onSelected = function() 
                if (menuVariables['services'].isAnimal) then 
                    menuVariables['services'].isAnimal = false 
                    menuVariables['services']['animal'] = "Wezwij hycla"
                    client_fpdSystem_cancelService(5)
                    return
                end
                if (menuVariables['services'].isAnimal == false) then
                    menuVariables['services'].isAnimal = true
                    menuVariables['services']['animal'] = "~r~Anuluj hycla"
                    client_fpdSystem_callService(5)
                    return
                end
            end})
            RageUI.Button(menuVariables['services']['tow'],"Wezwij lawetę do miejsca w którym przebywasz",{},true,{onSelected = function() 
                if (menuVariables['services'].isTowing) then 
                    menuVariables['services'].isTowing = false 
                    menuVariables['services']['tow'] = "Wezwij lawetę"
                    client_fpdSystem_cancelService(6)
                    return
                end
                if (menuVariables['services'].isTowing == false) then
                    menuVariables['services'].isTowing = true
                    menuVariables['services']['tow'] = "~r~Anuluj lawetę"
                    client_fpdSystem_callService(6)
                    return
                end
            end})

        end)

        -- Speed zone
        RageUI.IsVisible(MENUS['speed'], function()
            RageUI.List('Prędkość', {
                { Name = "0 km/h", Value = 0 },
                { Name = "10 km/h", Value = 10 },
                { Name = "20 km/h", Value = 20  },
                { Name = "30 km/h", Value = 30 },
                { Name = "40 km/h", Value = 40 },
                { Name = "50 km/h", Value = 50 },
                { Name = "60 km/h", Value = 60  },

            }, menuVariables.speed.list, "Wybierz prędkość", {}, true, {
                onListChange = function(Index, Item)
                    menuVariables.speed.list = Index;
                    menuVariables['speed']['valSpeed'] = Item.Value
                end,
                onSelected = function(Index, Item)
                    menuVariables['speed']['valSpeed'] = Item.Value
                end,
            })

            RageUI.List('Zasięg', {
                { Name = "5", Value = 5 },
                { Name = "10", Value = 10 },
                { Name = "20", Value = 20  },
                { Name = "30", Value = 30 },
                { Name = "40", Value = 40 },
                { Name = "50", Value = 50 },
                { Name = "60", Value = 60  },

            }, menuVariables.speed.listRange, "Wybierz zasięg", {}, true, {
                onListChange = function(Index, Item)
                    menuVariables.speed.listRange = Index;
                    menuVariables['speed']['valRange'] = Item.Value
                end,
                onSelected = function(Index, Item)
                    menuVariables['speed']['valRange'] = Item.Value
                end,
            })

            RageUI.Button("~g~Umieść strefę","Umieść strefę",{},true,{onSelected = function() 
                menuVariables['speed']['deleteBtn'] = true
                TriggerServerEvent("fpdSystem:createSpeedZone",menuVariables['speed']['valSpeed'],menuVariables['speed']['valRange'],GetEntityCoords(PlayerPedId()))
            end})
            RageUI.Button("~r~Usuń strefę","Usuń strefę",{},menuVariables['speed']['deleteBtn'],{onSelected = function() 
                menuVariables['speed']['deleteBtn'] = false
                TriggerServerEvent("fpdSystem:deleteSpeedZone")
            end})
        end)
    end
end)

Keys.Register("F4","F4","Główne Menu",function()

    if (not chatHidden) then 
        TriggerEvent("chat:toggleChat")
	    TriggerEvent("chat:clear")
        chatHidden = true 
    end
    RageUI.Visible(MENUS['MainMenu'], not RageUI.Visible(MENUS['MainMenu']))
end)

function fpdSystemGui_showPulloverMenu()
    if (not GUI_PlayerCanOpenVehicleMenu.ped and GUI_PlayerCanOpenPedMenu.ped) then
        if (not GUI_PlayerCanOpenPedMenu.distance) then
            fpdSystem_guiDrawHelpText("Jesteś zbyt daleko od zatrzymanego.")
            return
        end
        if (not chatHidden) then 
            TriggerEvent("chat:toggleChat")
            TriggerEvent("chat:clear")
            chatHidden = true 
        end
        
        GUI_PlayerCanOpenPedMenu.SearchList = {
            {Name = "Osobę", Value = 0},
        }
        --if (GUI_PlayerCanOpenPedMenu.vehStop) then
          --  table.insert(GUI_PlayerCanOpenPedMenu.SearchList,{Name="Pojazd", Value=1})
        --end

        RageUI.Visible(MENUS['ped'], not RageUI.Visible(MENUS['ped']))
        return 
    end
    if (GUI_PlayerCanOpenVehicleMenu.ped and not GUI_PlayerCanOpenPedMenu.ped) then
        if (not chatHidden) then 
            TriggerEvent("chat:toggleChat")
            TriggerEvent("chat:clear")
            chatHidden = true 
        end
        GUI_PlayerCanOpenVehicleMenu.ItemList = {}
        table.insert(GUI_PlayerCanOpenVehicleMenu.ItemList,{ Name = "Kierowcą", Value=GUI_PlayerCanOpenVehicleMenu.ped})
        local list = {}
        for i,v in pairs(GUI_PlayerCanOpenVehicleMenu.passengers) do 
            table.insert(list,{Name = "Pasażerem", Value=v})
        end 
        print('poszlo')
        RageUI.Visible(MENUS['pullover'], not RageUI.Visible(MENUS['pullover']))
        return
    end


end

Keys.Register("E","E","Menu zatrzymania",fpdSystemGui_showPulloverMenu)
