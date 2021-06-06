local isDMVOpened = false
local isPlayerInExam = false
local ped = nil 
local playerVehicle = nil
local pedVehicle = nil
local checkpoints = {}
local currentPoint = 1
local VEHICLE_DATA = {
    -- C
    ['benson']="pjB",
    ['biff']="pjC",
    ['cerberus']="pjC",
    ['cerberus2']="pjC",
    ['cerberus3']="pjC",
    ['hauler']="pjC",
    ['hauler2']="pjC",
    ['mule']="pjC",
    ['mule2']="pjC",
    ['mule3']="pjC",
    ['mule4']="pjC",
    ['packer']="pjC",
    ['phantom']="pjC",
    ['phantom2']="pjC",
    ['phantom3']="pjC",
    ['pounder']="pjC",
    ['pounder2']="pjC",
    ['stockade']="pjC",
    ['stockade3']="pjC",
    ['terbyte']="pjC",
    ['bulldozer']="pjC",
    ['cutter']="pjC",
    ['dump']="pjC",
    ['flatbed']="pjC",
    ['handler']="pjC",
    ['mixer']="pjC",
    ['mixer2']="pjC",
    ['rubble']="pjC",
    ['tiptruck']="pjC",
    ['tiptruck2']="pjC",
    ['airbus']="pjC",
    ['brickade']="pjC",
    ['bus']="pjC",
    ['coach']="pjC",
    ['pbus2']="pjC",
    ['rallytruck']="pjC",
    ['rentalbus']="pjC",
    ['tourbus']="pjC",
    ['trash']="pjC",
    ['trash2']="pjC",
    ['docktug']="pjC",
    ['ripley']="pjC",
    ['scrap']="pjC",
    ['towtruck']="pjC",
    ['towtruck2']="pjC",
    ['tractor']="pjC",
    ['tractor2']="pjC",
    ['tractor3']="pjC",
    ['utillitruck']="pjC",
    ['utillitruck2']="pjC",
    ['slamtruck']="pjC",
    ['boxville']="pjC",
    ['boxville2']="pjC",
    ['boxville3']="pjC",
    ['boxville4']="pjC",
    ['boxville5']="pjC",
    ['camper']="pjC",
    ['taco']="pjC",

    -- A
    ['akuma']="pjA",
    ['avarus']="pjA",
    ['bagger']="pjA",
    ['bati']="pjA",
    ['bati2']="pjA",
    ['bf400']="pjA",
    ['carbonrs']="pjA",
    ['chimera']="pjA",
    ['cliffhanger']="pjA",
    ['daemon']="pjA",
    ['daemon2']="pjA",
    ['defiler']="pjA",
    ['deathbike']="pjA",
    ['deathbike2']="pjA",
    ['deathbike3']="pjA",
    ['diablous']="pjA",
    ['diablous2']="pjA",
    ['double']="pjA",
    ['enduro']="pjA",
    ['esskey']="pjA",
    ['faggio']="pjA",
    ['faggio2']="pjA",
    ['faggio3']="pjA",
    ['fcr']="pjA",
    ['fcr2']="pjA",
    ['gargoyle']="pjA",
    ['hakuchou']="pjA",
    ['hakuchou2']="pjA",
    ['hexer']="pjA",
    ['innovation']="pjA",
    ['lectro']="pjA",
    ['manchez']="pjA",
    ['nemesis']="pjA",
    ['nightblade']="pjA",
    ['oppressor']="pjA",
    ['oppressor2']="pjA",
    ['pcj']="pjA",
    ['ratbike']="pjA",
    ['ruffian']="pjA",
    ['rrocket']="pjA",
    ['sanchez']="pjA",
    ['sanchez2']="pjA",
    ['sanctus']="pjA",
    ['shotaro']="pjA",
    ['sovereign']="pjA",
    ['stryder']="pjA",
    ['thrust']="pjA",
    ['vader']="pjA",
    ['vindicator']="pjA",
    ['vortex']="pjA",
    ['wolfsbane']="pjA",
    ['zombiea']="pjA",
    ['zombieb']="pjA",
    ['manchez2']="pjA",
}
function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end

