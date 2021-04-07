local currentSaw = nil
local vehicleWatch = nil
local gameTimer = false
isCutting = false
local function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function createParticles()
    RequestNamedPtfxAsset("des_fib_floor")
    while (not HasNamedPtfxAssetLoaded("des_fib_floor")) do
        Citizen.Wait(1)
    end
    UseParticleFxAsset("des_fib_floor")
    StartNetworkedParticleFxLoopedOnEntity("ent_ray_fbi5a_ramp_metal_imp",currentSaw, -0.715, 0.005,0.0,0.0,25.0,25.0,0.75,false,false,false)
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

function saw_cutDoors(vehicle,doorIndex)
    isCutting = true
    if (not gameTimer) then
        gameTimer = GetGameTimer()
    end
    createParticles()
    if (GetGameTimer() - gameTimer >= 3000) then
        SetVehicleDoorBroken(vehicle,doorIndex,true)
        gameTimer = false
        isCutting = false
    end
end
Citizen.CreateThread(function()
    while true do
        if (currentSaw) then
            if (IsPedGettingIntoAVehicle(GetPlayerPed(-1))) then
                saw_destroy()
            end
            if (vehicleWatch and DoesEntityExist(vehicleWatch)) then
                local MainVehPos = GetEntityCoords(vehicleWatch)
                local plrPos = GetEntityCoords(GetPlayerPed(-1))
                local distance = #(plrPos - MainVehPos)
                if (distance >=100) then
                    saw_destroy()
                end
                local plrOffset = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1),0.0,1.0,0.0)
                local vehicle = getVehicleInDirection(plrPos, plrOffset)
                if (DoesEntityExist(vehicle) and DecorGetInt(vehicle,"__MISSION_SAW_") == 1) then
                    local vehPos = GetWorldPositionOfEntityBone(vehicle,GetEntityBoneIndexByName(vehicle,"door_dside_f"))
                    local distanceToBone = GetDistanceBetweenCoords(vehPos, plrPos, 1)
                    if (distanceToBone <= 3.0 and IsVehicleDoorDamaged(vehicle,0)~=1) then
                        DrawHelp("Przytrzymaj ~INPUT_PICKUP~ aby wyciąć drzwi.")
                        if (IsControlPressed(0,38)) then
                            saw_cutDoors(vehicle,0)
                        end
                        
                    end
                   
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
exports("saw_destroy",saw_destroy)