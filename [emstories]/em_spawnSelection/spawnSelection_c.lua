local securedUI = false
local spawnData = {
    {x=-1095.47,y=-802.59,z=18.66,heading=35.27,model="a_m_m_farmer_01",skipFade=false},
    {x=1857.37,y=3679.15,z=33.76,heading=192.44,model="a_m_m_farmer_01",skipFade=false},
    {x=-438.06,y=6021.48,z=31.49,heading=305.66,model="a_m_m_farmer_01",skipFade=false},
  }
DecorRegister("selectedSpawn",3)



function spawnSelection_render()
    SetManualShutdownLoadingScreenNui(true)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    SetNuiFocus(true,true)
    print('Showing spawn selector')
    Wait(1500)
    SendNUIMessage({type="open_spawnSelector"})
    securedUI = true
end
Citizen.CreateThread(function()
    spawnSelection_render()
end)
AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(false)
end)

RegisterNUICallback("spawnPlayer", function(data, callback)
    if (not securedUI) then return end
    SetNuiFocus(false)
    print(data)
    local spawnNumber = tonumber(data.spawnNumber)
    exports.spawnmanager:spawnPlayer(spawnData[spawnNumber])
    selectedSpawn = spawnNumber
    DecorSetInt(PlayerPedId(-1),"selectedSpawn",spawnNumber)
    isDead = false 
      timerCount = 90 
    securedUI = false
    TriggerEvent("em:showHUD")
    callback("ok")
  end)