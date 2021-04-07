local isVehicleInventoryOpen = false
local currentVehicleInventory = nil
local hasSaw = false
local attachedType = nil
local attachedObjects = {}
local placedObjects = {}


local function getVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
	local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

local function GetDataFromVehicleModel(model)
    if (model) then
        return CONFIG_VEHICLES[model].faction,CONFIG_VEHICLES[model].department
    end
    return false
end

local function GetVehicleInventory(model)
    if (model) then
        return CONFIG_VEHICLES[model].Inventory
    end
    return false
end

local function DrawHelp(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, false, 1, 0)
end
local function getPlayerElementData(player)
    local FID = DecorGetInt(player,"__PLAYER_FACTION_")
    local DID = DecorGetInt(player,"__PLAYER_DEPARTMENT_")
    return {factionID=FID,departmentID=DID}
end

function carInventory_showGUI(items)
    isVehicleInventoryOpen = true
    SetNuiFocus(true,true)
    Citizen.Wait(100)
    SendNUIMessage({type="openInventory",data=items})
end

local function carInventory_hideGUI()
    isVehicleInventoryOpen = false
    currentVehicleInventory = nil
    SetNuiFocus(false)
    SendNUIMessage({type="closeInventory"})
end

function carInventory_useItem(response,cb)
    if (not isVehicleInventoryOpen) then cb("ok") return end
    local itemID = response.itemID
    if (itemID == -1) then
        carInventory_hideGUI()
        cb("ok")
        return
    end
    if (itemID == 1) then
        if (hasSaw) then
            TriggerServerEvent("chat:sendScriptMessage","Otwiera boczną roletę, po czym wkłada piłę i zasuwa roletę.",2)
            exports.em_fd_saw:saw_destroy()
            hasSaw = false
            return
        end
        hasSaw = true
        TriggerServerEvent("chat:sendScriptMessage","Otwiera boczną roletę, po czym wyjmuje piłę.",2)
        exports.em_fd_saw:onPlayerPickedUpSaw(currentVehicleInventory)
    end
    if (itemID == 2) then
        TriggerServerEvent("chat:sendScriptMessage","Otwiera boczną roletę, po czym wyjmuje gaśnicę.",2)
        GiveWeaponToPed(GetPlayerPed(-1),GetHashKey("WEAPON_FIREEXTINGUISHER"),999999,false,true)
        SetPedInfiniteAmmo(GetPlayerPed(-1),true,GetHashKey("WEAPON_FIREEXTINGUISHER"))
    end
    if (itemID == 3) then
        if (hasSaw) then return end
        attachedObjects[PlayerPedId()] = CreateObject(GetHashKey("prop_mp_cone_01"), 0,0,0,false,true,true)
        SetEntityLocallyInvisible(attachedObjects[PlayerPedId()],true)
        AttachEntityToEntity(attachedObjects[PlayerPedId()],PlayerPedId(),GetPedBoneIndex(GetPlayerPed(-1), 0),0,0.9,-0.9,0,0,0,true, true, false, true, 1, true)
        attachedType = "cone"
    end
    if (itemID == 4) then
        if (hasSaw) then return end
        if (attachedType) then return end
        attachedObjects[PlayerPedId()] = CreateObject(GetHashKey("prop_mp_barrier_02b"), 0, 0, 0, false, true, true)
        SetEntityLocallyInvisible(attachedObjects[PlayerPedId()],true)
        SetEntityAlpha(attachedObjects[PlayerPedId()],151,false)
        AttachEntityToEntity(attachedObjects[PlayerPedId()],PlayerPedId(),GetPedBoneIndex(GetPlayerPed(-1), 0),0,0.9,-0.9,0,0,0,true, true, false, true, 1, true)
        attachedType = "barrier"
    end
    carInventory_hideGUI()
    cb("ok")
end

