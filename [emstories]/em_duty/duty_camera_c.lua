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
    Citizen.Wait(500)
    FreezeEntityPosition(GetPlayerPed(-1), true)
end
function AnimCam()
    local playerPed = PlayerPedId()
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

function Visible()
    while enable == true do
        Citizen.Wait(0)
        Collision()
    end
end
