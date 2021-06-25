local MISSION_IDS = {[4]=true,[5]=true,[6]=true,[7]=true,[8]=true,[9]=true,[10]=true,[11]=true}
local calloutData = {blip=nil,started=false}
local fireID = nil
local currentID = nil


Citizen.CreateThread(function()
    while true do
        if (calloutData and calloutData.started) then
            if (fireID and fireID >0) then
                local firesInRange = countElements(Fire.active[fireID].flames)
                print("Pożary w zasiegu:"..firesInRange)
                if (firesInRange<=1) then
                    fireID = nil

                    DeleteEntity(calloutData.blip)
                    RemoveBlip(calloutData.blip)
                    calloutData = {blip=nil,started=false}
                    TriggerServerEvent("callouts_end",currentID, true)
                    currentID = nil
                end
            end
        end
        Citizen.Wait(500)
    end
end)

function callout_cancelCallout(ID)
    if (fireID and fireID >0) then
        DeleteEntity(calloutData.blip)
        RemoveBlip(calloutData.blip)
        TriggerServerEvent("fireManager:removeFire",fireID)
        calloutData = {blip=nil,started=false}
        fireID = nil
        currentID = nil
    end
end

function callout_startupMission(ID, data, location)
    if (not MISSION_IDS[ID]) then return end
    currentID = ID
    local vectorLocation = vector3(location.x,location.y,location.z)
    TriggerServerEvent("fireManager:createFire",vectorLocation,location.spread,location.spreadChance)
    local blip = AddBlipForCoord(location.x,location.y,location.z)
    SetBlipSprite(blip,data.sprite)
    SetBlipDisplay(blip,4)
    SetBlipColour(blip,data.colour)
    SetBlipScale(blip, 1.0)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, data.colour)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wezwanie: Pożar")
    EndTextCommandSetBlipName(blip)
    calloutData.blip = blip
    Citizen.CreateThread(function()
        while true do
            local playerPos = GetEntityCoords(GetPlayerPed(-1))
            if (#(playerPos - vectorLocation) < 20) then
                calloutData.started = true
            end
            Citizen.Wait(1000)
        end
    end)
end


function callouts_returnFireID(ID)
    fireID = ID
end

RegisterNetEvent("em_callouts:cancelMission")
AddEventHandler("em_callouts:cancelMission",callout_cancelCallout)

RegisterNetEvent("callouts_returnFireID")
AddEventHandler("callouts_returnFireID",callouts_returnFireID)
RegisterNetEvent("em_callouts:startupMission")
AddEventHandler("em_callouts:startupMission",callout_startupMission)