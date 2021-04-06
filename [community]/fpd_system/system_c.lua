local speedZones = {}
QUESTIONS = {}
JAILS = {}
JAIL_BLIP = nil
local SERVICES = {
    ["PED_MODELS"]= {
        [2]={"s_m_m_doctor_01"},
        [4]={"s_m_y_autopsy_01"},
        [6]={"mp_m_waremech_01"},
        [5]={"csb_chef"}
    },
    ["VEHICLES"]={
        [6]={"flatbed"},
        [2]={"ambulance"},
        [4]={"burrito3"},
        [5]={"bobcatxl"},
    }
}
local ANIMALS_MODELS = {
    ["a_c_husky"]=true,
    ["a_c_deer"]=true,
    ["a_c_crow"]=true,
    ["a_c_dolphin"]=true,
    ["a_c_fish"]=true,
    ["a_c_hen"]=true,
    ["a_c_humpback"]=true,
    ["a_c_killerwhale"]=true,
    ["a_c_mtlion"]=true,
    ["a_c_pig"]=true,
    ["a_c_pigeon"]=true,
    ["a_c_poodle"]=true,
    ["a_c_pug"]=true,
    ["a_c_rabbit_01"]=true,
    ["a_c_rat"]=true,
    ["a_c_retriever"]=true,
    ["a_c_rheus"]=true,
    ["a_c_rottweiler"]=true,
    ["a_c_seagull"]=true,
    ["a_c_sharkhammer"]=true,
    ["a_c_sharktiger"]=true,
    ["a_c_shepherd"]=true,
    ["a_c_stingray"]=true,
    ["a_c_westy"]=true,
    ["a_c_boar"]=true,
    ["a_c_cat_01"]=true,
    ["a_c_chickenhawk"]=true,
    ["a_c_chimp"]=true,
    ["a_c_chop"]=true,
    ["a_c_cormorant"]=true,
    ["a_c_cow"]=true,
    ["a_c_coyote"]=true,
}
local policeCars = {
    ['pdcvpi']=true,
    ['pdimpala']=true,
    ['pdfpiu']=true,
    ['pdcharger']=true,
    ['durango18']=true,
    ['sv2']=true,
    ['sweethoe']=true,
    ['sheriff2']=true,
    ['umfusion']=true,
    ['umranger']=true,
    ['zr1RB']=true,
    ['M5RB_VV']=true,
    ['sp1']=true,
    ['sp5']=true,
    ['sp3']=true,
    ['sp7']=true,
    ['sp11']=true,
    ['sp17']=true,
    ['sp15']=true,
    ['sp9']=true,
    ['sp8']=true,
    ['sp25']=true,
    ['sp27']=true,
    ['ssexplorer']=true,
    ['sotruck']=true,
    ['sscvpi']=true,
    ['sotaurus']=true,
}
AddTextEntry("VehiclePlateData","~b~[Centrala]\n~w~Model: ~b~~a~\n~w~Kolor: ~b~~a~\n~w~Rejestracja: ~b~~a~\n~w~Kierowca: ~b~~a~\n~w~Flagi: ~b~~a~\n~w~Ubezpieczenie: ~b~~a~\n~w~Dowód rejestracyjny: ~b~~a~")
AddTextEntry("PedIDCard","Imię, nazwisko: ~b~~a~ ~a~\n~w~Data urodzenia: ~b~~a~\n~a~")
AddTextEntry("PedDriveCard","Imię, naziwsko: ~b~~a~ ~a~\n~w~Data urodzenia: ~b~~a~\n~w~Ważny do: ~b~~a~")
AddTextEntry("PedAlcoholGood","~b~[Alkomat]\n~w~Poziom alkoholu we krwi: ~g~0.0%\n~w~Niedozwolony poziom alkoholu to ~g~0,008% ~w~lub więcej.")
AddTextEntry("PedAlcoholBad","~b~[Alkomat]\n~w~Poziom alkoholu we krwi: ~r~~a~%\n~w~Niedozwolony poziom alkoholu to ~g~0,008% ~w~lub więcej.")
AddTextEntry("PedDrugs","~b~[Wyniki wymazu]\n~w~Kokaina: ~a~\n~w~Marihuana: ~a~\n~w~Metadon: ~a~")
AddTextEntry("PedItems","~b~[Przeszukanie]\n~a~")
local colorNames = {
    ['0'] = "Metallic Black",
    ['1'] = "Metallic Graphite Black",
    ['2'] = "Metallic Black Steal",
    ['3'] = "Metallic Dark Silver",
    ['4'] = "Metallic Silver",
    ['5'] = "Metallic Blue Silver",
    ['6'] = "Metallic Steel Gray",
    ['7'] = "Metallic Shadow Silver",
    ['8'] = "Metallic Stone Silver",
    ['9'] = "Metallic Midnight Silver",
    ['10'] = "Metallic Gun Metal",
    ['11'] = "Metallic Anthracite Grey",
    ['12'] = "Matte Black",
    ['13'] = "Matte Gray",
    ['14'] = "Matte Light Grey",
    ['15'] = "Util Black",
    ['16'] = "Util Black Poly",
    ['17'] = "Util Dark silver",
    ['18'] = "Util Silver",
    ['19'] = "Util Gun Metal",
    ['20'] = "Util Shadow Silver",
    ['21'] = "Worn Black",
    ['22'] = "Worn Graphite",
    ['23'] = "Worn Silver Grey",
    ['24'] = "Worn Silver",
    ['25'] = "Worn Blue Silver",
    ['26'] = "Worn Shadow Silver",
    ['27'] = "Metallic Red",
    ['28'] = "Metallic Torino Red",
    ['29'] = "Metallic Formula Red",
    ['30'] = "Metallic Blaze Red",
    ['31'] = "Metallic Graceful Red",
    ['32'] = "Metallic Garnet Red",
    ['33'] = "Metallic Desert Red",
    ['34'] = "Metallic Cabernet Red",
    ['35'] = "Metallic Candy Red",
    ['36'] = "Metallic Sunrise Orange",
    ['37'] = "Metallic Classic Gold",
    ['38'] = "Metallic Orange",
    ['39'] = "Matte Red",
    ['40'] = "Matte Dark Red",
    ['41'] = "Matte Orange",
    ['42'] = "Matte Yellow",
    ['43'] = "Util Red",
    ['44'] = "Util Bright Red",
    ['45'] = "Util Garnet Red",
    ['46'] = "Worn Red",
    ['47'] = "Worn Golden Red",
    ['48'] = "Worn Dark Red",
    ['49'] = "Metallic Dark Green",
    ['50'] = "Metallic Racing Green",
    ['51'] = "Metallic Sea Green",
    ['52'] = "Metallic Olive Green",
    ['53'] = "Metallic Green",
    ['54'] = "Metallic Gasoline Blue Green",
    ['55'] = "Matte Lime Green",
    ['56'] = "Util Dark Green",
    ['57'] = "Util Green",
    ['58'] = "Worn Dark Green",
    ['59'] = "Worn Green",
    ['60'] = "Worn Sea Wash",
    ['61'] = "Metallic Midnight Blue",
    ['62'] = "Metallic Dark Blue",
    ['63'] = "Metallic Saxony Blue",
    ['64'] = "Metallic Blue",
    ['65'] = "Metallic Mariner Blue",
    ['66'] = "Metallic Harbor Blue",
    ['67'] = "Metallic Diamond Blue",
    ['68'] = "Metallic Surf Blue",
    ['69'] = "Metallic Nautical Blue",
    ['70'] = "Metallic Bright Blue",
    ['71'] = "Metallic Purple Blue",
    ['72'] = "Metallic Spinnaker Blue",
    ['73'] = "Metallic Ultra Blue",
    ['74'] = "Metallic Bright Blue",
    ['75'] = "Util Dark Blue",
    ['76'] = "Util Midnight Blue",
    ['77'] = "Util Blue",
    ['78'] = "Util Sea Foam Blue",
    ['79'] = "Uil Lightning blue",
    ['80'] = "Util Maui Blue Poly",
    ['81'] = "Util Bright Blue",
    ['82'] = "Matte Dark Blue",
    ['83'] = "Matte Blue",
    ['84'] = "Matte Midnight Blue",
    ['85'] = "Worn Dark blue",
    ['86'] = "Worn Blue",
    ['87'] = "Worn Light blue",
    ['88'] = "Metallic Taxi Yellow",
    ['89'] = "Metallic Race Yellow",
    ['90'] = "Metallic Bronze",
    ['91'] = "Metallic Yellow Bird",
    ['92'] = "Metallic Lime",
    ['93'] = "Metallic Champagne",
    ['94'] = "Metallic Pueblo Beige",
    ['95'] = "Metallic Dark Ivory",
    ['96'] = "Metallic Choco Brown",
    ['97'] = "Metallic Golden Brown",
    ['98'] = "Metallic Light Brown",
    ['99'] = "Metallic Straw Beige",
    ['100'] = "Metallic Moss Brown",
    ['101'] = "Metallic Biston Brown",
    ['102'] = "Metallic Beechwood",
    ['103'] = "Metallic Dark Beechwood",
    ['104'] = "Metallic Choco Orange",
    ['105'] = "Metallic Beach Sand",
    ['106'] = "Metallic Sun Bleeched Sand",
    ['107'] = "Metallic Cream",
    ['108'] = "Util Brown",
    ['109'] = "Util Medium Brown",
    ['110'] = "Util Light Brown",
    ['111'] = "Metallic White",
    ['112'] = "Metallic Frost White",
    ['113'] = "Worn Honey Beige",
    ['114'] = "Worn Brown",
    ['115'] = "Worn Dark Brown",
    ['116'] = "Worn straw beige",
    ['117'] = "Brushed Steel",
    ['118'] = "Brushed Black steel",
    ['119'] = "Brushed Aluminium",
    ['120'] = "Chrome",
    ['121'] = "Worn Off White",
    ['122'] = "Util Off White",
    ['123'] = "Worn Orange",
    ['124'] = "Worn Light Orange",
    ['125'] = "Metallic Securicor Green",
    ['126'] = "Worn Taxi Yellow",
    ['127'] = "police car blue",
    ['128'] = "Matte Green",
    ['129'] = "Matte Brown",
    ['130'] = "Worn Orange",
    ['131'] = "Matte White",
    ['132'] = "Worn White",
    ['133'] = "Worn Olive Army Green",
    ['134'] = "Pure White",
    ['135'] = "Hot Pink",
    ['136'] = "Salmon pink",
    ['137'] = "Metallic Vermillion Pink",
    ['138'] = "Orange",
    ['139'] = "Green",
    ['140'] = "Blue",
    ['141'] = "Mettalic Black Blue",
    ['142'] = "Metallic Black Purple",
    ['143'] = "Metallic Black Red",
    ['144'] = "hunter green",
    ['145'] = "Metallic Purple",
    ['146'] = "Metaillic V Dark Blue",
    ['147'] = "MODSHOP BLACK1",
    ['148'] = "Matte Purple",
    ['149'] = "Matte Dark Purple",
    ['150'] = "Metallic Lava Red",
    ['151'] = "Matte Forest Green",
    ['152'] = "Matte Olive Drab",
    ['153'] = "Matte Desert Brown",
    ['154'] = "Matte Desert Tan",
    ['155'] = "Matte Foilage Green",
    ['156'] = "DEFAULT ALLOY COLOR",
    ['157'] = "Epsilon Blue",
}

