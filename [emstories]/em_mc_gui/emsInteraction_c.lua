local isInteractionWindowOpen = false
local canOpenInteraction = false
local ped = false
local pedData = {}

function loadAnimDict( dict )
	while ( not HasAnimDictLoaded( dict ) ) do
		RequestAnimDict( dict )
		Citizen.Wait( 0 )
	end
end

local function GetPedInFront()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end
local function DrawHelp(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, false, 1, 0)
end
local function getPlayerElementData(player)
    local FID = LocalPlayer.state.factionID
    local DID = LocalPlayer.state.departmentID
    return {factionID=FID,departmentID=DID}
end
local function isPlayerHoldingMedicBag()
    return exports.em_mc_bag:isPlayerHoldingBag()
end
local function isPlayerWithStretcher()
    local state = exports.em_mc_stretcher:getStretcherState()
    if (state == 0) then return true else return false end
end
function getStretcherState()
    return exports.em_mc_stretcher:getStretcherState()
end 
function emsInteraction_gui()
    if (isInteractionWindowOpen) then
        isInteractionWindowOpen = false
        SendNUIMessage({type="closeInteraction"})
        SetNuiFocus(false)
        
        return
    end
    if (canOpenInteraction) then
        isInteractionWindowOpen = true
        SetNuiFocus(true, true)
        Citizen.Wait(100)
        SendNUIMessage({type="openInteraction",data={hasBag=isPlayerHoldingMedicBag(),hasStretcher=isPlayerWithStretcher()}})
        pedData.sex = DecorGetInt(ped,"__MISSION_MC_PED_SEX_")
        SendNUIMessage({type="showPedInformation",data=pedData})
    else

    end
end

function restartVariable()
    SendNUIMessage({type="updatePedData",data={{temp="Brak informacji",puls="Brak informacji",diagnose="Brak informacji",taskList="Zbyt mało informacji aby określić diagnozę."}}})
end
local inInteraction = false
function emsInteraction_action(response, cb)
    if (not isInteractionWindowOpen) then return end
    local actionID = response.actionID 
    if (actionID == -1) then
        emsInteraction_gui()
        cb("ok")
        return
    end
    if (actionID == 1) then
        pedData.temp = DecorGetFloat(ped,"__MISSION_MC_PED_TEMP_")
        SendNUIMessage({type="updatePedData",data=pedData})
    end
    if (actionID == 2) then
        pedData.puls = DecorGetInt(ped,"__MISSION_MC_PED_PULSE_")
        SendNUIMessage({type="updatePedData",data=pedData})
    end
    if (actionID == 3) then
        if (inInteraction) then
            DrawHelp("Wykonujesz aktualnie czynność. Poczekaj aż ją skończysz.")
            return
        end
        inInteraction = true
        loadAnimDict("random@train_tracks")
        pedData.diagnose = exports.em_callouts:GetPedSickType()
        TaskPlayAnim(GetPlayerPed(-1),"random@train_tracks","idle_e",2.0,2.0,-1,0,0,false,false,false)
        Wait(4500)
        inInteraction = false
        SendNUIMessage({type="updatePedData",data=pedData})
    end
    if (actionID == 4) then
        if (inInteraction) then
            DrawHelp("Wykonujesz aktualnie czynność. Poczekaj aż ją skończysz.")
            return
        end
        inInteraction = true
        loadAnimDict("gestures@f@standing@casual")
        exports.em_callouts:TaskWatcher_completeID(1)
        TaskPlayAnim(GetPlayerPed(-1),"gestures@f@standing@casual","gesture_hand_down",2.0,2.0,-1,0,0,false,false,false)
        Wait(2500)
        inInteraction = false
        ClearPedTasks(GetPlayerPed(-1))
    end
    if (actionID == 5) then
        if (inInteraction) then
            DrawHelp("Wykonujesz aktualnie czynność. Poczekaj aż ją skończysz.")
            return
        end
        inInteraction = true
        loadAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
        exports.em_callouts:TaskWatcher_completeID(2)
        TaskPlayAnim(GetPlayerPed(-1),"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer",2.0,2.0,-1,0,0,false,false,false)
        Wait(5000)
        inInteraction = false
        ClearPedTasks(GetPlayerPed(-1))
    end
    if (actionID == 6) then
        emsInteraction_gui()
        cb('ok')
        exports.em_mc_stretcher:putNPCOnStretcher(ped)
        exports.em_callouts:TaskWatcher_completeID(3)
        

    end
    if (pedData.diagnose and pedData.puls and pedData.temp) then
        pedData.taskList = exports.em_callouts:GetTaskList()
        SendNUIMessage({type="updatePedData",data=pedData})
    end
    cb("ok")
end
Citizen.CreateThread(function()
    while true do
        if (GetVehiclePedIsIn(PlayerPedId(),false) == 0) then
            local playerData = getPlayerElementData(PlayerPedId(-1))
            if (playerData.factionID == 2) then
                local plrCoords = GetEntityCoords(GetPlayerPed(-1),1)
                ped = GetPedInFront()
                if (ped ~= 0) then
                    local pedData = DecorGetInt(ped,"__MISSION_MC_PED_")
                    if (pedData == 2) then
                        local hasPlayerBag = isPlayerHoldingMedicBag()
                        local hasPlayerStretcher = isPlayerWithStretcher()
                        if (getStretcherState() ~= 2) then
                            if (not hasPlayerBag and not hasPlayerStretcher) then
                                DrawHelp("Nie posiadasz torby medycznej aby rozpocząć interakcję.")
                                canOpenInteraction = false
                            else
                                local pedCoords = GetEntityCoords(ped)
                                if (#(plrCoords - pedCoords) <= 2.0) then
                                    DrawHelp("Interakcja z poszkodowanym - ~INPUT_PICKUP~")
                                    canOpenInteraction = true
                                else
                                    canOpenInteraction = false
                                end
                            end
                        end
                    end
                else
                    canOpenInteraction = false
                end
            end
        end
        Citizen.Wait(10)
    end
end)
exports("restartVariables",restartVariable)
RegisterNUICallback("Interaction",emsInteraction_action)
RegisterCommand("openPedInteractionMenu",emsInteraction_gui)
RegisterKeyMapping("openPedInteractionMenu","EMS: Interakcja z poszkodowanym","keyboard","e")