local calloutData = {started=false, driver=nil,veh=nil,passenger=nil,blip=nil,escortID=nil,destination=nil,near=false}
local MISSION_ID = 2

local escortData = {
    {
        vehModel="stockade",
        driverModel="s_m_m_armoured_01",
        passengerModel="s_m_m_armoured_02",
        seatPassenger=2,
        endPosition={
            {
                x=-86.54,
                y=-656.12,
                z=35.65
            },
        },
    },
    {
        vehModel="pbus",
        driverModel="s_m_m_armoured_02",
        passengerModel="s_m_y_prisoner_01",
        endPosition={
            {
                x=1856.86,
                y=2608.64,
                z=45.33
            },
            {
                x=-1285.58,
                y=2541.7,
                z=17.78,
            }
        }
    },
    {
        vehModel="stretch",
        driverModel="s_m_m_armoured_01",
        passengerModel="s_m_m_armoured_02",
        seatPassenger=3,
        endPosition={
            {
                x=243.52,
                y=-372.09,
                z=43.98,
            }
        }
    },
}
function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end

Citizen.CreateThread(function()
    while true do
        if (calloutData.started and calloutData.near) then
            local msg = ""
            if (IsPedDeadOrDying(calloutData.driver)) then
                msg = "~r~Wezwanie zostało przerwane - kierowca jest martwy."
            end
            if (IsVehicleDriveable(calloutData.veh, true) ~=1) then
                msg = "~r~Wezwanie zostało przerwane - pojazd został zniszczony"
            end
            if ((IsVehicleDriveable(calloutData.veh, true) ~=1) or (IsPedDeadOrDying(calloutData.driver))) then
                DeleteEntity(calloutData.driver)
                DeleteEntity(calloutData.veh)
                DeleteEntity(calloutData.blip)
                if (calloutData.escortID == 2) then
                    for i=2,6 do
                        DeleteEntity(calloutData.passenger[i])
                    end
                else
                    DeleteEntity(calloutData.passenger)
                end
                calloutData = {started=false, driver=nil,veh=nil,passenger=nil,blip=nil,escortID=nil,destination=nil}
                exports.em_3dtext:DrawNotification("System","System",msg)
                TriggerServerEvent("callouts_end",MISSION_ID,false)
            end
        end
        Citizen.Wait(0)
    end
end)