local function GetVehicleInDirection( entFrom, coordFrom, coordTo )
	local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    
    if ( IsEntityAVehicle( vehicle ) ) then 
        return vehicle
    end 
end

function client_fpdSystem_drawDialogue(text)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(3000,0)
end
function client_fpdSystem_drawNotification(type,data)
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
    if (type == 5) then
        BeginTextCommandThefeedPost("VehiclePlateData")

        AddTextComponentString(data.type)
        AddTextComponentString(data.color)
        AddTextComponentString(data.nameplate)
        AddTextComponentString(data.lastPed)
        AddTextComponentString("-")
        AddTextComponentString(data.insurance)
        AddTextComponentString(data.registration)
        EndTextCommandThefeedPostTicker(true,true)
    end
    if (type == 6) then
        BeginTextCommandThefeedPost("PedItems")
        AddTextComponentString(data)
        EndTextCommandThefeedPostTicker(true,true)
    end
end

--[[

    Ped Documents

]]
function client_fpdSystem_prepareDocumentsData(document,retPed)
    if (not retPed) then 
        local ped = GetPedInFront()
        local pedType = GetPedType(ped)
        if (pedType == 4 or pedType == 5) then
            local pedID = NetworkGetNetworkIdFromEntity(ped)
            while pedID<1 do
                pedID = NetworkGetNetworkIdFromEntity(ped)
            end
            exports.fpd_3dtext:DrawNotification("Centrala","Centrala","~b~Trwa łączenie z centralą, proszę czekać.",true)
            TriggerServerEvent("fpdSystem:getPedData",pedID,pedType,document)
        end
    elseif (retPed) then 
        local pedType = GetPedType(retPed)
        if (pedType == 4 or pedType == 5) then
            local pedID = NetworkGetNetworkIdFromEntity(retPed)
            while pedID<1 do
                pedID = NetworkGetNetworkIdFromEntity(retPed)
            end
            exports.fpd_3dtext:DrawNotification("Centrala","Centrala","~b~Trwa łączenie z centralą, proszę czekać.",true)
            TriggerServerEvent("fpdSystem:getPedData",pedID,pedType,document)
        end
    end
end

function client_fpdSystem_prepareVehicleLicenseCheck()
    local targetVehicle = nil
    if (IsPedInAnyVehicle(PlayerPedId(),false)) then 
        local veh = GetVehiclePedIsIn(PlayerPedId(),false)
        local coordA = GetEntityCoords(veh,1)
        local coordB = GetOffsetFromEntityInWorldCoords(veh, 0.0,20.0,0.0)
        targetVehicle = GetVehicleInDirection(veh,coordA,coordB)
    else 
        local coordA = GetEntityCoords(GetPlayerPed(-1),1)
        local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1),0.0,20.0,0.0)
        targetVehicle = GetVehicleInDirection(GetPlayerPed(-1),coordA,coordB)
    end

    if (targetVehicle) then 
        local ped = nil
        local vehID = NetworkGetNetworkIdFromEntity(targetVehicle)
        while (vehID <1) do 
            vehID = NetworkGetNetworkIdFromEntity(targetVehicle)
        end
        local color1 = GetVehicleColours(targetVehicle)
        local color = colorNames[tostring(color1)]
        local marka = GetDisplayNameFromVehicleModel(GetEntityModel(targetVehicle))
        local nameplate = GetVehicleNumberPlateText(targetVehicle)

        if (IsVehicleSeatFree(targetVehicle,-1)) then 
            TriggerServerEvent("fpdSystem:getVehiclePlateData",vehID,false,false,{color,marka,nameplate})
        else 
            ped = GetPedInVehicleSeat(targetVehicle,-1)
            local pedType = GetPedType(ped)
            if (pedType == 4 or pedType == 5) then 
                local pedID = NetworkGetNetworkIdFromEntity(ped)
                while pedID <1 do 
                    pedID = NetworkGetNetworkIdFromEntity(ped)
                end
                TriggerServerEvent("fpdSystem:getVehiclePlateData",vehID,pedID,pedType,{color,marka,nameplate})
            end
        end
    end
end

--[[

    Speed Zones

]]
function client_fpdSystem_createSpeedZone(data)
    speedZones[source] = data
    speedZones[source].blip = AddBlipForRadius(data.pos.x,data.pos.y,data.pos.z, data.range+0.1)
    SetBlipHighDetail(speedZones[source].blip,true)
    SetBlipColour(speedZones[source].blip,9)
    SetBlipAlpha(speedZones[source].blip,128)
    speedZones[source].zone = AddSpeedZoneForCoord(data.pos.x,data.pos.y,data.pos.z,data.range+0.1,data.speed+0.1,false)
end

function client_fpdSystem_deleteSpeedZone()
    if (speedZones[source]) then
        DeleteEntity(speedZones[source].blip)
        RemoveBlip(speedZones[source].blip)
        RemoveSpeedZone(speedZones[source].zone)
        speedZones[source] = nil
    end
end

--[[

    Service Calls

]]
local EXISTING_SERVICES = {}

function client_fpdSystem_cancelService(serviceID)
    if (serviceID == 5) then 
        if (EXISTING_SERVICES[serviceID]) then
            if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].healingPed)
                DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                DeleteEntity(EXISTING_SERVICES[serviceID].healingPed)
                RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                    Wait(0)
                    DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                end
                EXISTING_SERVICES[serviceID] = {}
                exports.fpd_3dtext:DrawNotification("Centrala","~b~Hycel","Hycel został odesłany do bazy.",false,"CHAR_CALL911",0,false)
            end
        end
    end
    if (serviceID == 4) then 
        if (EXISTING_SERVICES[serviceID]) then
            if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].healingPed)
                DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                DeleteEntity(EXISTING_SERVICES[serviceID].healingPed)
                RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                    Wait(0)
                    DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                end
                EXISTING_SERVICES[serviceID] = {}
                exports.fpd_3dtext:DrawNotification("Centrala","~b~Koroner","Koroner został odesłany do bazy.",false,"CHAR_CALL911",0,false)
            end
        end

    end
    if (serviceID == 6) then 
        if (EXISTING_SERVICES[serviceID]) then
            if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)

                DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                    Wait(0)
                    DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                end
                EXISTING_SERVICES[serviceID] = {}
                exports.fpd_3dtext:DrawNotification("Centrala","~b~Laweta","Laweta została odesłana do bazy.",false,"CHAR_CALL911",0,false)
            end
        end
    end

    if (serviceID == 2) then 
        if (EXISTING_SERVICES[serviceID]) then
            if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)

                DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                    Wait(0)
                    DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                end
                EXISTING_SERVICES[serviceID] = nil
                exports.fpd_3dtext:DrawNotification("Centrala","~b~Ambulans","Ambulans został odesłany do bazy.",false,"CHAR_CALL911",0,false)
            end
        end
        EXISTING_SERVICES[serviceID] = {}
    end
