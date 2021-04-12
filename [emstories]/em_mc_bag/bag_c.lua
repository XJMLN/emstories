local currentBag = false
local vehicleWatch = nil

function isPlayerHoldingBag()
    return currentBag
end
function bag_destroy()
    DeleteEntity(currentBag)
    currentBag = nil
    vehicleWatch = nil
    return true
end

Citizen.CreateThread(function()
    while true do
        if (currentBag) then
            if (IsPedGettingIntoAVehicle(GetPlayerPed(-1))) then
                bag_destroy()
            end
        end
        Citizen.Wait(10)
    end
end)
function bag_pickup(vehicle)
    if (currentBag) then bag_destroy() return end
    vehicleWatch = vehicle

    RequestModel(GetHashKey(BAG_MODEL))
    while not HasModelLoaded(GetHashKey(BAG_MODEL)) do
        Citizen.Wait(100)
    end
    local plrCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0,0.0,-5.0)
    currentBag = CreateObject(GetHashKey(BAG_MODEL), plrCoords.x, plrCoords.y, plrCoords.z, 1,1,1)
    Citizen.Wait(1000)
    local netid = ObjToNet(currentBag)
    SetNetworkIdExistsOnAllMachines(netid, true)
    NetworkSetNetworkIdDynamic(netid, true)
    SetNetworkIdCanMigrate(netid, false)
    AttachEntityToEntity(currentBag, GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()),57005), 0.4,0.0,0.0,90.0,0.0,270.0,1,1,0,1,0,1)
    return true
end
exports("onPlayerPickedUpBag", bag_pickup)
exports("isPlayerHoldingBag",isPlayerHoldingBag)