local hudShowed = false
local pRank = ""
local pDepartment = ""
local departments = {
    [1]={
        [1]="Los Santos Fire Department",
    },
    [2]={
        [1]="Los Santos Medical Center",
        [2]="Sandy Shores Medical Center",
        [3]="Paleto Bay Medical Center",
    },
    [3]={
        [1]="Los Santos Police Department",
        [2]="Blaine County Police Department",
        [3]="San Andreas Highway Patrol",
    }
}

DecorRegister("__PLAYER_MONEY_",3)
DecorRegister("isVIP",2)
DecorRegister("adminLevel",3)
AddEventHandler("em:showHUD",function()
    Wait(1000)
    SendNUIMessage({type="drawHUD"})
    hudShowed = true
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(PlayerPedId())
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
		local current_zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
        local IsInVehicle = IsPedSittingInAnyVehicle(ped)
        if (hudShowed) then
            if GetStreetNameFromHashKey(var1) and GetNameOfZone(pos.x, pos.y, pos.z) then
                if GetStreetNameFromHashKey(var1) then
                    if GetStreetNameFromHashKey(var2) == "" then
                        SendNUIMessage({type="streetUpdate",data={zone=current_zone,money=DecorGetInt(PlayerPedId(),"__PLAYER_MONEY_")}})
                    else
                        SendNUIMessage({type="streetUpdate",data={zone=current_zone,street=GetStreetNameFromHashKey(var2),money=DecorGetInt(PlayerPedId(),"__PLAYER_MONEY_")}})
                    end
                end
            end
            if (IsInVehicle) then
                local vehicle = GetVehiclePedIsIn(ped,false)
                local driver = GetPedInVehicleSeat(vehicle,-1)
                if (driver == ped) then
                    local speed = GetEntitySpeed(vehicle)
                    local speedRet = math.floor(speed * 3.6)
                    local fuel = "-"
                    if (DecorExistOn(vehicle,"_VEH_FUEL_LEVEL_")) then
                        fuel = math.floor(DecorGetFloat(vehicle,"_VEH_FUEL_LEVEL_"))
                    end
                    SendNUIMessage({type="updateVehicle",data={vehicle=true,speed=speedRet,fuel=fuel}})
                end
            else
                SendNUIMessage({type="updateVehicle",data={vehicle=false,speed=speedRet,fuel=""}})
            end
        end
    end
end)

RegisterNetEvent("em_core_client:playerLoaded")
RegisterNetEvent("em_core_client:PlayerMoneyChange")
RegisterNetEvent("em_core_client:playerFactionChange")
AddEventHandler("em_core_client:playerFactionChange",function(data)
    print(data.rankName)
    pRank = data.rankName
    pDepartment = departments[data.factionID][data.departmentID]
    SendNUIMessage({type="updateFaction",data={rank=pRank,department=pDepartment,xp=data.xp}})
end)
AddEventHandler("em_core_client:PlayerMoneyChange",function(data)
    DecorSetInt(PlayerPedId(-1),"__PLAYER_MONEY_",data)
end)
 
AddEventHandler("em_core_client:playerLoaded",function(data)
    DecorSetInt(PlayerPedId(-1),"__PLAYER_MONEY_",data.money)
    DecorSetInt(PlayerPedId(-1),"adminLevel",data.level)
end)

AddEventHandler("em_hud:updateMoney",function(data)
    DecorSetInt(PlayerPedId(-1),"__PLAYER_MONEY_",data.money)
    DecorSetInt(PlayerPedId(-1),"adminLevel",data.level)
end)