end
function client_fpdSystem_callService(serviceID)
    local servicesSpawnDistance = 100 + math.random(10,25)
    local player = GetPlayerPed(-1)
    local playerPos = GetEntityCoords(player)
    local npcModel = GetHashKey(SERVICES["PED_MODELS"][serviceID][math.random(1,#SERVICES["PED_MODELS"][serviceID])])
    local vehModel = GetHashKey(SERVICES["VEHICLES"][serviceID][math.random(1,#SERVICES["VEHICLES"][serviceID])])
    local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(player,0.0,5.0,0.0)
    RequestModel(vehModel)
    RequestModel(npcModel)

    while not HasModelLoaded(vehModel) do
        RequestModel(vehModel)
        Citizen.Wait(0)
    end
    while not HasModelLoaded(npcModel) do
        RequestModel(npcModel)
        Citizen.Wait(0)
    end
    if (serviceID == 5) then
        if (EXISTING_SERVICES[serviceID]) then
            if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].healingPed)
                DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                DeleteEntity(EXISTING_SERVICES[serviceID].healingPed)
                RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                    Wait(0)
                    DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                end
                EXISTING_SERVICES[serviceID] = nil
            end
        end
        EXISTING_SERVICES[serviceID] = {}
        if IsPedSittingInAnyVehicle(player) then return end

        EXISTING_SERVICES[serviceID].healingPed = GetPedInFront()
        if (EXISTING_SERVICES[serviceID].healingPed == 0) then 
            fpdSystem_guiCancelService('animal')
            client_fpdSystem_cancelService(5)
            exports.fpd_3dtext:DrawNotification("Centrala","~b~Hycel","Nie znaleziono martwych zwierząt.",true,"CHAR_CALL911",0,false)
            return 
        end
        local isAnimal = false
        for i,v in pairs(ANIMALS_MODELS) do 
            if (GetEntityModel(EXISTING_SERVICES[serviceID].healingPed) == GetHashKey(i)) then
                isAnimal = true 
            end
        end

        if (not isAnimal) then 
            fpdSystem_guiCancelService('animal')
            client_fpdSystem_cancelService(5)
            exports.fpd_3dtext:DrawNotification("Centrala","~b~Hycel","Nie znaleziono martwych zwierząt.",true,"CHAR_CALL911",0,false)
            return 
        end
        if (DoesEntityExist(EXISTING_SERVICES[serviceID].healingPed) and IsPedDeadOrDying(EXISTING_SERVICES[serviceID].healingPed,true)) then 
            TriggerEvent("fpdSystem_client:useRadio")
            Wait(math.random(2000,6000))

            local x,y,z = table.unpack(GetEntityCoords(player, false))
            local heading, vector = GetNthClosestVehicleNode(x,y,z,servicesSpawnDistance,0,0,0)
            local sX, sY, sZ = table.unpack(vector)
            local pedPos = GetEntityCoords(EXISTING_SERVICES[serviceID].healingPed)


            EXISTING_SERVICES[serviceID].vehicle = CreateVehicle(vehModel, sX, sY, sZ, heading, true, true)
            local vehicleHash = GetHashKey(EXISTING_SERVICES[serviceID].vehicle)

            EXISTING_SERVICES[serviceID].ped = CreatePedInsideVehicle(EXISTING_SERVICES[serviceID].vehicle, 26, npcModel, -1, true, false)
            
            TaskVehicleDriveToCoord(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, pedPos.x, pedPos.y, pedPos.z, 17.0, 0,vehicleHash, 1074528293,1.0,true)
            SetVehicleFixed(EXISTING_SERVICES[serviceID].vehicle)
            SetVehicleOnGroundProperly(EXISTING_SERVICES[serviceID].vehicle)
            exports.fpd_3dtext:DrawNotification("Centrala","~b~Hycel","Hycel jest w drodze do Ciebie.",false,"CHAR_CALL911",0,false)
            if (DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) and DoesEntityExist(EXISTING_SERVICES[serviceID].ped)) then
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                EXISTING_SERVICES[serviceID].blip = AddBlipForEntity(EXISTING_SERVICES[serviceID].vehicle)
                
                SetBlipSprite(EXISTING_SERVICES[serviceID].blip, 141)
                SetBlipColour(EXISTING_SERVICES[serviceID].blip, 2)
                EXISTING_SERVICES[serviceID].driving = true
                SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 1, true)
				SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 2, true)
                SetVehicleSiren(EXISTING_SERVICES[serviceID].vehicle, true)
                while(EXISTING_SERVICES[serviceID].driving) do 
                    if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].ped,true)) then 
                        fpdSystem_guiCancelService('animal')
                        client_fpdSystem_cancelService(5)
                        break
                        return 
                    end
                    Citizen.Wait(300)
                    local distanceToVehicle = GetDistanceBetweenCoords(GetEntityCoords(EXISTING_SERVICES[serviceID].vehicle), GetEntityCoords(EXISTING_SERVICES[serviceID].healingPed), 1)
                    if (distanceToVehicle <= 20) then
                        TaskVehicleTempAction(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 27, 6000)

                        
                        if (GetEntitySpeed(EXISTING_SERVICES[serviceID].vehicle) < 8) then
                            TaskLeaveVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,256)
                            TaskGoToEntity(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].healingPed, -1, 3, 4.0, 0, 0)
                        else
                            FreezeEntityPosition(EXISTING_SERVICES[serviceID].vehicle,true)
                            TaskLeaveVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,256)
                            TaskGoToEntity(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].healingPed, -1, 3, 4.0, 0, 0)
                        end

                        Wait(10000)
                            if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].healingPed,true)) then 
                                DeleteEntity(EXISTING_SERVICES[serviceID].healingPed)
                            end
                                TaskEnterVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,-1,-1,2.0,1,0)
                                FreezeEntityPosition(EXISTING_SERVICES[serviceID].vehicle,false)
                                SetDriveTaskDrivingStyle(EXISTING_SERVICES[serviceID].vehicle, 786603)
                                SetVehicleDoorShut(EXISTING_SERVICES[serviceID].vehicle, 2, 0)
                                SetVehicleDoorShut(EXISTING_SERVICES[serviceID].vehicle,3,0)
                                TaskVehicleDriveWander(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 17.0, 786603)
                                
                                Wait(20000)
                                if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                                    SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                                    SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                                    SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].towedVehicle)

                                    DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                                    DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                                    DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                                    RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                                    while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                                        Wait(0)
                                        DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                                    end
                                    EXISTING_SERVICES[serviceID].driving = false
                                    EXISTING_SERVICES[serviceID] = nil
                                    fpdSystem_guiCancelService('animal')
                                    break
                                end
                    end
                end
            else
                fpdSystem_guiCancelService('animal')
                client_fpdSystem_cancelService(5)
                exports.fpd_3dtext:DrawNotification("Centrala","~b~Hycel","Nie znaleziono martwych zwierząt.",true,"CHAR_CALL911",0,false)
            end
        end
    end
    if (serviceID == 4) then 
        if (EXISTING_SERVICES[serviceID]) then
            if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)

                DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                    Wait(0)
                    DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                end
                EXISTING_SERVICES[serviceID] = nil
            end
        end
        EXISTING_SERVICES[serviceID] = {}
        if IsPedSittingInAnyVehicle(player) then return end

        EXISTING_SERVICES[serviceID].healingPed = GetPedInFront()
        if (EXISTING_SERVICES[serviceID].healingPed== 0) then 
            fpdSystem_guiCancelService('coroner')
            client_fpdSystem_cancelService(4)
            exports.fpd_3dtext:DrawNotification("Centrala","~b~Koroner","Nie znaleziono martwych postaci.",true,"CHAR_CALL911",0,false)
            return 
        end
        if (DoesEntityExist(EXISTING_SERVICES[serviceID].healingPed) and IsPedDeadOrDying(EXISTING_SERVICES[serviceID].healingPed,true)) then 
            TriggerEvent("fpdSystem_client:useRadio")
            Wait(math.random(2000,6000))

            local x,y,z = table.unpack(GetEntityCoords(player, false))
            local heading, vector = GetNthClosestVehicleNode(x,y,z,servicesSpawnDistance,0,0,0)
            local sX, sY, sZ = table.unpack(vector)
            local pedPos = GetEntityCoords(EXISTING_SERVICES[serviceID].healingPed)


            EXISTING_SERVICES[serviceID].vehicle = CreateVehicle(vehModel, sX, sY, sZ, heading, true, true)
            local vehicleHash = GetHashKey(EXISTING_SERVICES[serviceID].vehicle)

            EXISTING_SERVICES[serviceID].ped = CreatePedInsideVehicle(EXISTING_SERVICES[serviceID].vehicle, 26, npcModel, -1, true, false)
            
            TaskVehicleDriveToCoord(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, pedPos.x, pedPos.y, pedPos.z, 17.0, 0,vehicleHash, 1074528293,1.0,true)
            SetVehicleFixed(EXISTING_SERVICES[serviceID].vehicle)
            SetVehicleOnGroundProperly(EXISTING_SERVICES[serviceID].vehicle)
            exports.fpd_3dtext:DrawNotification("Centrala","~b~Koroner","Koroner jest w drodze do Ciebie.",false,"CHAR_CALL911",0,false)
            if (DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) and DoesEntityExist(EXISTING_SERVICES[serviceID].ped)) then
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                EXISTING_SERVICES[serviceID].blip = AddBlipForEntity(EXISTING_SERVICES[serviceID].vehicle)
                
                SetBlipSprite(EXISTING_SERVICES[serviceID].blip, 310)
                SetBlipColour(EXISTING_SERVICES[serviceID].blip, 0)
                EXISTING_SERVICES[serviceID].driving = true
                SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 1, true)
				SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 2, true)
                SetVehicleSiren(EXISTING_SERVICES[serviceID].vehicle, true)
                while(EXISTING_SERVICES[serviceID].driving) do
                    if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].ped,true)) then 
                        fpdSystem_guiCancelService('coroner')
                        client_fpdSystem_cancelService(4)
                        break
                        return 
                    end
                    Citizen.Wait(300)
                    local distanceToVehicle = GetDistanceBetweenCoords(GetEntityCoords(EXISTING_SERVICES[serviceID].vehicle), GetEntityCoords(EXISTING_SERVICES[serviceID].healingPed), 1)
                    if (distanceToVehicle <= 20) then
                        TaskVehicleTempAction(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 27, 6000)

                        
                        if (GetEntitySpeed(EXISTING_SERVICES[serviceID].vehicle) < 8) then
                            TaskLeaveVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,256)
                            TaskGoToEntity(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].healingPed, -1, 3, 4.0, 0, 0)
                        else
                            FreezeEntityPosition(EXISTING_SERVICES[serviceID].vehicle,true)
                            TaskLeaveVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,256)
                            TaskGoToEntity(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].healingPed, -1, 3, 4.0, 0, 0)
                        end

                        Wait(10000)
                            if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].healingPed,true)) then 
                                DeleteEntity(EXISTING_SERVICES[serviceID].healingPed)
                            end
                                TaskEnterVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,-1,-1,2.0,1,0)
                                FreezeEntityPosition(EXISTING_SERVICES[serviceID].vehicle,false)
                                SetDriveTaskDrivingStyle(EXISTING_SERVICES[serviceID].vehicle, 786603)
                                SetVehicleDoorShut(EXISTING_SERVICES[serviceID].vehicle, 2, 0)
                                SetVehicleDoorShut(EXISTING_SERVICES[serviceID].vehicle,3,0)
                                TaskVehicleDriveWander(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 17.0, 786603)
                                
                                Wait(20000)
                                if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                                    SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                                    SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                                    SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].towedVehicle)

                                    DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                                    DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                                    DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                                    RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                                    while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                                        Wait(0)
                                        DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                                    end
                                    EXISTING_SERVICES[serviceID].driving = false
                                    EXISTING_SERVICES[serviceID] = nil
                                    fpdSystem_guiCancelService('coroner')
                                    break
                                end
                    end
                end
            else
                fpdSystem_guiCancelService('coroner')
                client_fpdSystem_cancelService(4)
                exports.fpd_3dtext:DrawNotification("Centrala","~b~Koroner","Nie znaleziono martwych postaci.",true,"CHAR_CALL911",0,false)
            end
        end
    end
    if (serviceID == 2) then
        if (EXISTING_SERVICES[serviceID]) then
            if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)

                DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                    Wait(0)
                    DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                end
                EXISTING_SERVICES[serviceID] = nil
            end
        end
        EXISTING_SERVICES[serviceID] = {}
        if IsPedSittingInAnyVehicle(player) then return end

        EXISTING_SERVICES[serviceID].healingPed = GetPedInFront()
        if (EXISTING_SERVICES[serviceID].healingPed== 0) then 
            fpdSystem_guiCancelService('ambulance')
            client_fpdSystem_cancelService(2)
            exports.fpd_3dtext:DrawNotification("Centrala","~b~Ambulans","Nie znaleziono martwych postaci.",true,"CHAR_CALL911",0,false)
            return 
        end
        if (DoesEntityExist(EXISTING_SERVICES[serviceID].healingPed) and IsPedDeadOrDying(EXISTING_SERVICES[serviceID].healingPed,true)) then 
            TriggerEvent("fpdSystem_client:useRadio")
            Wait(math.random(2000,6000))

            local x,y,z = table.unpack(GetEntityCoords(player, false))
            local heading, vector = GetNthClosestVehicleNode(x,y,z,servicesSpawnDistance,0,0,0)
            local sX, sY, sZ = table.unpack(vector)
            local pedPos = GetEntityCoords(EXISTING_SERVICES[serviceID].healingPed)


            EXISTING_SERVICES[serviceID].vehicle = CreateVehicle(vehModel, sX, sY, sZ, heading, true, true)
            local vehicleHash = GetHashKey(EXISTING_SERVICES[serviceID].vehicle)

            EXISTING_SERVICES[serviceID].ped = CreatePedInsideVehicle(EXISTING_SERVICES[serviceID].vehicle, 26, npcModel, -1, true, false)
            
            TaskVehicleDriveToCoord(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, pedPos.x, pedPos.y, pedPos.z, 17.0, 0,vehicleHash, 1074528293,1.0,true)
            SetVehicleFixed(EXISTING_SERVICES[serviceID].vehicle)
            SetVehicleOnGroundProperly(EXISTING_SERVICES[serviceID].vehicle)
            exports.fpd_3dtext:DrawNotification("Centrala","~b~Ambulans","Ambulans jest w drodze do Ciebie.",false,"CHAR_CALL911",0,false)
            if (DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) and DoesEntityExist(EXISTING_SERVICES[serviceID].ped)) then
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                EXISTING_SERVICES[serviceID].blip = AddBlipForEntity(EXISTING_SERVICES[serviceID].vehicle)
                
                SetBlipSprite(EXISTING_SERVICES[serviceID].blip, 153)
                SetBlipColour(EXISTING_SERVICES[serviceID].blip, 1)
                EXISTING_SERVICES[serviceID].driving = true
                SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 1, true)
				SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 2, true)
                SetVehicleSiren(EXISTING_SERVICES[serviceID].vehicle, true)
                while(EXISTING_SERVICES[serviceID].driving) do
                    if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].ped,true)) then 
                        fpdSystem_guiCancelService('ambulance')
                        client_fpdSystem_cancelService(2)
                        break
                        return 
                        
                    end
                    Citizen.Wait(300)
                    local distanceToVehicle = GetDistanceBetweenCoords(GetEntityCoords(EXISTING_SERVICES[serviceID].vehicle), GetEntityCoords(EXISTING_SERVICES[serviceID].healingPed), 1)
                    if (distanceToVehicle <= 20) then
                        TaskVehicleTempAction(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 27, 6000)

                        
                        if (GetEntitySpeed(EXISTING_SERVICES[serviceID].vehicle) < 8) then
                            TaskLeaveVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,256)
                            TaskGoToEntity(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].healingPed, -1, 3, 4.0, 0, 0)
                        else
                            FreezeEntityPosition(EXISTING_SERVICES[serviceID].vehicle,true)
                            TaskLeaveVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,256)
                            TaskGoToEntity(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].healingPed, -1, 3, 4.0, 0, 0)
                        end

                        Wait(10000)
                            if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].healingPed,true)) then 
                                ClearPedTasksImmediately(EXISTING_SERVICES[serviceID].healingPed)
                                SetEntityHealth(EXISTING_SERVICES[serviceID].healingPed,100)
                                ResurrectPed(EXISTING_SERVICES[serviceID].healingPed)
                                ClearPedTasksImmediately(EXISTING_SERVICES[serviceID].healingPed)
                                SetPedIntoVehicle(EXISTING_SERVICES[serviceID].healingPed,EXISTING_SERVICES[serviceID].vehicle,0)
                            end
                            if (IsPedInVehicle(EXISTING_SERVICES[serviceID].healingPed, EXISTING_SERVICES[serviceID].vehicle, false)) then 
                                FreezeEntityPosition(EXISTING_SERVICES[serviceID].vehicle,false)
                                TaskEnterVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,-1,-1,2.0,1,0)
                                SetDriveTaskDrivingStyle(EXISTING_SERVICES[serviceID].vehicle, 786603)
                                SetVehicleDoorShut(EXISTING_SERVICES[serviceID].vehicle, 2, 0)
                                SetVehicleDoorShut(EXISTING_SERVICES[serviceID].vehicle,3,0)
                                TaskVehicleDriveWander(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 17.0, 786603)
                                Wait(10000)
                                if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                                    SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                                    SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                                    SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].healingPed)

                                    DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                                    DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                                    DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                                    DeleteEntity(EXISTING_SERVICES[serviceID].healingPed)
                                    RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                                    while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                                        Wait(0)
                                        DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                                    end
                                    EXISTING_SERVICES[serviceID].driving = false
                                    EXISTING_SERVICES[serviceID] = nil
                                    fpdSystem_guiCancelService('towing')
                                    break
                                end
                            end
                    end
                end
            else
                fpdSystem_guiCancelService('ambulance')
                client_fpdSystem_cancelService(2)
                exports.fpd_3dtext:DrawNotification("Centrala","~b~Ambulans","Nie znaleziono martwych postaci.",true,"CHAR_CALL911",0,false)
            end
        end
    end
    if (serviceID == 6) then
        if (EXISTING_SERVICES[serviceID]) then
            if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].towedVehicle)

                DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                DeleteEntity(EXISTING_SERVICES[serviceID].towedVehicle)
                RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                    Wait(0)
                    DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                end
                EXISTING_SERVICES[serviceID] = nil
            end
        end
        EXISTING_SERVICES[serviceID] = {}
        if IsPedSittingInAnyVehicle(player) then 
            EXISTING_SERVICES[serviceID].towedVehicle = GetVehiclePedIsIn(player, false)
        else
            EXISTING_SERVICES[serviceID].towedVehicle = GetVehicleInDirection(player,playerPos, inFrontOfPlayer)
        end

        if (DoesEntityExist(EXISTING_SERVICES[serviceID].towedVehicle)) then 
            TriggerEvent("fpdSystem_client:useRadio")
            Wait(math.random(2000,6000))

            local x,y,z = table.unpack(GetEntityCoords(player, false))
            local heading, vector = GetNthClosestVehicleNode(x,y,z,servicesSpawnDistance,0,0,0)
            local sX, sY, sZ = table.unpack(vector)
            local vehPos = GetEntityCoords(EXISTING_SERVICES[serviceID].towedVehicle)

            EXISTING_SERVICES[serviceID].vehicle = CreateVehicle(vehModel, sX, sY, sZ, heading, true, true)
            local vehicleHash = GetHashKey(EXISTING_SERVICES[serviceID].vehicle)

            EXISTING_SERVICES[serviceID].ped = CreatePedInsideVehicle(EXISTING_SERVICES[serviceID].vehicle, 26, npcModel, -1, true, false)
            
            TaskVehicleDriveToCoord(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, vehPos.x, vehPos.y, vehPos.z, 17.0, 0,vehicleHash, 786603,1.0,true)
            SetVehicleFixed(EXISTING_SERVICES[serviceID].vehicle)
            SetVehicleOnGroundProperly(EXISTING_SERVICES[serviceID].vehicle)
            exports.fpd_3dtext:DrawNotification("Centrala","~b~Laweta","Laweta jest w drodze do Ciebie.",false,"CHAR_CALL911",0,false)
            if (DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) and DoesEntityExist(EXISTING_SERVICES[serviceID].ped)) then
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                EXISTING_SERVICES[serviceID].blip = AddBlipForEntity(EXISTING_SERVICES[serviceID].vehicle)
                SetBlipColour(EXISTING_SERVICES[serviceID].blip, 29)
                SetBlipFlashes(EXISTING_SERVICES[serviceID].blip, true)
                SetBlipSprite(EXISTING_SERVICES[serviceID].blip, 68)
                EXISTING_SERVICES[serviceID].driving = true
                SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 1, true)
				SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 2, true)
                SetVehicleSiren(EXISTING_SERVICES[serviceID].vehicle, true)
                while(EXISTING_SERVICES[serviceID].driving) do
                    if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].ped,true)) then 
                        fpdSystem_guiCancelService('towing')
                        client_fpdSystem_cancelService(6)
                        break
                        return 
                    end
                    Citizen.Wait(300)
                    local distanceToVehicle = GetDistanceBetweenCoords(GetEntityCoords(EXISTING_SERVICES[serviceID].vehicle), GetEntityCoords(EXISTING_SERVICES[serviceID].towedVehicle), 1)
                    if (distanceToVehicle <= 15) then
                        TaskVehicleTempAction(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 27, 10000)
                        Wait(3000)
                        AttachEntityToEntity(EXISTING_SERVICES[serviceID].towedVehicle, EXISTING_SERVICES[serviceID].vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                        SetDriveTaskDrivingStyle(EXISTING_SERVICES[serviceID].vehicle, 786603)
                        TaskVehicleDriveWander(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 17.0, 786603)
                        RemoveBlip(EXISTING_SERVICES[serviceID].blip)
                        EXISTING_SERVICES[serviceID].blip = nil 
                        Wait(30000)
                        if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].towedVehicle)
            
                            DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                            DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                            DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                            DeleteEntity(EXISTING_SERVICES[serviceID].towedVehicle)
                            RemoveBlip(EXISTING_SERVICES[serviceID].blip)
            
                            while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                                Wait(0)
                                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                            end
                            EXISTING_SERVICES[serviceID].driving = false
                            EXISTING_SERVICES[serviceID] = nil
                            fpdSystem_guiCancelService('towing')
                            break
                        end
                    end
                end
            end
        else 
            fpdSystem_guiCancelService('towing')
            client_fpdSystem_cancelService(6)
            exports.fpd_3dtext:DrawNotification("Centrala","~b~Laweta","Nie znaleziono pojazdu przed Tobą.",true,"CHAR_CALL911",0,false)
        end
    end
