local fuelStations = {}
local fuelPumps = {}
local plrMoney = 0
local Config = {}
-- Mnoznik dla klass, jak chcesz zeby np Sports bralo wiecej to dajesz np. 1.5 jak chcesz zeby mniej bralo to dajesz 0.9
Config.Classes = {
	[0] = 1.0, -- Compacts
	[1] = 1.0, -- Sedans
	[2] = 1.0, -- SUVs
	[3] = 1.0, -- Coupes
	[4] = 1.0, -- Muscle
	[5] = 1.0, -- Sports Classics
	[6] = 1.0, -- Sports
	[7] = 1.0, -- Super
	[8] = 1.0, -- Motorcycles
	[9] = 1.0, -- Off-road
	[10] = 1.0, -- Industrial
	[11] = 1.0, -- Utility
	[12] = 1.0, -- Vans
	[13] = 0.0, -- Cycles
	[14] = 1.0, -- Boats
	[15] = 1.0, -- Helicopters
	[16] = 1.0, -- Planes
	[17] = 1.0, -- Service
	[18] = 1.0, -- Emergency
	[19] = 1.0, -- Military
	[20] = 1.0, -- Commercial
	[21] = 1.0, -- Trains
}

-- Po lewej %RPM Po prawej ile paliwa (podzielone przez 10) ma zabierac z paliwa co 1 sekunde
Config.FuelUsage = {
	[1.0] = 1.4,
	[0.9] = 1.2,
	[0.8] = 1.0,
	[0.7] = 0.9,
	[0.6] = 0.8,
	[0.5] = 0.7,
	[0.4] = 0.5,
	[0.3] = 0.4,
	[0.2] = 0.2,
	[0.1] = 0.1,
	[0.0] = 0.0,
}

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
local vehicle = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (fuelPumps and tablelength(fuelPumps)>0) then
            for station_id,fuelData in pairs(fuelPumps) do
                for i,v in pairs(fuelData) do
                    DrawMarker(29,v.x,v.y,v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.00, 1.00, 1.00, 0, 250, 0, 200, false, true, 2, true, false, false, false)
                    vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
                    if (vehicle and GetDistanceBetweenCoords(v.x,v.y,v.z,GetEntityCoords(vehicle,false))<1.5*1.12 and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
                        showHelp = true
                        if (not isPumpMenuVisible and showHelp) then
                            if (GetIsVehicleEngineRunning(vehicle)) then
                                DrawHelp('Wyłącz silnik aby rozpocząć tankowanie.')
                                if (isUIOpened) then
                                    SendNUIMessage({type="playerLeaveMarker"})
                                    isUIOpened = false
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

RegisterNUICallback("pay",function(data,callback)
    if (not plrMoney) then return end
    SetNuiFocus(false)
    SetNuiFocusKeepInput(false)
    local fuel = data.fuel
    local toPay = data.toPay
    TriggerServerEvent("em_fuelStations:verifyMoney",toPay,fuel)
    callback("ok")
end)

function stations_showGUI(price,plrVal)
    SetNuiFocus(true,false)
    SetNuiFocusKeepInput(true)
    plrMoney = plrVal
    isUIOpened = true
    if (GetVehicleClass(vehicle) == 18) then
        price = 0
    end
    SendNUIMessage({type="open_fuelMenu",data={fuel=math.floor(GetFuel(vehicle)),price=price,money=plrVal}})
end

local fuelSynced = false
function ManageFuelUsage(vehicle)
    if (not DecorExistOn(vehicle,"_VEH_FUEL_LEVEL_")) then
        SetFuel(vehicle,math.random(200,800)/10)
    elseif not fuelSynced then
        SetFuel(vehicle, GetFuel(vehicle))
        fuelSynced = true
    end

    if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle, GetVehicleFuelLevel(vehicle) - Config.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] * (Config.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
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
        Citizen.Wait(10000)
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

function stations_fuelCar(fuel)
    local fuelNow = GetFuel(vehicle)
    local newFuel = fuelNow + fuel
    if (newFuel>100) then
        newFuel = 100
    end
    SetFuel(vehicle,newFuel)
end
RegisterNetEvent("em_fuelStations:createStations")
RegisterNetEvent("em_fuelStations:returnStationPrice")
RegisterNetEvent("em_fuelStations:fuelCar")
AddEventHandler("em_fuelStations:fuelCar",stations_fuelCar)
AddEventHandler("em_fuelStations:returnStationPrice",stations_showGUI)
AddEventHandler("em_fuelStations:createStations",stations_create)