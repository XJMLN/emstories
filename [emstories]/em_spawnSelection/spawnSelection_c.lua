local securedUI = false
DecorRegister("selectedSpawn",3)



function spawnSelection_render()
    SetManualShutdownLoadingScreenNui(true)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    SetNuiFocus(true,true)
    Wait(1500)
    SendNUIMessage({type="open_spawnSelector"})
    securedUI = true
end
Citizen.CreateThread(function()
    spawnSelection_render()
end)

RegisterNUICallback("spawnPlayer", function(data, callback)
    if (not securedUI) then return end
    SetNuiFocus(false)
    local spawnNumber = tonumber(data.spawnNumber)
    TriggerServerEvent("em_core:spawnPlayer",spawnNumber)
    selectedSpawn = spawnNumber
    DecorSetInt(PlayerPedId(-1),"selectedSpawn",spawnNumber)
    isDead = false
    timerCount = 90
    securedUI = false
    TriggerEvent("em:showHUD")
    callback("ok")
  end)