local isVehicleInventoryOpen = false
local currentVehicleInventory = nil
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

function carInventory_useItem(response)
    if (not isVehicleInventoryOpen) then return end
    local itemID = response.itemID
    if (itemID == -1) then
        carInventory_hideGUI()
        return
    end
    if (itemID == 1) then
        TriggerServerEvent("chat:sendScriptMessage","Otwiera boczną roletę, po czym wyjmuje piłę.",2)
        exports.em_fd_saw:onPlayerPickedUpSaw(currentVehicleInventory)
    end
    if (itemID == 2) then
        TriggerServerEvent("chat:sendScriptMessage","Otwiera boczną roletę, po czym wyjmuje gaśnicę.",2)
        GiveWeaponToPed(GetPlayerPed(-1),GetHashKey("WEAPON_FIREEXTINGUISHER"),999999,false,true)
        SetPedInfiniteAmmo(GetPlayerPed(-1),true,GetHashKey("WEAPON_FIREEXTINGUISHER"))
    end

    print("Wyciągasz "..itemID)
    carInventory_hideGUI()
end

Citizen.CreateThread(function()
    while true do
        if (GetVehiclePedIsIn(PlayerPedId(),false) == 0) then
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
                            --if (playerData.factionID == factionID and playerData.departmentID == departmentID) then
                                DrawHelp(v.name)
                                if (IsControlJustReleased(0,38)) then
                                    if (i == 'boot') then
                                        SetVehicleDoorOpen(vehicle,5,false,false)
                                    end
                                    currentVehicleInventory = vehicle
                                    carInventory_showGUI(v.items)
                                end
                            --end
                        end
                    end
                end
            end
        end
        Citizen.Wait(10)
    end
end)

RegisterNUICallback("useItem",carInventory_useItem)