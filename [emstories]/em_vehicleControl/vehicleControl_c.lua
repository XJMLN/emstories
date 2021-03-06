local menuOpened = false

function vehControl_show()
    local player = GetPlayerPed(-1)
    local IsInVehicle = IsPedSittingInAnyVehicle(player)
    if (IsInVehicle) then
        local vehicle = GetVehiclePedIsIn(player,false)
        local driver = GetPedInVehicleSeat(vehicle,-1)
        if (driver == player) then
            local engineState = GetIsVehicleEngineRunning(vehicle)
            local driverWindow, passengerWindow = IsVehicleWindowIntact(vehicle,1), IsVehicleWindowIntact(vehicle,0)
            local driverWindowState, passengerWindowState = 0, 0
            local trunk = GetVehicleDoorAngleRatio(vehicle,5)
            local bonnet = GetVehicleDoorAngleRatio(vehicle,4)
            local dome,domeState = IsVehicleInteriorLightOn(vehicle),0
            local bonnetStatus = 0
            local trunkStatus = 0
            if (dome) then
                domeState = 1
            end
            if (bonnet ~=0) then
                bonnetStatus = 1
            end
            if (trunk~=0) then
                trunkStatus = 1
            end
            if (driverWindow == false) then
                driverWindowState = 1
            else
                driverWindowState = 0
            end
            if (passengerWindow == false) then
                passengerWindowState = 1
            else
                passengerWindowState = 0
            end

            if (not engineState) then
                engineState = 0
            end
            if (IsControlJustPressed(0,21)) then
                SetNuiFocus(true,true)
                SendNUIMessage({type="renderVehicleControl",data={dome=domeState,engine=engineState,driverWind=driverWindowState,passengerWind=passengerWindowState,trunk=trunkStatus,bonnet=bonnetStatus}})
            end
        end
    end
end

RegisterNUICallback("none",function(data,callback)
    SendNUIMessage({type="destroyInstance"})
    SetNuiFocus(false)
    callback("ok")
end)

RegisterNUICallback("action",function(data,callback)
    if (not data and not data.type) then return end
    local player = GetPlayerPed(-1)
    local IsInVehicle = IsPedSittingInAnyVehicle(player)
    if (IsInVehicle) then
        local vehicle = GetVehiclePedIsIn(player,false)
        local driver = GetPedInVehicleSeat(vehicle,-1)
        if (driver == player) then
            local state = data.state
            if (data.type == "engine") then
                if (state == 1) then
                    SetVehicleEngineOn(vehicle,false,false,true)
                else
                    SetVehicleEngineOn(vehicle,true,false,false)
                end
            end
            if (data.type == "window") then
                if (state == 1) then
                    RollUpWindow(vehicle,1)
                    RollUpWindow(vehicle,0)
                else

                    RollDownWindow(vehicle,0)
                    RollDownWindow(vehicle,1)
                end
            end
            if (data.type == "trunk") then
                if (state == 0) then
                    SetVehicleDoorOpen(vehicle,5,false,false)
                else
                    SetVehicleDoorShut(vehicle,5,false)
                end
            end
            if (data.type == "bonnet") then
                if (state == 0) then
                    SetVehicleDoorOpen(vehicle,4,false,false)
                else
                    SetVehicleDoorShut(vehicle,4,false)
                end
            end
            if (data.type == "dome") then
                if (state == 0) then
                    SetVehicleInteriorlight(vehicle,true)
                else
                    SetVehicleInteriorlight(vehicle,false)
                end
            end
            SendNUIMessage({type="destroyInstance"})
            SetNuiFocus(false)
            callback("ok")
        end
    end
end)


RegisterCommand("toggleVehControl",vehControl_show)
RegisterKeyMapping("toggleVehControl","Pojazd: Panel Interakcji","keyboard","lshift")