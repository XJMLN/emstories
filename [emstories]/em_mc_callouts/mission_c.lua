local missionElements = {}
local missionCoords = nil
local missionID = nil

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function mcSystem_createRoute(coords, M_ID)
    missionID = M_ID
    local player = source
    missionElements[player] = {}
    missionCoords = coords
    local blip = AddBlipForCoord(coords.x,coords.y,coords.z)
    
    SetBlipSprite(blip,403)
    SetBlipDisplay(blip,4)
    SetBlipColour(blip,3)
    SetBlipAsShortRange(blip,false)
    SetBlipScale(blip,1.0)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cel Wezwania")
    EndTextCommandSetBlipName(blip)
    missionElements[player].blip = blip
    ClearGpsMultiRoute()
    StartGpsMultiRoute(10, true, true)
    AddPointToGpsMultiRoute(table.unpack(coords))
    SetGpsMultiRouteRender(true)
end

function mcSystem_destroyRoute()
    local player = source
    if (missionElements[player]) then
        ClearGpsMultiRoute()
        RemoveBlip(missionElements[player].blip)
        missionElements[player].blip = nil
        missionElements[player] = nil
    end
end

function mcSystem_initDispatch(data)
    local coords = data.location
    local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local streetName = GetStreetNameFromHashKey(streetName)
    local text = ("%s."):format((crossingRoad > 0) and streetName .. " / " .. GetStreetNameFromHashKey(crossingRoad) or streetName)
    data.textLocation = text
    TriggerServerEvent("em_dispatch_init",2,data)
end

RegisterNetEvent("mcSystem_initCallout")
AddEventHandler("mcSystem_initCallout",mcSystem_initDispatch)
RegisterNetEvent("mcSystem_createRoute")
AddEventHandler("mcSystem_createRoute",mcSystem_createRoute)
RegisterNetEvent("mcSystem_destroyRoute")
AddEventHandler("mcSystem_destroyRoute",mcSystem_destroyRoute)