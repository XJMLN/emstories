local hasNPCLoaded = false
local isArmoryGUIOpen = false
local plrMoney = 0
local plrData = nil
function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end

function armory_initTable(plrData)
    local retVal = ARMORY_OFFER
    for i,v in ipairs(plrData) do
        retVal[v.weapon_hash] = nil
    end
    return retVal
end

function armory_showGUI(data)
    if (not data) then
        isArmoryGUIOpen = true
        TriggerServerEvent("armory:getUserData")
        return
    end
    if (data and isArmoryGUIOpen) then
        plrMoney = data.money
        plrData = data.data
        local offer = armory_initTable(data.data)
        SetNuiFocus(true, true)
        SendNUIMessage({type="showArmory",data=offer})
    end
end

function armory_hideGUI()
    if (not isArmoryGUIOpen) then return end
    isArmoryGUIOpen = false
    plrMoney = 0
    SetNuiFocus(false)
end

function armory_showError()
    if (not isArmoryGUIOpen) then return end
    SendNUIMessage({type="showError"})
end
function armory_completeCheckout(hash)
    if (not isArmoryGUIOpen) then return end
    table.insert(plrData,{weapon_hash=hash})
    local offer = armory_initTable(plrData)
    SendNUIMessage({type="showArmory",data=offer})
    SendNUIMessage({type="showSuccess"})
end
Citizen.CreateThread(function()
    for _,v in pairs(ARMORY_POSITIONS) do
        local skin_model = GetHashKey(PED_SKINS[math.random(0,#PED_SKINS)])
        RequestModel(skin_model)
        while not HasModelLoaded(skin_model) do
            Wait(1)
        end
  
      RequestAnimDict("mini@strip_club@idles@bouncer@base")
      while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
        Wait(1)
      end
      ped =  CreatePed(1,skin_model,v.ped[1],v.ped[2],v.ped[3],v.ped['heading'], false, true)
      SetPedDiesWhenInjured(ped,false)
      SetBlockingOfNonTemporaryEvents(ped,true)
      SetEntityHeading(ped, v.ped['heading'])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for i,v in ipairs(ARMORY_POSITIONS) do
            v = v['player']
            local ped = GetEntityCoords(PlayerPedId(),false)
            local playerFaction = LocalPlayer.state.factionID
            if (ped and GetDistanceBetweenCoords(v[1],v[2],v[3],ped[1],ped[2],ped[3])<2.5 and GetVehiclePedIsIn(PlayerPedId(), false) == 0 ) then
                DrawHelp("Wciśnij ~INPUT_PICKUP~ aby wyświetlić ofertę zbrojowni.")
                if (IsControlJustPressed(0, 38)) then
                    armory_showGUI(false)
                end
            end
        end
    end
end)
function armory_checkout(data)
    local hash = data.cartHash
    TriggerServerEvent("armory:checkout",hash)
end
RegisterNUICallback("checkout",armory_checkout)
RegisterNUICallback("exitArmory",armory_hideGUI)
RegisterNetEvent("armory_client:sendUserData")
RegisterNetEvent("armory_client:checkoutError")
RegisterNetEvent("armory_client:checkoutSuccess")
AddEventHandler("armory_client:checkoutSuccess",armory_completeCheckout)
AddEventHandler("armory_client:checkoutError",armory_showError)
AddEventHandler("armory_client:sendUserData",armory_showGUI)