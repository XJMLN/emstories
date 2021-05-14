GUI = {}
GUI.pullover = RageUI.CreateMenu("Zatrzymanie", "Wybierz opcje")
GUI.followMode = RageUI.CreateMenu("Pozycja pojazdu","Wybierz opcje")
GUI['followMode']:DisplayGlare(false)
GUI['pullover']:DisplayGlare(false)
GUI['followMode'].EnableMouse = true
GUI['pullover'].EnableMouse = true
GUI.Variables = {
    player = {
        distance = false,
        currentPed = nil,
        currentVehicle = nil,
        inVehicle = false,
    },
    pullover ={
        docNumber = 1,
        docValue = nil,
        cuffs = "~y~Zakuj",
        cuffState=true,
    },
    followModes = {
        follow = "Włącz podążanie",
    }
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        RageUI.IsVisible(GUI.pullover, function()
            RageUI.List("Sprawdź", {
                { Name = "Dowód osobisty", Value = 0},
                { Name = "Prawo jazdy", Value = 1},
                { Name = "Licencja na broń", Value = 2},
            },GUI.Variables.pullover.docNumber, "Wybierz dokument", {}, true, {
                onListChange = function(Index, Item)
                    GUI.Variables.pullover.docNumber = Index
                    GUI.Variables.pullover.docValue = Item.Value
                end,
                onSelected = function(Index, Item)
                    GUI.Variables.pullover.docValue = Item.Value
                    ai_prepareDocumentsData(Item.Value, GUI.Variables.player.currentPed,isPerformingVehicleStop)
                end
            })
            if (isPerformingVehicleStop and GUI.Variables.player.inVehicle) then
                RageUI.Button("Sprawdź dane pojazdu","Sprawdź dane pojazdu",{},true,{
                    onSelected=function()
                        ai_prepareVehicleData(GUI.Variables.player.currentVehicle)
                    end
                })
            end
            RageUI.Button("Wykonaj badanie alkomatem","Wykonaj badanie alkomatem", {}, true, {
                onSelected=function()
                    ai_prepareTestResults(1,GUI.Variables.player.currentPed,isPerformingVehicleStop)
                end 
            })

            RageUI.Button("Wykonaj test narkotykowy","Wykonaj test narkotykowy",{},true,{
                onSelected=function()
                    ai_prepareTestResults(2,GUI.Variables.player.currentPed,isPerformingVehicleStop)
                end
            })
            if (isPerformingVehicleStop and GUI.Variables.player.inVehicle==false) or (not isPerformingVehicleStop) then
                RageUI.Button("Przeszukaj osobę","Przeszukaj zatrzymanego",{},true,{
                    onSelected=function()
                        ai_searchPed(GUI.Variables.player.currentPed)
                    end
                })
            end
            if (isPerformingVehicleStop and GUI.Variables.player.inVehicle==false) then
                RageUI.Button("Przeszukaj pojazd","Przeszukaj zatrzymany pojazd",{},true,{
                    onSelected=function()
                        ai_searchVeh(GUI.Variables.player.currentPed,GUI.Variables.player.currentVehicle)
                    end
                })
            end
            if (isPerformingVehicleStop and GUI.Variables.player.inVehicle==false) then
                RageUI.Button("Powrót do pojazdu","Rozkaż kierowcy powrócić do pojazdu",{},true,{
                    onSelected=function()
                        ai_returnToVehicle(GUI.Variables.player.currentPed)
                    end
                })
            end
            if (isPerformingVehicleStop and GUI.Variables.player.inVehicle==false) or (not isPerformingVehicleStop) then
                RageUI.Button(GUI.Variables.pullover.cuffs,"Zakuj/Rozkuj zatrzymanego",{},GUI.Variables.pullover.cuffState, {
                    onSelected=function()
                        ai_cuffPed(GUI.Variables.player.currentPed)
                    end
                })
            end

            RageUI.Button("~r~Zakończ zatrzymanie","Zakończ zatrzymanie",{},true,{
                onSelected=function()
                    ai_endPedPullover(GUI.Variables.player.currentPed,GUI.Variables.player.currentVehicle)
                end
            })
        end)
        RageUI.IsVisible(GUI.followMode, function()
            RageUI.Button(GUI.Variables.followModes.follow,"Podążanie za Twoim pojazdem.",{},true,{
                onSelected=function()
                    ai_followVehicle(GUI.Variables.player.currentVehicle)
                    if (isVehicleFollowing(GUI.Variables.player.currentVehicle)) then
                        GUI.Variables.followModes.follow = "Wyłącz podążanie"
                    else
                        GUI.Variables.followModes.follow = "Włącz podążanie"
                    end
                end
            })
        end)
    end
end)

function gui_pulloverShow()
    if (GetVehiclePedIsIn(GetPlayerPed(-1),false) ~= 0) then return end
    if (not GUI.Variables.player.distance) then return end
    if (not GUI.Variables.player.currentPed) then return end
    RageUI.Visible(GUI['pullover'],not RageUI.Visible(GUI['pullover']))
end
function gui_followShow()
    if (GetVehiclePedIsIn(GetPlayerPed(-1),false) == 0) then return end
    if (not GUI.Variables.player.currentVehicle) then return end
    if (STOPPED_VEHS[GUI.Variables.player.currentVehicle].followMode == 1) then
        GUI.Variables.followModes.follow = "Wyłącz podążanie"
    else
        GUI.Variables.followModes.follow = "Włącz podążanie"
    end
    RageUI.Visible(GUI.followMode,not RageUI.Visible(GUI.followMode))
end
function gui_vehPullover()
    print('veh_pullover')
end
RegisterCommand("pokazpozycjemenu",gui_followShow)
RegisterCommand("pokazinteractionveh",gui_vehPullover)
RegisterKeyMapping("pokazpozycjemenu","PD: Pozycja zatrzymanegu (Menu)","keyboard","x")
RegisterKeyMapping("pokazpozycjemenu","PD: Menu zatrzymania (pojazd)","keyboard","e")

Keys.Register("E","E","Menu zatrzymania (osoba)", gui_pulloverShow)