end

--[[

    Ped Arrests/Stop traffic

]]
STOPPED_PEDS = {}
STOPPED_VEHS = {}
STOPPED_PEDS_FROM_VEH = {}
ARRESTED_PEDS = {}
isPEDInVehicle = nil
CUFFED_PEDS = {}
FOLLOW_MODE = {state=1,ped=nil,pedID=nil,nearVehicle=false}

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
function isPedCuffed(pedID)
    if (CUFFED_PEDS[pedID] and CUFFED_PEDS[pedID].state==true) then return true else return false end
end

function isPedFromVehicleStop(pedID)
    if (STOPPED_PEDS_FROM_VEH[pedID] and STOPPED_PEDS_FROM_VEH[pedID].ped) then return true else return false end
end
function isVehicleStopped(vehID)
    if (STOPPED_VEHS[vehID] and STOPPED_VEHS[vehID].stopped) then return true else return false end
    return false
end
function isPedStopped(pedID)
    if (STOPPED_PEDS[pedID] and STOPPED_PEDS[pedID].stopped) then return true else return false end
    return false
end
function isPedArrested(pedID)
    if (ARRESTED_PEDS[pedID] and ARRESTED_PEDS[pedID].ped) then return true else return false end
end
Citizen.CreateThread(function()
    while true do 
        if (tablelength(ARRESTED_PEDS)>0) then
            if (IsControlJustPressed(0,303)) then
                client_fpdSystem_createDropoff(client_fpdSystem_getClosestCoordsToJail())
            end
        end
        local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
        if (vehicle and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then 
            local coordA = GetEntityCoords(vehicle,1)
            local coordB = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,20.0,0.0)
            local targetVehicle = GetVehicleInDirection(vehicle,coordA,coordB)
            if (targetVehicle) then 
                local ped = nil
                local vehID = NetworkGetNetworkIdFromEntity(targetVehicle)
                while (vehID <1) do 
                    vehID = NetworkGetNetworkIdFromEntity(targetVehicle)
                end
                
                if (IsVehicleSeatFree(targetVehicle,-1)) then
                else 
                    ped = GetPedInVehicleSeat(targetVehicle,-1)
                    local pedType = GetPedType(ped)
                    if (pedType == 4 or pedType == 5) then 
                        local pedID = NetworkGetNetworkIdFromEntity(ped)
                        while pedID <1 do 
                            pedID = NetworkGetNetworkIdFromEntity(ped)
                        end
                        if (IsControlPressed(0,21) and ped and targetVehicle  and #GUI_PlayerCanOpenVehicleMenu<1) then
                            if (not isVehicleStopped(vehID) and not IsPedDeadOrDying(ped)) then
                                if (IsVehicleSirenOn(vehicle)) then
                                    TimerBarProgress = TimerBarProgress + 0.03
                                    DrawTimerBar(5000, "Zatrzymywanie")
                                    if (TimerBarProgress>5.0) then 
                                        client_fpdSystem_stopVehicle(vehicle,targetVehicle,ped,vehID,pedID)
                                    end
                                else 
                                    fpdSystem_guiDrawHelpText("Włącz sygnały świetlne, aby przejść do zatrzymania.")
                                end
                            end
                        end
                    end
                end
            end
        end
        if (FOLLOW_MODE.state == 0) then

            if (isPedStopped(FOLLOW_MODE.pedID) and isPedCuffed(FOLLOW_MODE.pedID) and FOLLOW_MODE.state == 0) then
                local coordA = GetEntityCoords(GetPlayerPed(-1),1)
                local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0,1.0,0.0)
                local targetVehicle = GetVehicleInDirection(GetPlayerPed(-1),coordA,coordB)
                if (targetVehicle) then
                    local model = GetDisplayNameFromVehicleModel(GetEntityModel(targetVehicle))
                    if (policeCars[model]) then
                        local doorPassengerLeft = GetWorldPositionOfEntityBone(targetVehicle,GetEntityBoneIndexByName(targetVehicle,"door_dside_r"))
                        local doorPassengerRight = GetWorldPositionOfEntityBone(targetVehicle,GetEntityBoneIndexByName(targetVehicle,"door_pside_r"))
                        local distanceLeft = GetDistanceBetweenCoords(doorPassengerLeft,coordA,1)
                        local distanceRight = GetDistanceBetweenCoords(doorPassengerRight,coordA,1)
                        if (distanceLeft <=2.5 or distanceRight <=2.5) and (FOLLOW_MODE.state == 0 and isPedCuffed(FOLLOW_MODE.pedID) and not FOLLOW_MODE.pedInVehicle) then
                            FOLLOW_MODE.nearVehicle = true
                            fpdSystem_guiDrawHelpText("~INPUT_VEH_DUCK~ Posadź zatrzymanego w pojeździe")
                            if (distanceLeft < distanceRight and IsControlJustPressed(0,73)) then
                                if (GetPedInVehicleSeat(targetVehicle,1) ~= 0) then
                                    exports.fpd_3dtext:DrawNotification("Centrala","Centrala","~r~To miejsce w pojeździe jest już zajęte",true)
                                    
                                else
                                    FOLLOW_MODE.pedInVehicle = true
                                    client_fpdSystem_arrestedPed(FOLLOW_MODE.ped,FOLLOW_MODE.pedID,targetVehicle,1)
                                end
                            elseif (distanceRight < distanceLeft and IsControlJustPressed(0,73)) then
                                if (GetPedInVehicleSeat(targetVehicle,2) ~= 0) then
                                    exports.fpd_3dtext:DrawNotification("Centrala","Centrala","~r~To miejsce w pojeździe jest już zajęte",true)
                                    
                                else
                                    FOLLOW_MODE.pedInVehicle = true
                                    client_fpdSystem_arrestedPed(FOLLOW_MODE.ped,FOLLOW_MODE.pedID,targetVehicle,2)
                                end
                            end
                        elseif (distanceLeft >=2.9 or distanceRight >=2.9) and (FOLLOW_MODE.state == 0 and isPedCuffed(FOLLOW_MODE.pedID)) then 
                            FOLLOW_MODE.nearVehicle = false
                        end
                    end
                end
            end
        end

        local ped = GetPedInFront()
        local pedType = GetPedType(ped)
        if (pedType == 4 or pedType == 5) then
            local pedID = NetworkGetNetworkIdFromEntity(ped)
            while pedID<1 do
                pedID = NetworkGetNetworkIdFromEntity(ped)
            end
            if (isPedStopped(pedID)) then 
                if (IsPedDeadOrDying(ped)) then 
                    client_fpdSystem_stopPedCancel(ped,pedID)
                elseif(not IsPedDeadOrDying(ped) and FOLLOW_MODE.state == 1) then
                    DetachEntity(ped,true,false)
                    TaskGoToEntity(ped, GetPlayerPed(-1), -1, 1.0, 10.0, 0,0)
                elseif(not IsPedDeadOrDying(ped) and FOLLOW_MODE.state == 0 and not FOLLOW_MODE.pedInVehicle) then
                    TaskPlayAnim(ped,"mp_arresting","idle",8.0,-8,-1,49,0,0,0,0)
                    AttachEntityToEntity(ped,GetPlayerPed(-1),11816,0,0.3,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
                end
            end
            if (IsControlPressed(0,74) and ped and pedType and not GUI_PlayerCanOpenPedMenu.ped) then
                
                if (not isPedCuffed(pedID) and not isPedStopped(pedID) and not IsPedDeadOrDying(ped) and not isPedFromVehicleStop(pedID) and not GUI_PlayerCanOpenPedMenu.ped) then
                    TimerBarProgress = TimerBarProgress + 0.03
                    DrawTimerBar(5000,"Zatrzymywanie")
                    if (TimerBarProgress>5.0) then
                        client_fpdSystem_stopPed(ped,pedID)
                    end
                end
            elseif (not IsControlJustPressed(0,73) and not IsControlJustPressed(0,74) and not GUI_PlayerCanOpenPedMenu.ped) then
                TimerBarProgress = 0
            end

            if (IsControlPressed(0,73) and ped and pedType and GUI_PlayerCanOpenPedMenu.ped and not IsControlPressed(0,74)) then
                if (not isPedCuffed(pedID) and isPedStopped(pedID)) then
                    TimerBarProgress = TimerBarProgress + 0.03
                    DrawTimerBar(5000,"Zakuwanie")
                    if (TimerBarProgress>5.0) then
                        client_fpdSystem_cuff(ped,pedID)
                    end
                elseif (isPedCuffed(pedID) and isPedStopped(pedID)) then
                    TimerBarProgress = TimerBarProgress + 0.03
                    DrawTimerBar(5000,"Rozkuwanie")
                    if (TimerBarProgress>5.0) then
                        client_fpdSystem_cuff(ped,pedID)
                    end
                end
            elseif (not IsControlPressed(0,73) and not IsControlPressed(0,74)) then
                TimerBarProgress = 0
            end
        end
        Citizen.Wait(1)
    end
    
end)

function client_fpdSystem_endPullovers(vehicle)
    local vehicle = vehicle
    local selectedPed = GetPedInVehicleSeat(vehicle,1)
    local selectedPed2 = GetPedInVehicleSeat(vehicle,2)
    if (selectedPed ~= 0 ) then
        local pedID = NetworkGetNetworkIdFromEntity(selectedPed)
        while pedID<1 do
            pedID = NetworkGetNetworkIdFromEntity(selectedPed)
        end

        if (STOPPED_PEDS[pedID] and STOPPED_PEDS[pedID].stopped) then 
            RemoveBlip(STOPPED_PEDS[pedID].blip)
            DeleteEntity(STOPPED_PEDS[pedID].blip)
            ClearPedTasksImmediately(STOPPED_PEDS[pedID].ped)
            RemovePedFromGroup(STOPPED_PEDS[pedID].ped)
            DeleteEntity(STOPPED_PEDS[pedID].ped)
            if (STOPPED_PEDS_FROM_VEH[pedID] and STOPPED_PEDS_FROM_VEH[pedID].vehicle) then
                local pedVehicle = STOPPED_PEDS_FROM_VEH[pedID].vehicle
                local vehID = STOPPED_PEDS_FROM_VEH[pedID].vehID
                if (pedVehicle) then
                    DeleteEntity(pedVehicle)
                end
                if (isVehicleStopped(vehID)) then
                    RemoveBlip(STOPPED_VEHS[vehID].blip)
                    DeleteEntity(STOPPED_VEHS[vehID].blip)
                    SetEntityAsMissionEntity(STOPPED_VEHS[vehID].ped,false,false)
                    SetEntityAsMissionEntity(STOPPED_VEHS[vehID].vehicle,false,false)
                end
            end
            STOPPED_PEDS[pedID]=nil
            STOPPED_PEDS_FROM_VEH[pedID]=nil
            ARRESTED_PEDS[pedID] = nil
            isPEDInVehicle = nil
            CUFFED_PEDS[pedID] = nil
            if (RageUI.Visible(MENUS['ped'])) then
                RageUI.Visible(MENUS['ped'],false)
            end
            FOLLOW_MODE = {state=1,ped=nil,pedID=nil,nearVehicle=false}
            GUI_PlayerCanOpenVehicleMenu = {}
            GUI_PlayerCanOpenPedMenu = {ped=nil,pedID=nil,vehStop=false}
            GUI_PlayerCanOpenPedMenu.SearchList = {}
           
        end
    end
    if (JAIL_BLIP) then
        RemoveBlip(JAIL_BLIP)
        JAIL_BLIP = nil
        DRAW_MARKER = false
    end
end
function client_fpdSystem_createDropoff(coords)
    local coords = coords
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if (not JAIL_BLIP and tablelength(ARRESTED_PEDS)>0) then
                JAIL_BLIP = AddBlipForCoord(coords[1],coords[2],coords[3])
                SetBlipSprite(JAIL_BLIP,237)
                SetBlipColour(JAIL_BLIP,17)
                SetBlipDisplay(JAIL_BLIP,2)
                SetBlipRoute(JAIL_BLIP,true)
                SetBlipRouteColour(JAIL_BLIP,17)
                DRAW_MARKER = true
            end
            if (DRAW_MARKER and tablelength(ARRESTED_PEDS)>0) then
                DrawMarker(1,coords[1],coords[2],coords[3],0.0,0.0,0.0,0,180.0,0.0,1.5,1.5,1.5,122,199,74,90,false,true,2,nil,nil,false)
                local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                if (vehicle and GetDistanceBetweenCoords(coords[1],coords[2],coords[3],GetEntityCoords(vehicle,false)) < 1.5*1.12 and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
                    fpdSystem_guiDrawHelpText("Wciśnij ~INPUT_REPLAY_SCREENSHOT~, aby odesłać aresztowanego.")
                    if (IsControlJustPressed(0,303) and tablelength(ARRESTED_PEDS)>0) then
                        client_fpdSystem_endPullovers(vehicle)
                    end
                end
            end
        end
    end)
end
function client_fpdSystem_arrestedPed(ped,pedID,targetVehicle,seat)
    ARRESTED_PEDS[pedID] = {ped=ped}
    fpdSystem_guiDrawHelpText("Wciśnij ~INPUT_REPLAY_SCREENSHOT~, aby wyświetlić trasę do najbliższego posterunku.")
    if (STOPPED_PEDS[pedID] and STOPPED_PEDS[pedID].stopped) then 
        RemoveBlip(STOPPED_PEDS[pedID].blip)
        DeleteEntity(STOPPED_PEDS[pedID].blip)
        STOPPED_PEDS[pedID].blip = nil
    end
    Citizen.CreateThread(function()
        DetachEntity(ped,true,false)
        RemovePedFromGroup(ped)
        ClearPedSecondaryTask(ped)
        ClearPedTasks(ped)
        TaskEnterVehicle(ped,targetVehicle,5000,seat,2.0,1,0)
        Wait(5000)
        SetPedConfigFlag(ped,292,true)

    end)
end
function client_fpdSystem_pullover_drug(ped)
    local pedType = GetPedType(ped)
    if (pedType == 4 or pedType == 5) then
        local pedID = NetworkGetNetworkIdFromEntity(ped)
        while pedID<1 do
            pedID = NetworkGetNetworkIdFromEntity(ped)
        end
        exports.fpd_3dtext:DrawNotification("Centrala","Centrala","~b~Oczekiwanie na wynik...",true)
        TriggerServerEvent("fpdSystem:getPedDataDrugs",pedID,pedType)
    end
end
function client_fpdSystem_pullover_alcohol(ped)
    local pedType = GetPedType(ped)
    if (pedType == 4 or pedType == 5) then
        local pedID = NetworkGetNetworkIdFromEntity(ped)
        while pedID<1 do
            pedID = NetworkGetNetworkIdFromEntity(ped)
        end
        exports.fpd_3dtext:DrawNotification("Centrala","Centrala","~b~Oczekiwanie na wynik...",true)
        TriggerServerEvent("fpdSystem:getPedDataAlcohol",pedID,pedType)
    end
end

function client_fpdSystem_question(questionData,ped)
    if (not questionData) then return end 
    local pedType = GetPedType(ped)
    if (pedType == 4 or pedType == 5) then
        local pedID = NetworkGetNetworkIdFromEntity(ped)
        while pedID<1 do
            pedID = NetworkGetNetworkIdFromEntity(ped)
        end
        TriggerServerEvent("fpdSystem:runQuestion",pedID,pedType,questionData['question'],questionData['answers'])
    end
end

function client_fpdSystem_pullover_search(type,ped)
    if (type == 0) then
        local pedType = GetPedType(ped)
        if (pedType == 4 or pedType == 5) then
            local pedID = NetworkGetNetworkIdFromEntity(ped)
            while pedID<1 do
                pedID = NetworkGetNetworkIdFromEntity(ped)
            end
            TriggerServerEvent("fpdSystem:getPedDataItems",pedID,pedType)
        end
    end
end
function client_fpdSystem_pullover_stepOut(Index,vehID)
    if (isVehicleStopped(vehID)) then
        local selectedPed = GetPedInVehicleSeat(STOPPED_VEHS[vehID].vehicle,Index-1)
        if (selectedPed ~= 0) then
            Citizen.CreateThread(function()
                if (isVehicleStopped(vehID)) then
                    TaskLeaveAnyVehicle(selectedPed)
                    SetEntityAsMissionEntity(selectedPed,true,true)
                    local playerGroupId = GetPedGroupIndex(GetPlayerPed(-1))
                    SetPedAsGroupMember(selectedPed,playerGroupId)
                end
            end)
            local pedID = NetworkGetNetworkIdFromEntity(selectedPed)
            while pedID<1 do
                pedID = NetworkGetNetworkIdFromEntity(selectedPed)
            end
            STOPPED_PEDS_FROM_VEH[pedID]={vehID=vehID,ped=selectedPed,vehicle=STOPPED_VEHS[vehID].vehicle}
            isPEDInVehicle = false
            STOPPED_VEHS[vehID].leavedPeds[pedID] = {ped=selectedPed,seatIndex=Index-1}
            client_fpdSystem_stopPed(selectedPed,pedID,true,vehID)
        end
    end
end
function client_fpdSystem_stopPedCancel(ped,pedID)
    if (STOPPED_PEDS[pedID] and STOPPED_PEDS[pedID].stopped) then 
        RemoveBlip(STOPPED_PEDS[pedID].blip)
        DeleteEntity(STOPPED_PEDS[pedID].blip)
        ClearPedTasksImmediately(STOPPED_PEDS[pedID].ped)
        RemovePedFromGroup(STOPPED_PEDS[pedID].ped)
        STOPPED_PEDS[pedID]=nil
        STOPPED_PEDS_FROM_VEH[pedID]=nil
        ARRESTED_PEDS[pedID] = nil
        isPEDInVehicle = nil
        CUFFED_PEDS[pedID] = nil
        if (RageUI.Visible(MENUS['ped'])) then
            RageUI.Visible(MENUS['ped'],false)
        end
        FOLLOW_MODE = {state=1,ped=nil,pedID=nil,nearVehicle=false}
        GUI_PlayerCanOpenVehicleMenu = {}
        GUI_PlayerCanOpenPedMenu = {ped=nil,pedID=nil,vehStop=false}
        GUI_PlayerCanOpenPedMenu.SearchList = {}
    end
end

function client_fpdSystem_cancelPullover(vehID)
    if (isVehicleStopped(vehID)) then
        RemoveBlip(STOPPED_VEHS[vehID].blip)
        DeleteEntity(STOPPED_VEHS[vehID].blip)
        Citizen.CreateThread(function()
            for i,v in pairs(STOPPED_VEHS[vehID].leavedPeds) do
                RemovePedFromGroup(v.ped)
                TaskEnterVehicle(v.ped,STOPPED_VEHS[vehID].vehicle,2000,v.seatIndex,2.0,1,0)
                
            end
        end)
        Wait(500)
        
        TaskVehicleDriveWander(STOPPED_VEHS[vehID].ped,STOPPED_VEHS[vehID].vehicle,55.0,786603)
        SetEntityAsMissionEntity(STOPPED_VEHS[vehID].ped,false,false)
        SetEntityAsMissionEntity(STOPPED_VEHS[vehID].vehicle,false,false)
        STOPPED_VEHS[vehID]={}
        GUI_PlayerCanOpenVehicleMenu = {}
        if (RageUI.Visible(MENUS['pullover'])) then
            RageUI.Visible(MENUS['pullover'],false)
        end
        
    end
end
function client_fpdSystem_stopVehicle(vehicleSource,vehicle,ped,vehID,pedID)
    local vehicleSource, vehicle, ped, vehID, pedID = vehicleSource, vehicle, ped, vehID, pedID
    STOPPED_VEHS[vehID] = {stopped=true,ped=ped,vehicle=vehicle,pedID=pedID,leavedPeds={}}
    STOPPED_VEHS[vehID].blip = AddBlipForEntity(vehicle)
    SetBlipDisplay(STOPPED_VEHS[vehID].blip,2)
    SetBlipSprite(STOPPED_VEHS[vehID].blip,225)
    SetBlipColour(STOPPED_VEHS[vehID].blip,46)
    SetEntityHealth(ped,200)
    SetEntityAsMissionEntity(vehicle,true,true)
    local plrPos = GetEntityCoords(GetPlayerPed(PlayerPedId()))
    SetEntityAsMissionEntity(ped,true,true)
    local chanceFlee = math.random(30)
    local chanceShootOrFlee = math.random(5)
    fpdSystem_guiDrawHelpText("Pojazd został zatrzymany. Podejdź do okna kierowcy aby rozpocząć interakcję.")
    TimerBarProgress = 0
    isPEDInVehicle = true
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if (isVehicleStopped(vehID)) then
                local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
	            local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 1.0, 0.0)
	            local vehNearBy = GetVehicleInDirection(GetPlayerPed(-1),coordA, coordB)
                local trunkpos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "door_dside_f"))
	            local playerpos = GetEntityCoords(GetPlayerPed(-1), 1)
	            local distanceToTrunk = GetDistanceBetweenCoords(trunkpos, playerpos, 1)
                if (distanceToTrunk<= 1.6) then
                    if (isVehicleStopped(vehID) and isPEDInVehicle) then
                        fpdSystem_guiDrawHelpText("~INPUT_PICKUP~ Interakcja z zatrzymanym")
                        local passengers = {}
                        for i=0,4 do
                            local ped = GetPedInVehicleSeat(vehicle)
                            if (DoesEntityExist(ped)) then

                                passengers[i] = ped
                            end
                        end
                        if (isVehicleStopped(vehID)) then
                            GUI_PlayerCanOpenVehicleMenu = {ped=ped,veh=vehicle,passengers=passengers,vehID=vehID}
                        end
                    else
                        GUI_PlayerCanOpenVehicleMenu = {}
                        if (RageUI.Visible(MENUS['pullover'])) then
                            RageUI.Visible(MENUS['pullover'],false)
                        end
                    end
                else 
                    GUI_PlayerCanOpenVehicleMenu = {}
                    if (RageUI.Visible(MENUS['pullover'])) then
                        RageUI.Visible(MENUS['pullover'],false)
                    end
                end
            end
        end
    end)
