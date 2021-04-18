local stateStretcher = false
local objectStretcher = nil
local vehicleStretcher = nil
local pedStretcher = nil
local modelStretcher = "prop_ld_binbag_01"
local inBedDicts = "anim@gangops@morgue@table@"
local inBedAnims = "ko_front"
function getStretcherState()
    return stateStretcher
end

function stretcher_destroy()
    DetachEntity(PlayerPedId(),true,true)
    DeleteEntity(objectStretcher)
    objectStretcher = nil
    stateStretcher = false
    pedStretcher = nil
    Citizen.Wait(100)
    ClearPedTasksImmediately(PlayerPedId())
    return true
end

Citizen.CreateThread(function()
    while true do
        if (objectStretcher) then
            if (IsPedGettingIntoAVehicle(GetPlayerPed(-1))) then
                ClearPedTasksImmediately(GetPlayerPed(-1))
            end
        end
        Citizen.Wait(10)
    end
end)

LoadAnim = function(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        
        Citizen.Wait(1)
    end
end

function stretcher_create(vehicle)
    if (objectStretcher) then stretcher_destroy() return end
    RequestModel(GetHashKey(modelStretcher))
    while not HasModelLoaded(modelStretcher) do
        Citizen.Wait(100)
    end
    objectStretcher = CreateObject(GetHashKey(modelStretcher), GetEntityCoords(PlayerPedId()),true)
    PlaceObjectOnGroundProperly(objectStretcher)
    Citizen.Wait(1000)
    local netid = ObjToNet(objectStretcher)
    SetNetworkIdExistsOnAllMachines(netid, true)
    NetworkSetNetworkIdDynamic(netid, true)
    SetNetworkIdCanMigrate(netid, false)
    NetworkRequestControlOfEntity(objectStretcher)
    LoadAnim("anim@heists@box_carry@")
    AttachEntityToEntity(objectStretcher, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), 0.0, -1.0, -0.69, 194.0, 180.0, 180.0, 0.0, false, false, true, false, 2, true)
    stateStretcher = 0
    while IsEntityAttachedToEntity(objectStretcher, PlayerPedId()) do
        Citizen.Wait(5)

        if not IsEntityPlayingAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 3) then
            TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 50, 0, false, false, false)
        end

        if IsPedDeadOrDying(PlayerPedId()) then
            stretcher_destroy()
            DetachEntity(objectStretcher, true, true)
        end
    end
    return true
end

function stretcher_putNPC(ped)
    if (not ped or not objectStretcher) then return end
    pedStretcher = ped
    LoadAnim(inBedDicts)
    AttachEntityToEntity(ped, objectStretcher, 0,0,0.0,0.99,0.0,90.0,270.0,0.0,false,false,false,false,2,true)
    TaskPlayAnim(ped,inBedDicts,inBedAnims, 8.0,8.0,-1,69,1,false,false,false)
    stateStretcher = 1
    while IsEntityAttachedToEntity(ped, objectStretcher) do
        Citizen.Wait(5)
        local heading = GetEntityHeading(objectStretcher)
        SetEntityHeading(ped,heading)
    end
end
function strecher_putInVehicle(vehicle)
    if (stateStretcher == 1) then
        vehicleStretcher = vehicle
        DetachEntity(PlayerPedId(),true,true)
        DeleteEntity(objectStretcher)
        objectStretcher = nil
        ClearPedTasksImmediately(PlayerPedId())
        stretcherState = nil
    end
end
exports("putNPCOnStretcher",stretcher_putNPC)
exports("putInVehicle",strecher_putInVehicle)
exports("onPlayerPickedUpStretcher",stretcher_create)
exports("getStretcherState",getStretcherState)