local calloutID = nil
local missionElements = {}
local player = nil
local missionCoords = nil
local taskWatchData = {}
local dropoffCoords = nil
local dropoffState = false
DecorRegister("__MISSION_MC_ITEMS_",3)
DecorRegister("__MISSION_MC_PED_",3)
DecorRegister("__MISSION_MC_PED_SEX_",3)
DecorRegister("__MISSION_MC_PED_TEMP_",1)
DecorRegister("__MISSION_MC_PED_PULSE_",3)

local function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end
local function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
local function round(num, numDecimalPlaces)
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

function mcPedCallouts_getPedDisease()
    return missionElements[player].pedData.diagnose
end
function mcPedCallouts_getTaskList()
    return missionElements[player].pedData.taskList
end

function mcPedCallouts_initTaskWatcher(tasks)
    taskWatchData = {}
    taskWatchData.completedTasks = {}
    taskWatchData.tasks = tasks
    taskWatchData.taskCounter = tablelength(tasks)
    taskWatchData.completedTaskCounter = 0
end

function mcPedCallouts_taskWatcherComplete(taskID)
    if (taskWatchData.tasks[taskID]) then
        if (not taskWatchData.completedTasks[taskID]) then
            taskWatchData.completedTasks[taskID] = true
            taskWatchData.completedTaskCounter = taskWatchData.completedTaskCounter + 1
        end
    end
end

function mcPedCallouts_pedInAmbulance()
    DrawHelp("Przetransportuj poszkodowanego do szpitala. Najbliższy szpital został zaznaczony na mapie.")
    DeleteEntity(missionElements[player].ped)
    missionElements[player].ped = nil
    TriggerEvent("mcSystem_destroyRoute")
    dropoffCoords = getClosestCoords(EMERGENCY_POINTS)
    local blip = AddBlipForCoord(dropoffCoords[1],dropoffCoords[2],dropoffCoords[3])
    SetBlipSprite(blip,153)
    SetBlipDisplay(blip,4)
    SetBlipColour(blip,3)
    SetBlipAsShortRange(blip,false)
    SetBlipScale(blip,1.0)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cel Wezwania")
    EndTextCommandSetBlipName(blip)
    missionElements[player].blip = blip
    ClearGpsMultiRoute()
    StartGpsMultiRoute(10, true, true)
    AddPointToGpsMultiRoute(table.unpack(dropoffCoords))
    SetGpsMultiRouteRender(true)
    dropoffState = true
end
function mcPedCallouts_create(data)
    calloutID = data.systemData.id
    player = source
    missionElements[player] = {}
    missionElements[player].completedSteps = 0
    local coords = data.location
    missionCoords = coords
    local pedData = data.pedData
    TriggerEvent("mcSystem_createRoute",coords, calloutID)
    local npcSex = math.random(4,5)
    local npcModel = GetHashKey(PED_MODELS[npcSex][math.random(1,#PED_MODELS[npcSex])])
    local npcCoord = pedData.location
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Citizen.Wait(1)
    end
    local NPC = CreatePed(npcSex, npcModel, npcCoord.x,npcCoord.y,npcCoord.z,pedData.heading, false, true)
    missionElements[player].ped = NPC
    
    SetEntityHeading(NPC, pedData.heading)
    SetBlockingOfNonTemporaryEvents(NPC,true)
    DecorSetInt(NPC,"__MISSION_MC_PED_",2)
    DecorSetInt(NPC,"__MISSION_MC_PED_SEX_",npcSex)
    local temp = round(randomFloat(pedData.temperatureFrom,pedData.temperatureTo),1)
    local pulse = math.random(pedData.pulseFrom,pedData.pulseTo)
    local diagnose = pedData.diagnose[math.random(1,#pedData.diagnose)]
    local taskList = pedData.taskList
    pedData.diagnose = diagnose
    pedData.pulse = pulse
    pedData.temp = temp
    pedData.taskList = taskList
    missionElements[player].pedData = pedData
    DecorSetInt(NPC,"__MISSION_MC_PED_PULSE_",pulse)
    DecorSetFloat(NPC,"__MISSION_MC_PED_TEMP_",temp)
    mcPedCallouts_initTaskWatcher(pedData.tasksIDs)
end

function mcPedCallouts_endCallout()
    TriggerServerEvent("mcMission:endMission",calloutID,taskWatchData.completedTaskCounter)
    ClearGpsMultiRoute()
    RemoveBlip(missionElements[player].blip)
    DeleteEntity(missionElements[player].blip)
    missionElements[player].blip = nil
    dropoffState = nil
    dropoffCoords = nil
    missionCoords = nil
    
    taskWatchData = {}
    calloutID = nil
end
Citizen.CreateThread(function()
    while true do
        if (dropoffState) then
            DrawMarker(1,dropoffCoords[1],dropoffCoords[2],dropoffCoords[3],0.0,0.0,0.0,0,180.0,0.0,1.5,1.5,1.5,122,199,74,90,false,true,2,nil,nil,false)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if (vehicle and GetDistanceBetweenCoords(dropoffCoords[1],dropoffCoords[2],dropoffCoords[3], GetEntityCoords(vehicle,false)) < 1.5 and GetPedInVehicleSeat(vehicle,-1)==PlayerPedId()) then
                DrawHelp("Wciśnij ~INPUT_PICKUP~ aby personel szpitala przejął poszkodowanego.")
                if (IsControlJustPressed(0,38)) then
                    mcPedCallouts_endCallout()
                end
            end
        end
        Citizen.Wait(10)
    end
end)
function mcPedCallouts_cancel()
    if (missionElements[player]) then
        ClearGpsMultiRoute()
        RemoveBlip(missionElements[player].blip)
        DeleteEntity(missionElements[player].blip)
        DeleteEntity(missionElements[player].ped)
        missionElements[player].ped = nil
        missionElements[player].blip = nil
        dropoffState = nil
        dropoffCoords = nil
        missionCoords = nil
        taskWatchData = {}
        calloutID = nil
    end
end
exports("mc_pedCallout_cancel",mcPedCallouts_cancel)
exports("onPlayerPutPedInAmbulance",mcPedCallouts_pedInAmbulance)
exports("GetPedSickType",mcPedCallouts_getPedDisease)
exports("GetTaskList",mcPedCallouts_getTaskList)
exports("TaskWatcher_completeID",mcPedCallouts_taskWatcherComplete)
RegisterNetEvent("mcSystem_createPedEnvironment")
AddEventHandler("mcSystem_createPedEnvironment",mcPedCallouts_create)
