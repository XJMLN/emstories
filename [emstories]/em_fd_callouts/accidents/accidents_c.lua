local missionElements = {}
local accidentID = false
local accidentData = nil
local player = nil
local missionCoords = false

DecorRegister("__MISSION_SAW_",3)
function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end
function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end
Citizen.CreateThread(function() -- mission tasks thread
    while true do
        if (accidentID and accidentID == 9) then
            local plrCoords = GetEntityCoords(GetPlayerPed(-1))
            if (missionCoords and #(plrCoords - missionCoords) <= 100 and missionElements[player].completedSteps == 0) then
                accidentSystem_createAccident()
                missionElements[player].completedSteps = 1
            end
            if (not DoesEntityExist(missionElements[player].ped) and DoesEntityExist(missionElements[player].veh)) then
                missionElements[player].completedSteps = 4
                exports.em_3dtext:DrawDialogueText("Wezwij lawetę",5000)
            end
            if (missionElements[player].completedSteps>1 and not DoesEntityExist(missionElements[player].ped) and not DoesEntityExist(missionElements[player].veh)) then
                missionElements[player].completedSteps = 5
                accidentSystem_end(accidentID)
                accidentID = false
            end
            
            if (missionCoords and #(plrCoords - missionCoords) <=30 and #(plrCoords - missionCoords)>3) then
                exports.em_3dtext:DrawDialogueText("Wykonaj oględziny miejsca zdarzenia.",5000)
                missionElements[player].completedSteps = 1
            end
            if (missionCoords and #(plrCoords - missionCoords) <=3 and IsVehicleDoorDamaged(missionElements[player].veh,0)~=1) then
                exports.em_3dtext:DrawDialogueText("Drzwi pojazdu są zablokowane, wyjmij piłę i je wytnij.",5000)
                missionElements[player].completedSteps = 2
            end
            if (missionCoords and #(plrCoords - missionCoords) <=3 and IsVehicleDoorDamaged(missionElements[player].veh,0)==1 and DoesEntityExist(missionElements[player].ped)) then
                exports.em_3dtext:DrawDialogueText("Wezwij ambulans do poszkodowanego",5000)
                missionElements[player].completedSteps = 3
            end

        end
        Citizen.Wait(1)
    end

end)
function accidentSystem_end(ID)
    print('halo?')
    ClearGpsMultiRoute()
    DeleteEntity(missionElements[player].ped)
    missionElements[player].ped = nil
    DeleteEntity(missionElements[player].veh)
    missionElements[player].veh = nil
    RemoveBlip(missionElements[player].blip)
    DeleteEntity(missionElements[player].blip)
    missionElements[player].blip = nil
    TriggerServerEvent("accidentSystem_endCallout",missionElements[player].completedSteps,ID)
    missionElements[player] = {}
    player = nil
    accidentID = nil
    missionCoords = nil
    accidentData = nil

end
function accidentSystem_createAccident()
    local coords = accidentData.location
    local vD = accidentData.vehicleData
    local vehicleModel = GetHashKey(ACCIDENTS_VEHICLES[math.random(1,#ACCIDENTS_VEHICLES)])
    local npcModel = GetHashKey(ACCIDENTS_PEDS[math.random(1,#ACCIDENTS_PEDS)])
    RequestModel(npcModel)
    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        RequestModel(vehicleModel)
        Citizen.Wait(0)
    end
    while not HasModelLoaded(npcModel) do
        RequestModel(npcModel)
        Citizen.Wait(0)
    end
    loadAnimDict("mp_sleep")
    local veh = CreateVehicle(vehicleModel, vD.location.x, vD.location.y, vD.location.z, vD.heading, true, true)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    local ped = CreatePedInsideVehicle(veh, 26, npcModel, -1, true, false)
    
    missionElements[player].veh = veh
    missionElements[player].ped = ped
    SetVehicleOnGroundProperly(veh)
    SetEntityAsMissionEntity(ped)
   
    SetEntityAsMissionEntity(veh)
    SetVehicleDoorsLocked(veh, 4)
    local id = NetworkGetNetworkIdFromEntity(veh)
	SetNetworkIdCanMigrate(id, true)
    SetVehicleEngineHealth(veh, 300.0)
    if (vD.frontDamage) then
        for i=1,9 do 
            SetVehicleDamage(veh, 0.0, 1.0, 0.1, 200.0, 200.0, true)
            Citizen.Wait(100)
        end
    end
    SetEntityHealth(ped,0)
    SetPedDiesInVehicle(ped,true)
    
    --TaskPlayAnim(ped, "mp_sleep", "sleep_loop", 2.0, 2.0, -1, 51, 0, false, false, false)
    TaskSetBlockingOfNonTemporaryEvents(ped,true)
    DecorSetInt(veh,"__MISSION_SAW_",1)
end
function accidentSystem_create(data)
    accidentID = data.systemData.id
    player = source
    accidentData = data
    missionElements[player] = {}
    missionElements[player].completedSteps = 0 
    local coords = data.location
    missionCoords = coords
    local vD = data.vehicleData
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip,380)
    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    SetBlipScale(blip, 1.0)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wypadek")
    EndTextCommandSetBlipName(blip)
    missionElements[player].blip = blip

    ClearGpsMultiRoute()
    StartGpsMultiRoute(6, true, true)
    AddPointToGpsMultiRoute(coords.x,coords.y,coords.z)
    SetGpsMultiRouteRender(true)

   
end

RegisterNetEvent("accidentSystem_create")
AddEventHandler("accidentSystem_create",accidentSystem_create)