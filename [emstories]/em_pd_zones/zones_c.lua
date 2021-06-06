local createdZones = {}
local leftMessageSent = false
local enterMessageSent = false
AddTextEntry("patrolZoneOutNotification","Opuściłeś strefę patrolowania.\nNie otrzymasz dodatkowego doświadczenia za patrolowanie strefy.")
AddTextEntry("patrolZoneInNotification","Znajdujesz się na strefie patrolowania.\nCo jakiś czas będziesz otrzymywać dodatkowe doświadczenie.")
function DrawNotification(title,subtitle,iconName,iconType,flash,type,XP)

    BeginTextCommandThefeedPost(type)
    if (XP) then
        AddTextComponentSubstringPlayerName(title)
        EndTextCommandThefeedPostTicker(true,true)
    end
    EndTextCommandThefeedPostMessagetext(iconName,iconName, flash, iconType, title, subtitle)
end
function zones_startup()
    for i,v in pairs(ZONES) do
        createdZones[v.departmentID] = PolyZone:Create(v.coords,{
            name=tostring(v.departmentID),
            minZ=-100.0,
            maxZ=500.0,
            data={departmentID=v.departmentID},
        })
    end
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            local coord = GetEntityCoords(PlayerPedId())
            local departmentID = LocalPlayer.state.departmentID
            if (departmentID and departmentID > 0 and createdZones[departmentID] and createdZones[departmentID]:isPointInside(coord)) then
                leftMessageSent = false
                if (not enterMessageSent) then
                    DrawNotification("Centrala","Informacja","CHAR_CALL911",1,false,"patrolZoneInNotification")
                    enterMessageSent = true
                end
            else
                if (not messageSent and departmentID and departmentID >0) then
                    DrawNotification("Centrala","Informacja","CHAR_CALL911",1,false,"patrolZoneOutNotification")
                    messageSent = true
                    enterMessageSent = false
                end
            end
        end
    end)
end
zones_startup()

function zones_xpNotify()
    if (enterMessageSent) then
        DrawNotification("Otrzymujesz ~g~50XP~w~ za patrolowanie strefy.",false,false,false,false,"STRING",true)
        TriggerServerEvent("zones:givePlayerXP")
    end
end
RegisterNetEvent("zones:xpNotification")
AddEventHandler("zones:xpNotification",zones_xpNotify)