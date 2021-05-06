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
    while true do
        Citizen.Wait(0)
        if (not hasNPCLoaded) then
            for i,v in ipairs(ARMORY_POSITIONS) do
                local skin_model = GetHashKey(PED_SKINS[math.random(0,#PED_SKINS)])
                RequestModel(skin_model)
                while not HasModelLoaded(skin_model) do
                    Wait(1)
                end
                Wait(4)
                v.pedElement = CreatePed(1,skin_model,v.ped[1],v.ped[2],v.ped[3],v.ped['heading'],true,false)
                SetPedDiesWhenInjured(v.pedElement,false)
                SetBlockingOfNonTemporaryEvents(v.pedElement,true)
                SetPedCanPlayAmbientAnims(v.pedElement, false)
                SetPedCanRagdollFromPlayerImpact(v.pedElement, false)
                SetEntityAsMissionEntity(v.pedElement,true,true)
                SetEntityInvincible(v.pedElement, true)
                Citizen.Wait(5000)
                FreezeEntityPosition(v.pedElement, true)
            end
            hasNPCLoaded = true
        end

        if (hasNPCLoaded) then
            for i,v in ipairs(ARMORY_POSITIONS) do
                v = v['player']
                local ped = GetEntityCoords(PlayerPedId(),false)
                local playerFaction = DecorGetInt(PlayerPedId(),"__PLAYER_FACTION_")
                if (ped and GetDistanceBetweenCoords(v[1],v[2],v[3],ped[1],ped[2],ped[3])<2.5 and GetVehiclePedIsIn(PlayerPedId(), false) == 0 and playerFaction == 1) then
                    DrawHelp("Wciśnij ~INPUT_PICKUP~ aby wyświetlić ofertę zbrojowni.")
                    if (IsControlJustPressed(0, 38)) then
                        armory_showGUI(false)
                    end
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