local EXISTING_SERVICES = {}
local function GetVehicleInDirection( entFrom, coordFrom, coordTo )
	local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    if ( IsEntityAVehicle( vehicle ) ) then
        return vehicle
    end
end
function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end
function GetPedInFront()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end

function ai_requestModels(npcModel, vehModel)
    RequestModel(vehModel)
    RequestModel(npcModel)

    while not HasModelLoaded(vehModel) do
        RequestModel(vehModel)
        Citizen.Wait(0)
    end
    while not HasModelLoaded(npcModel) do
        RequestModel(npcModel)
        Citizen.Wait(0)
    end
end

function ai_removeEntities(serviceID)
    if (EXISTING_SERVICES[serviceID]) then
        if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then
            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
            if (EXISTING_SERVICES[serviceID].healingPed) then
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].healingPed)
                DeleteEntity(EXISTING_SERVICES[serviceID].healingPed)
            end
            DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
            DeleteEntity(EXISTING_SERVICES[serviceID].blip)
            DeleteEntity(EXISTING_SERVICES[serviceID].ped)
           
            RemoveBlip(EXISTING_SERVICES[serviceID].blip)

            while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do
                Wait(0)
                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
            end
            EXISTING_SERVICES[serviceID] = {}
        end
    end
end

function ai_services_cancel(serviceID)
    ai_removeEntities(serviceID)
    exports.em_3dtext:DrawNotification("Centrala",servicesNames[serviceID].title,servicesNames[serviceID].desc, false, "CHAR_CALL911",0,false)
end


