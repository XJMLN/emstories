local Camera = {
	face = {x = 402.92, y = -1000.72, z = -98.45, fov = 10.00},
	body = {x = 402.92, y = -1000.72, z = -99.01, fov = 30.00},
    lhand = {x = 402.89, y= -1000.72, z= -99.01,fov=10.00},
    rhand = {x=402.89,y=-1000.72,z=-99.01,fov=10.00},
}
local Sex = 0
local departments = {
    [3]={
        [1]=1
    },
    [2]={
        [1]=2,
        [2]=3,
        [3]=4,
    },
    [1]={
        [1]=5,
        [2]=6,
        [3]=7,
    }
}

function LoadDefaultComponents()
    for i=1, #Components, 1 do
		Character[Components[i].name] = Components[i].value
	end
end
function creator_changeModel(model)
    LoadDefaultComponents()
    local skin = GetHashKey(model)
    Character['model_hash']=skin
    if (IsModelInCdimage(skin) and IsModelValid(skin)) then
        RequestModel(skin)
        while not HasModelLoaded(skin) do
            Citizen.Wait(0)
        end
        SetPlayerModel(PlayerId(), skin)
        SetPedDefaultComponentVariation(PlayerPedId())
        if model == 'mp_m_freemode_01' then
            SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 11, 15, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 4, 61, 4, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 6, 34, 0, 2) 

            Character['arms'] = 15
            Character['torso_1'] = 15
            Character['tshirt_1'] = 15
            Character['pants_1'] = 61
            Character['pants_2'] = 4
            Character['shoes_1'] = 34
            Character['glasses_1'] = 0


        elseif model == 'mp_f_freemode_01' then
            SetPedComponentVariation(GetPlayerPed(-1), 3, 15, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 11, 5, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 4, 57, 0, 2)
            SetPedComponentVariation(GetPlayerPed(-1), 6, 35, 0, 2)
            Character['arms'] = 15
            Character['torso_1'] = 5
            Character['tshirt_1'] = 15
            Character['pants_1'] = 57
            Character['pants_2'] = 0
            Character['shoes_1'] = 35
            Character['glasses_1'] = -1
        end
        SetModelAsNoLongerNeeded(skin)
        clothes = GetClothesData()
    end
end

function creator_changeSex(sex)
    if (sex == 1) then
        Character['sex'] = 0
        Sex = 0
        pedModel = "mp_m_freemode_01"
    else
        Character['sex'] = 1
        Sex = 1
        pedModel = "mp_f_freemode_01"
    end
    
    creator_changeModel(pedModel)
end
local factions = nil
function CharCreatorAnimation(faction)
    factions = faction
	enable = true
	DisplayRadar(false)
	AnimCam()
	Visible()
end

function AnimCam()
    creator_changeModel("mp_m_freemode_01")
	local playerPed = PlayerPedId()
    DoScreenFadeOut(1000)
    Citizen.Wait(4000) 
    DestroyAllCams(true)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Camera['body'].x, Camera['body'].y, Camera['body'].z, 0.00, 0.00, 0.00, Camera['body'].fov, false, 0)
    SetCamActive(cam2, true)
    RenderScriptCams(true, false, 2000, true, true) 
    Citizen.Wait(500)
    DoScreenFadeIn(2000)
    SetEntityCoords(GetPlayerPed(-1), 405.59, -997.18, -99.00, 0.0, 0.0, 0.0, true)
    SetEntityHeading(GetPlayerPed(-1), 90.00)
    
    Citizen.Wait(500)
    cam3 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.99, -998.02, -99.00, 0.00, 0.00, 0.00, 50.00, false, 0)
    PointCamAtCoord(cam3, 402.99, -998.02, -99.00)
    SetCamActiveWithInterp(cam2, cam3, 5000, true, true)
    LoadAnim("mp_character_creation@customise@male_a")
    TaskPlayAnim(GetPlayerPed(-1), "mp_character_creation@customise@male_a", "intro", 1.0, 1.0, 4000, 0, 1, 0, 0, 0)
    Citizen.Wait(5000)

    local coords = GetEntityCoords(GetPlayerPed(-1))
    if GetDistanceBetweenCoords(coords, 402.89, -996.87, -99.0, true) > 0.5 then
    	SetEntityCoords(GetPlayerPed(-1), 402.89, -996.87, -99.0, 0.0, 0.0, 0.0, true)
    	SetEntityHeading(GetPlayerPed(-1), 173.97)
    end

    Citizen.Wait(100)
    RageUI.Visible(MENUS['MainMenu'], true)
    Citizen.Wait(1000)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    CreateSkinCam("body")
end

