local hudShowed = false
AddEventHandler("em:showHUD",function()
    Wait(1000)
    SendNUIMessage({type="drawHUD"})
    hudShowed = true
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(PlayerPedId())
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
		local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
        local IsInVehicle = IsPedSittingInAnyVehicle(ped)
        if (hudShowed) then
            if GetStreetNameFromHashKey(var1) and GetNameOfZone(pos.x, pos.y, pos.z) then
                if GetStreetNameFromHashKey(var1) then
                    if GetStreetNameFromHashKey(var2) == "" then
                        SendNUIMessage({type="streetUpdate",data={zone=current_zone}})
                    else
                        SendNUIMessage({type="streetUpdate",data={zone=current_zone,street=GetStreetNameFromHashKey(var2)}})
                    end
                end
            end
            if (IsInVehicle) then
                local vehicle = GetVehiclePedIsIn(ped,false)
                local driver = GetPedInVehicleSeat(vehicle,-1)
                if (driver == ped) then
                    local speed = GetEntitySpeed(vehicle)
                    local speedRet = math.floor(speed * 3.6)
                    SendNUIMessage({type="updateVehicle",data={vehicle=true,speed=speedRet}})
                end
            else
                SendNUIMessage({type="updateVehicle",data={vehicle=false,speed=speedRet}})
            end
        end
    end
end)