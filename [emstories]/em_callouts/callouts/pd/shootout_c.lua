local calloutData = {peds={}, blip=nil, started=false, showed=false}
local MISSION_ID = 19

function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end

Citizen.CreateThread(function()
    while true do
        if (calloutData.started) then
            if (not DoesEntityExist(calloutData.peds[1]) and not DoesEntityExist(calloutData.peds[2]) and not DoesEntityExist(calloutData.peds[3]) and not DoesEntityExist(calloutData.peds[4]) and not DoesEntityExist(calloutData.peds[5])) then
                DeleteEntity(calloutData.peds[1])
                DeleteEntity(calloutData.peds[2])
                DeleteEntity(calloutData.peds[3])
                DeleteEntity(calloutData.peds[4])
                DeleteEntity(calloutData.peds[5])
                DeleteEntity(calloutData.blip)
                calloutData = {peds={}, blip=nil, started=false,showed=false}
                TriggerServerEvent("callouts_end",MISSION_ID,true)
            end
            if (IsPedDeadOrDying(calloutData.peds[1]) and IsPedDeadOrDying(calloutData.peds[2]) and IsPedDeadOrDying(calloutData.peds[3]) and IsPedDeadOrDying(calloutData.peds[4]) and IsPedDeadOrDying(calloutData.peds[5]) and not calloutData.showed) then
                calloutData.showed = true
                DrawHelp("Osoby zamieszane w strzelaninę nie żyją, wezwanie zakończy się gdy koroner odbierze zwłoki.")
            end
        end
        Citizen.Wait(1000)
    end
end)

function callout_cancelCallout(ID)
    if (calloutData and calloutData.started) then
        DeleteEntity(calloutData.peds[1])
        DeleteEntity(calloutData.peds[2])
        DeleteEntity(calloutData.peds[3])
        DeleteEntity(calloutData.peds[4])
        DeleteEntity(calloutData.peds[5])
        DeleteEntity(calloutData.blip)
        calloutData = {peds={}, blip=nil, started=false,showed=false}
    end
end


function callout_startupMission(id, data, coords)
    if (id ~= MISSION_ID) then return end
    local coords = coords
    local combatWeapon = WEAPONS['range'][math.random(1,#WEAPONS['range'])]
    for i,v in pairs(coords.data) do
        if (v.used) then return end
        local npcModel = GetHashKey(PEDS[math.random(1,#PEDS)])
        RequestModel(npcModel)
        while not HasModelLoaded(npcModel) do 
            RequestModel(npcModel)
            Wait(0)
        end
        local ped = CreatePed(26,npcModel,v.x,v.y,v.z,v.heading,true,true)
        SetEntityAsMissionEntity(ped,true,true)
        GiveWeaponToPed(ped,combatWeapon,99,false,true)
        SetBlockingOfNonTemporaryEvents(ped,true)
        v.used = true
        table.insert(calloutData.peds,ped)
    end

    TaskCombatPed(calloutData.peds[1],GetPlayerPed(-1),0,16)
    TaskCombatPed(calloutData.peds[2],GetPlayerPed(-1),0,16)
    TaskCombatPed(calloutData.peds[3],GetPlayerPed(-1),0,16)
    TaskCombatPed(calloutData.peds[4],GetPlayerPed(-1),0,16)
    TaskCombatPed(calloutData.peds[5],GetPlayerPed(-1),0,16)
    local blip = AddBlipForEntity(calloutData.peds[1])
    SetBlipSprite(blip,665)
    SetBlipDisplay(blip, 4)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    SetBlipScale(blip, 1.0)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wezwanie: Strzelanina")
    EndTextCommandSetBlipName(blip)
    calloutData.blip = blip
    calloutData.coords = coords
    calloutData.started = true
    DrawHelp("Osoby otworzyły ogień w Twoją stronę. ~g~Otrzymałeś pozwolenie ~w~na użycie ~y~broni palnej~w~.")
end

RegisterNetEvent("em_callouts:startupMission", callout_startupMission)
AddEventHandler("em_callouts:startupMission",callout_startupMission)

RegisterNetEvent("em_callouts:cancelMission")
AddEventHandler("em_callouts:cancelMission",callout_cancelCallout)