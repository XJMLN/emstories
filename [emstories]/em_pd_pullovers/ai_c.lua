--TextDraws
STOPPED_PEDS = {}
JAILS = {}
JAIL_BLIP = nil
policeCars = {
    ['14pdcharger']=true,
}
ARRESTED_PEDS = {}
local upcomingNotify = false
local cuffedPed = nil
local nearVehicleCuffed = false
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
function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end
function isPedCuffed(ped)
    if (not STOPPED_PEDS[ped]) then return false end
    return STOPPED_PEDS[ped].cuffed
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
    loadAnimDict("mp_arrest_paired")
    loadAnimDict("mp_arresting")
    if (not isPedCuffed(ped)) then
        local plrAnim = "cop_p2_back_left"
        local targetAnim = "crook_p2_back_left"
        AttachEntityToEntity(STOPPED_PEDS[ped].ped,GetPlayerPed(-1),11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
        TaskPlayAnim(STOPPED_PEDS[ped].ped,"mp_arrest_paired",targetAnim,8.0,-8.0,5500,33,0,false,false,false)
        TaskPlayAnim(GetPlayerPed(-1),"mp_arrest_paired",plrAnim,8.0, -8.0, 5500, 33, 0, false, false, false)
        Citizen.Wait(950)
        DetachEntity(STOPPED_PEDS[ped].ped,true,false)
        Citizen.Wait(3000)
        SetEnableHandcuffs(STOPPED_PEDS[ped].ped,true)
        SetPedCanRagdoll(STOPPED_PEDS[ped].ped,false)
        STOPPED_PEDS[ped].cuffed=true
        upcomingNotify = true
        Citizen.CreateThread(function()
            if (isPedCuffed(ped)) then
                TaskPlayAnim(STOPPED_PEDS[ped].ped,"mp_arresting","idle",8.0,-8,-1,49,0,0,0,0)
            end
        end)
        Citizen.Wait(900)
        DrawHelp("Podejdź do tylnych drzwi swojego radiowozu aby przetransportować zatrzymanego do więzienia.")
        Citizen.Wait(3500)
        upcomingNotify = false
        cuffedPed = {el=STOPPED_PEDS[ped].ped,pedID=ped}
    else
        STOPPED_PEDS[ped].cuffed=false
        AttachEntityToEntity(STOPPED_PEDS[ped].ped,GetPlayerPed(-1),11816,0,0.3,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
        TaskPlayAnim(GetPlayerPed(-1),"mp_arresting","a_uncuff",8.0,-8,-1,49,0,0,0,0)
        Citizen.Wait(2000)
        DetachEntity(STOPPED_PEDS[ped].ped,true,false)
        ClearPedSecondaryTask(GetPlayerPed(-1))
        StopAnimTask(STOPPED_PEDS[ped].ped, 'mp_arresting', 'idle', 1.0)
        SetEnableHandcuffs(STOPPED_PEDS[ped].ped,false)
        SetPedCanRagdoll(STOPPED_PEDS[ped].ped,true)
        cuffedPed = nil
    end
end
function ai_startPedPullover(ped, netID,pedType)
    ai_showBadge()
    STOPPED_PEDS[netID] = {stopped=true, ped=ped,pedType=pedType,cuffed=false}
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
function ai_endPedPullover(ped)
    STOPPED_PEDS[ped].stopped = false
    RemoveBlip(STOPPED_PEDS[ped].blip)
    DeleteEntity(STOPPED_PEDS[ped].blip)
    RemoveGroup(GetPedGroupIndex(GetPlayerPed(-1)))
    STOPPED_PEDS[ped] = nil
    GUI.Variables.player.currentPed = nil
    GUI.Variables.player.distance = false
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
                TriggerServerEvent("pullover:checkPedIllegality",pedID,STOPPED_PEDS[pedID].pedType)
                if (STOPPED_PEDS[pedID] and STOPPED_PEDS[pedID].stopped) then
                    RemoveBlip(STOPPED_PEDS[pedID].blip)
                    DeleteEntity(STOPPED_PEDS[pedID].blip)
                    ClearPedTasksImmediately(STOPPED_PEDS[pedID].ped)
                    RemovePedFromGroup(STOPPED_PEDS[pedID].ped)
                    DeleteEntity(STOPPED_PEDS[pedID].ped)
                    STOPPED_PEDS[pedID]=nil
                    ARRESTED_PEDS[pedID]=nil
                end
                
            end
            if (selectedPed2 ~= 0) then
                local pedID = NetworkGetNetworkIdFromEntity(selectedPed2)
                while pedID<1 do
                    pedID = NetworkGetNetworkIdFromEntity(selectedPed2)
                end
                TriggerServerEvent("pullover:checkPedIllegality",pedID,STOPPED_PEDS[pedID].pedType)
                if (STOPPED_PEDS[pedID] and STOPPED_PEDS[pedID].stopped) then
                    RemoveBlip(STOPPED_PEDS[pedID].blip)
                    DeleteEntity(STOPPED_PEDS[pedID].blip)
                    ClearPedTasksImmediately(STOPPED_PEDS[pedID].ped)
                    RemovePedFromGroup(STOPPED_PEDS[pedID].ped)
                    DeleteEntity(STOPPED_PEDS[pedID].ped)
                    STOPPED_PEDS[pedID]=nil
                    ARRESTED_PEDS[pedID]=nil
                end
                
            end
            cuffedPed = nil
            isVehicleInDropoffMarker = false
            nearVehicleCuffed =false
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
                        
                        if (not STOPPED_PEDS[pedID]) then
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

function ai_loadConfig()
    local jailsFile = LoadResourceFile(GetCurrentResourceName(), "config/jails.json")
    JAILS = json.decode(jailsFile)
    JAILS = JAILS[1]['jails']
end

ai_loadConfig()
RegisterCommand("pokazjaile",ai_createDropoff)
RegisterCommand("odeslijpeda",ai_pedToJail)
RegisterKeyMapping("odeslijpeda","PD: Odesłanie aresztowanego do wiezienia (zatrzymanie)","keyboard","h")
RegisterKeyMapping("pokazjaile","PD: Pokaż trasę do posterunku (zatrzymanie)","keyboard","u")