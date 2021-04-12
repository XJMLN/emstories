local calloutID = nil
local missionElements = {}
local player = nil
local missionCoords = nil

DecorRegister("__MISSION_MC_ITEMS_",3)
DecorRegister("__MISSION_MC_PED_",3)
DecorRegister("__MISSION_MC_PED_SEX_",3)
DecorRegister("__MISSION_MC_PED_TEMP_",1)
DecorRegister("__MISSION_MC_PED_PULSE_",3)

local function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
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
end

exports("GetPedSickType",mcPedCallouts_getPedDisease)
exports("GetTaskList",mcPedCallouts_getTaskList)
RegisterNetEvent("mcSystem_createPedEnvironment")
AddEventHandler("mcSystem_createPedEnvironment",mcPedCallouts_create)
