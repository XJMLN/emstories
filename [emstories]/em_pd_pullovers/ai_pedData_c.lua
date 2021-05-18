AddTextEntry("PedIDCard","Imię: ~b~~a~\n~w~Nazwisko: ~b~~a~\n~w~Data urodzenia: ~b~~a~\n~a~")
AddTextEntry("PedDriveCard","Imię: ~b~~a~\n~w~Nazwisko: ~b~~a~\n~w~Data urodzenia: ~b~~a~\n~w~Ważny do: ~b~~a~")
AddTextEntry("PedAlcoholGood","~b~[Alkomat]\n~w~Poziom alkoholu we krwi: ~g~~a~%\n~w~Niedozwolony poziom alkoholu to ~g~0,008% ~w~lub więcej.")
AddTextEntry("PedAlcoholBad","~b~[Alkomat]\n~w~Poziom alkoholu we krwi: ~r~~a~%\n~w~Niedozwolony poziom alkoholu to ~g~0,008% ~w~lub więcej.")
AddTextEntry("PedDrugs","~b~[Wyniki wymazu]\n~w~Kokaina: ~a~\n~w~Marihuana: ~a~\n~w~Metadon: ~a~")
AddTextEntry("PedItems","~b~[Przeszukanie]\n~a~")
AddTextEntry("VehiclePulloverInformation","Naciśnij ~INPUT_PICKUP~ aby rozpocząć interakcję z kierowcą\nNaciśnij ~INPUT_VEH_DUCK~ aby rozkazać kierowcy wyjście z pojazdu")
AddTextEntry("vehicleInfo","~w~Rejestracja pojazdu: ~b~~a~\n~w~Sprawdź więcej danych pojazdu w ~g~MDT")
function ai_prepareVehicleData(vehicleID)
    if (not vehicleID) then return end
    local vehData = STOPPED_VEHS[vehicleID]
    BeginTextCommandThefeedPost("vehicleInfo")
    AddTextComponentString(GetVehicleNumberPlateText(vehData.vehicle))
    EndTextCommandThefeedPostTicker(true,true)
end
function ai_prepareDocumentsData(documentID, ped, isVehicleStop)
    if (not ped) then return end
    local pedData = STOPPED_PEDS[ped]
    if (isVehicleStop) then
        pedData = convert_vehDataToPedData(STOPPED_VEHS[GUI.Variables.player.currentVehicle])
    end
    DrawDialogue("Zatrzymany mówi: Bez pośpiechu mamy czas, hehe.")
    TriggerServerEvent("pullover:getPedData", ped, pedData.pedType, documentID)
end

function ai_prepareTestResults(testID, ped, isVehicleStop)
    if (not ped) then return end
    local pedData = STOPPED_PEDS[ped]
    if (isVehicleStop) then
        pedData = convert_vehDataToPedData(STOPPED_VEHS[GUI.Variables.player.currentVehicle])
    end
    DrawDialogue("Zatrzymany mówi: Gdzie to mam sobie włożyć? hehe żarty panie policjant.")
    TriggerServerEvent("pullover:getPedTestData", ped, pedData.pedType, testID)
end
function ai_outputData(type, data)
    if (type == 0) then 
        local handle = RegisterPedheadshot(NetworkGetEntityFromNetworkId(data.element))
        while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
            Citizen.Wait(0)
        end
        local txd = GetPedheadshotTxdString(handle)
        BeginTextCommandThefeedPost("PedIDCard")
        AddTextComponentString(data.fName)
        AddTextComponentString(data.lName)
        AddTextComponentString(data.date)
        AddTextComponentString(data.suspect)
        EndTextCommandThefeedPostMessagetext(txd, txd, false, 0, "State of San Andreas", "~b~Dowód osobisty")
        EndTextCommandThefeedPostTicker(true,true)
        UnregisterPedheadshot(handle)
    end
    if (type == 1) then
        local handle = RegisterPedheadshot(NetworkGetEntityFromNetworkId(data.element))
        while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
            Citizen.Wait(0)
        end
        local txd = GetPedheadshotTxdString(handle)
        BeginTextCommandThefeedPost("PedDriveCard")
        AddTextComponentString(data.fName)
        AddTextComponentString(data.lName)
        AddTextComponentString(data.date)
        AddTextComponentString(data.driverLicenseExpiry)
        EndTextCommandThefeedPostMessagetext(txd, txd, false, 0, "State of San Andreas", "~b~Prawo jazdy")
        EndTextCommandThefeedPostTicker(true,true)
        UnregisterPedheadshot(handle)
    end
    if (type == 2) then
        exports.em_3dtext:DrawNotification("Centrala","Centrala",data.weaponLicense,true)
    end
    
    if (type == 6) then
        BeginTextCommandThefeedPost("PedItems")
        AddTextComponentString(data.items)
        EndTextCommandThefeedPostTicker(true,true)
    end
end
function ai_outputTestData(type, data)
    if (type == 1 and tonumber(data.alcohol) < 0.008) then 
        BeginTextCommandThefeedPost("PedAlcoholGood")
        AddTextComponentString(tostring(data.alcohol))
        EndTextCommandThefeedPostTicker(true,true)
    end
    if (type == 1 and tonumber(data.alcohol) >= 0.008) then 
        BeginTextCommandThefeedPost("PedAlcoholBad")
        AddTextComponentString(data.alcohol)
        EndTextCommandThefeedPostTicker(true,true)
    end
    if (type == 2) then
        BeginTextCommandThefeedPost("PedDrugs")
        AddTextComponentString(data.drugs.cocaine)
        AddTextComponentString(data.drugs.marijuana)
        AddTextComponentString(data.drugs.meth)
        EndTextCommandThefeedPostTicker(true,true)
    end
end

function ai_searchPed(ped,isVehicleStop)
    if (not ped) then return end
    local pedData = STOPPED_PEDS[ped]
    if (isVehicleStop) then
        pedData = convert_vehDataToPedData(STOPPED_VEHS[GUI.Variables.player.currentVehicle])
    end
    DrawDialogue("Zatrzymany mówi: No i co jeszcze? Może mam kucnąć i kaszlnąć...")
    TriggerServerEvent("pullover:getPedItems", ped, pedData.pedType)
end

function ai_searchVeh(ped,veh)
    if (not veh or not ped) then return end
    local vehData = STOPPED_VEHS[veh]
    local pedData = STOPPED_PEDS[ped]
    TriggerServerEvent("pullover:getVehicleItems", ped,pedData.pedType,veh)
end
function ai_outputResults(reward,XP)
    if (reward) then
        exports.em_3dtext:DrawNotification("Centrala","Centrala","Otrzymujesz "..XP.."XP za prawidłowe aresztowanie.",true)
    else
        exports.em_3dtext:DrawNotification("Centrala","Centrala","Zatrzymałeś/aś niewinną osobę, nie otrzymujesz nagrody.",true)
    end
end
RegisterNetEvent("ai_pedDataReturn")
RegisterNetEvent("ai_pedTestDataReturn")
RegisterNetEvent("ai_pedIllegalityReturn")
RegisterNetEvent("ai_vehItemsReturn")
AddEventHandler("ai_vehItemsReturn",ai_outputData)
AddEventHandler("ai_pedIllegalityReturn",ai_outputResults)
AddEventHandler("ai_pedTestDataReturn", ai_outputTestData)
AddEventHandler("ai_pedDataReturn", ai_outputData)