local missionElements = {}
removedFirstFire = false
function fSystem_createRoute(coords)
    removedFirstFire = false
    local player = source
    missionElements[player] = {}
    local blip = AddBlipForCoord(coords.x,coords.y,coords.z)
    
    SetBlipSprite(blip,436)
    SetBlipDisplay(blip,4)
    SetBlipColour(blip,1)
    SetBlipAsShortRange(blip,false)
    SetBlipScale(blip,1.0)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Pożar")
    EndTextCommandSetBlipName(blip)
    missionElements[player].blip = blip
    ClearGpsMultiRoute()
    StartGpsMultiRoute(6, true, true)
    AddPointToGpsMultiRoute(table.unpack(coords))
    SetGpsMultiRouteRender(true)
end 

function fSystem_destroyRoute()
    local player = source
    if (missionElements[player]) then
        ClearGpsMultiRoute()
        RemoveBlip(missionElements[player].blip)
        missionElements[player].blip = nil
        missionElements[player] = nil
    end
end

function fSystem_initDispatch(data)
    local coords = data.location
    local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetName)
    local text = ("%s."):format((crossingRoad > 0) and streetName .. " / " .. GetStreetNameFromHashKey(crossingRoad) or streetName)
    data.textLocation = text
    TriggerServerEvent("em_dispatch_init",3,data)
end
RegisterNetEvent("fireSystem_initCallout")
AddEventHandler("fireSystem_initCallout",fSystem_initDispatch)
RegisterNetEvent("fireSystem_createRoute")
AddEventHandler("fireSystem_createRoute",fSystem_createRoute)
RegisterNetEvent("fireSystem_destroyRoute")
AddEventHandler("fireSystem_destroyRoute",fSystem_destroyRoute)