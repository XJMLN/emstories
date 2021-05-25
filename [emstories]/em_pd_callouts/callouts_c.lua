local calloutLocation = false
local calloutcalloutBlip = nil
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function pdCallout_initDispatch(data)
    local departmentID = LocalPlayer.state.departmentID
    local coords = data.locations[departmentID][math.random(1,#data.locations[departmentID])]
    calloutLocation = coords
    local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetName)
    local text = ("%s."):format((crossingRoad > 0) and streetName .. " / " .. GetStreetNameFromHashKey(crossingRoad) or streetName)
    data.textLocation = text
    TriggerServerEvent("em_dispatch_init",1,data)
end

function pdCallout_createRoute(data)
    local data = data
    calloutBlip = AddBlipForCoord(calloutLocation.x,calloutLocation.y, calloutLocation.z)
    SetBlipSprite(calloutBlip,665)
    SetBlipDisplay(calloutBlip, 4)
    SetBlipColour(calloutBlip, 1)
    SetBlipAsShortRange(calloutBlip, false)
    SetBlipScale(calloutBlip, 1.0)
    SetBlipRoute(calloutBlip, true)
    SetBlipRouteColour(calloutBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cel wezwania")
    EndTextCommandSetBlipName(calloutBlip)
    Citizen.CreateThread(function()
        while true do
            local plrPos = GetEntityCoords(PlayerPedId())
            if (GetDistanceBetweenCoords(plrPos.x,plrPos.y,plrPos.z,calloutLocation.x,calloutLocation.y, calloutLocation.z, false) <=300) then
                DeleteEntity(calloutBlip)
                RemoveBlip(calloutBlip)
                pdCallout_startupMission(data.id, data, calloutLocation)
                calloutBlip = nil
                calloutLocation = nil
                break
            end

            Citizen.Wait(0)
        end
    end)
end
RegisterNetEvent("pdCallout_initCallout")
RegisterNetEvent("pdCallout:create")
AddEventHandler("pdCallout:create",pdCallout_createRoute)
AddEventHandler("pdCallout_initCallout",pdCallout_initDispatch)
