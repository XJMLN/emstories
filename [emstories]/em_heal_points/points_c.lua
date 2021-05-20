function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end

Citizen.CreateThread(function()
    while true do
        for i,v in pairs(HEAL_POINTS) do
            DrawMarker(27,v[1],v[2],v[3],0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,242, 48, 78, 150, false, true, 2, true, nil, false)
            local plrCoord = GetEntityCoords(PlayerPedId(), false)
            if (GetDistanceBetweenCoords(v[1],v[2],v[3],plrCoord)< 0.5*1.12 and GetVehiclePedIsIn(PlayerPedId(), false)==0) then
                DrawHelp("Wciśnij ~INPUT_PICKUP~ aby skorzystać z uleczenia (Koszt: $"..HEAL_PRICE..")")
                if (IsControlJustPressed(0,38)) then
                    TriggerServerEvent("em_heal:buyHeal")
                end
            end
        end
        Citizen.Wait(0)
    end
end)

function heal_returnData(retVal)
    if (not retVal) then
        exports.em_3dtext:DrawNotification("System","System","~r~Nie posiadasz tylu pieniędzy.",true)
        return
    end
    SetEntityHealth(GetPlayerPed(-1),200)
    exports.em_3dtext:DrawNotification("System","System","~g~Zostałeś/aś uleczony/a.",true)
end
RegisterNetEvent("em_heal:healPlayer")
AddEventHandler("em_heal:healPlayer",heal_returnData)