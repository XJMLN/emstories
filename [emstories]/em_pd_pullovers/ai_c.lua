--TextDraws
STOPPED_PEDS = {}
STOPPED_VEHS = {}
JAILS = {}
JAIL_BLIP = nil
policeCars = {
    ['14pdcharger']=true,
    ['11pdcvpi']=true,
}
ARRESTED_PEDS = {}
local upcomingNotify = false
local cuffedPed = nil
local nearVehicleCuffed = false
local isFleeing = false
isPerformingVehicleStop = false
function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end
function GetVehicleInDirection( entFrom, coordFrom, coordTo )
	local rayHandle = StartShapeTestCapsule( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 5.0, 10, entFrom, 7 )
    local _, _, _, _, vehicle = GetShapeTestResult( rayHandle )
    
    if ( IsEntityAVehicle( vehicle ) ) then 
        return vehicle
    end 
end
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
function GetVehHealthPercent(vehicle)
	local vehiclehealth = GetEntityHealth(vehicle) - 100
	local maxhealth = GetEntityMaxHealth(vehicle) - 100
	local procentage = (vehiclehealth / maxhealth) * 100
	return procentage
end

function getClosestCoordsToJail()
    local _ClosestCoord = nil
    local _ClosestDistance = 9999999
    local _playerPed = PlayerPedId()
    local _Coord = GetEntityCoords(_playerPed)

    for _,v in pairs(JAILS) do
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
function DrawDialogue(text)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(3000,0)
end
function DrawHelp(text,label)
    if (label) then
        BeginTextCommandDisplayHelp(label)
        EndTextCommandDisplayHelp(0,false,1,0)
        return
    end
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end
function isPedCuffed(ped)
    if (not STOPPED_PEDS[ped]) then 
        if (STOPPED_PEDS[ped] == GUI.Variables.player.currentPed) then
            if (GUI.Variables.player.currentVehicle and STOPPED_VEHS[GUI.Variables.player.currentVehicle] and STOPPED_VEHS[GUI.Variables.player.currentVehicle].cuffed) then return true end
            return false
        end
        return false 
    end
    return STOPPED_PEDS[ped].cuffed
end
function isVehicleStopped(veh)
    if (not STOPPED_VEHS[veh]) then return false end
    return true
end
function isVehicleFollowing(veh)
    if (STOPPED_VEHS[veh] and STOPPED_VEHS[veh].followMode == 1) then return true end
    return false
end
function canPlayerInteractWithDriver(veh)
    if (STOPPED_VEHS[veh] and STOPPED_VEHS[veh].canInteract) then return true end
    return false
end
function convert_vehDataToPedData(veh)
    return {ped = veh.ped, pedType=veh.pedType, pedID=veh.pedID,cuffed=veh.cuffed}