end

function client_fpdSystem_returnToVehicle(ped,pedID,vehID)
    if (STOPPED_PEDS[pedID] and STOPPED_PEDS[pedID].stopped) then 
        RemoveBlip(STOPPED_PEDS[pedID].blip)
        DeleteEntity(STOPPED_PEDS[pedID].blip)
        ClearPedTasksImmediately(STOPPED_PEDS[pedID].ped)
        STOPPED_PEDS[pedID]=nil
        RemovePedFromGroup(ped)
        local seatID = STOPPED_VEHS[vehID].leavedPeds[pedID].seatIndex
        Citizen.CreateThread(function()
            TaskEnterVehicle(ped,STOPPED_VEHS[vehID].vehicle,2000,seatID,2.0,1,0)
        end)
        ARRESTED_PEDS[pedID] = nil
        isPEDInVehicle = true
        CUFFED_PEDS[pedID] = nil
        if (RageUI.Visible(MENUS['ped'])) then
            RageUI.Visible(MENUS['ped'],false)
        end
        FOLLOW_MODE = {state=1,ped=nil,pedID=nil,nearVehicle=false}
        GUI_PlayerCanOpenPedMenu = {ped=nil,pedID=nil,vehStop=false}
        GUI_PlayerCanOpenPedMenu.SearchList = {}
    end