function ai_services_init(serviceID)
    local servicesSpawnDistance = 50 + math.random(10,25)
    local player = GetPlayerPed(-1)
    local playerPos = GetEntityCoords(player)
    local npcModel = GetHashKey(SERVICES["PED_MODELS"][serviceID][math.random(1,#SERVICES['PED_MODELS'][serviceID])])
    local vehModel = GetHashKey(SERVICES["VEHICLES"][serviceID][math.random(1,#SERVICES['VEHICLES'][serviceID])])
    local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(player,0.0,5.0,0.0)
    ai_requestModels(npcModel, vehModel)

    if (EXISTING_SERVICES[serviceID]) then
        ai_removeEntities(serviceID)
    end
    EXISTING_SERVICES[serviceID] = {}
    --
    --  Hycel
    --
    if (serviceID == 4) then
        if (IsPedSittingInAnyVehicle(player)) then return end
        EXISTING_SERVICES[serviceID].healingPed = GetPedInFront()
        if (EXISTING_SERVICES[serviceID].healingPed == 0) then
            duty_gui_cancelService(serviceID)
            ai_services_cancel(serviceID)
            exports.em_3dtext:DrawNotification("Centrala","~b~Hycel","Nie znaleziono martwych zwierząt.",true,"CHAR_CALL911",0,false)
            return
        end
        local isAnimal = false
        for i,v in pairs(ANIMALS_MODELS) do
            if (GetEntityModel(EXISTING_SERVICES[serviceID].healingPed) == GetHashKey(i)) then
                isAnimal = true
            end
        end

        if (not isAnimal) then 
            duty_gui_cancelService(serviceID)
            ai_services_cancel(serviceID)
            exports.em_3dtext:DrawNotification("Centrala","~b~Hycel","Nie znaleziono martwych zwierząt.",true,"CHAR_CALL911",0,false)
            return 
        end
        if (DoesEntityExist(EXISTING_SERVICES[serviceID].healingPed) and IsPedDeadOrDying(EXISTING_SERVICES[serviceID].healingPed,true)) then 
            TriggerEvent("playAnimation:radio")
            Wait(math.random(2000,6000))
            local x,y,z = table.unpack(GetEntityCoords(player, false))
            local heading, vector = GetNthClosestVehicleNode(x,y,z,servicesSpawnDistance,0,0,0)
            local sX, sY, sZ = table.unpack(vector)
            local pedPos = GetEntityCoords(EXISTING_SERVICES[serviceID].healingPed)
            EXISTING_SERVICES[serviceID].vehicle = CreateVehicle(vehModel, sX, sY, sZ, heading, true, true)
            local vehicleHash = GetHashKey(EXISTING_SERVICES[serviceID].vehicle)

            EXISTING_SERVICES[serviceID].ped = CreatePedInsideVehicle(EXISTING_SERVICES[serviceID].vehicle, 26, npcModel, -1, true, false)

            TaskVehicleDriveToCoord(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, pedPos.x, pedPos.y, pedPos.z, 17.0, 0,vehicleHash, 1074528293,1.0,true)
            SetVehicleFixed(EXISTING_SERVICES[serviceID].vehicle)
            SetVehicleOnGroundProperly(EXISTING_SERVICES[serviceID].vehicle)
            exports.em_3dtext:DrawNotification("Centrala","~b~Hycel","Hycel jest w drodze do Ciebie.",false,"CHAR_CALL911",0,false)
            if (DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) and DoesEntityExist(EXISTING_SERVICES[serviceID].ped)) then
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                EXISTING_SERVICES[serviceID].blip = AddBlipForEntity(EXISTING_SERVICES[serviceID].vehicle)
                SetBlipSprite(EXISTING_SERVICES[serviceID].blip, 141)
                SetBlipColour(EXISTING_SERVICES[serviceID].blip, 2)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Hycel")
                EndTextCommandSetBlipName(EXISTING_SERVICES[serviceID].blip)
                EXISTING_SERVICES[serviceID].driving = true
                SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 1, true)
				SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 2, true)
                SetVehicleSiren(EXISTING_SERVICES[serviceID].vehicle, true)
                while(EXISTING_SERVICES[serviceID].driving) do 
                    if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].ped,true)) then 
                        duty_gui_cancelService(serviceID)
                        ai_services_cancel(serviceID)
                        break
                        return
                    end
                    Citizen.Wait(300)
                    local distanceToVehicle = GetDistanceBetweenCoords(GetEntityCoords(EXISTING_SERVICES[serviceID].vehicle), GetEntityCoords(EXISTING_SERVICES[serviceID].healingPed), 1)
                    if (distanceToVehicle <= 20) then
                        TaskVehicleTempAction(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 27, 6000)
                        if (GetEntitySpeed(EXISTING_SERVICES[serviceID].vehicle) < 8) then
                            TaskLeaveVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,256)
                            TaskGoToEntity(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].healingPed, -1, 3, 4.0, 0, 0)
                        else
                            FreezeEntityPosition(EXISTING_SERVICES[serviceID].vehicle,true)
                            TaskLeaveVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,256)
                            TaskGoToEntity(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].healingPed, -1, 3, 4.0, 0, 0)
                        end
                        Wait(7000)
                        FreezeEntityPosition(EXISTING_SERVICES[serviceID].ped,false)
                            if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].healingPed,true)) then 
                                DeleteEntity(EXISTING_SERVICES[serviceID].healingPed)
                            end
                        TaskEnterVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,-1,-1,2.0,1,0)
                        FreezeEntityPosition(EXISTING_SERVICES[serviceID].vehicle,false)
                        SetDriveTaskDrivingStyle(EXISTING_SERVICES[serviceID].vehicle, 786603)
                        SetVehicleDoorShut(EXISTING_SERVICES[serviceID].vehicle, 2, 0)
                        SetVehicleDoorShut(EXISTING_SERVICES[serviceID].vehicle,3,0)
                        TaskVehicleDriveWander(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 17.0, 786603)
                        Wait(20000)
                        if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].towedVehicle)
                            DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                            DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                            DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                            RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                            while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                                Wait(0)
                                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                            end
                            EXISTING_SERVICES[serviceID].driving = false
                            EXISTING_SERVICES[serviceID] = nil
                            duty_gui_cancelService(serviceID)
                            break
                        end
                    end
                end
            else
                duty_gui_cancelService(serviceID)
                ai_services_cancel(serviceID)
                exports.em_3dtext:DrawNotification("Centrala","~b~Hycel","Nie znaleziono martwych zwierząt.",true,"CHAR_CALL911",0,false)
            end
        end
    end
    if (serviceID == 3) then 
        if IsPedSittingInAnyVehicle(player) then return end

        EXISTING_SERVICES[serviceID].healingPed = GetPedInFront()
        if (EXISTING_SERVICES[serviceID].healingPed== 0) then
            EXISTING_SERVICES[serviceID].healingPed = GetPedInVehicleSeat(GetVehicleInDirection(player,playerPos, inFrontOfPlayer),-1)
        end
        if (EXISTING_SERVICES[serviceID].healingPed== 0) then 
            duty_gui_cancelService(serviceID)
            ai_services_cancel(serviceID)
            exports.em_3dtext:DrawNotification("Centrala","~b~Koroner","Nie znaleziono martwych postaci.",true,"CHAR_CALL911",0,false)
            return 
        end
        if (DoesEntityExist(EXISTING_SERVICES[serviceID].healingPed) and IsPedDeadOrDying(EXISTING_SERVICES[serviceID].healingPed,true)) then 
            TriggerEvent("playAnimation:radio")
            Wait(math.random(2000,6000))

            local x,y,z = table.unpack(GetEntityCoords(player, false))
            local heading, vector = GetNthClosestVehicleNode(x,y,z,servicesSpawnDistance,0,0,0)
            local sX, sY, sZ = table.unpack(vector)
            local pedPos = GetEntityCoords(EXISTING_SERVICES[serviceID].healingPed)


            EXISTING_SERVICES[serviceID].vehicle = CreateVehicle(vehModel, sX, sY, sZ, heading, true, true)
            local vehicleHash = GetHashKey(EXISTING_SERVICES[serviceID].vehicle)

            EXISTING_SERVICES[serviceID].ped = CreatePedInsideVehicle(EXISTING_SERVICES[serviceID].vehicle, 26, npcModel, -1, true, false)
            
            TaskVehicleDriveToCoord(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, pedPos.x, pedPos.y, pedPos.z, 17.0, 0,vehicleHash, 1074528293,1.0,true)
            SetVehicleFixed(EXISTING_SERVICES[serviceID].vehicle)
            SetVehicleOnGroundProperly(EXISTING_SERVICES[serviceID].vehicle)
            exports.em_3dtext:DrawNotification("Centrala","~b~Koroner","Koroner jest w drodze do Ciebie.",false,"CHAR_CALL911",0,false)
            if (DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) and DoesEntityExist(EXISTING_SERVICES[serviceID].ped)) then
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                EXISTING_SERVICES[serviceID].blip = AddBlipForEntity(EXISTING_SERVICES[serviceID].vehicle)
                SetBlipSprite(EXISTING_SERVICES[serviceID].blip, 310)
                SetBlipColour(EXISTING_SERVICES[serviceID].blip, 0)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Koroner")
                EndTextCommandSetBlipName(EXISTING_SERVICES[serviceID].blip)
                EXISTING_SERVICES[serviceID].driving = true
                SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 1, true)
				SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 2, true)
                SetVehicleSiren(EXISTING_SERVICES[serviceID].vehicle, true)
                while(EXISTING_SERVICES[serviceID].driving) do
                    if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].ped,true)) then 
                        duty_gui_cancelService(serviceID)
                        ai_services_cancel(serviceID)
                        break
                        return 
                    end
                    Citizen.Wait(300)
                    local distanceToVehicle = GetDistanceBetweenCoords(GetEntityCoords(EXISTING_SERVICES[serviceID].vehicle), GetEntityCoords(EXISTING_SERVICES[serviceID].healingPed), 1)
                    if (distanceToVehicle <= 20) then
                        TaskVehicleTempAction(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 27, 6000)
                        if (GetEntitySpeed(EXISTING_SERVICES[serviceID].vehicle) < 8) then
                            TaskLeaveVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,256)
                            TaskGoToEntity(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].healingPed, -1, 3, 4.0, 0, 0)
                        else
                            FreezeEntityPosition(EXISTING_SERVICES[serviceID].vehicle,true)
                            TaskLeaveVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,256)
                            TaskGoToEntity(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].healingPed, -1, 3, 4.0, 0, 0)
                        end
                        Wait(10000)
                        if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].healingPed,true)) then 
                            DeleteEntity(EXISTING_SERVICES[serviceID].healingPed)
                        end
                        TaskEnterVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,-1,-1,2.0,1,0)
                        FreezeEntityPosition(EXISTING_SERVICES[serviceID].vehicle,false)
                        SetDriveTaskDrivingStyle(EXISTING_SERVICES[serviceID].vehicle, 786603)
                        SetVehicleDoorShut(EXISTING_SERVICES[serviceID].vehicle, 2, 0)
                        SetVehicleDoorShut(EXISTING_SERVICES[serviceID].vehicle,3,0)
                        TaskVehicleDriveWander(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 17.0, 786603)
                        Wait(20000)
                        if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].towedVehicle)

                            DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                            DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                            DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                            RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                            while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                                Wait(0)
                                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                            end
                            EXISTING_SERVICES[serviceID].driving = false
                            EXISTING_SERVICES[serviceID] = nil
                            duty_gui_cancelService(serviceID)
                            break
                        end
                    end
                end
            else
                duty_gui_cancelService(serviceID)
                ai_services_cancel(serviceID)
                exports.em_3dtext:DrawNotification("Centrala","~b~Koroner","Nie znaleziono martwych postaci.",true,"CHAR_CALL911",0,false)
            end
        end
    end

    if (serviceID == 2) then
        if IsPedSittingInAnyVehicle(player) then return end

        EXISTING_SERVICES[serviceID].healingPed = GetPedInFront()
        if (EXISTING_SERVICES[serviceID].healingPed== 0) then
            EXISTING_SERVICES[serviceID].healingPed = GetPedInVehicleSeat(GetVehicleInDirection(player,playerPos, inFrontOfPlayer),-1)
        end
        if (EXISTING_SERVICES[serviceID].healingPed== 0) then 
            duty_gui_cancelService(serviceID)
            ai_services_cancel(serviceID)
            exports.em_3dtext:DrawNotification("Centrala","~b~Ambulans","Nie znaleziono martwych postaci.",true,"CHAR_CALL911",0,false)
            return 
        end
        if (DoesEntityExist(EXISTING_SERVICES[serviceID].healingPed) and IsPedDeadOrDying(EXISTING_SERVICES[serviceID].healingPed,true)) then 
            TriggerEvent("playAnimation:radio")
            Wait(math.random(2000,6000))

            local x,y,z = table.unpack(GetEntityCoords(player, false))
            local heading, vector = GetNthClosestVehicleNode(x,y,z,servicesSpawnDistance,0,0,0)
            local sX, sY, sZ = table.unpack(vector)
            local pedPos = GetEntityCoords(EXISTING_SERVICES[serviceID].healingPed)


            EXISTING_SERVICES[serviceID].vehicle = CreateVehicle(vehModel, sX, sY, sZ, heading, true, true)
            local vehicleHash = GetHashKey(EXISTING_SERVICES[serviceID].vehicle)

            EXISTING_SERVICES[serviceID].ped = CreatePedInsideVehicle(EXISTING_SERVICES[serviceID].vehicle, 26, npcModel, -1, true, false)
            
            TaskVehicleDriveToCoord(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, pedPos.x, pedPos.y, pedPos.z, 17.0, 0,vehicleHash, 1074528293,1.0,true)
            SetVehicleFixed(EXISTING_SERVICES[serviceID].vehicle)
            SetVehicleOnGroundProperly(EXISTING_SERVICES[serviceID].vehicle)
            exports.em_3dtext:DrawNotification("Centrala","~b~Ambulans","Ambulans jest w drodze do Ciebie.",false,"CHAR_CALL911",0,false)
            if (DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) and DoesEntityExist(EXISTING_SERVICES[serviceID].ped)) then
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                EXISTING_SERVICES[serviceID].blip = AddBlipForEntity(EXISTING_SERVICES[serviceID].vehicle)
                
                SetBlipSprite(EXISTING_SERVICES[serviceID].blip, 153)
                SetBlipColour(EXISTING_SERVICES[serviceID].blip, 1)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Ambulans")
                EndTextCommandSetBlipName(EXISTING_SERVICES[serviceID].blip)
                EXISTING_SERVICES[serviceID].driving = true
                SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 1, true)
				SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 2, true)
                SetVehicleSiren(EXISTING_SERVICES[serviceID].vehicle, true)
                while(EXISTING_SERVICES[serviceID].driving) do
                    if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].ped,true)) then 
                        duty_gui_cancelService(serviceID)
                        ai_services_cancel(serviceID)
                        break
                        return 
                        
                    end
                    Citizen.Wait(300)
                    local distanceToVehicle = GetDistanceBetweenCoords(GetEntityCoords(EXISTING_SERVICES[serviceID].vehicle), GetEntityCoords(EXISTING_SERVICES[serviceID].healingPed), 1)
                    if (distanceToVehicle <= 20) then
                        TaskVehicleTempAction(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 27, 6000)

                        
                        if (GetEntitySpeed(EXISTING_SERVICES[serviceID].vehicle) < 8) then
                            TaskLeaveVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,256)
                            TaskGoToEntity(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].healingPed, -1, 3, 4.0, 0, 0)
                        else
                            FreezeEntityPosition(EXISTING_SERVICES[serviceID].vehicle,true)
                            TaskLeaveVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,256)
                            TaskGoToEntity(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].healingPed, -1, 3, 4.0, 0, 0)
                        end

                        Wait(10000)
                            if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].healingPed,true)) then 
                                ClearPedTasksImmediately(EXISTING_SERVICES[serviceID].healingPed)
                                SetEntityHealth(EXISTING_SERVICES[serviceID].healingPed,100)
                                ResurrectPed(EXISTING_SERVICES[serviceID].healingPed)
                                ClearPedTasksImmediately(EXISTING_SERVICES[serviceID].healingPed)
                                SetPedIntoVehicle(EXISTING_SERVICES[serviceID].healingPed,EXISTING_SERVICES[serviceID].vehicle,0)
                            end
                            if (IsPedInVehicle(EXISTING_SERVICES[serviceID].healingPed, EXISTING_SERVICES[serviceID].vehicle, false)) then 
                                FreezeEntityPosition(EXISTING_SERVICES[serviceID].vehicle,false)
                                TaskEnterVehicle(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle,-1,-1,2.0,1,0)
                                SetDriveTaskDrivingStyle(EXISTING_SERVICES[serviceID].vehicle, 786603)
                                SetVehicleDoorShut(EXISTING_SERVICES[serviceID].vehicle, 2, 0)
                                SetVehicleDoorShut(EXISTING_SERVICES[serviceID].vehicle,3,0)
                                TaskVehicleDriveWander(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 17.0, 786603)
                                Wait(10000)
                                if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                                    SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                                    SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                                    SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].healingPed)

                                    DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                                    DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                                    DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                                    DeleteEntity(EXISTING_SERVICES[serviceID].healingPed)
                                    RemoveBlip(EXISTING_SERVICES[serviceID].blip)

                                    while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                                        Wait(0)
                                        DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                                    end
                                    EXISTING_SERVICES[serviceID].driving = false
                                    EXISTING_SERVICES[serviceID] = nil
                                    duty_gui_cancelService(serviceID)
                                    break
                                end
                            end
                    end
                end
            else
                duty_gui_cancelService(serviceID)
                ai_services_cancel(serviceID)
                exports.em_3dtext:DrawNotification("Centrala","~b~Ambulans","Nie znaleziono martwych postaci.",true,"CHAR_CALL911",0,false)
            end
        end
    end

    if (serviceID == 1) then
        if IsPedSittingInAnyVehicle(player) then 
            EXISTING_SERVICES[serviceID].towedVehicle = GetVehiclePedIsIn(player, false)
        else
            EXISTING_SERVICES[serviceID].towedVehicle = GetVehicleInDirection(player,playerPos, inFrontOfPlayer)
        end

        if (DoesEntityExist(EXISTING_SERVICES[serviceID].towedVehicle)) then 
            TriggerEvent("playAnimation:radio")
            Wait(math.random(2000,6000))

            local x,y,z = table.unpack(GetEntityCoords(player, false))
            local heading, vector = GetNthClosestVehicleNode(x,y,z,servicesSpawnDistance,0,0,0)
            local sX, sY, sZ = table.unpack(vector)
            local vehPos = GetEntityCoords(EXISTING_SERVICES[serviceID].towedVehicle)

            EXISTING_SERVICES[serviceID].vehicle = CreateVehicle(vehModel, sX, sY, sZ, heading, true, true)
            local vehicleHash = GetHashKey(EXISTING_SERVICES[serviceID].vehicle)

            EXISTING_SERVICES[serviceID].ped = CreatePedInsideVehicle(EXISTING_SERVICES[serviceID].vehicle, 26, npcModel, -1, true, false)
            
            TaskVehicleDriveToCoord(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, vehPos.x, vehPos.y, vehPos.z, 17.0, 0,vehicleHash, 786603,1.0,true)
            SetVehicleFixed(EXISTING_SERVICES[serviceID].vehicle)
            SetVehicleOnGroundProperly(EXISTING_SERVICES[serviceID].vehicle)
            exports.em_3dtext:DrawNotification("Centrala","~b~Laweta","Laweta jest w drodze do Ciebie.",false,"CHAR_CALL911",0,false)
            if (DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) and DoesEntityExist(EXISTING_SERVICES[serviceID].ped)) then
                SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                EXISTING_SERVICES[serviceID].blip = AddBlipForEntity(EXISTING_SERVICES[serviceID].vehicle)
                SetBlipColour(EXISTING_SERVICES[serviceID].blip, 29)
                SetBlipFlashes(EXISTING_SERVICES[serviceID].blip, true)
                SetBlipSprite(EXISTING_SERVICES[serviceID].blip, 68)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Laweta")
                EndTextCommandSetBlipName(EXISTING_SERVICES[serviceID].blip)
                EXISTING_SERVICES[serviceID].driving = true
                SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 1, true)
				SetVehicleIndicatorLights(EXISTING_SERVICES[serviceID].vehicle, 2, true)
                SetVehicleSiren(EXISTING_SERVICES[serviceID].vehicle, true)
                while(EXISTING_SERVICES[serviceID].driving) do
                    if (IsPedDeadOrDying(EXISTING_SERVICES[serviceID].ped,true)) then 
                        duty_gui_cancelService(serviceID)
                        ai_services_cancel(serviceID)
                        break
                        return 
                    end
                    Citizen.Wait(300)
                    local distanceToVehicle = GetDistanceBetweenCoords(GetEntityCoords(EXISTING_SERVICES[serviceID].vehicle), GetEntityCoords(EXISTING_SERVICES[serviceID].towedVehicle), 1)
                    if (distanceToVehicle <= 15) then
                        TaskVehicleTempAction(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 27, 10000)
                        Wait(3000)
                        AttachEntityToEntity(EXISTING_SERVICES[serviceID].towedVehicle, EXISTING_SERVICES[serviceID].vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                        SetDriveTaskDrivingStyle(EXISTING_SERVICES[serviceID].vehicle, 786603)
                        TaskVehicleDriveWander(EXISTING_SERVICES[serviceID].ped,EXISTING_SERVICES[serviceID].vehicle, 17.0, 786603)
                        RemoveBlip(EXISTING_SERVICES[serviceID].blip)
                        EXISTING_SERVICES[serviceID].blip = nil 
                        Wait(30000)
                        if DoesEntityExist(EXISTING_SERVICES[serviceID].vehicle) then 
                            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].vehicle)
                            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].ped)
                            SetEntityAsMissionEntity(EXISTING_SERVICES[serviceID].towedVehicle)
            
                            DeleteEntity(EXISTING_SERVICES[serviceID].vehicle)
                            DeleteEntity(EXISTING_SERVICES[serviceID].blip)
                            DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                            DeleteEntity(EXISTING_SERVICES[serviceID].towedVehicle)
                            RemoveBlip(EXISTING_SERVICES[serviceID].blip)
            
                            while DoesEntityExist(EXISTING_SERVICES[serviceID].ped) do 
                                Wait(0)
                                DeleteEntity(EXISTING_SERVICES[serviceID].ped)
                            end
                            EXISTING_SERVICES[serviceID].driving = false
                            EXISTING_SERVICES[serviceID] = nil
                            duty_gui_cancelService(serviceID)
                            break
                        end
                    end
                end
            end
        else 
            duty_gui_cancelService(serviceID)
            ai_services_cancel(serviceID)
            exports.em_3dtext:DrawNotification("Centrala","~b~Laweta","Nie znaleziono pojazdu przed Tobą.",true,"CHAR_CALL911",0,false)
        end
    end
end

function playAnimationRadio()
    loadAnimDict("random@arrests")
    Citizen.CreateThread(function()
        TaskPlayAnim(GetPlayerPed(-1), "random@arrests", "generic_radio_enter", 1.5, 2.0, -1, 50, 2.0, 0, 0, 0 )
        Citizen.Wait(6000)
        ClearPedTasks(GetPlayerPed(-1))
    end)
end
AddEventHandler("playAnimation:radio",playAnimationRadio)