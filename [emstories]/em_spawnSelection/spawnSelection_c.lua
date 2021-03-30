local securedUI = false
DecorRegister("selectedSpawn",3)
local departments = {
    [3]={
        [1]=1
    },
    [2]={
        [1]=2,
        [2]=3,
        [3]=4,
    },
    [1]={
        [1]=5,
        [2]=6,
        [3]=7,
    }
}


function spawnSelection_render(data)
    SetManualShutdownLoadingScreenNui(true)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    SetNuiFocus(true,true)
    Wait(1500)
    SendNUIMessage({type="open_spawnSelector",data=data})
    securedUI = true
end

RegisterNUICallback("spawnPlayer", function(data, callback)
    if (not securedUI) then return end
    SetNuiFocus(false)
    if (data.newplayer == 1) then
        exports.em_characters:startCharacterCreator(data.faction)
        local spawnNumber = tonumber(data.spawnNumber)
        selectedSpawn = spawnNumber
        DecorSetInt(PlayerPedId(-1),"selectedSpawn",spawnNumber)
        isDead = false
        timerCount = 90
        securedUI = false
        callback("ok")
        return
    end
    local spawnNumber = tonumber(data.spawnNumber)
    if (data.faction ~=4) then
        TriggerServerEvent("em_core:setPlayerFaction",data.faction,departments[data.faction][spawnNumber])
    end
    TriggerServerEvent("em_core:spawnPlayer",spawnNumber,data.faction)
    selectedSpawn = spawnNumber
    DecorSetInt(PlayerPedId(-1),"selectedSpawn",spawnNumber)
    isDead = false
    timerCount = 90
    securedUI = false
    TriggerEvent("em:showHUD",data.faction)
    callback("ok")
end)

RegisterNetEvent("em_spawnSelection:loadData")
AddEventHandler("em_spawnSelection:loadData",spawnSelection_render)