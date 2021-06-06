local MISSION_IDS = {[13]=true,[14]=true}
local calloutData = {blip=nil,ped=nil,started=false,steps=0,coords=nil, diagnose=nil,pulse=nil,temp=nil,taskList="",pedData=nil}
local taskWatchData = {}
local currentID = nil
local dropoffCoords = nil
local dropoffState = false
local EMERGENCY_POINTS = {
    "366.27,-596.34,28.92", -- lsmc
}
DecorRegister("__MISSION_MC_ITEMS_",3)
DecorRegister("__MISSION_MC_PED_",3)
DecorRegister("__MISSION_MC_PED_SEX_",3)
DecorRegister("__MISSION_MC_PED_TEMP_",1)
DecorRegister("__MISSION_MC_PED_PULSE_",3)

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end

function mcPedCallouts_getPedDisease()
    return calloutData.diagnose
end
function mcPedCallouts_getTaskList()
    return calloutData.taskList
end

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

function mcPedCallouts_pedInAmbulance()
    DrawHelp("Przetransportuj poszkodowanego do szpitala. Najbliższy szpital został zaznaczony na mapie.")
    DeleteEntity(calloutData.ped)
    calloutData.ped = nil
    dropoffCoords = getClosestCoords(EMERGENCY_POINTS)
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
    if (not MISSION_IDS[ID]) then return end
    if (success) then
        TriggerServerEvent("callouts_end",currentID,true)
    end
    DeleteEntity(calloutData.ped)
    DeleteEntity(calloutData.blip)
    RemoveBlip(calloutData.blip)
    calloutData = {blip=nil,ped=nil,started=false,steps=0,coords=nil, diagnose=nil,pulse=nil,temp=nil,taskList="",pedData=nil}
    dropoffState = false
    dropoffCoords = nil
    currentID = nil
    taskWatchData = {}
end
function callout_startupMission(ID, data, location)
    if (not MISSION_IDS[ID]) then return end
    exports.em_mc_gui:restartVariables()
    currentID = ID
    local pedModel = GetHashKey(PEDS[math.random(1,#PEDS)])
    local pedData = data.pedData
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Citizen.Wait(0)
    end
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
    local pulse = math.random(pedData.pulseFrom,pedData.pulseTo)
    local diagnose = pedData.diagnose[math.random(1,#pedData.diagnose)]
    local taskList = pedData.taskList
    DecorSetInt(NPC,"__MISSION_MC_PED_",2)
    calloutData.ped = NPC
    calloutData.blip = blip
    calloutData.temp = temp
    calloutData.pulse = pulse
    calloutData.diagnose = diagnose
    calloutData.taskList = taskList
    calloutData.pedData = pedData
    DecorSetInt(NPC,"__MISSION_MC_PED_PULSE_",pulse)
    DecorSetFloat(NPC,"__MISSION_MC_PED_TEMP_",temp)
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

exports("onPlayerPutPedInAmbulance",mcPedCallouts_pedInAmbulance)
exports("GetPedSickType",mcPedCallouts_getPedDisease)
exports("GetTaskList",mcPedCallouts_getTaskList)
exports("TaskWatcher_completeID",callout_accident_taskWatcherComplete)
RegisterNetEvent("em_callouts:startupMission")
AddEventHandler("em_callouts:startupMission",callout_startupMission)



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
