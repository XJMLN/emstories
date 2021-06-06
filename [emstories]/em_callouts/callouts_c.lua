local calloutLocation = nil
local calloutBlip = nil
local hasStarted = false
function callouts_initDispatch(calloutData)
    local departmentID = LocalPlayer.state.departmentID
    local coords = calloutData.locations[departmentID][math.random(1,#calloutData.locations[departmentID])]
    calloutLocation = coords
    local streetName, crossingRoad = GetStreetNameAtCoord(coords.x,coords.y,coords.z)
    local text = ("%s."):format((crossingRoad >0) and GetStreetNameFromHashKey(streetName).. "/".. GetStreetNameFromHashKey(crossingRoad) or GetStreetNameFromHashKey(streetName))
    calloutData.textLocation = text
    TriggerServerEvent("em_dispatch_init",LocalPlayer.state.factionID, calloutData)
end

function callouts_callOusideFunction(ID, data, coords)
    if (not hasStarted) then
        hasStarted = true
        print("from main scope "..ID)
        TriggerEvent("em_callouts:startupMission",ID,data,coords)
        DeleteEntity(calloutBlip)
        RemoveBlip(calloutBlip)
        Wait(200)
        calloutBlip = nil
        calloutLocation = nil
    end
end
function callouts_createRoute(calloutData)
    local calloutData = calloutData
    hasStarted = false
    calloutBlip = AddBlipForCoord(calloutLocation.x,calloutLocation.y, calloutLocation.z)
    SetBlipSprite(calloutBlip,calloutData.sprite)
    SetBlipDisplay(calloutBlip, 4)
    SetBlipColour(calloutBlip, calloutData.colour)
    SetBlipAsShortRange(calloutBlip, false)
    SetBlipScale(calloutBlip, 1.0)
    SetBlipRoute(calloutBlip, true)
    SetBlipRouteColour(calloutBlip, calloutData.colour)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cel wezwania")
    EndTextCommandSetBlipName(calloutBlip)
    Citizen.CreateThread(function()
        while true do
            if (not hasStarted and calloutLocation and calloutBlip) then
            local plrPos = GetEntityCoords(PlayerPedId())
            if (GetDistanceBetweenCoords(plrPos.x,plrPos.y,plrPos.z,calloutLocation.x,calloutLocation.y, calloutLocation.z, false) <=300) then
                callouts_callOusideFunction(calloutData.id, calloutData, calloutLocation)
            end
            end
        Citizen.Wait(0)
        end
    end)
end

RegisterNetEvent("callouts_initDispatch")
AddEventHandler("callouts_initDispatch",callouts_initDispatch)

RegisterNetEvent("callouts_createRoute")
AddEventHandler("callouts_createRoute",callouts_createRoute)
