function dmv_startExam(examID)
    local plrMoney = exports.em_core:PlayersGetMoney(source)
    if (plrMoney < 300) then
        TriggerClientEvent("dmv:showError",source,"Nie posiadasz wystarczającej ilości pieniędzy.")
        return
    end
    exports.em_core:PlayersTakeMoney(source, 300)
    TriggerClientEvent("dmv:startExamSuccess",source,examID)
end
function dmv_giveLicense(ID)
    local source = source
    local licenses = json.decode(Player(source).state.pj)
    local plrData = exports.em_core:PlayersGetPlayerFromId(source)
    licenses[ID] = 1
    
    local data = json.encode(licenses)
    Player(source).state.pj = data
    MySQL.Async.execute("UPDATE em_users SET driver_licenses=@licenses WHERE identifier=@identifier",{['@identifier']=plrData.identifier,['@licenses']=data},function(rowChanged)
    end)
end
RegisterNetEvent("dmv:startExam")
RegisterNetEvent("dmv:giveLicense")
AddEventHandler("dmv:giveLicense",dmv_giveLicense)
AddEventHandler("dmv:startExam",dmv_startExam)