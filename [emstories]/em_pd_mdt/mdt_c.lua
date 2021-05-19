local isMDTOpened = false
local policeCars = {
    ['14pdcharger']=true
}

local function getPlayerElementData()
    local FID = LocalPlayer.state.factionID
    local DID = LocalPlayer.state.departmentID
    return {factionID=FID,departmentID=DID}
end

function mdt_render(data,citations,departmentData)
    SetNuiFocus(true,true)
    SendNUIMessage({type="renderApp",data=true})
    SendNUIMessage({type="sendPlayerData",data={playerData=data,citations=citations,departmentData=departmentData}})
    isMDTOpened = true
end

function mdt_gui()
    local data = getPlayerElementData()
    if (data.factionID ==1) then
        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)
        local model = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
        if (policeCars[model]) then
            if (isMDTOpened) then
                SetNuiFocus(false)
                SendNUIMessage({type="renderApp",data=false})
                isMDTOpened = false
            else
                TriggerServerEvent("mdt:getPlayerData",data)
            end
        end
    end
end
function mdt_searchPerson(data)
    if (not isMDTOpened) then return end
    TriggerServerEvent("mdt:searchPerson",data)
end

function mdt_searchVehicle(data)
    if (not isMDTOpened) then return end
    TriggerServerEvent("mdt:searchVehicle",data)
end

function mdt_returnPerson(person)
    if (not isMDTOpened) then return end
    SendNUIMessage({type="fetchPersonData",data=person})
end
function mdt_returnVehicle(vehicle)
    if (not isMDTOpened) then return end
    SendNUIMessage({type="fetchVehicleData",data=vehicle})
end
function mdt_addCitation(data)
    if (not isMDTOpened) then return end
    if (string.len(data.fName)<1) or (string.len(data.lName)<1) or (string.len(data.citations)<4) or (not data.agree) then
        SendNUIMessage({type="createdCitation",data='fillall'})
        return
    end
    TriggerServerEvent("mdt:addCitation",data)
end
function mdt_returnCitation(data)
    if (not isMDTOpened) then return end
    print(data)
    SendNUIMessage({type="createdCitation",data=data})
end
RegisterNUICallback("closedApp", function()
    SetNuiFocus(false)
    isMDTOpened = false
end)
RegisterNUICallback("MDT_PersonSearch",mdt_searchPerson)
RegisterNUICallback("MDT_addCitation",mdt_addCitation)
RegisterNUICallback("MDT_VehicleSearch",mdt_searchVehicle)
RegisterNetEvent("mdt_showMDT")
RegisterNetEvent("mdt_returnPerson")
RegisterNetEvent("mdt_returnVehicle")
RegisterNetEvent("mdt_returnCitation")
AddEventHandler("mdt_returnVehicle",mdt_returnVehicle)
AddEventHandler("mdt_returnCitation",mdt_returnCitation)
AddEventHandler("mdt_returnPerson",mdt_returnPerson)
AddEventHandler("mdt_showMDT",mdt_render)

RegisterCommand("openMDT", mdt_gui)
RegisterKeyMapping("openMDT","PD: MDT (radiowóz)","keyboard","b")