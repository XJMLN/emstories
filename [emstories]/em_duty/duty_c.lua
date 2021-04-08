DecorRegister("__PLAYER_DEPARTMENT_",3)
DecorRegister("__PLAYER_FACTION_",3)
vehicleRoom = nil
plrFactionID = nil
local plrDepartmentID = nil
local enable = false
local cam2 = nil
local camName=""
local camSkin = nil
local returnPos = nil

local Camera = {
	body = {x = 455.24, y = -980.77, z = 30.9, fov = 30.00,rot=-90.00},
    garage = {x = 228.04, y=-999.21, z = -99.1, fov = 30.00,rot=0},
}

function restoreDefaultVariables()
    menusVariables = {
        vehiclesMarkIndex = 1,
        vehiclesUMarkIndex = 1,
        vehicleData = {},
        vehicleSelected = false,
        skinSelected = false,
        showExtras = false,
        extras = nil,
        error = false,
        names = {
            [3]={marked="Wozy Strażackie",unmarked="Pojazdy Użytkowe"},
            [2]={marked="Ambulanse",unmarked="Pojazdy Użytkowe"},
            [1]={marked="Oznakowane",unmarked="Nieoznakowane"},
        }
    }
    vehicleRoom = nil
    plrFactionID = nil
    plrDepartmentID = nil
    enable = false
    cam2 = nil
    camName=""
    camSkin = nil
    returnPos = nil
end
function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for i=1,#dutyMarkers do
            loc = dutyMarkers[i]['pos']
            DrawMarker(2,loc[1],loc[2],loc[3],0.0,0.0,0.0,0,180.0,0.0,0.5,0.5,0.5,122,199,74,90,true,true,2,nil,nil,false)
            local plrCoord = GetEntityCoords(PlayerPedId(), false)
            if (GetDistanceBetweenCoords(loc[1],loc[2],loc[3],plrCoord) < 0.5*1.12 and GetVehiclePedIsIn(PlayerPedId(), false) == 0) then
                DrawHelp("Wciśnij ~INPUT_PICKUP~ aby rozpocząć służbę.")
                if (IsControlJustPressed(0,38)) then
                    TriggerServerEvent("em_duty:getPlayerFaction",dutyMarkers[i]['factionID'],dutyMarkers[i]['departmentID'],GetEntityModel(PlayerPedId()))
                    returnPos = loc
                end
            end
        end
    end
end)

function loadSkin(skin)
    local playerPed = PlayerPedId()
    local character = json.decode(skin)
        if character['ears_1'] == -1 then
            ClearPedProp(playerPed, 2)
        else
            SetPedPropIndex			(playerPed, 2,		character['ears_1'],			character['ears_2'], true)						-- Ears Accessories
        end
    
        SetPedComponentVariation	(playerPed, 8,		character['tshirt_1'] -1,			character['tshirt_2']-1, 0)					-- Tshirt
        SetPedComponentVariation	(playerPed, 11,		character['torso_1']-1,			character['torso_2']-1, 0)					-- torso parts
        SetPedComponentVariation	(playerPed, 3,		character['arms']-1,				character['arms_2']-1, 0)						-- Amrs
        SetPedComponentVariation	(playerPed, 10,		character['decals_1']-1,			character['decals_2']-1, 0)					-- decals
        SetPedComponentVariation	(playerPed, 4,		character['pants_1']-1,			character['pants_2']-1, 0)					-- pants
        SetPedComponentVariation	(playerPed, 6,		character['shoes_1']-1,			character['shoes_2']-1, 0)					-- shoes
        SetPedComponentVariation	(playerPed, 1,		character['mask_1']-1,			character['mask_2']-1, 0)						-- mask
        SetPedComponentVariation	(playerPed, 9,		character['bproof_1']-1,			character['bproof_2']-1, 0)					-- bulletproof
        SetPedComponentVariation	(playerPed, 7,		character['chain_1']-1,			character['chain_2']-1, 0)					-- chain
        SetPedComponentVariation	(playerPed, 5,		character['bags_1']-1,			character['bags_2']-1, 0)						-- Bag
    
        if (character['helmet_1']) then
            if character['helmet_1'] == 0 then
                ClearPedProp(playerPed, 0)
            else
                SetPedPropIndex			(playerPed, 0,		character['helmet_1']-1,			character['helmet_2']-1, true)					-- Helmet
            end
        else
            ClearPedProp(playerPed, 0)
        end
        if (character['glasses_1']) then
            if character['glasses_1'] == 0 then
                ClearPedProp(playerPed, 1)
            else
                SetPedPropIndex			(playerPed, 1,		character['glasses_1']-1,			character['glasses_2']-1, true)					-- Glasses
            end 

        else 
            ClearPedProp(playerPed, 1)
        end
        if (character['watches_1']) then
            if character['watches_1'] == 0 then
                ClearPedProp(playerPed, 6)
            else
                SetPedPropIndex			(playerPed, 6,		character['watches_1']-1,			character['watches_2']-1, true)					-- Watches
            end
        else 
            ClearPedProp(playerPed, 6)
        end 
        if (character['bracelets_1']) then
            if character['bracelets_1'] == 0 then
                ClearPedProp(playerPed,	7)
            else
                SetPedPropIndex			(playerPed, 7,		character['bracelets_1']-1,		character['bracelets_2']-1, true)				-- Bracelets
            end
        else 
            ClearPedProp(playerPed,	7)
        end
