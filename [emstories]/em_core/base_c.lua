local spawnData = {
    [4] = {
        {x=296.45,y=188.57,z=104.22,heading=153.65},
        {x=-1259.83,y=-1481.2,z=4.33,heading=90},
        {x=160.54,y=-988.59,z=30.09,heading=0.0},
        {x=-41.23,y=6508.26,z=31.45,heading=0.0},
        {x=1698.47,y=4806.75,z=41.84,heading=0.0},
        {x=1534.77,y=3777.0,z=41.84,heading=0.0},
    },
    [3] = {
        {x=202.64,y=-1630.31,z=29.68,heading=313.92},
    },
    [2]={
        {x=357.84,y=-593.44,z=28.79,heading=246.27},
        {x=1839.93,y=3671.5,z=34.28,heading=214.03},
        {x=-244.49,y=6329.29,z=32.43,heading=221.39},
    },
    [1]={
        {x=432.58,y=-984.79,z=30.71,heading=355.32},
        {x=1855.8,y=3682.13,z=34.27,heading=208.62},
        {x=-438.79,y=6020.92,z=31.49,heading=317.92},
    }
}
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
firstspawn = false
_spawnNumber = 0
_faction = 0
_alreadyInCreator = false
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

function base_spawnPlayer(spawnNumber,faction,skin,playerData)
    local source = PlayerId()
    local skin = skin
    local money = money
    if (_spawnNumber == 0) then
        _spawnNumber = spawnNumber
        _faction = faction
        firstspawn = true
    end
    if (_spawnNumber ~= spawnNumber) then
        _spawnNumber = spawnNumber
        _faction = faction
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
        local pos = spawnData[_faction][_spawnNumber]
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
        if (_faction ~= 4 and not _alreadyInCreator) then
            _alreadyInCreator = true
            TriggerServerEvent("em_duty:getPlayerFaction",_faction,departments[_faction][_spawnNumber],GetEntityModel(PlayerPedId()))
        end
        firstspawn = false
        TriggerEvent("em_hud:updateMoney",playerData)
    end)

end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        local playerPed = PlayerPedId()
        if playerPed and playerPed ~= -1 then
            if IsEntityDead(playerPed) then
                TriggerServerEvent("em_core:spawnPlayer",_spawnNumber,_faction)
            end
        end
    end
end)

RegisterNetEvent("em_core_client:spawnPlayer")
AddEventHandler("em_core_client:spawnPlayer",base_spawnPlayer)

