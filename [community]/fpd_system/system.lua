DUTY = {}
DEPARTMENTS = {}
DATA = {}
PEDS = {}
VEHS = {}
ITEMS = {}
SpeedZones = {}
lastNames = {}
firstNames = {
    female = {},
    male = {},
}


--@fpdSystem_getLicense(Player plr) @return string contains license
function fpdSystem_getLicense(plr)
	local license
	for k, v in ipairs(GetPlayerIdentifiers(plr)) do
	   if string.match(v, "license:") then
		  license = v
		  break
	   end
	end
	return string.gsub(license,"license:","")
end

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end

	local t={} ; i=1

	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end

	return t
end

--@fpdSystem_isPlayerOnDuty(Player plr) @return boolean true/false
function fpdSystem_isPlayerOnDuty(plr)
    if (DUTY[plr]) then
        return DUTY[plr].state
    end
    return false
end
--@fpdSystem_getPlayerData(Player plr) @used to getPLayerData when DUTY[plr].state == true
--example: {"departmentName":"Los Santos Police Department","rankID":5,"callsign":"1V-652","departmentID":1,"rankName":"Officer II","state":true}
function fpdSystem_getPlayerData(plr)
    local plr = plr
    local UID = exports.fpd_core:getPlayerAccountID(plr)
    MySQL.Async.fetchAll("SELECT rankID,departmentID,callsign FROM department_members WHERE userID=@UID",
    {
        ["@UID"]=UID
    },function(returnData)
        if (returnData and returnData[1]) then
            local playerData = returnData[1]
            if (not DUTY[plr]) then DUTY[plr] = {state=false} return end
            DUTY[plr].rankID = playerData.rankID
            DUTY[plr].departmentID = playerData.departmentID
            DUTY[plr].callsign = playerData.callsign
            DUTY[plr].departmentName = DATA["DEPARTMENTS"][playerData.departmentID]
            DUTY[plr].rankName = DATA["RANKS"][playerData.departmentID][playerData.rankID]
        end
    end)
end

function fpdSystem_setPlayerDutyStatus(plr,status)
    if (not DUTY[plr]) then
        DUTY[plr] = {state=status}
        if (status == true) then 
            fpdSystem_getPlayerData(plr)
        end
    end
end

--[[

    Speed zones

]]
function fpdSystem_createSpeedZone(speed,range,pos)
    local plr = source
    if (SpeedZones[plr]) then fpdSystem_deleteSpeedZone(plr) return end
    SpeedZones[plr] = {speed=speed,range=range,pos=pos}
    TriggerClientEvent("fpdSystem_client:createSpeedZone",plr,SpeedZones[plr])
end

function fpdSystem_deleteSpeedZone(player)
    local plr = source
    if (player) then
        plr = player
    end
    if (not SpeedZones[plr]) then return end 
    TriggerClientEvent("fpdSystem_client:deleteSpeedZone",plr)
end

--[[

    Ped Questions/Documents
title,subtitle,text,onlyText,iconName,iconType,flash
]]
function fpdSystem_createPed_generateItems(ped)
    local pedItems = ""
    for i,v in ipairs(ITEMS) do
        if (v.itemLocation == 0) then
            local chance = math.random(v.multiplier)
            if (chance >v.multiplier/2) then
                if (v.isIllegal) then
                    pedItems = pedItems.."~r~"..v.name.."\n"
                else
                    pedItems = pedItems.."~g~"..v.name.."\n"
                end
            end
        end
    end
    return pedItems
