local MISSION_IDS = {[17]=true}
local calloutData = {blip=nil,started=false,ped=nil,ped2=nil,dropoff=false,dropoffCoords=nil}
local bonus = false
local currentID = nil

function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end

function transport_timer()
    bonus = true
    Wait(180000)
    bonus = false
end

function enterVehicleTask()
    Citizen.CreateThread(function()
        local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)
        if (playerVehicle) then
            TaskEnterVehicle(calloutData.ped, playerVehicle,6000,0,2.0,1,0)
            Wait(6000)
            SetPedConfigFlag(calloutData.ped,292,true)
        end
    end)
end
function callout_dropoff()
    enterVehicleTask()
    DeleteEntity(calloutData.blip)
    RemoveBlip(calloutData.blip)
    local dropoff = getClosestCoords(HOSPITAL_POINTS)
    local blip = AddBlipForCoord(dropoff[1],dropoff[2],dropoff[3])
    SetBlipSprite(blip,655)
    SetBlipDisplay(blip,4)
    SetBlipColour(blip,3)
    SetBlipScale(blip, 1.0)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip,3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cel wezwania")
    EndTextCommandSetBlipName(blip)
    calloutData.blip = blip
    calloutData.dropoff = true
    exports.em_gui:showNotification("Informacja","Jeśli opuścisz pojazd, wezwanie zostanie anulowane. Jeśli uda Ci się ukończyć wezwanie w czasie krótszym niż 3 minuty, otrzymasz dodatkowe punkty XP.",9000)
    transport_timer()
    Citizen.CreateThread(function()
        while true do
            if (calloutData.dropoff) then
                DrawMarker(1,dropoff[1],dropoff[2],dropoff[3],0.0,0.0,0.0,0,180.0,0.0,1.5,1.5,1.5,122,199,74,90,false,true,2,nil,nil,false)
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if (vehicle) then
                    calloutData.dropoff = false
                    if (vehicle and GetDistanceBetweenCoords(dropoff[1],dropoff[2],dropoff[3], GetEntityCoords(vehicle,false)) < 1.5 and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
                        DeleteEntity(calloutData.blip)
                        DeleteEntity(calloutData.ped)
                        RemoveBlip(calloutData.blip)
                        TriggerServerEvent("callouts_end",currentID,true)
                        calloutData = {blip=nil,started=false,ped=nil,ped2=nil,dropoff=false,dropoffCoords=nil}
                        bonus = false
                        currentID = nil

                    end
                end
            end
            Citizen.Wait(0)
        end
    end)
end
function callout_cancelCallout(ID)
    if (calloutData and calloutData.started) then
        DeleteEntity(calloutData.ped)
        DeleteEntity(calloutData.ped2)
        DeleteEntity(calloutData.blip)
        calloutData = {blip=nil,started=false,ped=nil,ped2=nil,dropoff=false,dropoffCoords=nil}
        bonus = false
        currentID = nil
    end
end

function callout_startupMission(ID, data, location)
    if (not MISSION_IDS[ID]) then return end
    local blip = AddBlipForCoord(location.x, location.y, location.z)
    SetBlipSprite(blip,data.sprite)
    SetBlipDisplay(blip,4)
    SetBlipColour(blip,data.colour)
    SetBlipScale(blip, 1.0)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, data.colour)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wezwanie:"..data.title)
    EndTextCommandSetBlipName(blip)
    local pedModel = GetHashKey(PEDS[math.random(1,#PEDS)])
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Citizen.Wait(0)
    end
    local ped = CreatePed(26, pedModel, location.x, location.y, location.z, location.heading, true,true)
    SetBlockingOfNonTemporaryEvents(ped,true)
    SetEntityAsMissionEntity(ped,true,true)
    calloutData.ped = ped
    calloutData.blip = blip
    calloutData.started = true
    Citizen.CreateThread(function()
        while true do
            if (calloutData.started) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if (vehicle and GetDistanceBetweenCoords(location.x, location.y, location.z, GetEntityCoords(vehicle,false)) < 20 and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
                    DrawHelp("Wciśnij ~INPUT_PICKUP~ aby odebrać chorych.")
                    if (IsControlJustPressed(0,38)) then
                        callout_dropoff()
                    end
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