end
function client_fpdSystem_stopPed(ped,pedID,vehStop,vehID)
    local fromPullover = vehStop
    local vehIDs = vehID
    if (not vehStop) then 
        vehIDs = false
        fromPullover = false
    end
    STOPPED_PEDS[pedID] = {stopped=true,ped=ped}
    STOPPED_PEDS[pedID].blip = AddBlipForEntity(ped)
    SetBlipDisplay(STOPPED_PEDS[pedID].blip,2)
    SetBlipSprite(STOPPED_PEDS[pedID].blip,280)
    SetBlipColour(STOPPED_PEDS[pedID].blip,46)
    local playerGroupId = GetPedGroupIndex(GetPlayerPed(-1))
    SetPedAsGroupMember(ped,playerGroupId)
    
    GUI_PlayerCanOpenPedMenu = {ped=ped,pedID=pedID,vehStop=fromPullover,distance=true,vehID=vehIDs}
    Citizen.CreateThread(function()
        while true do
            if (GUI_PlayerCanOpenPedMenu.pedID and GUI_PlayerCanOpenPedMenu.pedID>0) then
                local plrPos = GetEntityCoords(GetPlayerPed(-1),1)
                local pedPos = GetEntityCoords(STOPPED_PEDS[pedID].ped,1)
                local distance = GetDistanceBetweenCoords(plrPos,pedPos)
                SetBlockingOfNonTemporaryEvents(STOPPED_PEDS[pedID].ped,true)
                if (distance<=2.5 and (not FOLLOW_MODE or not FOLLOW_MODE.nearVehicle) and not isPedArrested(GUI_PlayerCanOpenPedMenu.pedID)) then
                    
                    fpdSystem_guiDrawHelpText("~INPUT_PICKUP~ Interakcja z zatrzymanym\n~INPUT_VEH_DUCK~ Zakuj/Rozkuj zatrzymanego")
                    GUI_PlayerCanOpenPedMenu.distance = true

                else
                    GUI_PlayerCanOpenPedMenu.distance = false
                    if (RageUI.Visible(MENUS['ped'])) then
                        RageUI.Visible(MENUS['ped'],false)
                    end
                end
            end
            Wait(1)
        end
    end)
    
