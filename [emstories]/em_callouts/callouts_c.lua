local calloutLocation = nil
local calloutBlip = nil
local hasStarted = false
function split(str, pat)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t,cap)
        end
        last_end = e+1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end
function getClosestCoords(tables)
    local _ClosestCoord = nil
    local _ClosestDistance = 9999999
    local _playerPed = PlayerPedId()
    local _Coord = GetEntityCoords(_playerPed)

    for _,v in pairs(tables) do
        loc = split(v,",")
        for ii,vv in ipairs(loc) do		loc[ii]=tonumber(vv)	end
        local _Distance = #(vector3(loc[1],loc[2],loc[3]) - _Coord)
        if (_Distance <= _ClosestDistance) then
            _ClosestDistance = _Distance
            _ClosestCoord = loc
        end
    end
    return _ClosestCoord
end

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
        print("^4Trwa generowanie wezwania...^0")
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

function callouts_cancel(ID)
    local source = source
    if (hasStarted) then
        TriggerEvent("em_callouts:cancelMission",ID)
        return
    end
    DeleteEntity(calloutBlip)
    RemoveBlip(calloutBlip)
    calloutLocation = nil
    calloutBlip = nil
    hasStarted = false

end
RegisterNetEvent("callouts_initDispatch")
AddEventHandler("callouts_initDispatch",callouts_initDispatch)

RegisterNetEvent("callouts_cancelCallout")
AddEventHandler("callouts_cancelCallout",callouts_cancel)
RegisterNetEvent("callouts_createRoute")
AddEventHandler("callouts_createRoute",callouts_createRoute)
