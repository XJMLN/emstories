local spawnData = {
    {x=-1095.47,y=-802.59,z=18.66,heading=35.27},
    {x=1857.37,y=3679.15,z=33.76,heading=192.44},
    {x=-438.06,y=6021.48,z=31.49,heading=305.66},
}
firstspawn = false
_spawnNumber = 0
local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)

    local ped = GetPlayerPed(player)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end
        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end
        FreezeEntityPosition(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end
        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        SetPlayerInvincible(player, true)
        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end

function base_spawnPlayer(spawnNumber,skin,money)
    local source = PlayerId()
    local skin = skin
    local money = money
    if (_spawnNumber == 0) then
        _spawnNumber = spawnNumber
        firstspawn = true
    end
    Citizen.CreateThread(function()
        
        DoScreenFadeOut(500)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end
        local model = ""
        if skin['sex'] == 0 then
            model = GetHashKey('mp_m_freemode_01')
        else
            model = GetHashKey('mp_f_freemode_01')
        end
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Wait(0)
        end
        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(GetPlayerPed(PlayerId()))
        freezePlayer(PlayerId(),true)
        local pos = spawnData[_spawnNumber]
        RequestCollisionAtCoord(pos.x,pos.y,pos.z)
        local ped = PlayerPedId()
        SetEntityCoordsNoOffset(ped,pos.x,pos.y,pos.z,false,false,false,true)
        NetworkResurrectLocalPlayer(pos.x,pos.y,pos.z,pos.heading,true,true,false)
        ClearPedTasksImmediately(ped)
        RemoveAllPedWeapons(ped)
        ClearPlayerWantedLevel(PlayerId())

        local time = GetGameTimer()

        while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
            Citizen.Wait(0)
        end
        if IsScreenFadedOut() then
            DoScreenFadeIn(500)

            while not IsScreenFadedIn() do
                Citizen.Wait(0)
            end
        end
        freezePlayer(PlayerId(), false)
        SetEntityVisible(ped, true)
        if (firstspawn) then
            TriggerEvent("skinchanger:loadSkin",skin,false,firstspawn)
        else
            TriggerEvent("skinchanger:loadSkin",skin,nil,nil)
        end
        firstspawn = false
        TriggerEvent("em_hud:updateMoney",money)
    end)

end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local playerPed = PlayerPedId()
        if playerPed and playerPed ~= -1 then
            if IsEntityDead(playerPed) then
                TriggerServerEvent("em_core:spawnPlayer",PlayerId(-1),_spawnNumber)
            end
        end
    end
end)

RegisterNetEvent("em_core_client:spawnPlayer")
AddEventHandler("em_core_client:spawnPlayer",base_spawnPlayer)

