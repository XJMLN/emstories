local fuelStations = {}
local fuelPumps = {}


function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function stations_create(data)
    fuelStations = data
    for i,v in pairs(fuelStations) do
        fuelPumps[v.station_id] = v.pumps
    end
end

function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
    
end

local isPumpMenuVisible = false
local showHelp = false
local isUIOpened = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (fuelPumps and tablelength(fuelPumps)>0) then
            for station_id,fuelData in pairs(fuelPumps) do
                for i,v in pairs(fuelData) do
                    DrawMarker(29,v.x,v.y,v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.00, 1.00, 1.00, 0, 250, 0, 200, false, true, 2, true, false, false, false)
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                    if (vehicle and GetDistanceBetweenCoords(v.x,v.y,v.z,GetEntityCoords(vehicle,false))<1.5*1.12 and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
                        showHelp = true
                        if (not isPumpMenuVisible and showHelp) then
                            if (GetIsVehicleEngineRunning(vehicle)) then
                                DrawHelp('Wyłącz silnik aby rozpocząć tankowanie.')
                                if (isUIOpened) then
                                    
                                end
                            else
                                DrawHelp("Wciśnij ~INPUT_PICKUP~ aby rozpocząć tankowanie.")
                                if (IsControlJustPressed(0,38)) then
                                    TriggerServerEvent("em_fuelStations:getPriceForStation",station_id)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

function stations_showGUI(price)
    SetNuiFocus(true,false)
    SetNuiFocusKeepInput(true)
    isUIOpened = true
    SendNUIMessage({type="open_fuelMenu",data={fuel=math.floor(GetFuel(vehicle)),price=price}})
end

local fuelSynced = false
function ManageFuelUsage(vehicle)
    if (not DecorExistOn(vehicle,"_VEH_FUEL_LEVEL_")) then
        SetFuel(vehicle,math.random(200,800)/10)
    elseif not fuelSynced then
        SetFuel(vehicle, GetFuel(vehicle))
        fuelSynced = true
    end
end

function GetFuel(vehicle)
	return DecorGetFloat(vehicle, "_VEH_FUEL_LEVEL_")
end

function SetFuel(vehicle, fuel)
	if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
		SetVehicleFuelLevel(vehicle, fuel + 0.0)
		DecorSetFloat(vehicle, "_VEH_FUEL_LEVEL_", GetVehicleFuelLevel(vehicle))
	end
end

Citizen.CreateThread(function()
    DecorRegister("_VEH_FUEL_LEVEL_",1)
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        if (IsPedInAnyVehicle(ped)) then
            local vehicle = GetVehiclePedIsIn(ped)
            if (GetPedInVehicleSeat(vehicle,-1)==ped) then
                ManageFuelUsage(vehicle)
            end
        else
            if fuelSynced then
                fuelSynced = false
            end
        end
    end
end)

RegisterNetEvent("em_fuelStations:createStations")
RegisterNetEvent("em_fuelStations:returnStationPrice")
AddEventHandler("em_fuelStations:returnStationPrice",stations_showGUI)
AddEventHandler("em_fuelStations:createStations",stations_create)