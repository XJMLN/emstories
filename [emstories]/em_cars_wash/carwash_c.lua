local carWashStarted = false
local showHelp = false
local errorMsg = false
local vehicle = false
function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end
local msg = "Wciśnij ~INPUT_PICKUP~ aby rozpocząć mycie. Koszt ~g~$10~w~."
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for id,pos in pairs(CARWASHES) do
            DrawMarker(36,pos[1],pos[2],pos[3], 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.00, 1.00, 1.00, 0, 250, 0, 200, false, true, 2, true, false, false, false)
            vehicle = GetVehiclePedIsIn(PlayerPedId(),false)
            if (vehicle and GetDistanceBetweenCoords(pos[1],pos[2],pos[3],GetEntityCoords(vehicle,false))<1.5*1.12 and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
                showHelp = true
                if (not carWashStarted and showHelp and not errorMsg) then
                    if (GetIsVehicleEngineRunning(vehicle)) then
                        DrawHelp(msg)
                        if (IsControlJustPressed(0,38)) then
                            TriggerServerEvent("em_carwash:checkPlayerMoney",id)
                        end
                    else
                        DrawHelp("Silnik pojazdu musi być włączony.")
                    end
                end
            end
        end
    end
end)

function carwash_startWash(callback,wash_id)
    if (callback~="OK") then
        errorMsg = true
        DrawHelp(callback)
        Wait(3500)
        errorMsg = false
        return
    end
    if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Wait(1)
		end
	end
    carWashStarted = true
    local aipath = CARWASHES[wash_id]['aiPath']
    local particlesCoords = CARWASHES[wash_id]['particlesCoords']
    local player = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(player,false)
    particles = {}
    UseParticleFxAssetNextCall("core")
    particles[1] = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p",particlesCoords[1][1],particlesCoords[1][2],particlesCoords[1][3],0.0,0.0,0.0,1.0,false,false,false,false)
    UseParticleFxAssetNextCall("core")
    particles[2] = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p",particlesCoords[2][1],particlesCoords[2][2],particlesCoords[2][3],0.0,0.0,0.0,1.0,false,false,false,false)
    UseParticleFxAssetNextCall("core")
    particles[3] = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p",particlesCoords[3][1],particlesCoords[3][2],particlesCoords[3][3],0.0,0.0,0.0,1.0,false,false,false,false)
    Citizen.CreateThread(function()
        local Task = TaskVehicleDriveToCoord(player,veh,aipath[1],aipath[2],aipath[3],2.0,0,GetHashKey(GetEntityModel(veh)),16777216,1.0,true)
        local pos = GetEntityCoords(veh,false)
        if (carWashStarted) then

        end
        while true do
            Citizen.Wait(0)
            
            if (GetScriptTaskStatus(player,0x93a5526e) ==7 and carWashStarted) then
                StopParticleFxLooped(particles[1],0)
                StopParticleFxLooped(particles[2],0)
                StopParticleFxLooped(particles[3],0)
                WashDecalsFromVehicle(veh,1.0)
                SetVehicleDirtLevel(veh)
                carWashStarted = false
                particles[1] = nil
                particles[2] = nil
                particles[3] = nil
            end
        end
    end)
    
end

RegisterCommand("test",function()
    ClearPedTasksImmediately(PlayerPedId())
end,false)

RegisterCommand("drive",function()
    local player = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(player,false)
    TaskVehicleDriveToCoordLongrange(player, veh, -2098.48,-319.77,13.1, 20.0, 447, 2.0)
end,false)
RegisterNetEvent("em_carwash:startWash")
AddEventHandler("em_carwash:startWash",carwash_startWash)