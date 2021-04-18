local missionElements = {}
local missionCoords = nil
removedFirstFire = false
local watcher = false
local FireID = false
local player = nil
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

Citizen.CreateThread(function()
    while true do
        if (watcher) then
            local coords = missionCoords
            if (Fire and Fire.active and Fire.active[FireID] and Fire.active[FireID].flames) then
                local firesInRange = countElements(Fire.active[FireID].flames)
                print('getting number of fires: '..firesInRange)
                if (firesInRange <= 1) then
                    TriggerServerEvent("fireMission:endMission",FireID)
                    FireID = false
                    watcher = false
                end
            end
        end
        Citizen.Wait(2500)
    end
end)
function fSystem_createRoute(coords,fireID)
    removedFirstFire = false
    FireID = fireID
    player = source
    missionElements[player] = {}
    missionCoords = coords
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
    Wait(15000)
    Citizen.CreateThread(function()
        while true do
            local playerPos = GetEntityCoords(GetPlayerPed(-1))
            if (#(playerPos - missionCoords) < 20) then
                watcher = true
            end
            Citizen.Wait(1000)
        end
    end)
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
function fSystem_cancelFire()
    if (missionElements[player]) then
        ClearGpsMultiRoute()
        RemoveBlip(missionElements[player].blip)
        watcher = false
        missionCoords = nil
        missionElements[player].blip = nil
        missionElements[player] = nil
        TriggerServerEvent("em_fire_callout:cancel",FireID)
    end
end

exports("fireCallout_cancel",fSystem_cancelFire)
RegisterNetEvent("fireSystem_initCallout")
AddEventHandler("fireSystem_initCallout",fSystem_initDispatch)
RegisterNetEvent("fireSystem_createRoute")
AddEventHandler("fireSystem_createRoute",fSystem_createRoute)
RegisterNetEvent("fireSystem_destroyRoute")
AddEventHandler("fireSystem_destroyRoute",fSystem_destroyRoute)