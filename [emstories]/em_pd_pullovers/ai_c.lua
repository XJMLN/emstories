--TextDraws
STOPPED_PEDS = {}

function DrawDialogue(text)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(3000,0)
end
function DrawHelp(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, false, 1, 0)
end
function GetPedInFront()
	local player = PlayerId()
	local plyPed = GetPlayerPed(player)
	local plyPos = GetEntityCoords(plyPed, false)
	local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
	local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
	local _, _, _, _, ped = GetShapeTestResult(rayHandle)
	return ped
end
function ai_startPedPullover(ped, netID,pedType)
    STOPPED_PEDS[netID] = {stopped=true, ped=ped,pedType=pedType}
    STOPPED_PEDS[netID].blip = AddBlipForEntity(ped)
    SetBlipDisplay(STOPPED_PEDS[netID].blip, 2)
    SetBlipSprite(STOPPED_PEDS[netID].blip, 280)
    SetBlipColour(STOPPED_PEDS[netID].blip, 46)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Zatrzymana osoba")
    EndTextCommandSetBlipName(STOPPED_PEDS[netID].blip)
    local playerGroupId = GetPedGroupIndex(GetPlayerPed(-1))
    SetPedAsGroupMember(ped,playerGroupId)
end

Citizen.CreateThread(function()
    while true do
        if (GetVehiclePedIsIn(PlayerPedId(), false) == 0) then
            local ped = GetPedInFront() 
            local pedType = GetPedType(ped)
            if (pedType == 4 or pedType == 5) then
                local pedID = NetworkGetNetworkIdFromEntity(ped)
                while pedID < 1 do
                    pedID = NetworkGetNetworkIdFromEntity(ped)
                end
                if (STOPPED_PEDS[pedID] and STOPPED_PEDS[pedID].stopped) then
                    local plrPos = GetEntityCoords(GetPlayerPed(-1),1)
                    local pedPos = GetEntityCoords(ped, 1)
                    local dist = GetDistanceBetweenCoords(plrPos, pedPos)
                    if (dist <=2.5) then
                        DrawHelp("Naciśnij ~INPUT_PICKUP~ aby rozpocząć interakcję z zatrzymanym.")
                        GUI.Variables.player.distance = true
                        GUI.Variables.player.currentPed = pedID
                    else
                        GUI.Variables.player.distance = false
                        GUI.Variables.player.currentPed = nil
                        if (RageUI.Visible(GUI['pullover'])) then
                            RageUI.Visible(GUI['pullover'],false)
                        end
                    end
                end
                if (IsControlPressed(0,74) and ped and pedType) then
                    if (not IsPedDeadOrDying(ped)) then
                        SetBlockingOfNonTemporaryEvents(ped,true)
                        ai_startPedPullover(ped, pedID,pedType)
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)