function carInventory_placeObject()
    DetachEntity(attachedObjects[PlayerPedId()])
    DeleteEntity(attachedObjects[PlayerPedId()])
    attachedObjects[PlayerPedId()] = nil
    Citizen.Wait(150)
    if (not placedObjects[PlayerPedId()]) then
        placedObjects[PlayerPedId()] = {}
    end
    
    if (#placedObjects[PlayerPedId()] >= 4) then
        exports.em_3dtext:DrawNotification("System","","Nie możesz postawić więcej niż 4 obiekty. Aby usunąć obiekty wpisz ~g~/obiekty",true)
        attachedType = nil 
        return 
    else
        if (attachedType == "cone") then
            local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0))
            local object = CreateObject(GetHashKey("prop_mp_cone_01"),x,y,z,true,true,true)
            PlaceObjectOnGroundProperly(object)
            SetEntityHeading(object,GetEntityHeading(PlayerPedId())+90)
            SetEntityCollision(object,false,false)
            FreezeEntityPosition(object,true)
            table.insert(placedObjects[PlayerPedId()],object)
        end
        if (attachedType == "barrier") then 
            local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0))
            local object = CreateObject(GetHashKey("prop_mp_barrier_02b"),x,y,z,true,true,true)
            PlaceObjectOnGroundProperly(object)
            SetEntityHeading(object,GetEntityHeading(PlayerPedId())+0)
            SetEntityCollision(object,false,false)
            FreezeEntityPosition(object,true)
            table.insert(placedObjects[PlayerPedId()],object)
        end
        attachedType = nil
    end
end

Citizen.CreateThread(function()
    while true do
        if (IsPedGettingIntoAVehicle(GetPlayerPed(-1))) then
            if (attachedObjects and attachedObjects[PlayerPedId()]) then
                DetachEntity(attachedObjects[PlayerPedId()])
                DeleteEntity(attachedObjects[PlayerPedId()])
                attachedObjects[PlayerPedId()] = nil
                attachedType = nil
            end
        end
        if (GetVehiclePedIsIn(PlayerPedId(),false) == 0) then
            if (attachedType and attachedObjects and attachedObjects[PlayerPedId()]) then
                local textString = ""
                if (attachedType == "cone") then 
                    textString = "pachołek"
                else 
                    textString = "barierkę"
                end
                exports.em_3dtext:DrawDialogueText("Wciśnij ~g~E~w~ aby położyć "..textString..".")
                if (IsControlJustReleased(0,38)) then
                    carInventory_placeObject()
                end
            end
            local plrCoords = GetEntityCoords(GetPlayerPed(-1),1)
            local plrOffset = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1),0.0,1.0,0.0)
            local vehicle = getVehicleInDirection(plrCoords,plrOffset)
            if (DoesEntityExist(vehicle) and IsEntityAVehicle(vehicle)) then
                local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                if (CONFIG_VEHICLES[model]) then
                    local factionID, departmentID = GetDataFromVehicleModel(model)
                    local playerData = getPlayerElementData(PlayerPedId(-1))
                    local vehicleInventory = GetVehicleInventory(model)
                    for i,v in pairs(vehicleInventory) do
                        local vehPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle,i))
                        local distanceToBone = GetDistanceBetweenCoords(vehPos, plrCoords, 1)
                        if (distanceToBone <= 3.0) then
                            if (playerData.factionID == factionID and playerData.departmentID == departmentID) then
                                DrawHelp(v.name)
                                if (IsControlJustReleased(0,38)) then
                                    if (i == 'boot') then
                                        SetVehicleDoorOpen(vehicle,5,false,false)
                                    end
                                    currentVehicleInventory = vehicle
                                    carInventory_showGUI(v.items)
                                end
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(10)
    end
end)

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

RegisterCommand("obiekty",function(source,args,rawCommand)
    if (placedObjects and placedObjects[PlayerPedId()]) then
        for i,v in ipairs(placedObjects[PlayerPedId()]) do
            DeleteEntity(v)
            v = nil 
        end
        placedObjects[PlayerPedId()] = {}
        exports.em_3dtext:DrawNotification("System","","Usunięto postawione obiekty.",true)
    end
end,false)
exports('vehicleInventory_deleteAllObjects',deleteAllObjects)
RegisterNUICallback("useItem",carInventory_useItem)
AddEventHandler("playerDropped",function()
    deleteAllObjects(PlayerPedId())
end)