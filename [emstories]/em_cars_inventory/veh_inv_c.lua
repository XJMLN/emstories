local openedTrunkVehicle = nil
local attachedType = nil
local attachedObjects = {

}

local placedObjects = {

}

local weaponsData = {453432689,2210333304,911657153,101631238,1737195953}
function show_inventoryGUI()
    SetNuiFocus(true, true)
    Citizen.Wait(500)
    SendNUIMessage({type = "newInstance"})
end

function deleteAllObjects(plr)
    if attachedObjects[plr] then
        for i,v in ipairs(attachedObjects[plr]) do 
            DetachEntity(v)
            DeleteEntity(v)
            v = nil
        end
    end
    if (placedObjects[plr]) then 
        for i,v in ipairs(placedObjects[plr]) do 
            DeleteEntity(v) 
            v= nil 
        end
    end
end

exports('vehicleInventory_deleteAllObjects', function(plr)
	if attachedObjects[plr] then
        for i,v in ipairs(attachedObjects[plr]) do 
            DetachEntity(v)
            DeleteEntity(v)
            v = nil
        end
    end
    if (placedObjects[plr]) then 
        for i,v in ipairs(placedObjects[plr]) do 
            DeleteEntity(v) 
            v= nil 
        end
    end
end)
Citizen.CreateThread(function()
	while true do
		local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
		local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 1.0, 0.0)
		local vehicle = getVehicleInDirection(coordA, coordB)
        
		if DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle) then
            local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
            
            if (GetVehicleClass(vehicle) == 18) then
			    local trunkpos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "boot"))
			    local playerpos = GetEntityCoords(GetPlayerPed(-1), 1)
			    local distanceToTrunk = GetDistanceBetweenCoords(trunkpos, playerpos, 1)
                local department = DecorGetInt(GetPlayerPed(-1),"department")
                
			    if distanceToTrunk <= 1.6 and GetVehiclePedIsIn(PlayerPedId(), false) == 0 and attachedType == nil and department>0 then
                    exports.fpd_3dtext:Draw3DText(trunkpos.x, trunkpos.y, trunkpos.z - 0.3, "Wciśnij ~g~E~w~ aby otworzyć",2,0.4)
                    if IsControlJustReleased(0,38) then
                        SetVehicleDoorOpen(vehicle, 5, false, false)
                        openedTrunkVehicle = vehicle
                        show_inventoryGUI()
                    end
			    end
            end
		end
        if (attachedObjects and attachedObjects[PlayerPedId()]) then 
            local textString = ""
            if (attachedType == "cone") then 
                textString = "pachołek"
            else 
                textString = "barierkę"
            end
            exports.fpd_3dtext:DrawDialogueText("Wciśnij ~g~E~w~ aby położyć "..textString..".")
            if IsControlJustReleased(0,38) then
                objectPlaced()
            end
        end
		Citizen.Wait(0)
	end
end)

function objectPlaced()
    DetachEntity(attachedObjects[PlayerPedId()])
    DeleteEntity(attachedObjects[PlayerPedId()])
    attachedObjects[PlayerPedId()] = nil
    Citizen.Wait(150)
    if (not placedObjects[PlayerPedId()]) then
        placedObjects[PlayerPedId()] = {}
    end
    
    if (#placedObjects[PlayerPedId()] >= 4) then
        exports.fpd_3dtext:DrawNotification("Police Department","","Nie możesz postawić więcej niż 4 obiekty. Aby usunąć obiekty wpisz ~g~/obiekty",true)
        attachedType = nil 
        return 
    else
        if (attachedType == "cone") then
            local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0))
            local object = CreateObject(GetHashKey("prop_mp_cone_01"),x,y,z,true,true,true)
            PlaceObjectOnGroundProperly(object)
            SetEntityHeading(object,GetEntityHeading(PlayerPedId())+90)
            table.insert(placedObjects[PlayerPedId()],object)
        end
        if (attachedType == "barrier") then 
            local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0))
            local object = CreateObject(GetHashKey("prop_mp_barrier_02b"),x,y,z,true,true,true)
            PlaceObjectOnGroundProperly(object)
            SetEntityHeading(object,GetEntityHeading(PlayerPedId())+0)
            table.insert(placedObjects[PlayerPedId()],object)
        end
        attachedType = nil 
    end
    
end
RegisterNUICallback('cone', function(data, cb)
    if (not openedTrunkVehicle) then return end
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroyInstance'
    })
    SetVehicleDoorShut(openedTrunkVehicle,5,false)
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)

    attachedObjects[PlayerPedId()] = CreateObject(GetHashKey("prop_mp_cone_01"), 0, 0, 0, false, true, true)
    SetEntityLocallyInvisible(attachedObjects[PlayerPedId()],true)
    SetEntityAlpha(attachedObjects[PlayerPedId()],151,false)
    AttachEntityToEntity(attachedObjects[PlayerPedId()],PlayerPedId(),GetPedBoneIndex(GetPlayerPed(-1), 0),0,0.9,-0.9,0,0,0,true, true, false, true, 1, true)
    attachedType = "cone"
    openedTrunkVehicle = nil
    cb('ok')
end)


RegisterNUICallback('none', function(data, cb)
    if (not openedTrunkVehicle) then return end
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroyInstance'
    })
    SetVehicleDoorShut(openedTrunkVehicle,5,false)
    openedTrunkVehicle = nil
    cb('ok')
end)

RegisterNUICallback('barrier', function(data, cb)
    if (not openedTrunkVehicle) then return end
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroyInstance'
    })
    
    SetVehicleDoorShut(openedTrunkVehicle,5,false)
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    
    attachedObjects[PlayerPedId()] = CreateObject(GetHashKey("prop_mp_barrier_02b"), 0, 0, 0, false, true, true)
    SetEntityLocallyInvisible(attachedObjects[PlayerPedId()],true)
    SetEntityAlpha(attachedObjects[PlayerPedId()],151,false)
    AttachEntityToEntity(attachedObjects[PlayerPedId()],PlayerPedId(),GetPedBoneIndex(GetPlayerPed(-1), 0),0,0.9,-0.9,0,0,0,true, true, false, true, 1, true)
    attachedType = "barrier"
    openedTrunkVehicle = nil
    cb('ok')
end)

RegisterNUICallback('ammo', function(data, cb)
    if (not openedTrunkVehicle) then return end
    cb('ok')
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroyInstance'
    })
    SetVehicleDoorShut(openedTrunkVehicle,5,false)
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    AddAmmoToPed(PlayerPedId(),weaponsData[5],500)
    AddAmmoToPed(PlayerPedId(),weaponsData[1],500)
    AddAmmoToPed(PlayerPedId(),weaponsData[2],500)
    AddAmmoToPed(PlayerPedId(),weaponsData[3],500)
    AddAmmoToPed(PlayerPedId(),weaponsData[4],500)
    openedTrunkVehicle = nil
end)

RegisterCommand("obiekty",function(source,args,rawCommand)
    if (placedObjects and placedObjects[PlayerPedId()]) then 
        for i,v in ipairs(placedObjects[PlayerPedId()]) do 
            DeleteEntity(v)
            v = nil 
        end
        placedObjects[PlayerPedId()] = {}
        exports.fpd_3dtext:DrawNotification("Police Department","","Usunięto postawione obiekty.",true)
    end
end,false)

function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

AddEventHandler("playerDropped",function() 
    local source = source 
    deleteAllObjects(PlayerPedId())
end)