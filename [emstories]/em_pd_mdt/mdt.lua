local DepartmentNames = {
    [5] = "Los Santos Police Department",
    [6] = "Blaine County Police Department",
    [7] = "San Andreas Highway Patrol",
}
local citations = {}
function countCitation(val)
    local data = {}
    for i,v in ipairs(val) do
        if (data[v]) then
            data[v] = data[v] + 1
        else
            data[v] = 1
        end
    end
    return data
end

function mdt_getOnlineOfficers(departmentID)
    local players = exports.em_core:PlayersGetAllPlayers()
    local departmentPlayers = {}
    for i,v in pairs(players) do
        if (v.departmentID == departmentID) then
            table.insert(departmentPlayers,{name=GetPlayerName(i), rankName=v.rankName, callsign=v.callsign})
        end
    end

    return departmentPlayers
end

function mdt_getCitationsConfig()
    MySQL.Async.fetchAll('SELECT citation_name,citation_desc,citation_price FROM em_config_citations',{},function(data)
        for i,v in ipairs(data) do
            citations[v.citation_name] = {citation_desc=v.citation_desc}
        end
    end)
end
function mdt_getPlayerData(data)
    local source = source
    local DID = data.departmentID
    local FID = data.factionID
    local player = exports.em_core:PlayersGetPlayerFromId(source)
    local playerData = {
        departmentID = DID,
        xp = player.xp,
        callsign = player.callsign,
        departmentName = DepartmentNames[DID],
        rank = player.rankName,
        name = GetPlayerName(source)
    }
    local playersInDepartment = mdt_getOnlineOfficers(DID)
    TriggerClientEvent("mdt_showMDT",source,playerData,citations,playersInDepartment)
end

function mdt_searchPerson(data)
    local source = source
    local personData = exports.em_pd_pullovers:searchPed(data)
    if (personData and personData.fName) then
        MySQL.Async.fetchAll("SELECT citation_data FROM em_pd_citations WHERE citation_fName=@fName and citation_lName=@lName",{['@fName']=personData.fName,['@lName']=personData.lName},function(result)
            local row = result[1]
            local citation = {}
            if (row and row.citation_data) then
                citation = json.decode(row.citation_data)
            end
            personData.citations = citation
            personData.citationCounter = countCitation(citation)
            TriggerClientEvent("mdt_returnPerson",source,personData)
        end)
    else
        TriggerClientEvent("mdt_returnPerson",source,personData)
    end
end

function mdt_searchVehicle(data)
    local vehData = exports.em_pd_pullovers:searchVehicle(data)
    TriggerClientEvent("mdt_returnVehicle",source,vehData)
end
function mdt_addCitation(data)
    local source = source
    local personData = exports.em_pd_pullovers:searchPed({fName=data.fName,lName=data.lName})
    if (not personData) then
        TriggerClientEvent("mdt_returnCitation",source,'notfoundperson')
        return
    end

    MySQL.Async.fetchAll("SELECT citation_data FROM em_pd_citations WHERE citation_fName=@fName and citation_lName=@lName",{['@fName']=data.fName,['@lName']=data.lName},function(result)
        local row = result[1]
        local citation = {}
        if (row and row.citation_data) then
            citation = json.decode(row.citation_data)
        end
        for i,v in ipairs(json.decode(data.citations)) do
            table.insert(citation,v)
        end
        citation = json.encode(citation)
        MySQL.Async.execute("INSERT INTO em_pd_citations SET citation_fName=@fName, citation_lName=@lName, citation_data=@citations ON DUPLICATE KEY UPDATE citation_data=@citations",{['@fName']=data.fName,['@lName']=data.lName,['citations']=citation},function(result)
            TriggerClientEvent("mdt_returnCitation",source,'allgood')
        end)
    end)
end
RegisterNetEvent("mdt:getPlayerData")
RegisterNetEvent("mdt:searchPerson")
RegisterNetEvent("mdt:addCitation")
RegisterNetEvent("mdt:searchVehicle")
AddEventHandler("mdt:searchVehicle",mdt_searchVehicle)
AddEventHandler("mdt:addCitation",mdt_addCitation)
AddEventHandler("mdt:searchPerson",mdt_searchPerson)
AddEventHandler("mdt:getPlayerData",mdt_getPlayerData)
AddEventHandler("onResourceStart",function(resname)
    if (GetCurrentResourceName() == resname) then
        mdt_getCitationsConfig()
    end
end)