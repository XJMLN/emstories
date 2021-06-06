local MISSION_IDS = {[15]=true}
local calloutData = {blip=nil,started=false,dropoff=false,dropoffCoords=nil}
local bonus = false
local currentID = nil
local TRANSPORT_POINTS = {
    {x=-3020.51,y=85.73,z=11.61}
}

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

function callout_dropoff()
    DeleteEntity(calloutData.blip)
    RemoveBlip(calloutData.blip)

    local dropoff = TRANSPORT_POINTS[math.random(1,#TRANSPORT_POINTS)]
    local blip = AddBlipForCoord(dropoff.x,dropoff.y,dropoff.z)
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
                DrawMarker(1,dropoff.x,dropoff.y,dropoff.z,0.0,0.0,0.0,0,180.0,0.0,1.5,1.5,1.5,122,199,74,90,false,true,2,nil,nil,false)
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if (not vehicle) then
                    calloutData.dropoff = false
                    if (vehicle and GetDistanceBetweenCoords(dropoff.x,dropoff.y,dropoff.z, GetEntityCoords(vehicle,false)) < 1.5 and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
                        DeleteEntity(calloutData.blip)
                        RemoveBlip(calloutData.blip)
                        TriggerServerEvent("callouts_end",currentID,true)
                        calloutData = {blip=nil,started=false,dropoff=false,dropoffCoords=nil}
                        bonus = false
                        currentID = nil

                    end
                end
            end
            Citizen.Wait(0)
        end
    end)
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
    calloutData.blip = blip
    calloutData.started = true
    Citizen.CreateThread(function()
        while true do
            if (calloutData.started) then
                DrawMarker(1,location.x, location.y, location.z,0.0,0.0,0.0,0,180.0,0.0,1.5,1.5,1.5,122,199,74,90,false,true,2,nil,nil,false)
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if (vehicle and GetDistanceBetweenCoords(location.x, location.y, location.z, GetEntityCoords(vehicle,false)) < 1.5 and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
                    DrawHelp("Wciśnij ~INPUT_PICKUP~ aby odebrać paczki z krwią.")
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
