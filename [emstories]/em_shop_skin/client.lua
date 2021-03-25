clotheshop = false
local clothesShops = {
	{-708.61,-160.03,37.42},
	{-1188.76,-769.26,17.33},
	{-1457.31,-241.28,49.81},
	{-158.88,-297.31,39.73},
	{121.12,-225.95,54.56},
	{429.99,-799.83,29.49},
	{71.95,-1399.16,29.38},
	{1.21,6512.64,31.88},
	{617.69,2765.24,42.09},
}
function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end
menuOpened = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		for i,v in ipairs(clothesShops) do
        	DrawMarker(1,v[1],v[2],v[3],0.0,0.0,0.0,0,180.0,0.0,0.8,0.8,0.8,122,199,74,90,false,true,2,nil,nil,false)

        	local playerCoord = GetEntityCoords(PlayerPedId(), false)
        	local locVector = vector3(v[1],v[2],v[3])
        	if Vdist2(playerCoord,locVector) < 0.5*1.12 and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
				if (not menuOpened) then 
					DrawHelp("Wciśnij ~INPUT_PICKUP~ aby otworzyć kreator postaci.")
				end
            	if IsControlJustReleased(0,38) then
					menuOpened = true
               		TriggerServerEvent("mpcreator:getSkinData")
            	end
			end
		end

    	end
end)
function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end
function reloadMenuFreeMode()
	submenuAppearance.SubMenu:Clear()
	submenuClothes.SubMenu:Clear()
	AddMenuAppearance(submenuAppearance)
	AddMenuClothes(submenuClothes)
end
setCamera = false

function camera()
	Citizen.CreateThread(function()
		local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		SetCamActive(cam,  true)
		RenderScriptCams(true,  false,  0,  true,  true)
		
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local camPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 2.0, 0.0)
		
		SetCamCoord(cam, camPos.x, camPos.y, camPos.z+0.7)
		PointCamAtCoord(cam,pos.x,pos.y,pos.z+0.7)
		
		local pedHeading = GetEntityHeading(PlayerPedId())
		local setCam = GetFollowPedCamViewMode()

		SetFollowPedCamViewMode(0)
		
		while setCamera do
			SetEntityLocallyVisible(PlayerPedId())
			Citizen.Wait(0)

				DisableAllControlActions(0)
				coords = GetEntityCoords(GetPlayerPed(-1),true)
				if (IsDisabledControlPressed(0, 32) and (GetCamFov(cam)>=9.0)) then
					SetCamFov(cam, GetCamFov(cam)- 2.0)
				end
				if (IsDisabledControlPressed(0, 33) and (GetCamFov(cam)<=91.0)) then
					SetCamFov(cam, GetCamFov(cam)+ 2.0)
				end
				if (IsDisabledControlPressed(0, 34)) then
					pedHeading=pedHeading-1.5
					SetEntityHeading(PlayerPedId(), pedHeading)
				end
				if (IsDisabledControlPressed(0, 35)) then
					pedHeading=pedHeading+1.5
					SetEntityHeading(PlayerPedId(), pedHeading)
				end
				HideHudComponentThisFrame(19)
				HideHudComponentThisFrame(20)
		end
		SetCamActive(cam,  false)
		RenderScriptCams(false,  false,  0,  true,  true)
		SetFollowPedCamViewMode(setCam)
	end)
end
RegisterNetEvent('mpcreator:OpenClothesMenu')
AddEventHandler('mpcreator:OpenClothesMenu',function(skin)
	local skin = skin
	if (showText) then 
		showText = false 
		ClearPrints()
	end
	setCamera = true
	camera()
	Character = skin
	TriggerEvent('skinchanger:loadSkin', skin)
	clotheshop = true
	reloadMenuOtherPed()
	otherPedMenu:Visible(true)
end)

function reloadMenuOtherPed()
	otherPedMenu:Clear()
	AddMenuClothes(otherPedMenu)
end

function changemodel(skin)
    local model = GetHashKey(skin)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end
		LoadDefaultComponents()
        SetPlayerModel(PlayerId(), model)
        if skin ~= "mp_f_freemode_01" and skin ~= "mp_m_freemode_01" then 
            SetPedRandomComponentVariation(GetPlayerPed(-1), true)
			
        elseif skin == "mp_m_freemode_01" then
			Character['sex'] = 0
            SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 11, 146, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 4, 3, 7, 2)
			SetPedComponentVariation(GetPlayerPed(-1), 6, 12, 12, 2)
			SetPedHeadBlendData(GetPlayerPed(-1), 29, 29, 0, 29, 29, 0, 1.0, 1.0, 0, true)
			
			Character['mom'] = 29
			Character['Dad'] = 29
			Character['face'] = 1.0
			Character['skin'] = 1.0
			Character['tshirt_1'] = 15
			Character['torso_1'] = 146
			Character['pants_1'] = 3
			Character['pants_2'] = 7
			Character['shoes_1'] = 12
			Character['shoes_2'] = 12
			
			reloadMenuFreeMode()
		elseif skin == "mp_f_freemode_01" then
			Character['sex'] = 1
            SetPedComponentVariation(GetPlayerPed(-1), 11, 27, 0, 2)--torso_1
            SetPedComponentVariation(GetPlayerPed(-1), 4, 3, 15, 2)--pants_1
			SetPedComponentVariation(GetPlayerPed(-1), 6, 66, 5, 2)--shoes_1
			SetPedHeadBlendData(GetPlayerPed(-1), 29, 29, 0, 29, 29, 0, 1.0, 1.0, 0, true)
			
			Character['mom'] = 29
			Character['Dad'] = 29
			Character['face'] = 1.0
			Character['skin'] = 1.0
			Character['glasses_1'] = -1
			Character['torso_1'] = 27
			Character['pants_1'] = 3
			Character['pants_2'] = 15
			Character['shoes_1'] = 66
			Character['shoes_2'] = 5
			reloadMenuFreeMode()
        end
		Character['model_hash'] = model
		reloadMenuOtherPed()
		--_menuPool:RefreshIndex()
        SetModelAsNoLongerNeeded(model)
    else
    end
end