end
function ai_showBadge()
    loadAnimDict("random@atm_robbery@return_wallet_male")
	local prop = CreateObject(GetHashKey('prop_fib_badge'), GetEntityCoords(PlayerPedId()), true)
	AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.03, 0.003, -0.045, 90.0, 0.0, 75.0, 1, 0, 0, 0, 0, 1)
	TaskPlayAnim(PlayerPedId(), "random@atm_robbery@return_wallet_male", "return_wallet_positive_a_player", 8.0, 3.0, 1000, 56, 1, false, false, false)
	Citizen.Wait(1000)
	DeleteEntity(prop)
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
function ai_cuffPed(ped)
    local ped = ped
    local data = STOPPED_PEDS[ped]
    print(ped)
    print(data.ped)
    loadAnimDict("mp_arrest_paired")
    loadAnimDict("mp_arresting")
    if (not isPedCuffed(ped)) then
        GUI.Variables.pullover.cuffs="~y~Rozkuj"
        local plrAnim = "cop_p2_back_left"
        local targetAnim = "crook_p2_back_left"
        AttachEntityToEntity(data.ped,GetPlayerPed(-1),11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
        TaskPlayAnim(data.ped,"mp_arrest_paired",targetAnim,8.0,-8.0,5500,33,0,false,false,false)
        TaskPlayAnim(GetPlayerPed(-1),"mp_arrest_paired",plrAnim,8.0, -8.0, 5500, 33, 0, false, false, false)
        Citizen.Wait(950)
        DetachEntity(data.ped,true,false)
        Citizen.Wait(3000)
        SetEnableHandcuffs(data.ped,true)
        SetPedCanRagdoll(data.ped,false)
        data.cuffed=true
        upcomingNotify = true
        Citizen.CreateThread(function()
            if (isPedCuffed(ped)) then
                TaskPlayAnim(data.ped,"mp_arresting","idle",8.0,-8,-1,49,0,0,0,0)
            end
        end)
        Citizen.Wait(900)
        DrawHelp("Podejdź do tylnych drzwi swojego radiowozu aby przetransportować zatrzymanego do więzienia.")
        Citizen.Wait(3500)
        upcomingNotify = false
        cuffedPed = {el=data.ped,pedID=ped}
    else
        data.cuffed=false
        GUI.Variables.pullover.cuffs="~y~Zakuj"
        AttachEntityToEntity(data.ped,GetPlayerPed(-1),11816,0,0.3,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
        TaskPlayAnim(GetPlayerPed(-1),"mp_arresting","a_uncuff",8.0,-8,-1,49,0,0,0,0)
        Citizen.Wait(2000)
        DetachEntity(data.ped,true,false)
        ClearPedSecondaryTask(GetPlayerPed(-1))
        StopAnimTask(data.ped, 'mp_arresting', 'idle', 1.0)
        SetEnableHandcuffs(data.ped,false)
        SetPedCanRagdoll(data.ped,true)
        cuffedPed = nil
    end
end
function ai_startPedPullover(ped, netID,pedType,vehicleStop)
    STOPPED_PEDS[netID] = {stopped=true, ped=ped,pedType=pedType,cuffed=false,vehicleStop=vehicleStop}
    STOPPED_PEDS[netID].blip = AddBlipForEntity(ped)
    SetBlipDisplay(STOPPED_PEDS[netID].blip, 2)
    SetBlipSprite(STOPPED_PEDS[netID].blip, 280)
    SetBlipColour(STOPPED_PEDS[netID].blip, 46)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Zatrzymana osoba")
    EndTextCommandSetBlipName(STOPPED_PEDS[netID].blip)
    local playerGroupId = GetPedGroupIndex(GetPlayerPed(-1))
    SetPedAsGroupMember(ped,playerGroupId)
end
function ai_endPedPullover(ped,vehicleStop)
    if (isPedCuffed(ped)) then
        exports.em_3dtext:DrawNotification("Centrala","Centrala","~r~Najpierw zdejmij kajdanki osobie zatrzymanej.",true)
        return
    end
    if (vehicleStop) then--{stopped=true,ped=driver.el,vehicle=veh.el,pedID=driver.id,pedType=driver.type,followMode=0,canInteract=false,cuffed=false}
        local pedElement = STOPPED_VEHS[vehicleStop].ped
        local vehicle = STOPPED_VEHS[vehicleStop].vehicle
        if (not IsPedInAnyVehicle(pedElement,false)) then
            TaskEnterVehicle(pedElement,vehicle,6000,-1,2.0,1,0)
        end
        TaskVehicleDriveWander(pedElement,vehicle,500.0,387)
        RemoveBlip(STOPPED_VEHS[vehicleStop].blip)
        DeleteEntity(STOPPED_VEHS[vehicleStop].blip)
        RemoveGroup(GetPedGroupIndex(GetPlayerPed(-1)))
        STOPPED_VEHS[vehicleStop] = nil
        isFleeing = false
        isPerformingVehicleStop = false
        if (STOPPED_PEDS[ped]) then
            STOPPED_PEDS[ped].stopped = false
            RemoveBlip(STOPPED_PEDS[ped].blip)
            DeleteEntity(STOPPED_PEDS[ped].blip)
            RemoveGroup(GetPedGroupIndex(GetPlayerPed(-1)))
            STOPPED_PEDS[ped] = nil
        end
    else
        STOPPED_PEDS[ped].stopped = false
        RemoveBlip(STOPPED_PEDS[ped].blip)
        DeleteEntity(STOPPED_PEDS[ped].blip)
        RemoveGroup(GetPedGroupIndex(GetPlayerPed(-1)))
        STOPPED_PEDS[ped] = nil
    end
    GUI.Variables.player.currentPed = nil
    GUI.Variables.player.distance = false
    GUI.Variables.player.currentVehicle = nil
    GUI.Variables.player.inVehicle=false
    GUI.pullover.cuffs = "~y~Zakuj"
    if (RageUI.Visible(GUI['pullover'])) then
        RageUI.Visible(GUI['pullover'],false)
    end
end

function ai_arrestPed(ped,pedID,vehicle,seat)
    ARRESTED_PEDS[pedID] = {ped=ped}
    if (STOPPED_PEDS[pedID] and STOPPED_PEDS[pedID].stopped) then
        RemoveBlip(STOPPED_PEDS[pedID].blip)
        DeleteEntity(STOPPED_PEDS[pedID].blip)
        STOPPED_PEDS[pedID].blip = nil
    end
    Citizen.CreateThread(function()
        RemoveGroup(GetPedGroupIndex(GetPlayerPed(-1)))
        ClearPedSecondaryTask(ped)
        ClearPedTasks(ped)
        TaskEnterVehicle(ped,vehicle,6000,seat,2.0,1,0)
        Wait(6000)
        SetPedConfigFlag(ped,292,true)
        DrawHelp("Wciśnij ~INPUT_BB407206~ aby wyświetlić trasę do najbliższego posterunku")
            exports.em_3dtext:DrawNotification("Centrala","Centrala","Pamiętaj o wezwaniu lawety po pojazd zatrzymanej osoby.",true)
    end)
end
local isVehicleInDropoffMarker = false
function ai_createDropoff()
    if (tablelength(ARRESTED_PEDS)>0 and not JAIL_BLIP) then
        local coords = getClosestCoordsToJail()
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(1)
                if (not JAIL_BLIP and tablelength(ARRESTED_PEDS)>0) then
                    JAIL_BLIP = AddBlipForCoord(coords[1],coords[2],coords[3])
                    SetBlipSprite(JAIL_BLIP,237)
                    SetBlipColour(JAIL_BLIP,17)
                    SetBlipDisplay(JAIL_BLIP,2)
                    SetBlipRoute(JAIL_BLIP,true)
                    SetBlipRouteColour(JAIL_BLIP,17)
                    DRAW_MARKER = true
                end
                if (DRAW_MARKER and tablelength(ARRESTED_PEDS)>0) then
                    DrawMarker(1,coords[1],coords[2],coords[3],0.0,0.0,0.0,0,180.0,0.0,1.5,1.5,1.5,122,199,74,90,false,true,2,nil,nil,false)
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                    if (vehicle and GetDistanceBetweenCoords(coords[1],coords[2],coords[3],GetEntityCoords(vehicle,false)) < 1.5*1.12 and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
                        isVehicleInDropoffMarker = vehicle
                        DrawHelp("Wciśnij ~INPUT_F66F32FE~ aby odesłać aresztowanego.")
                    else
                        isVehicleInDropoffMarker = false
                    end
                end
            end
        end)
    end
end
function ai_pedToJail()
    local vehicle = isVehicleInDropoffMarker
    
    if (vehicle and GetVehiclePedIsIn(PlayerPedId(),false) == vehicle) then
        if (tablelength(ARRESTED_PEDS)>0) then
            local selectedPed = GetPedInVehicleSeat(vehicle,1)
            local selectedPed2 = GetPedInVehicleSeat(vehicle,2)
            if (selectedPed ~= 0 ) then
                local pedID = NetworkGetNetworkIdFromEntity(selectedPed)
                while pedID<1 do
                    pedID = NetworkGetNetworkIdFromEntity(selectedPed)
                end
                local data = STOPPED_PEDS[pedID]
                TriggerServerEvent("pullover:checkPedIllegality",pedID,data.pedType)
                if (data and data.stopped) then
                    RemoveBlip(data.blip)
                    DeleteEntity(data.blip)
                    ClearPedTasksImmediately(data.ped)
                    RemovePedFromGroup(data.ped)
                    DeleteEntity(data.ped)
                    if data.vehicleStop then
                        local vehID = data.vehicleStop
                        if (DoesEntityExist(STOPPED_VEHS[vehID].vehicle)) then
                            DeleteEntity(STOPPED_VEHS[vehID].vehicle)
                            RemoveBlip(STOPPED_VEHS[vehID].blip)
                            DeleteEntity(STOPPED_VEHS[vehID].blip)
                        end
                        STOPPED_VEHS[vehID] = nil
                    end
                    STOPPED_PEDS[pedID]=nil
                    ARRESTED_PEDS[pedID]=nil
                end
                
            end
            if (selectedPed2 ~= 0) then
                local pedID = NetworkGetNetworkIdFromEntity(selectedPed2)
                while pedID<1 do
                    pedID = NetworkGetNetworkIdFromEntity(selectedPed2)
                end
                local data = STOPPED_PEDS[pedID]
                TriggerServerEvent("pullover:checkPedIllegality",pedID,data.pedType)
                if (data and data.stopped) then
                    RemoveBlip(data.blip)
                    DeleteEntity(data.blip)
                    ClearPedTasksImmediately(data.ped)
                    RemovePedFromGroup(data.ped)
                    DeleteEntity(data.ped)
                    if data.vehicleStop then
                        local vehID = data.vehicleStop
                        if (DoesEntityExist(STOPPED_VEHS[vehID].vehicle)) then
                            DeleteEntity(STOPPED_VEHS[vehID].vehicle)
                            RemoveBlip(STOPPED_VEHS[vehID].blip)
                            DeleteEntity(STOPPED_VEHS[vehID].blip)
                        end
                        STOPPED_VEHS[vehID] = nil
                    end
                    STOPPED_PEDS[pedID]=nil
                    ARRESTED_PEDS[pedID]=nil
                end
                
            end
            cuffedPed = nil
            isVehicleInDropoffMarker = false
            nearVehicleCuffed =false
            GUI.Variables.player.currentVehicle=nil
            GUI.Variables.player.distance = false
            GUI.Variables.player.inVehicle=false
            GUI.Variables.player.currentPed=nil
            isFleeing = false
            isPerformingVehicleStop = false
            if (JAIL_BLIP) then
                RemoveBlip(JAIL_BLIP)
                JAIL_BLIP = nil
                DRAW_MARKER = false
            end
        end
    end
end
Citizen.CreateThread(function()
    while true do

        if (GetVehiclePedIsIn(PlayerPedId(), false) == 0) then
            if (cuffedPed and cuffedPed.el) then
                if (isPedCuffed(cuffedPed.pedID) and not ARRESTED_PEDS[cuffedPed.pedID]) then
                    local coordA = GetEntityCoords(GetPlayerPed(-1),1)
                    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0,1.0,0.0)
                    local targetVehicle = GetVehicleInDirection(GetPlayerPed(-1),coordA,coordB)
                    if (targetVehicle) then
                        local model = GetDisplayNameFromVehicleModel(GetEntityModel(targetVehicle))
                        if (policeCars[model]) then
                            local doorPassengerLeft = GetWorldPositionOfEntityBone(targetVehicle,GetEntityBoneIndexByName(targetVehicle,"door_dside_r"))
                            local doorPassengerRight = GetWorldPositionOfEntityBone(targetVehicle,GetEntityBoneIndexByName(targetVehicle,"door_pside_r"))
                            local distanceLeft = GetDistanceBetweenCoords(doorPassengerLeft,coordA,1)
                            local distanceRight = GetDistanceBetweenCoords(doorPassengerRight,coordA,1)
                            if (distanceLeft <=1.0 or distanceRight <=1.0) then
                                nearVehicleCuffed = true
                                DrawHelp("Wciśnij ~INPUT_VEH_DUCK~ aby posadzić zatrzymanego w pojeździe")
                                if (distanceLeft < distanceRight and IsControlJustPressed(0,73)) then
                                    if (GetPedInVehicleSeat(targetVehicle,1) ~= 0) then
                                        exports.em_3dtext:DrawNotification("Centrala","Centrala","~r~To miejsce w pojeździe jest już zajęte",true)
                                    else
                                        ai_arrestPed(cuffedPed.el,cuffedPed.pedID,targetVehicle,1)
                                    end
                                elseif (distanceRight < distanceLeft and IsControlJustPressed(0,73)) then
                                    if (GetPedInVehicleSeat(targetVehicle,2) ~= 0) then
                                        exports.em_3dtext:DrawNotification("Centrala","Centrala","~r~To miejsce w pojeździe jest już zajęte",true)
                                    else
                                        ai_arrestPed(cuffedPed.el,cuffedPed.pedID,targetVehicle,2)
                                    end
                                end
                            else
                                nearVehicleCuffed = false
                            end
                        end
                    end
                end
            end
            local ped = GetPedInFront() 
            local pedType = GetPedType(ped)
            if (pedType == 4 or pedType == 5) then
                local pedID = NetworkGetNetworkIdFromEntity(ped)
                while pedID < 1 do
                    pedID = NetworkGetNetworkIdFromEntity(ped)
                end
                if (STOPPED_PEDS[pedID] and STOPPED_PEDS[pedID].stopped) then

                    local plrPos = GetEntityCoords(GetPlayerPed(-1),1)
                    local pedPos = GetEntityCoords(ped, 1)
                    local dist = GetDistanceBetweenCoords(plrPos, pedPos)
                    if (dist <=2.5) then
                        if (not upcomingNotify and not nearVehicleCuffed) then
                            DrawHelp("Naciśnij ~INPUT_PICKUP~ aby rozpocząć interakcję z zatrzymanym.")
                        end
                        GUI.Variables.player.distance = true
                        GUI.Variables.player.currentPed = pedID
                    else
                        GUI.Variables.player.distance = false
                        GUI.Variables.player.currentPed = nil
                        if (RageUI.Visible(GUI['pullover'])) then
                            RageUI.Visible(GUI['pullover'],false)
                        end
                    end
                end
                if (IsControlPressed(0,74) and ped and pedType) then
                    if (not IsPedDeadOrDying(ped)) then
                        
                        if (not STOPPED_PEDS[pedID] and not isPerformingVehicleStop) then
                            SetBlockingOfNonTemporaryEvents(ped,true)
                            ai_startPedPullover(ped, pedID,pedType)
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)
--[[
    Vehicle Pullovers
]]
function ai_returnToVehicle(ped)
    if (isPedCuffed(ped)) then
        exports.em_3dtext:DrawNotification("Centrala","Centrala","~r~Najpierw zdejmij kajdanki osobie zatrzymanej.",true)
        return
    end
    STOPPED_PEDS[ped].stopped = false
    
    RemoveBlip(STOPPED_PEDS[ped].blip)
    DeleteEntity(STOPPED_PEDS[ped].blip)
    if (RageUI.Visible(GUI['pullover'])) then
        RageUI.Visible(GUI['pullover'],false)
    end
    GUI.Variables.player.inVehicle=true
    RemoveGroup(GetPedGroupIndex(GetPlayerPed(-1)))
    TaskEnterVehicle(STOPPED_PEDS[ped].ped, STOPPED_VEHS[GUI.Variables.player.currentVehicle].vehicle, -1,-1,1.0,1,0)
    print('return to vehicle')
    print('inVehicle:'..tostring(GUI.Variables.player.inVehicle))
    STOPPED_PEDS[ped] = nil
end
function ai_stopVehicle()
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)
    if (vehicle ~=0) then
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        if (policeCars[model] and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
            local coordA = GetEntityCoords(vehicle,1)
            local coordB = GetOffsetFromEntityInWorldCoords(vehicle, 0.0,20.0,0.0)
            local targetVehicle = GetVehicleInDirection(vehicle,coordA,coordB)
            if (targetVehicle) then
                local ped = nil
                local vehID = NetworkGetNetworkIdFromEntity(targetVehicle)
                while (vehID<1) do
                    vehID = NetworkGetNetworkIdFromEntity(targetVehicle)
                end
                if (IsVehicleSeatFree(targetVehicle,-1)) then return end
                ped = GetPedInVehicleSeat(targetVehicle,-1)
                local pedType = GetPedType(ped)
                if (pedType == 4 or pedType == 5) then
                    local pedID = NetworkGetNetworkIdFromEntity(ped)
                    while (pedID<1) do
                        pedID = NetworkGetNetworkIdFromEntity(ped)
                    end
                    if (not isVehicleStopped(vehID) and not IsPedDeadOrDying(ped)) then
                        if (IsVehicleSirenOn(vehicle)) then
                            ai_startVehiclePullover(vehicle,{el=targetVehicle,id=vehID},{el=ped,id=pedID,type=pedType})
                        else
                            DrawHelp("Włącz sygnały świetlne, aby przejść do zatrzymania pojazdu")
                        end
                    end
                end
            end
        end
    end
end

function ai_startVehiclePullover(copCar, veh, driver)
    STOPPED_VEHS[veh.id] = {stopped=true,ped=driver.el,vehicle=veh.el,pedID=driver.id,pedType=driver.type,followMode=0,canInteract=false,cuffed=false}
    GUI.Variables.player.currentVehicle = veh.id
    isPerformingVehicleStop = true
    STOPPED_VEHS[veh.id].blip = AddBlipForEntity(veh.el)
    SetBlipDisplay(STOPPED_VEHS[veh.id].blip,2)
    SetBlipSprite(STOPPED_VEHS[veh.id].blip,225)
    SetBlipColour(STOPPED_VEHS[veh.id].blip,46)
    SetEntityHealth(ped,200)
    SetEntityAsMissionEntity(veh.el,true,true)
    SetEntityAsMissionEntity(driver.el,true,true)
    SetBlockingOfNonTemporaryEvents(driver.el,true)
    local chanceFlee = math.random(30)
    if (chanceFlee >=25) then
        SetDriverAbility(driver.el, 1.0) 
        SetDriverAggressiveness(driver.el, 1.0) 
        TaskVehicleDriveWander(driver.el, veh.el, 220.0,787260)
        isFleeing = STOPPED_VEHS[veh.id]
        DrawHelp("Kierowca ucieka, rusz w pościg - staraj się zablokować jego pojazd")
    else
        DrawHelp("Naciśnij ~INPUT_44A127F7~ aby zmienić pozycję zatrzymanego pojazdu")
        STOPPED_VEHS[veh.id].canInteract = true
    end
    local stoppedVehicle = STOPPED_VEHS[veh.id].vehicle
    GUI.Variables.player.inVehicle = true
    Citizen.CreateThread(function()
        while true do
            if GetVehiclePedIsIn(GetPlayerPed(-1),false) == 0 then
                if (canPlayerInteractWithDriver(veh.id)) then
                    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
	                local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 1.0, 0.0)
	                local vehNearBy = GetVehicleInDirection(GetPlayerPed(-1),coordA, coordB)
                    if (vehNearBy == stoppedVehicle) then
                        local driverDoor = GetWorldPositionOfEntityBone(stoppedVehicle, GetEntityBoneIndexByName(stoppedVehicle, "door_dside_f"))
                        local distance = GetDistanceBetweenCoords(driverDoor,coordA,1)
                        if (distance <= 1.6) then
                            if (GetPedInVehicleSeat(stoppedVehicle,-1) == driver.el and GUI.Variables.player.inVehicle) then
                                if (not upcomingNotify) then
                                    DrawHelp(nil,"VehiclePulloverInformation")
                                end
                                GUI.Variables.player.distance = true
                                GUI.Variables.player.currentPed = driver.id
                                
                                if (IsControlJustPressed(0,73) and GUI.Variables.player.inVehicle) then
                                    if (not IsPedDeadOrDying(driver.el)) then
                                        GUI.Variables.player.inVehicle = false
                                        SetBlockingOfNonTemporaryEvents(driver.el,true)
                                        local playerGroupId = GetPedGroupIndex(GetPlayerPed(-1))
                                        SetPedAsGroupMember(driver.el,playerGroupId)
                                        TaskLeaveVehicle(driver.el,veh.el,256)
                                        
                                        ai_startPedPullover(driver.el,driver.id,driver.type,veh.id)
                                    end
                                end
                            end
                        else
                            GUI.Variables.player.distance = false
                            GUI.Variables.player.currentPed = nil
                        end
                    end
                end
            end
            Citizen.Wait(0)
        end

    end)
