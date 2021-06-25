local MISSION_ID = 16
local calloutData = {train=nil,blip=nil,driver=nil,ped=nil,steps=0,pulse=nil,diagnose=nil,coords=nil,temp=nil,taskList="",pedData=nil}
local taskWatchData = {}
local dropoffCoords = nil
local dropoffState = nil
local currentID = nil

DecorRegister("__MISSION_MC_ITEMS_",3)
DecorRegister("__MISSION_MC_PED_",3)
DecorRegister("__MISSION_MC_PED_SEX_",3)
DecorRegister("__MISSION_MC_PED_TEMP_",1)
DecorRegister("__MISSION_MC_PED_PULSE_",3)

function callout_accident_taskWatcher(tasks)
    taskWatchData = {}
    taskWatchData.completedTasks = {}
    taskWatchData.tasks = tasks
    taskWatchData.taskCounter = tablelength(tasks)
    taskWatchData.completedTaskCounter = 0
end

function callout_accident_taskWatcherComplete(taskID)
    if (taskWatchData.tasks[taskID]) then
        if (not taskWatchData.completedTasks[taskID]) then
            taskWatchData.completedTasks[taskID] = true
            taskWatchData.completedTaskCounter = taskWatchData.completedTaskCounter + 1
        end
    end
end

function callout_cancelCallout(ID)
    if (calloutData and calloutData.started) then
        DeleteEntity(calloutData.ped)
        DeleteEntity(calloutData.blip)
        DeleteMissionTrain(calloutData.train)
        DeleteEntity(calloutData.driver)
        RemoveBlip(calloutData.blip)
        calloutData = {blip=nil,ped=nil,train=nil,driver=nil,started=false,steps=0,coords=nil, diagnose=nil,pulse=nil,temp=nil,taskList="",pedData=nil}
        dropoffState = false
        dropoffCoords = nil
        currentID = nil
        taskWatchData = {}
    end
end

function mcPedCallouts_pedInAmbulance()
    if (not currentID) then return end
    DrawHelp("Przetransportuj poszkodowanego do szpitala. Najbliższy szpital został zaznaczony na mapie.")
    DeleteEntity(calloutData.ped)
    DeleteEntity(calloutData.blip)
    RemoveBlip(calloutData.blip)
    calloutData.ped = nil
    dropoffCoords = getClosestCoords(HOSPITAL_POINTS)
    ClearAllBlipRoutes()
    local blip = AddBlipForCoord(dropoffCoords[1],dropoffCoords[2],dropoffCoords[3])
    SetBlipSprite(blip,153)
    SetBlipDisplay(blip,4)
    SetBlipColour(blip,3)
    SetBlipAsShortRange(blip,false)
    SetBlipScale(blip,1.0)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Szpital")
    EndTextCommandSetBlipName(blip)
    calloutData.blip = blip
    dropoffState = true
end

function callout_endMission(ID,success)
    if (MISSION_ID ~= ID) then return end
    if (success) then
        TriggerServerEvent("callouts_end",currentID,true)
    end
    DeleteEntity(calloutData.ped)
    DeleteEntity(calloutData.blip)
    DeleteMissionTrain(calloutData.train)
    DeleteEntity(calloutData.driver)
    RemoveBlip(calloutData.blip)
    calloutData = {blip=nil,ped=nil,train=nil,driver=nil,started=false,steps=0,coords=nil, diagnose=nil,pulse=nil,temp=nil,taskList="",pedData=nil}
    dropoffState = false
    dropoffCoords = nil
    currentID = nil
    taskWatchData = {}
end

