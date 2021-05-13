AddTextEntry("PedIDCard","Imię, nazwisko: ~b~~a~ ~a~\n~w~Data urodzenia: ~b~~a~\n~a~")
AddTextEntry("PedDriveCard","Imię, naziwsko: ~b~~a~ ~a~\n~w~Data urodzenia: ~b~~a~\n~w~Ważny do: ~b~~a~")
AddTextEntry("PedAlcoholGood","~b~[Alkomat]\n~w~Poziom alkoholu we krwi: ~g~0.0%\n~w~Niedozwolony poziom alkoholu to ~g~0,008% ~w~lub więcej.")
AddTextEntry("PedAlcoholBad","~b~[Alkomat]\n~w~Poziom alkoholu we krwi: ~r~~a~%\n~w~Niedozwolony poziom alkoholu to ~g~0,008% ~w~lub więcej.")
AddTextEntry("PedDrugs","~b~[Wyniki wymazu]\n~w~Kokaina: ~a~\n~w~Marihuana: ~a~\n~w~Metadon: ~a~")
AddTextEntry("PedItems","~b~[Przeszukanie]\n~a~")


function ai_prepareDocumentsData(documentID, ped)
    if (not ped) then return end
    local pedData = STOPPED_PEDS[ped]
    exports.fpd_3dtext:DrawNotification("Centrala","Centrala","~b~Trwa łączenie z centralą...",true)
    TriggerServerEvent("pullover:getPedData", ped, pedData.pedType, documentID)
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
        BeginTextCommandThefeedPost("PedAlcoholGood")
        AddTextComponentString(data.alcohol)
        EndTextCommandThefeedPostTicker(true,true)
    end
    if (type == 3) then 
        BeginTextCommandThefeedPost("PedAlcoholBad")
        AddTextComponentString(data.alcohol)
        EndTextCommandThefeedPostTicker(true,true)
    end
    if (type == 4) then
        BeginTextCommandThefeedPost("PedDrugs")
        AddTextComponentString(data.drugs.cocaine)
        AddTextComponentString(data.drugs.marijuana)
        AddTextComponentString(data.drugs.meth)
        EndTextCommandThefeedPostTicker(true,true)
    end
    
    if (type == 6) then
        BeginTextCommandThefeedPost("PedItems")
        AddTextComponentString(data)
        EndTextCommandThefeedPostTicker(true,true)
    end
end
RegisterNetEvent("ai_pedDataReturn")
AddEventHandler("ai_pedDataReturn", ai_outputData)