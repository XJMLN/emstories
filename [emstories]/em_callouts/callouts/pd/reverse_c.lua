local calloutData = {ped=nil, veh=nil,blip=nil, stopped=false,started=false}
local MISSION_ID = 1
function GetVehHealthPercent(vehicle)
	local vehiclehealth = GetEntityHealth(vehicle) - 100
	local maxhealth = GetEntityMaxHealth(vehicle) - 100
	local procentage = (vehiclehealth / maxhealth) * 100
	return procentage
end
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

Citizen.CreateThread(function()
    while true do
        if (calloutData.started) then
            if (not DoesEntityExist(calloutData.ped) or not DoesEntityExist(calloutData.veh)) then
                DeleteEntity(calloutData.ped)
                DeleteEntity(calloutData.veh)
                DeleteEntity(calloutData.blip)
                calloutData = {ped=nil, veh=nil,blip=nil, stopped=false,started=false}
                TriggerServerEvent("callouts_end",MISSION_ID,true)
            end
        end
        Citizen.Wait(0)
    end
end)
function callout_startupMission(id,data,coords)
    if (id ~= MISSION_ID) then return end
    local coords = coords
    local vehicleModel = GetHashKey(VEHICLES[math.random(1,#VEHICLES)])
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
    AddTextComponentString("Wezwanie: Pojazd na wstecznym")
    EndTextCommandSetBlipName(blip)
    calloutData.ped = ped
    calloutData.veh = veh
    calloutData.blip = blip
    SetDriverAbility(ped,1.0)
    SetDriverAggressiveness(ped,1.0)
    TaskVehicleDriveWander(ped,veh, 100.0, 1596)
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
    Citizen.CreateThread(function()
        while true do
            if (calloutData.ped and calloutData.veh) then
                local hpEngine = GetVehHealthPercent(calloutData.veh)
                if (hpEngine<=25) then
                    if (not calloutData.stopped) then
                        --DrawHelp("Uciekająca osoba zatrzymała się. Możesz przystąpić do zatrzymania.")
                        TaskVehicleTempAction(calloutData.ped,calloutData.veh,6,9999)
                        calloutData.stopped = true
                        exports.em_pd_pullovers:ai_startVehiclePullover(GetVehiclePedIsIn(GetPlayerPed(-1),false),{el=calloutData.veh, id=calloutData.vehID}, {el=calloutData.ped, id=calloutData.pedID, type=calloutData.pedType})
                    end
                end
            end
            Citizen.Wait(0)
        end
    end)
end
RegisterNetEvent("em_callouts:startupMission")
AddEventHandler("em_callouts:startupMission",callout_startupMission)