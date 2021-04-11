local calloutID = nil
local missionElements = {}
local player = nil
local missionCoords = nil

DecorRegister("__MISSION_MC_ITEMS_",3)
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
    SetEntityHeading(NPC, pedData.heading)
    SetBlockingOfNonTemporaryEvents(NPC,true)
    

end
RegisterNetEvent("mcSystem_createPedEnvironment")
AddEventHandler("mcSystem_createPedEnvironment",mcPedCallouts_create)