end

function ai_followVehicle(vehicle)
    if (STOPPED_VEHS[vehicle]) then
        local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)
        if (vehicle ~=0) then
            local model = GetDisplayNameFromVehicleModel(GetEntityModel(playerVehicle))
            if (policeCars[model] and GetPedInVehicleSeat(playerVehicle,-1)==PlayerPedId()) then
                local pedVehicle = STOPPED_VEHS[vehicle].vehicle
                local followMode = STOPPED_VEHS[vehicle].followMode
                if (followMode==1) then
                    ClearPedSecondaryTask(STOPPED_VEHS[vehicle].ped)
                    ClearPedTasks(STOPPED_VEHS[vehicle].ped)
                    SetBlockingOfNonTemporaryEvents(STOPPED_VEHS[vehicle].ped,true)
                    STOPPED_VEHS[vehicle].followMode=0
                else
                    STOPPED_VEHS[vehicle].followMode=1
                    print('follow')
                    TaskVehicleEscort(STOPPED_VEHS[vehicle].ped,pedVehicle,playerVehicle,-1,500.0,828,1.0,1,10.0)
                end 
            end
        end
    end
end
Citizen.CreateThread(function()
    while true do
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)
        if (vehicle ~=0) then
            local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            if (policeCars[model] and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
                if (isFleeing) then
                    local vehData = isFleeing
                    local hpEngine = GetVehHealthPercent(vehData.vehicle)
                    if (hpEngine<=25) then
                        if (not GUI.Variables.player.distance) then
                            DrawHelp("Uciekający zatrzymał się. Możesz przystąpić do zatrzymania.")
                        end
                        TaskVehicleTempAction(vehData.ped,vehData.vehicle,6,9999)
                        SetBlockingOfNonTemporaryEvents(vehData.ped,true)
                        local playerGroupId = GetPedGroupIndex(GetPlayerPed(-1))
                        SetPedAsGroupMember(vehData.ped,playerGroupId)
                        vehData.canInteract = true
                    end
                end
            end
        end

        Citizen.Wait(0)
    end
end)
--[[
    config loader
]]
RegisterCommand('rgroup',function()
    RemoveGroup(GetPedGroupIndex(GetPlayerPed(-1)))
    print("DEV_COMMAND: Group removed")
end)
RegisterCommand('model',function()
    print(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(GetPlayerPed(-1),false))))
end)
function ai_loadConfig()
    local jailsFile = LoadResourceFile(GetCurrentResourceName(), "config/jails.json")
    JAILS = json.decode(jailsFile)
    JAILS = JAILS[1]['jails']
end

ai_loadConfig()
RegisterCommand("pokazjaile",ai_createDropoff)
RegisterCommand("pojazdzatrzymaj",ai_stopVehicle)
RegisterCommand("odeslijpeda",ai_pedToJail)
RegisterKeyMapping("pojazdzatrzymaj","PD: Zatrzymanie pojazdu","keyboard","LSHIFT")
RegisterKeyMapping("odeslijpeda","PD: Odesłanie aresztowanego do wiezienia (zatrzymanie)","keyboard","h")
RegisterKeyMapping("pokazjaile","PD: Pokaż trasę do posterunku (zatrzymanie)","keyboard","u")