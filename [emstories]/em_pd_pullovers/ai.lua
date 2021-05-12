ITEMS = {}
PEDS = {}
lastNames = {}
firstNames = {
    female = {},
    male = {},
}
function ai_prepareDocuments(ped, pedType, documentID)

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
AddEventHandler("onResourceStart",ai_startup)
RegisterNetEvent("pullover:getPedData")
AddEventHandler("pullover:getPedData", ai_prepareDocuments)