end

function client_fpdSystem_followMode(pedID,ped,state)
    if (isPedStopped(pedID) and isPedCuffed(pedID) and state == 1) then
        FOLLOW_MODE = {state=0,ped=ped,pedID=pedID}

    elseif (isPedStopped(pedID) and not isPedCuffed(pedID) and state == 1) then

    end
    
    if (isPedStopped(pedID) and state == 0) then
        DetachEntity(ped,true,false)
        FOLLOW_MODE = {state=1,ped=ped,pedID=pedID}
        
        
    end
end

function client_fpdSystem_cuff(ped,pedID)
    local player = GetPlayerPed(-1)
    RequestAnimDict("mp_arresting")
    loadAnimDict("random@arrests")
    loadAnimDict("random@arrests@busted")
    if (isPedStopped(pedID) and not isPedCuffed(pedID)) then
        
        Citizen.CreateThread(function()
            if (not isPedCuffed(pedID)) then
                menuVariables['peds']['canCuffs'] = false
                local playerPos = GetEntityCoords(player)
                local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(player,0.0,5.0,0.0)
                TaskPlayAnim(player,"mp_arresting","a_uncuff",8.0,-8,-1,49,0,0,0,0)
                TaskPlayAnim(ped,"mp_arresting","idle",8.0,-8,-1,49,0,0,0,0)
                AttachEntityToEntity(ped,player,11816,0,0.3,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
                Citizen.Wait(2000)
                DetachEntity(ped,true,false)
                ClearPedSecondaryTask(player)
                TaskPlayAnim(ped,"random@arrests@busted","exit",8.0,1.0,-1,2,0,0,0,0)
                Citizen.Wait(1000)
                SetEnableHandcuffs(ped,true)
                TaskPlayAnim(ped,"mp_arresting","idle",8.0,-8,-1,49,0,0,0,0)
                Citizen.Wait(900)
                CUFFED_PEDS[pedID]={ped=ped,state=true}
                menuVariables['peds']['cuff'] = "~y~Rozkuj"
                menuVariables['peds']['canCuffs'] = true
            end
        end)
        return
    elseif (isPedStopped(pedID) and isPedCuffed(pedID)) then
        
        Citizen.CreateThread(function()
            menuVariables['peds']['canCuffs'] = false
            local playerPos = GetEntityCoords(player)
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(player,0.0,5.0,0.0)
            TaskPlayAnim(player,"mp_arresting","a_uncuff",8.0,-8,-1,49,0,0,0,0)
            AttachEntityToEntity(ped,player,11816,0,0.3,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
            Citizen.Wait(2000)
            DetachEntity(ped,true,false)
            ClearPedSecondaryTask(player)
            ClearPedSecondaryTask(ped)
            ClearPedTasks(ped)
            StopAnimTask(ped, 'mp_arresting', 'idle', 1.0)
            SetEnableHandcuffs(ped,false)
            SetPedCanRagdoll(ped,true)
            Citizen.Wait(900)
            CUFFED_PEDS[pedID]=nil
            menuVariables['peds']['cuff'] = "~y~Zakuj"
            menuVariables['peds']['canCuffs'] = true
        end)
        
        return
    end
end
--[[

    Common functions
]]

function client_fpdSystem_getClosestCoordsToJail()
    local _ClosestCoord = nil
    local _ClosestDistance = 9999999
    local _playerPed = PlayerPedId()
    local _Coord = GetEntityCoords(_playerPed)

    for _,v in pairs(JAILS) do
        loc = split(v,",")
        for ii,vv in ipairs(loc) do		loc[ii]=tonumber(vv)	end
        local _Distance = #(vector3(loc[1],loc[2],loc[3]) - _Coord)
        if (_Distance <= _ClosestDistance) then
            _ClosestDistance = _Distance
            _ClosestCoord = loc
        end
    end
    return _ClosestCoord
end
function client_fpdSystem_useRadio()
    loadAnimDict("random@arrests")
    Citizen.CreateThread(function()
        TaskPlayAnim(GetPlayerPed(-1), "random@arrests", "generic_radio_enter", 1.5, 2.0, -1, 50, 2.0, 0, 0, 0 )
        Citizen.Wait(6000)
        ClearPedTasks(GetPlayerPed(-1))
    end)
end

function split(str, pat)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t,cap)
        end
        last_end = e+1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

function client_fpdSystem_loadJails()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if (tablelength(ARRESTED_PEDS)>0) then 
                for i=1, #JAILS do
                    loc = split(JAILS[i],",")
                    for ii,vv in ipairs(loc) do		loc[ii]=tonumber(vv)	end
                    DrawMarker(2,loc[1],loc[2],loc[3],0.0,0.0,0.0,0,180.0,0.0,0.5,0.5,0.5,122,199,74,90,true,true,2,nil,nil,false)
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                    if vehicle and GetDistanceBetweenCoords(loc[1],loc[2],loc[3],GetEntityCoords(vehicle,false)) < 0.5*1.12 and tablelength(ARRESTED_PEDS)>0 and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId() then
                        if IsControlJustReleased(0,38) then
                            print('oddanie peda')
                        end
                    end
                end
            end
        end
    end)
