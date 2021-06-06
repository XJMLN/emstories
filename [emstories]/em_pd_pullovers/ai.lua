ITEMS = {}
PEDS = {}
VEHS = {}
lastNames = {}
firstNames = {
    female = {},
    male = {},
}
function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
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
function ai_generateItems(location)
    local pedItems = ""
    for i,v in ipairs(ITEMS) do
        if (v.itemLocation == location) then
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

function ai_createPedClass(ped, gender)
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
    local chanceToSearch = math.random(1,5)
    local chanceWeaponLicense = math.random(1,5)
    local chanceAttitude = math.random(100)
    local attitude = 0
    if (chanceAttitude > 75) then 
        attitude = 1
    end
    local isSearched = ""
    if (chanceToSearch == 3) then 
        isSearched = "~r~Poszukiwany"
    end
    local weaponLicense = "~b~[Centrala]~n~~r~Brak licencji na broń."
    if (chanceWeaponLicense == 3) then 
        weaponLicense = "~b~[Centrala]~n~~b~Licencja na broń ważna do "..math.random(1,28).."/"..math.random(1,12).."/"..2021 + math.random(1,15).."."
    end
    local chanceToDrunk = math.random(100)
    local promile = 0.000
    if (chanceToDrunk > 40) then 
        chanceToDrunk = math.random(60)
        promile = randomFloat(0.001,0.006)
        if (chanceToDrunk > 30) then 
            promile = randomFloat(0.007,0.012)
        end
        promile = string.format("%.3f",promile)
    end
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
    
    PEDS[ped] = {element=ped,attitude=attitude,fName=string.gsub(firstNames[sex][math.random(1,#firstNames[sex])],"[\n\r]",""), lName=string.gsub(lastNames[math.random(1,#lastNames)],"[\n\r]",""),gender=sex,date=dateOfBirth,suspect=isSearched,driverLicenseExpiry=expiryDrivingLicense,weaponLicense=weaponLicense}
    PEDS[ped].items = ai_generateItems(0)
    PEDS[ped].drugs = drugs
    PEDS[ped].alcohol = promile
end


function ai_prepareDocuments(ped, pedType, documentID)
    local source = source
    if (not PEDS[ped]) then
        ai_createPedClass(ped,pedType)
    end
    TriggerClientEvent("ai_pedDataReturn",source,documentID,PEDS[ped])
end

function ai_prepareTest(ped, pedType, testID)
    local source = source
    if (not PEDS[ped]) then
        ai_createPedClass(ped, pedType)
    end
    TriggerClientEvent("ai_pedTestDataReturn", source, testID, PEDS[ped])
end

function ai_prepareItems(ped, pedType)
    local source = source
    if (not PEDS[ped]) then
        ai_createPedClass(ped, pedType)
    end
    TriggerClientEvent("ai_pedDataReturn", source, 6, PEDS[ped])
end
function ai_checkIllegality(ped,pedType)
    local source = source
    if (not PEDS[ped]) then
        ai_createPedClass(ped,pedType)
    end
    local drugs = PEDS[ped].drugs
    local alcohol = PEDS[ped].alcohol
    local items = PEDS[ped].items
    local isSearched = PEDS[ped].suspect
    local grantReward = false
    if (drugs.meth=="~r~Pozytywny") then
        grantReward = true
    elseif (drugs.cocaine=="~r~Pozytywny") then
        grantReward = true
    elseif(drugs.marijuana=="~r~Pozytywny") then
        grantReward = true
    end

    if (tonumber(alcohol)>=0.008) then
        grantReward = true
    end
    if (isSearched == "~r~Poszukiwany") then
        grantReward = true
    end
    if (string.find(items,"~r~")) then 
        grantReward = true
    end

    local vehicle = PEDS[ped].vehicle
    if (vehicle and vehicle>0) then
        local isStolen = VEHS[vehicle].isStolen
        local check = VEHS[vehicle].check
        local inPursuit = VEHS[vehicle].inPursuit

        if (isStolen) then
            grantReward = true
        end

        if (not check) then
            grantReward = true
        end

        if (inPursuit) then
            grantReward = true
        end
        local vItems = VEHS[vehicle].items
        if (string.find(vItems,"~r~")) then 
            grantReward = true
        end
    end
    if (grantReward) then
        exports.em_core:givePlayerXP(CONFIG_PULLOVER_XP,source)
    end
    TriggerClientEvent("ai_pedIllegalityReturn",source,grantReward,CONFIG_PULLOVER_XP)
end
function ai_startup(resname)
    if (GetCurrentResourceName() ~= resname) then return end
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
end

function ai_prepareVehicle(pedID, pedType, vehID, vehData)
    if (not PEDS[pedID]) then
        ai_createPedClass(pedID,pedType)
    end

    local sex = "male"
    if (pedType == 5) then
        sex = "female"
    end
    local runner = vehData.runner
    local yearOfRegistry = 2021 - math.random(1,15)
    local monthOfRegistry = math.random(1,12)
    local dayOfRegistry = math.random(1,28)
    local dateOfRegistry = dayOfRegistry.."/"..monthOfRegistry.."/"..yearOfRegistry
    local chanceToStolen = math.random(100)
    local fName = PEDS[pedID].fName
    local lName = PEDS[pedID].lName
    local isStolen = false
    if (chanceToStolen>85) then
        fName = string.gsub(firstNames[sex][math.random(1,#firstNames[sex])],"[\n\r]","")
        lName = string.gsub(lastNames[math.random(1,#lastNames)],"[\n\r]","")
        isStolen = true
    end
    local modelName = vehData.model
    local plate = vehData.plate
    local color = vehData.color
    local chanceToCheck = math.random(50)
    local check = true
    local dateOfCheck = math.random(1,28).."/"..math.random(1,12).."/2022"
    if (chanceToCheck>=47) then
        dateOfCheck = math.random(1,28).."/"..math.random(1,4).."/2021"
        check = false
    end
    VEHS[vehID] = {element=vehID, inPursuit=runner,isStolen=isStolen,fName=fName,lName=lName, dateOfRegistry=dateOfRegistry,modelName=modelName,plate=plate,color=color,check=check,dateOfCheck=dateOfCheck}
    VEHS[vehID].items = ai_generateItems(1)
    PEDS[pedID].vehicle = vehID
end

function ai_getVehicleItems(ped,pedType,vehicle)
    if (not VEHS[vehicle]) then
       ai_prepareVehicle(ped,pedType,vehicle)
    end
    TriggerClientEvent("ai_vehItemsReturn",source,6,VEHS[vehicle])
end

function ai_searchPed(data)
    local fName,lName = data.fName, data.lName
    local person = false
    for k,v in pairs(PEDS) do
        if (string.lower(v.fName) == string.lower(fName)) and (string.lower(v.lName) == string.lower(lName)) then
            person = v
        end
    end
    return person
end

function ai_searchVeh(data)
    local plate = data.plate
    local vehicle = false
    for k,v in pairs(VEHS) do
        if (string.lower(v.plate) == string.lower(plate)) then
            vehicle = v
        end
    end
    return vehicle
end

exports("searchPed",ai_searchPed)
exports("searchVehicle",ai_searchVeh)
RegisterNetEvent("pullover:getPedItems")
RegisterNetEvent("pullover:getPedData")
RegisterNetEvent("pullover:getPedTestData")
RegisterNetEvent("pullover:checkPedIllegality")
RegisterNetEvent("pullover:setVehicleData")
RegisterNetEvent("pullover:getVehicleItems")
RegisterNetEvent("pullover:prepareVehicleClass")
AddEventHandler("pullover:prepareVehicleClass",ai_prepareVehicle)
AddEventHandler("pullover:getVehicleItems",ai_getVehicleItems)
AddEventHandler("pullover:setVehicleData",ai_prepareVehicle)
AddEventHandler("pullover:getPedItems", ai_prepareItems)
AddEventHandler("pullover:getPedTestData", ai_prepareTest)
AddEventHandler("pullover:getPedData", ai_prepareDocuments)
AddEventHandler("pullover:checkPedIllegality",ai_checkIllegality)
AddEventHandler("onResourceStart",ai_startup)