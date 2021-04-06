local currentSaw = nil
local vehicleWatch = nil

local function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

local function DrawHelp(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, false, 1, 0)
end

function saw_destroy()
    DeleteEntity(currentSaw)
    currentSaw = nil
    vehicleWatch = nil
    ClearPedTasks(GetPlayerPed(-1))
    return true
end

Citizen.CreateThread(function()
    while true do
        if (currentSaw) then
            if (IsPedGettingIntoAVehicle(GetPlayerPed(-1))) then
                saw_destroy()
            end
            if (vehicleWatch and DoesEntityExist(vehicleWatch)) then
                local vehPos = GetEntityCoords(vehicleWatch)
                local plrPos = GetEntityCoords(GetPlayerPed(-1))
                local distance = #(plrPos - vehPos)
                if (distance >=100) then
                    saw_destroy()
                end
            end
        end
        Citizen.Wait(10)
    end
end)

function saw_pickup(vehicle)
    if (currentSaw) then saw_destroy() return end
    vehicleWatch = vehicle
    RequestAnimDict("weapons@heavy@minigun")
    while not HasAnimDictLoaded("weapons@heavy@minigun") do
        Citizen.Wait(100)
    end
    RequestModel(GetHashKey(CHAINSAW_MODEL))
    while not HasModelLoaded(GetHashKey(CHAINSAW_MODEL)) do
        Citizen.Wait(100)
    end
    TaskPlayAnim(GetPlayerPed(-1),"weapons@heavy@minigun","idle_2_aim_right_med",1.0, -1, -1, 50, 0, 0, 0, 0)
    local plrCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0,0.0,-5.0)
    currentSaw = CreateObject(GetHashKey(CHAINSAW_MODEL), plrCoords.x, plrCoords.y, plrCoords.z, 1, 1, 1)
    Citizen.Wait(1000)
    local netid = ObjToNet(currentSaw)
    SetNetworkIdExistsOnAllMachines(netid, true)
    NetworkSetNetworkIdDynamic(netid, true)
    SetNetworkIdCanMigrate(netid,false)
    AttachEntityToEntity(currentSaw, GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()),57005), 0.095, 0.095,0,290.0,180.0,55.0,1,1,0,1,0,1)
end

exports("onPlayerPickedUpSaw",saw_pickup)