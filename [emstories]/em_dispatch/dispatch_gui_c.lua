local dispatchShowing = false
local dispatchMission = false
local dispatchAccepted = false

function dispatch_cancelMission()
    if (dispatchAccepted) then return end
    if (dispatchShowing) then
        dispatchShowing = false
        dispatchMission = false
        SendNUIMessage({type="cancelDispatch"})
    end
end
function dispatch_gui_show(missionData)
    if (dispatchShowing) then return end
    dispatchShowing = true
    dispatchAccepted = false
    dispatchMission = missionData
    SetNuiFocus(false,false)
    SendNUIMessage({type="drawDispatch",data=missionData})
    Wait(15000)
    dispatch_cancelMission()
end

RegisterCommand("dispatchAccept",function()
    if (dispatchShowing) then
        dispatchAccepted = true
        dispatchShowing = false
        SendNUIMessage({type="cancelDispatch",music=math.random(1,4)})
        TriggerServerEvent("em_dispatch_accepted",dispatchMission)
    end
end)
RegisterKeyMapping("dispatchAccept",'Akceptuj Dispatch','keyboard','y')

RegisterNetEvent("em_dispatch_client:showRender")
AddEventHandler("em_dispatch_client:showRender",dispatch_gui_show)