function callout_startupMission(id, data, coords)
    if (id ~= MISSION_ID) then return end
    
    
    local coords = coords
    local player = source
    local escortID = coords.escortID
    local vehicleModel = escortData[escortID].vehModel
    local driverModel = escortData[escortID].driverModel
    local passengerModel = escortData[escortID].passengerModel
    RequestModel(npcModel)
    RequestModel(vehicleModel)
    RequestModel(passengerModel)
    while not HasModelLoaded(vehicleModel) do
        RequestModel(vehicleModel)
        Wait(0)
    end
    while not HasModelLoaded(driverModel) do
        RequestModel(driverModel)
        Wait(0)
    end
    while not HasModelLoaded(passengerModel) do
        RequestModel(passengerModel)
        Wait(0)
    end
    
    local veh = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z, coords.heading, true, true)
    local blip = AddBlipForEntity(veh)
    SetBlipSprite(blip,665)
    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    SetBlipScale(blip, 1.0)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wezwanie: Eskorta pojazdu")
    EndTextCommandSetBlipName(blip)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    local driver = CreatePedInsideVehicle(veh,26,driverModel, -1, true, false)
    local passenger
    if (not escortData[escortID].seatPassenger) then
        passenger = {}
        for i=2,6 do
            passenger[i] = CreatePedInsideVehicle(veh, 26, passengerModel, i, true, false)
            SetEntityAsMissionEntity(passenger[i] ,true, true)
        end
    else
        passenger = CreatePedInsideVehicle(veh,26,driverModel,escortData[escortID].seatPassenger , true, false)
        SetEntityAsMissionEntity(passenger,true, true)
    end
    SetEntityAsMissionEntity(veh,true, true)
    SetEntityAsMissionEntity(driver,true,true)
   
    calloutData.driver = driver
    calloutData.veh = veh
    calloutData.passenger = passenger
    calloutData.escortID = escortID
    calloutData.blip = blip
    SetDriverAbility(driver,1.0)
    Wait(500)
    DrawHelp("Jedź za zaznaczonym pojazdem, jeśli oddalisz się od celu wezwanie zostanie przerwane.")
    SetBlockingOfNonTemporaryEvents(driver,true)
    calloutData.destination =  escortData[escortID].endPosition[math.random(1,#escortData[escortID].endPosition)]
    TaskVehicleDriveToCoordLongrange(driver, veh, calloutData.destination.x,calloutData.destination.y,calloutData.destination.z,75.0,524331,15.0)
    calloutData.started = true
    Citizen.CreateThread(function()
        while true do
            if (calloutData.started) then
                local vehPosition = GetEntityCoords(veh)
                local plrPos = GetEntityCoords(PlayerPedId())
                if (GetDistanceBetweenCoords(calloutData.destination.x,calloutData.destination.y,calloutData.destination.z,vehPosition.x,vehPosition.y, vehPosition.z, false) <=15.0 and calloutData.near) then
                    DeleteEntity(calloutData.driver)
                    DeleteEntity(calloutData.veh)
                    DeleteEntity(calloutData.blip)
                    if (escortID == 2) then
                        for i=2,6 do
                            DeleteEntity(calloutData.passenger[i])
                        end
                    else
                        DeleteEntity(calloutData.passenger)
                    end
                    calloutData = {started=false, driver=nil,veh=nil,passenger=nil,blip=nil,escortID=nil,destination=nil}
                    TriggerServerEvent("callouts_end",MISSION_ID,true)
                end
                if (GetDistanceBetweenCoords(calloutData.destination.x,calloutData.destination.y,calloutData.destination.z,vehPosition.x,vehPosition.y, vehPosition.z, false) <=50 and not calloutData.near) then
                    DeleteEntity(calloutData.driver)
                    DeleteEntity(calloutData.veh)
                    DeleteEntity(calloutData.blip)
                    if (escortID == 2) then
                        for i=2,6 do
                            DeleteEntity(calloutData.passenger[i])
                        end
                    else
                        DeleteEntity(calloutData.passenger)
                    end
                    calloutData = {started=false, driver=nil,veh=nil,passenger=nil,blip=nil,escortID=nil,destination=nil}
                    TriggerServerEvent("callouts_end",MISSION_ID,false)
                end
                if (GetDistanceBetweenCoords(plrPos.x,plrPos.y,plrPos.z,vehPosition.x,vehPosition.y, vehPosition.z, false) <=100 and not calloutData.near) then
                    calloutData.near = true
                end
                if (GetDistanceBetweenCoords(plrPos.x,plrPos.y,plrPos.z,vehPosition.x,vehPosition.y, vehPosition.z, false) >=300 and calloutData.near) then
                    TriggerEvent("3dtext:DrawNotification","System","System","~r~Wezwanie zostało przerwane - oddaliłeś się od eskortowanego pojazdu.")
                    DeleteEntity(calloutData.driver)
                    DeleteEntity(calloutData.veh)
                    DeleteEntity(calloutData.blip)
                    if (escortID == 2) then
                        for i,v in pairs(calloutData.passenger) do
                            DeleteEntity(v)
                        end
                    else
                        DeleteEntity(calloutData.passenger)
                    end
                    calloutData = {started=false, driver=nil,veh=nil,passenger=nil,blip=nil,escortID=nil,destination=nil}
                    TriggerServerEvent("callouts_end",MISSION_ID,false)
                end
            end
            Citizen.Wait(0)
        end
    end)
end
RegisterNetEvent("em_callouts:startupMission")
AddEventHandler("em_callouts:startupMission",callout_startupMission)