function callout_startupMission(ID, data, location)
    if (MISSION_ID ~= ID) then return end
    exports.em_mc_gui:restartVariables()
    currentID = ID
    
    local pedModel = GetHashKey(PEDS[math.random(1,#PEDS)])
    local pedData = data.pedData
    loadAnimDict(pedData.animationDict)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Citizen.Wait(0)
    end
    local trainModel =GetHashKey("metrotrain")
    RequestModel(trainModel)
    while not HasModelLoaded(trainModel) do
        RequestModel(trainModel)
        Citizen.Wait(0)
    end
    local trainPos = location.trainPos
    local train = CreateMissionTrain(24,trainPos[1],trainPos[2],trainPos[3],trainPos[4])
    local driverModel = GetHashKey("s_m_m_lsmetro_01")
    RequestModel(driverModel)
	while not HasModelLoaded(driverModel) do
		RequestModel(driverModel)
		Citizen.Wait(0)
	end
    local driver = CreatePedInsideVehicle(train, 26, driverModel, -1, 1, true)
    SetEntityAsMissionEntity(driver,true,true)
    SetEntityAsMissionEntity(train,true,true)
    SetBlockingOfNonTemporaryEvents(driver,true)
    SetModelAsNoLongerNeeded(driverModel)
    SetModelAsNoLongerNeeded(pedModel)
    FreezeEntityPosition(train,true)
    SetTrainCruiseSpeed(train, 0.0)
    local blip = AddBlipForCoord(location.x, location.y, location.z)
    SetBlipSprite(blip,data.sprite)
    SetBlipDisplay(blip,4)
    SetBlipColour(blip,data.colour)
    SetBlipScale(blip, 1.0)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, data.colour)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Wezwanie:"..data.title)
    EndTextCommandSetBlipName(blip)
    local NPC = CreatePed(26, pedModel, location.x, location.y, location.z,location.heading, true, true)
    local sex = GetPedType(NPC)
    SetBlockingOfNonTemporaryEvents(NPC,true)
    DecorSetInt(NPC,"__MISSION_MC_PED_SEX_",sex)
    local temp = round(randomFloat(pedData.temperatureFrom,pedData.temperatureTo),1)
    local pulse = 1
    if (pedData.pulseFrom ~= 'dead') then
        pulse = math.random(pedData.pulseFrom,pedData.pulseTo)
    end
    local diagnose = pedData.diagnose[math.random(1,#pedData.diagnose)]
    local taskList = pedData.taskList
    DecorSetInt(NPC,"__MISSION_MC_PED_",2)
    calloutData.ped = NPC
    calloutData.blip = blip
    calloutData.temp = temp
    calloutData.pulse = pulse
    Entity(NPC).state.diagnose = diagnose
    Entity(NPC).state.taskList = taskList
    calloutData.pedData = pedData
    calloutData.started = true
    calloutData.train = train
    calloutData.driver = driver
    DecorSetInt(NPC,"__MISSION_MC_PED_PULSE_",pulse)
    DecorSetFloat(NPC,"__MISSION_MC_PED_TEMP_",temp)
    Wait(500)
    TaskPlayAnim(NPC,pedData.animationDict,pedData.animationName,2.0,2.0,-1,2,0,false,false,false)
    callout_accident_taskWatcher(pedData.tasksIDs)
end

Citizen.CreateThread(function()
    while true do
        if (dropoffState) then
            DrawMarker(1,dropoffCoords[1],dropoffCoords[2],dropoffCoords[3],0.0,0.0,0.0,0,180.0,0.0,1.5,1.5,1.5,122,199,74,90,false,true,2,nil,nil,false)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if (vehicle and GetDistanceBetweenCoords(dropoffCoords[1],dropoffCoords[2],dropoffCoords[3], GetEntityCoords(vehicle,false)) < 1.5 and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
                DrawHelp("Wciśnij ~INPUT_PICKUP~ aby personel szpitala przejął poszkodowanego.")
                if (IsControlJustPressed(0,38)) then
                    callout_endMission(currentID,true)
                end
            end
        end
        Citizen.Wait(10)
    end
end)
exports("TaskWatcher_completeID",callout_accident_taskWatcherComplete)
RegisterNetEvent("onPlayerPutPedInAmbulance")
AddEventHandler("onPlayerPutPedInAmbulance",mcPedCallouts_pedInAmbulance)
RegisterNetEvent("em_callouts:startupMission")
AddEventHandler("em_callouts:startupMission",callout_startupMission)
RegisterNetEvent("em_callouts:cancelMission")
AddEventHandler("em_callouts:cancelMission",callout_cancelCallout)


function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end
function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end
function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end
