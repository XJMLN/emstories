local MISSION_IDS ={[12]=true}
local calloutData = {blip=nil,ped=nil,vehicle=nil,started=false,step=0,coords=nil}
local currentID = nil
DecorRegister("__MISSION_SAW_",3)
function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end

Citizen.CreateThread(function() -- mission tasks thread
    while true do
        if (calloutData and calloutData.started) then
            local plrCoords = GetEntityCoords(GetPlayerPed(-1))
            if (calloutData.coords and #(plrCoords - calloutData.coords) <= 100 and calloutData.step == 0) then
                calloutData.step = 1
            end
            if (not DoesEntityExist(calloutData.ped) and DoesEntityExist(calloutData.vehicle)) then
                calloutData.step = 4
                exports.em_3dtext:DrawDialogueText("Wezwij lawetę",5000)
            end
            if (calloutData.step>1 and not DoesEntityExist(calloutData.ped) and not DoesEntityExist(calloutData.vehicle)) then
                calloutData.step = 5
                TriggerServerEvent("callouts_end",currentID,true)
                currentID = nil
                DeleteEntity(calloutData.blip)
                RemoveBlip(calloutData.blip)
                calloutData = {blip=nil,ped=nil,vehicle=nil,started=false,step=0,coords=nil}
            end
            if (calloutData.coords and #(plrCoords - calloutData.coords) <=30 and #(plrCoords - calloutData.coords)>3) then
                exports.em_3dtext:DrawDialogueText("Wykonaj oględziny miejsca zdarzenia.",5000)
                calloutData.step = 1
            end
            if (calloutData.coords and #(plrCoords - calloutData.coords) <=3 and IsVehicleDoorDamaged(calloutData.vehicle,0)~=1) then
                exports.em_3dtext:DrawDialogueText("Drzwi pojazdu są zablokowane, wyjmij piłę i je wytnij.",5000)
                calloutData.step = 2
            end
            if (calloutData.coords and #(plrCoords - calloutData.coords) <=3 and IsVehicleDoorDamaged(calloutData.vehicle,0)==1 and DoesEntityExist(calloutData.ped)) then
                exports.em_3dtext:DrawDialogueText("Wezwij ambulans do poszkodowanego",5000)
                calloutData.step = 3
            end

        end
        Citizen.Wait(1)
    end

end)

function callout_startupMission(ID, data, coords)
    if (not MISSION_IDS[ID]) then return end
    local vehicleModel = GetHashKey(VEHICLES[math.random(1,#VEHICLES)])
    local pedModel = GetHashKey(PEDS[math.random(1,#PEDS)])
    calloutData.coords = vector3(coords.x,coords.y,coords.z)
    RequestModel(pedModel)
    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        RequestModel(vehicleModel)
        Citizen.Wait(0)
    end
    while not HasModelLoaded(pedModel) do
        RequestModel(pedModel)
        Citizen.Wait(0)
    end
    local veh = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z,coords.heading,true,true)
    SetVehicleHasBeenOwnedByPlayer(veh,true)
    SetVehicleOnGroundProperly(veh)
    SetEntityAsMissionEntity(veh,true,true)
    SetVehicleDoorsLocked(veh, 4)
    local ped = CreatePedInsideVehicle(veh, 26, pedModel, -1, true, false)
    calloutData.ped = ped
    calloutData.vehicle = veh
    SetEntityAsMissionEntity(ped,true,true)
    local id = NetworkGetNetworkIdFromEntity(veh)
	SetNetworkIdCanMigrate(id, true)
    SetVehicleEngineHealth(veh, 300.0)
    for i=1,9 do 
        SetVehicleDamage(veh, 0.0, 1.0, 0.1, 200.0, 200.0, true)
        Citizen.Wait(100)
    end
    SetEntityHealth(ped,0)
    SetPedDiesInVehicle(ped,true)
    TaskSetBlockingOfNonTemporaryEvents(ped,true)
    DecorSetInt(veh,"__MISSION_SAW_",1)
    local blip = AddBlipForCoord(coords.x,coords.y,coords.z)
    SetBlipSprite(blip,data.sprite)
    SetBlipDisplay(blip,4)
    SetBlipColour(blip,data.colour)
    SetBlipScale(blip, 1.0)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, data.colour)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wezwanie: Wypadek")
    EndTextCommandSetBlipName(blip)
    calloutData.blip = blip
    
    calloutData.started = true
end

RegisterNetEvent("em_callouts:startupMission")
AddEventHandler("em_callouts:startupMission",callout_startupMission)