end

function client_fpdSystem_loadConfig()
    local questionsFile = LoadResourceFile(GetCurrentResourceName(), "config/questions.json")
    
    QUESTIONS = json.decode(questionsFile)
    QUESTIONS = QUESTIONS[1]['questions']
    local jailsFile = LoadResourceFile(GetCurrentResourceName(), "config/jails.json")
    JAILS = json.decode(jailsFile)
    JAILS = JAILS[1]['jails']
end
--[[

    Utils

]]
client_fpdSystem_loadConfig()
function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end

function GetPedInFront()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

RegisterNetEvent("fpdSystem_client:createSpeedZone")
RegisterNetEvent("fpdSystem_client:deleteSpeedZone")
RegisterNetEvent("fpdSystem_client:drawNotification")
RegisterNetEvent("fpdSystem_client:useRadio")
RegisterNetEvent("fpdSystem_client:drawDialogue")
AddEventHandler("fpdSystem_client:drawDialogue",client_fpdSystem_drawDialogue)
AddEventHandler("fpdSystem_client:useRadio", client_fpdSystem_useRadio)
AddEventHandler("fpdSystem_client:drawNotification",client_fpdSystem_drawNotification)
AddEventHandler("fpdSystem_client:deleteSpeedZone",client_fpdSystem_deleteSpeedZone)
AddEventHandler("fpdSystem_client:createSpeedZone",client_fpdSystem_createSpeedZone)