end
function fpdSystem_createPed(ped,gender)
    local sex = "male"
    if (gender == 5) then 
        sex = "female"
    end
    local minage = 20
    local maxage = 75
    local yearOfBirth = 2021 - math.random(minage,maxage)
    local monthOfBirth = math.random(1,12)
    local dayOfBirth = math.random(1,28)
    local dateOfBirth = dayOfBirth.."/"..monthOfBirth.."/"..yearOfBirth
    local expiryDrivingLicense = math.random(1,28).."/"..math.random(1,12).."/"..2021 + math.random(1,15)
    local chanceFishingLicense = math.random(1,5)
    local chanceToSearch = math.random(1,5)
    local chanceWeaponLicense = math.random(1,5)
    local chanceHuntingLicense = math.random(1,5)
    local chanceAttitude = math.random(100)
    local attitude = 0
    if (chanceAttitude > 75) then 
        attitude = 1
    end
    local isSearched = ""
    if (chanceToSearch == 3) then 
        isSearched = "~r~Poszukiwany"
    end
    local fishingLicense = "~b~[Centrala]~n~~r~Brak karty wędkarskiej."
    if (chanceFishingLicense == 3) then 
        fishingLicense = "~b~[Centrala]~n~~b~Karta wędkarska ważna do "..math.random(1,28).."/"..math.random(1,12).."/"..2021 + math.random(1,15).."."
    end
    local weaponLicense = "~b~[Centrala]~n~~r~Brak licencji na broń."
    if (chanceWeaponLicense == 3) then 
        weaponLicense = "~b~[Centrala]~n~~b~Licencja na broń ważna do "..math.random(1,28).."/"..math.random(1,12).."/"..2021 + math.random(1,15).."."
    end
    local huntingLicense = "~b~[Centrala]~n~~r~Brak licencji łowieckiej."
    if (chanceHuntingLicense == 3) then 
        huntingLicense = "~b~[Centrala]~n~~b~Licencja łowiecka ważna do "..math.random(1,28).."/"..math.random(1,12).."/"..2021 + math.random(1,15).."."
    end
    PEDS[ped] = {element=ped,attitude=attitude,fName=firstNames[sex][math.random(1,#firstNames[sex])], lName=lastNames[math.random(1,#lastNames)],gender=sex,date=dateOfBirth,suspect=isSearched,driverLicenseExpiry=expiryDrivingLicense,fishingLicense=fishingLicense,weaponLicense=weaponLicense,huntingLicense=huntingLicense}
    PEDS[ped].items = fpdSystem_createPed_generateItems(ped)
end
function fpdSystem_runQuestion(ped,gender,question,answers)
    local source = source
    if (not PEDS[ped]) then fpdSystem_createPed(ped,gender) end
    Wait(2000)
    TriggerClientEvent("fpdSystem_client:drawDialogue",source,question)
    local answer = answers[1]['good'][math.random(1,#answers[1]['good'])]
    if (PEDS[ped].attitude == 1) then
        answer = answers[1]['angry'][math.random(1,#answers[1]['angry'])]
    end
    Wait(2900)
    TriggerClientEvent("fpdSystem_client:drawDialogue",source,PEDS[ped].fName.." "..PEDS[ped].lName..": "..answer)
end
function fpdSystem_getPedDataAlcohol(ped,gender)
    local source = source 
    if (not PEDS[ped]) then fpdSystem_createPed(ped,gender) end
    if (not PEDS[ped].alcohol) then
        local chanceToDrunk = math.random(100)
        local promile = 0.0
        if (chanceToDrunk > 60) then 
            chanceToDrunk = math.random(60)
            promile = math.random(0.0,0.5)
            if (chanceToDrunk > 50) then 
                promile = math.random(0.01,2.5)
            end
        end
        PEDS[ped].alcohol = promile
    end
    Wait(2000)
    if (PEDS[ped].alcohol == 0.0) then
        TriggerClientEvent("fpdSystem_client:drawNotification",source,2,PEDS[ped])
    else 
        TriggerClientEvent("fpdSystem_client:drawNotification",source,3,PEDS[ped])
    end
end

function fpdSystem_getPedDataDrugs(ped,gender)
    local source = source 
    if (not PEDS[ped]) then fpdSystem_createPed(ped,gender) end 
    if (not PEDS[ped].drugs) then
        local chanceToCocaine = math.random(100)
        local chanceToMarijuana = math.random(100)
        local chanceToMeth = math.random(100)
        local drugs = {cocaine="~g~Negatywny",marijuana="~g~Negatywny",meth="~g~Negatywny"}
        if (chanceToMeth > 90) then
            drugs.meth="~r~Pozytywny"
        end
        if (chanceToCocaine > 85) then
            drugs.cocaine="~r~Pozytywny"
        end
        if (chanceToMarijuana > 85) then
            drugs.marijuana = "~r~Pozytywny"
        end
        PEDS[ped].drugs = drugs
    end
    TriggerClientEvent("fpdSystem_client:drawNotification",source,4,PEDS[ped])
end
function fpdSystem_getPedData(ped,gender,document)
    local source= source
    if (not PEDS[ped]) then 
        fpdSystem_createPed(ped,gender)
    end
    if (document == 0) then --dowód
        TriggerClientEvent("fpdSystem_client:drawNotification",source,0,PEDS[ped])
    end 
    if (document == 1) then -- prawko
        TriggerClientEvent("fpdSystem_client:drawNotification",source,1,PEDS[ped])
    end 
    if (document == 2) then 
        TriggerClientEvent("3dtext:DrawNotification",source,"Centrala","Centrala",PEDS[ped].weaponLicense,true)
    end
    if (document == 3) then 
        TriggerClientEvent("3dtext:DrawNotification",source,"Centrala","Centrala",PEDS[ped].fishingLicense,true)
    end
    if(document == 4) then 
        TriggerClientEvent("3dtext:DrawNotification",source,"Centrala","Centrala",PEDS[ped].huntingLicense,true)
    end
end

function fpdSystem_getPedDataItems(ped,gender)
    local source = source
    if (not PEDS[ped]) then
        fpdSystem_createPed(ped,gender)
    end
    Wait(500)
    TriggerClientEvent("fpdSystem_client:drawNotification",source,6,PEDS[ped].items)
end
function fpdSystem_getVehiclePlateData(veh,ped,pedType,vehData)
    if (ped and ped>0 and not PEDS[ped]) then fpdSystem_getPedData(ped,pedType,nil) end
    if (not VEHS[veh]) then 
        local color1 = vehData[1]
        local chanceInsurance = math.random(1,10)
        local insurance = "Ważne"
        if (chanceInsurance == 10) then 
            insurance = "~r~Przedawnione"
        end
        local chanceRegistration = math.random(1,10)
        registration = "Ważny"
        if (chanceRegistration == 10) then 
            registration = "~r~Przedawniony"
        end
        VEHS[veh] = {type=vehData[2],color=color1,nameplate=vehData[3],insurance=insurance,registration=registration}
        if (ped and ped>0) then 
            VEHS[veh].lastPed = PEDS[ped].fName.." "..PEDS[ped].lName
        else
            VEHS[veh].lastPed = "Nieznany"
        end
    end
    TriggerClientEvent("fpdSystem_client:drawNotification",source,5,VEHS[veh])
end
RegisterCommand("getData",function(source,arg,raw)
    fpdSystem_setPlayerDutyStatus(source,true)
end,false)

AddEventHandler("onResourceStart",function(resname)
    if (GetCurrentResourceName() ~= resname) then return end
    local retData = exports.fpd_core:getFivePDData()
    local ranks, departments = retData[1], retData[2]
    local lastNamesFile = LoadResourceFile(GetCurrentResourceName(), "config/last-names.txt")
    local firstNamesFemaleFile = LoadResourceFile(GetCurrentResourceName(), "config/female-first-names.txt")
    local firstNamesMaleFile = LoadResourceFile(GetCurrentResourceName(), "config/male-first-names.txt")
    local itemsFile = LoadResourceFile(GetCurrentResourceName(), "config/items.json")
    local firstNamesFemaleLines = stringsplit(firstNamesFemaleFile, "\n")
    local firstNamesMaleLines = stringsplit(firstNamesMaleFile, "\n")
    local lastNamesLines = stringsplit(lastNamesFile,"\n")
    for i,v in ipairs(lastNamesLines) do 
        table.insert(lastNames,v)
    end
    for i,v in ipairs(firstNamesFemaleLines) do 
        table.insert(firstNames['female'], v)
    end
    for i,v in ipairs(firstNamesMaleLines) do 
        table.insert(firstNames['male'],v)
    end
    ITEMS = json.decode(itemsFile)
    ITEMS = ITEMS
    DATA["RANKS"] = ranks
    DATA["DEPARTMENTS"] = departments
end)
RegisterNetEvent("fpdSystem:createSpeedZone")
RegisterNetEvent("fpdSystem:deleteSpeedZone")
RegisterNetEvent("fpdSystem:getPedData")
RegisterNetEvent("fpdSystem:getVehiclePlateData")
RegisterNetEvent("fpdSystem:getPedDataDrugs")
RegisterNetEvent("fpdSystem:getPedDataAlcohol")
RegisterNetEvent("fpdSystem:runQuestion")
RegisterNetEvent("fpdSystem:getPedDataItems")
AddEventHandler("fpdSystem:getPedDataItems",fpdSystem_getPedDataItems)
AddEventHandler("fpdSystem:runQuestion",fpdSystem_runQuestion)
AddEventHandler("fpdSystem:getPedDataDrugs",fpdSystem_getPedDataDrugs)
AddEventHandler("fpdSystem:getPedDataAlcohol",fpdSystem_getPedDataAlcohol)
AddEventHandler("fpdSystem:getVehiclePlateData",fpdSystem_getVehiclePlateData)
AddEventHandler("fpdSystem:getPedData",fpdSystem_getPedData)
AddEventHandler("fpdSystem:deleteSpeedZone",fpdSystem_deleteSpeedZone)
AddEventHandler("fpdSystem:createSpeedZone",fpdSystem_createSpeedZone)