end

function duty_prepareMenu(data,factionID,departmentID)
    plrFactionID = factionID
    plrDepartmentID = departmentID
    for i,v in ipairs(data) do
        table.insert(skins,{skin_id=v.skin_id,skin_data=v.skin_data,Name=v.name})
        table.insert(vehicles[v.vehicle_type],{type=v.vehicle_type,Name=v.vehicle_desc,hash=v.vehicle_hash,extras=v.vehicle_extras,livery=v.vehicle_livery})
    end
    enable = true
    DisplayRadar(false)
    AnimCam()
    RageUI.Visible(MENUS['MainMenu'], true)
    Visible()
end

function setVehicleExtras(veh,data)
    local data = json.decode(data)
    for i,v in ipairs(data) do
        SetVehicleExtra(veh,v.id,v.state)
    end
end
function duty_createVehicle(vehData)
    local hash = vehData['hash']
    local playerPed = PlayerPedId()

    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(500)
    end
    if (vehicles[playerPed]) then
        if (DoesEntityExist(vehicles[playerPed].vehicle)) then
            DeleteVehicle(vehicles[playerPed].vehicle)
        end
        vehicles[playerPed] = nil
    end
    TriggerServerEvent("em_duty:ghost",true)
    local spawnData = GARAGE_POS[plrFactionID][plrDepartmentID]
    local spawnHeading = spawnData['heading']
    vehicles[playerPed] = {}
    vehicles[playerPed].vehicle = CreateVehicle(hash,spawnData[1],spawnData[2],spawnData[3],spawnHeading, true,false)
    if (vehData['type'] == 0) then
        setVehicleExtras(vehicles[playerPed].vehicle,vehData['extras'])
    end
    SetVehicleLivery(vehicles[playerPed].vehicle,vehData['livery'])
    SetVehicleOnGroundProperly(vehicles[playerPed].vehicle)
    SetModelAsNoLongerNeeded(hash)
    SetEntityAsMissionEntity(vehicles[playerPed].vehicle,true,true)
    SetPedIntoVehicle(playerPed,vehicles[playerPed].vehicle,-1)
    Citizen.Wait(5000)
    TriggerServerEvent("em_duty:ghost",false)
end
function startDuty(vehData)
    local playerPed = GetPlayerPed(-1)
    
    DoScreenFadeOut(1000)
	Wait(1000)
	SetCamActive(camSkin,  false)
	RenderScriptCams(false,  false,  0,  true,  true)
	enable = false
	EnableAllControlActions(0)
    
    FreezeEntityPosition(GetPlayerPed(-1), false)
    SetEntityCoords(playerPed, loc[1],loc[2],loc[3])
	SetEntityHeading(playerPed, 90.00)
	Wait(1000)
    duty_createVehicle(vehData)
    DisplayRadar(true)
	DoScreenFadeIn(1000)
    DecorSetInt(PlayerPedId(-1),"__PLAYER_DEPARTMENT_",plrDepartmentID)
    DecorSetInt(PlayerPedId(-1),"__PLAYER_FACTION_",plrFactionID)
    TriggerServerEvent("em_duty:startPlayerDuty",plrFactionID,plrDepartmentID)
    restoreDefaultVariables()

end

function CreateSkinCam(camera)
	if camSkin then
		local newCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Camera[camera].x, Camera[camera].y, Camera[camera].z, 0.00, 0.00, Camera[camera].rot, Camera[camera].fov, false, 0)
		PointCamAtCoord(newCam, Camera[camera].x, Camera[camera].y, Camera[camera].z)
   		SetCamActiveWithInterp(newCam, camSkin, 2000, true, true)
   		camSkin = newCam
	else
		camSkin = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Camera[camera].x, Camera[camera].y, Camera[camera].z, 0.00, 0.00, Camera[camera].rot, Camera[camera].fov, false, 0)
	    SetCamActive(cam2, true)
	    RenderScriptCams(true, false, 2000, true, true) 
	end
    camName = camera
end

function showRoom(hash)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(500)
    end
    if (vehicleRoom) then
        DeleteVehicle(vehicleRoom)
        vehicleRoom = nil
    end
    vehicleRoom = CreateVehicle(hash,231.08,-986.6,-98.93,143.81,false,false)
    SetEntityAsMissionEntity(vehicleRoom,true,true)
    FreezeEntityPosition(vehicleRoom,true)
