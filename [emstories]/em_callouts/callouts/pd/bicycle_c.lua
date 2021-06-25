local calloutData = {ped=nil, veh=nil,blip=nil, stopped=false,started=false}
local MISSION_ID = 3
local vehicleModels = {"bmx","cruiser","fixter","scorcher","tribike","tribike2","tribike3"}

function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end

function callout_cancelCallout(ID)
    if (calloutData and calloutData.started) then
        DeleteEntity(calloutData.ped)
        DeleteEntity(calloutData.veh)
        DeleteEntity(calloutData.blip)
        calloutData = {ped=nil, veh=nil,blip=nil, stopped=false,started=false}
        bonus = false
        currentID = nil
    end
end

Citizen.CreateThread(function()
    while true do
        if (calloutData.started) then
            if (IsPedDeadOrDying(calloutData.ped)) then
                callout_cancelCallout(MISSION_ID)
                DrawHelp("~r~Rowerzysta został zabity.")
            end
        end
        Citizen.Wait(1000)
    end
end)
function callout_startupMission(id,data,coords)
    if (id ~= MISSION_ID) then return end
    local coords = coords
    local vehicleModel = GetHashKey(vehicleModels[math.random(1,#vehicleModels)])
    local npcModel = GetHashKey(PEDS[math.random(1,#PEDS)])
    RequestModel(npcModel)
    RequestModel(vehicleModel)
    while not HasModelLoaded(vehicleModel) do
        RequestModel(vehicleModel)
        Wait(0)
    end
    while not HasModelLoaded(npcModel) do
        RequestModel(npcModel)
        Wait(0)
    end
    local veh = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z, coords.heading, true, true)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    local ped = CreatePedInsideVehicle(veh, 26, npcModel,-1,true,false)
    SetEntityAsMissionEntity(veh,true, true)
    SetEntityAsMissionEntity(ped,true,true)
    local blip = AddBlipForEntity(veh)
    SetBlipSprite(blip,665)
    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    SetBlipScale(blip, 1.0)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wezwanie: Rowerzysta na autostradzie")
    EndTextCommandSetBlipName(blip)
    calloutData.ped = ped
    calloutData.veh = veh
    calloutData.coords = coords
    calloutData.blip = blip
    SetDriverAbility(ped,1.0)
    SetDriverAggressiveness(ped,1.0)
    TaskVehicleDriveWander(ped,veh, 100.0, 60)
    calloutData.pedType = GetPedType(ped)
    calloutData.pedID = NetworkGetNetworkIdFromEntity(calloutData.ped)
    calloutData.started = true
    while calloutData.pedID <1 do
        calloutData.pedID  = NetworkGetNetworkIdFromEntity(calloutData.ped)
    end
    calloutData.vehID = NetworkGetNetworkIdFromEntity(calloutData.veh)
    while calloutData.vehID <1 do
        calloutData.vehID  = NetworkGetNetworkIdFromEntity(calloutData.veh)
    end
    SetBlockingOfNonTemporaryEvents(calloutData.ped,true)
    DrawHelp("Podążaj za rowerzystą. ~r~Nie zabijaj go~w~.")
    Citizen.CreateThread(function()
        while true do
            if (calloutData.ped and calloutData.veh and not calloutData.stopped) then
                local bikePos = GetEntityCoords(calloutData.veh)
                if (GetDistanceBetweenCoords(bikePos.x, bikePos.y, bikePos.z,calloutData.coords.x,calloutData.coords.y,calloutData.coords.z,false)>=900) then
                    TaskVehicleTempAction(calloutData.ped,calloutData.veh,6,9999)
                    calloutData.stopped = true
                    exports.em_pd_pullovers:ai_startVehiclePullover(GetVehiclePedIsIn(GetPlayerPed(-1),false),{el=calloutData.veh, id=calloutData.vehID}, {el=calloutData.ped, id=calloutData.pedID, type=calloutData.pedType})
                end
            end
            Citizen.Wait(0)
        end
    end)
end
RegisterNetEvent("em_callouts:startupMission")
AddEventHandler("em_callouts:startupMission",callout_startupMission)

RegisterNetEvent("em_callouts:cancelMission")
AddEventHandler("em_callouts:cancelMission",callout_cancelCallout)