function dmv_showGUI(state)
    if (state) then
        isDMVOpened = true
        SetNuiFocus(true,true)
        SendNUIMessage({type="showDMV"})
    end
end

function dmv_hideGUI(data,cb)
    if (isDMVOpened) then
    isDMVOpened = false
    SendNUIMessage({type="closeDMV"})
    SetNuiFocus(false)
    if (data and data.a) then
        cb("ok")
    end
end
end

function dmv_checkout(data,cb)
    if (not isDMVOpened) then return end
    local examID = data.exam
    local licenses = json.decode(LocalPlayer.state.pj)
    if (licenses[examID] == 0) then
        TriggerServerEvent("dmv:startExam",examID)
        cb("ok")
    else
        SendNUIMessage({type="showError",data="Posiadasz prawo jazdy tej kategorii."})
        cb("ok")
        return
    end
    
end
function dmv_showError(text)
    SendNUIMessage({type="showError",data=text})
end
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
function dmv_startExam(ID)
    if (not isDMVOpened) then return end
    local ID = ID
    dmv_hideGUI()
    exports.em_3dtext:DrawNotification("Szkoła jazdy","","Z Twojego konta pobrano $300. Udaj się do pojazdu stojącego na parkingu.",false,"CHAR_CARSITE",0,false)
    RequestModel(GetHashKey(VEHICLES[ID]))
    while not HasModelLoaded(GetHashKey(VEHICLES[ID])) do
        Citizen.Wait(10)
    end
    RequestModel(GetHashKey(INSTRUCTOR_MODEL))
    while not HasModelLoaded(GetHashKey(INSTRUCTOR_MODEL)) do
        Citizen.Wait(10)
    end
    RequestModel(GetHashKey("dilettantedl"))
    while not HasModelLoaded(GetHashKey("dilettantedl")) do
        Citizen.Wait(10)
    end
    playerVehicle = CreateVehicle(GetHashKey(VEHICLES[ID]),-1325.3,-395.88,35.93,31.41,true,false)
    if (ID == 'pjA') then
        pedVehicle = CreateVehicle(GetHashKey("dilettantedl"),-1322.8,-393.0,35.95,31.86,true,false)
        ped = CreatePedInsideVehicle(pedVehicle,26,INSTRUCTOR_MODEL,-1,true,false)
        SetEntityAsMissionEntity(pedVehicle,true,true)
        SetVehicleColours(playerVehicle,38,38)
    end

    if (ID == 'pjB' or ID == 'pjC') then
        ped = CreatePedInsideVehicle(playerVehicle,26,INSTRUCTOR_MODEL,0,true,false)
    end
    SetEntityAsMissionEntity(playerVehicle,true,true)
    SetEntityAsMissionEntity(ped,true,true)
    SetBlockingOfNonTemporaryEvents(ped,true)
    TaskVehicleEscort(ped,pedVehicle,playerVehicle,-1,90.0,60,5.0,true,10.0)
    
    isPlayerInExam = true
    for i,v in ipairs(TRACKS[ID]) do
        local checkpoint
        if (i+1 == tablelength(TRACKS[ID])) then
            checkpoint = CreateCheckpoint(4, v[1],v[2],v[3]-0.5,v[1],v[2],v[3], 2.0, 255, 125, 0, 125, 0)
        else
            checkpoint = CreateCheckpoint(0, v[1],v[2],v[3]-0.5,TRACKS[ID][i+1][1],TRACKS[ID][i+1][2],TRACKS[ID][i+1][3], 2.0, 255, 125, 0, 125, 0)
        end
        checkpoints[i] = checkpoint
    end
    Citizen.CreateThread(function()
        while true do
            if (isPlayerInExam) then
                if (GetVehiclePedIsIn(PlayerPedId(),false) == playerVehicle) then
                    SetVehicleDoorsLocked(playerVehicle,4)
                    SetEntityMaxSpeed(playerVehicle,32/2.236936)
                    local current = TRACKS[ID][currentPoint]
                    local vehCoord = GetEntityCoords(playerVehicle,false)
                    if (GetDistanceBetweenCoords(current[1],current[2],current[3],vehCoord[1],vehCoord[2],vehCoord[3])<2.5) then
                        DeleteCheckpoint(checkpoints[currentPoint])
                        if (TRACKS[ID][currentPoint].last) then
                            DeleteEntity(playerVehicle)
                            DeleteEntity(ped)
                            
                            if (DoesEntityExist(pedVehicle)) then
                                DeleteEntity(pedVehicle)
                            end
                            isPlayerInExam = false
                            pedVehicle = nil
                            playerVehicle = nil
                            ped = nil
                            exports.em_3dtext:DrawNotification("Szkoła jazdy","","Otrzymałeś prawo jazdy.",false,"CHAR_CARSITE",0,false)
                            TriggerServerEvent("dmv:giveLicense",ID)
                            break
                        else
                            if (TRACKS[ID][currentPoint].checkRotation) then
                                local vehRot = GetEntityHeading(playerVehicle)
                                if (vehRot>TRACKS[ID][currentPoint].checkRotation[1] and vehRot<TRACKS[ID][currentPoint].checkRotation[2]) then
                                    currentPoint = currentPoint + 1
                                end
                            else
                                currentPoint = currentPoint + 1

                            end
                        end
                    end
                    BeginTextCommandPrint("STRING")
                    AddTextComponentSubstringPlayerName("Egzaminator: "..TRACKS[ID][currentPoint-1].dialog )
                    EndTextCommandPrint(1500,1)
                end
            end
            Citizen.Wait(0)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        DrawMarker(25,MARKER_POSITION[1],MARKER_POSITION[2],MARKER_POSITION[3]-1.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,235, 174, 52,150,false,true,2,nil,nil,nil,false)
        DrawMarker(36,MARKER_POSITION[1],MARKER_POSITION[2],MARKER_POSITION[3],0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,235, 174, 52,150,false,true,2,nil,nil,nil,false)
        local ped = GetEntityCoords(PlayerPedId(),false)
        if (GetVehiclePedIsIn(PlayerPedId(),false) == 0) and (GetDistanceBetweenCoords(ped[1],ped[2], ped[3],MARKER_POSITION[1],MARKER_POSITION[2],MARKER_POSITION[3], false)<1.5) then
            DrawHelp("Wciśnij ~INPUT_PICKUP~ aby wyświetlić ofertę szkoły jazdy.")
            if (IsControlJustPressed(0,38)) then
                dmv_showGUI(true)
            end
        end

        local fid = LocalPlayer.state.factionID
        if (not fid) then
            local veh = GetVehiclePedIsTryingToEnter(PlayerPedId())
            if (veh ~= playerVehicle) then
                local seat = GetSeatPedIsTryingToEnter(PlayerPedId())
                local playerLicenses = json.decode(LocalPlayer.state.pj)
                local vehData = VEHICLE_DATA[string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))]
                if (veh~=0 and seat == -1) then
                    if (not vehData) then
                        vehData = "pjB"
                    end
                    if (vehData and playerLicenses[vehData]~=1) then
                        ClearPedTasksImmediately(PlayerPedId())
                        exports.em_3dtext:DrawNotification("Szkoła jazdy","","~r~Nie posiadasz prawa jazdy.",true,"CHAR_CARSITE",0,false)
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("dmv:showError")
AddEventHandler("dmv:showError",dmv_showError)
RegisterNetEvent("dmv:startExamSuccess")
AddEventHandler("dmv:startExamSuccess",dmv_startExam)
RegisterNUICallback("exitDMV",dmv_hideGUI)
RegisterNUICallback("examCheckout",dmv_checkout)