end

function getAvailableExtras()
    local vehicleExtras = {}
    if (vehicleRoom and DoesEntityExist(vehicleRoom)) then
        for i=0,20 do
            if (DoesExtraExist(vehicleRoom, i)) then
                table.insert(vehicleExtras,{extraId=i,Name="Dodatek #"..i, state=(IsVehicleExtraTurnedOn(vehicleRoom, i) == 1)})
            end
        end
    end
    return vehicleExtras
end

function Collision()
    for i=1,256 do
        if NetworkIsPlayerActive(i) then
            SetEntityVisible(GetPlayerPed(i), false, false)
            SetEntityVisible(PlayerPedId(), true, true)
            SetEntityNoCollisionEntity(GetPlayerPed(i), GetPlayerPed(-1), false)
        end
    end
end

function backToDefault()
    if (camName == "garage") then
            local playerPed = PlayerPedId()
            FreezeEntityPosition(GetPlayerPed(-1), false)
            DoScreenFadeOut(1000)
            Citizen.Wait(3000)
            DestroyAllCams(true)
            cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Camera['body'].x, Camera['body'].y, Camera['body'].z, 0.00, 0.00, -90.00, Camera['body'].fov, false, 0)
            SetCamActive(cam2, true)
            RenderScriptCams(true, false, 2000, true, true)
            
            SetEntityCoords(GetPlayerPed(-1), 460.75, -980.77, 30.69, 0.0, 0.0, 0.0, true)
            SetEntityHeading(GetPlayerPed(-1), 90.00)
            DoScreenFadeIn(2000)
            Citizen.Wait(500)
            FreezeEntityPosition(GetPlayerPed(-1), true)
            CreateSkinCam("body")
    end
end
function setGarageCam()
    local playerPed = PlayerPedId()
    FreezeEntityPosition(GetPlayerPed(-1), false)
    DoScreenFadeOut(1000)
    LoadScene(230.42,-990.1,-99.2)
    Citizen.Wait(1000)
    DestroyAllCams(true)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Camera['garage'].x, Camera['garage'].y, Camera['garage'].z, 0.00, 0.00, 0.00, Camera['garage'].fov, false, 0)
    SetCamActive(cam2, true)
    RenderScriptCams(true, false, 2000, true, true)
    CreateSkinCam("garage")
    Citizen.Wait(3000)
    
    RequestModel(vehicles[1][1]['hash'])
    while not HasModelLoaded(vehicles[1][1]['hash']) do
        Citizen.Wait(500)
    end
    if (vehicleRoom) then
        DeleteVehicle(vehicleRoom)
        vehicleRoom = nil
    end
    vehicleRoom = CreateVehicle(vehicles[1][1]['hash'],231.08,-986.6,-98.93,143.81,false,false)
    SetEntityCoords(GetPlayerPed(-1), 230.42,-990.1,-99.2, 0.0, 0.0, 0.0, true)
    SetEntityHeading(GetPlayerPed(-1), 160.66)
    Citizen.Wait(2000)
    DoScreenFadeIn(2000)
    RageUI.Visible(MENUS['MainMenu'], false)
    RageUI.Visible(MENUS['garage'], true)
    MENUS.garage.Controls.Back.Enabled = true
    Citizen.Wait(500)

    FreezeEntityPosition(GetPlayerPed(-1), true)
end
function AnimCam()
    local playerPed = PlayerPedId()
    DoScreenFadeOut(1000)
    LoadScene(460.75, -980.77, 30.69)
    Citizen.Wait(5000)
    DestroyAllCams(true)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Camera['body'].x, Camera['body'].y, Camera['body'].z, 0.00, 0.00, -90.00, Camera['body'].fov, false, 0)
    SetCamActive(cam2, true)
    RenderScriptCams(true, false, 2000, true, true)
    
    SetEntityCoords(GetPlayerPed(-1), 460.75, -980.77, 30.69, 0.0, 0.0, 0.0, true)
    SetEntityHeading(GetPlayerPed(-1), 90.00)
    Citizen.Wait(1000)
    DoScreenFadeIn(2000)
    
    SetEntityCoords(GetPlayerPed(-1), 460.75, -980.77, 30.69, 0.0, 0.0, 0.0, true)
	SetEntityHeading(GetPlayerPed(-1), 90.00)
    Citizen.Wait(500)
    FreezeEntityPosition(GetPlayerPed(-1),true)
    CreateSkinCam("body")
end

function Visible()
    while enable == true do
        Citizen.Wait(0)
        Collision()
    end
end


RegisterNetEvent("em_duty_client:returnDepartmentData")
AddEventHandler("em_duty_client:returnDepartmentData",duty_prepareMenu)