function EndCharCreator()
	local playerPed = GetPlayerPed(-1)
    Character['sex'] = Sex
    TriggerServerEvent("em_shop_skins:save",Character)
	DoScreenFadeOut(1000)
	Wait(1000)
	SetCamActive(camSkin,  false)
	RenderScriptCams(false,  false,  0,  true,  true)
	enable = false
	EnableAllControlActions(0)
    FreezeEntityPosition(GetPlayerPed(-1), false)
	SetEntityCoords(playerPed, 405.59, -997.18, -99.00)
	SetEntityHeading(playerPed, 90.00)
	Wait(1000)
    local spawnNumber = DecorGetInt(PlayerPedId(-1),"selectedSpawn")
    if (factions ~=4) then
        TriggerServerEvent("em_core:setPlayerFaction",factions,departments[factions][spawnNumber])
    end
    TriggerServerEvent("em_core:spawnPlayer",spawnNumber,factions,true)
	DisplayRadar(true)
	DoScreenFadeIn(1000)
	Wait(1000)
    TriggerEvent("em:showHUD",factions)
end

function LoadAnim(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Wait(10)
  end
end

function CreateSkinCam(camera)
	if camSkin then
		local newCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Camera[camera].x, Camera[camera].y, Camera[camera].z, 0.00, 0.00, 0.00, Camera[camera].fov, false, 0)
		PointCamAtCoord(newCam, Camera[camera].x, Camera[camera].y, Camera[camera].z)
   		SetCamActiveWithInterp(newCam, camSkin, 2000, true, true)
   		camSkin = newCam
	else
		camSkin = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Camera[camera].x, Camera[camera].y, Camera[camera].z, 0.00, 0.00, 0.00, Camera[camera].fov, false, 0)
	    SetCamActive(cam2, true)
	    RenderScriptCams(true, false, 2000, true, true) 
	end
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

function updateApperance(id, color)
	local app = Apperance[id]
	local playerPed = PlayerPedId()
	if not color then
		if app.itemType == 'component' then
			SetPedComponentVariation(playerPed, app.itemID, app.index, 0, 2)
			Character[app.item..'_1'] = app.index
	    elseif app.itemType == 'headoverlay' then
			SetPedHeadOverlay(playerPed, app.itemID, app.index, math.floor(app.indextwo)/10+0.0)
			Character[app.item..'_1'] = app.index
			Character[app.item..'_2'] = math.floor(app.indextwo)
	    elseif app.itemType == 'eye' then
			SetPedEyeColor(playerPed, app.index, 0, 1)
			Character['eye_color'] = app.index
	    end
	end

    if color then
    	if app.itemType == 'component' then
            SetPedHairColor(playerPed, app.indextwo, 0)
            Character['hair_color_1'] = app.indextwo
        elseif app.itemType == 'headoverlay' then
            SetPedHeadOverlayColor(playerPed, app.itemID, 1, app.indextwo, 0)
            Character[app.item..'_3'] = app.indextwo
        end
    end	
end

function Visible()
    while enable == true do
        Citizen.Wait(0)
        Collision()
    end
end


function fixPlayerComponents(component,drawableKey, textureKey)
    local playerPed = PlayerPedId()
    SetPedComponentVariation(playerPed, component, Character[drawableKey],Character[textureKey], 2)
    local hash = GetHashNameForComponent(playerPed, component, Character[drawableKey], Character[textureKey])
    local fcDrawable, fcTexture, fcType = -1, -1, -1
    local fcCount = GetShopPedApparelForcedComponentCount(hash) - 1
    for fcId = 0, fcCount do
        local fcNameHash, fcEnumVal, f5, f7, f8 = -1, -1, -1, -1, -1
        fcNameHash, fcEnumVal, fcType = GetForcedComponent(hash, fcId)
        if fcType == 3 then
            if (fcNameHash == 0) or (fcNameHash == GetHashKey('0')) then
                fcDrawable = fcEnumVal
                fcTexture = 0
            else
                fcType, fcDrawable, fcTexture = GetComponentDataFromHash(fcNameHash)
            end
            if IsPedComponentVariationValid(playerPed, fcType, fcDrawable, fcTexture) then
                Character['arms'] = fcDrawable
                Character['arms_2'] = fcTexture
                SetPedComponentVariation(playerPed, fcType, fcDrawable, fcTexture, 2)
            end
        end
    end
    if GetEntityModel(playerPed) == GetHashKey('mp_f_freemode_01') then
        if (GetPedDrawableVariation(playerPed, 11) == 15) and (GetPedTextureVariation(playerPed, 11) == 16) then
            Character['arms'] = 15
            Character['arms_2'] = 0
            SetPedComponentVariation(playerPed, 3, 15, 0, 2);
        end
    elseif GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
        if (GetPedDrawableVariation(playerPed, 11) == 15) and (GetPedTextureVariation(playerPed, 11) == 0) then
            Character['arms'] = 15
            Character['arms_2'] = 0
            SetPedComponentVariation(playerPed, 3, 15, 0, 2);
        end
    end
end
exports("startCharacterCreator",CharCreatorAnimation)