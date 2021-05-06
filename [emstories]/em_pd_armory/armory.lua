function armory_getUserData()
    local source = source
    local playerData = exports.em_core:PlayersGetPlayerFromId(source)
    local FID = playerData.factionID
    local money = playerData.money
    if (FID and FID == 1) then
        MySQL.Async.fetchAll("SELECT weapons FROM em_users_police_armory WHERE user_id=@uid",{['@uid']=playerData.UID}, function(result)
            local row = result[1]
            if (row and row.weapons) then
                local retVal = row.weapons
                TriggerClientEvent("armory_client:sendUserData",source, {data=json.decode(retVal),money=money})
            end
        end)

    end
end
--{{"weapon_hash"="321321321"},{"weapon_hash"}}
function armory_checkout(hash)
    local source = source
    if (not hash) then return end
    if (ARMORY_OFFER[hash]) then
        local price = ARMORY_OFFER[hash].weaponPrice
        local plrMoney = exports.em_core:PlayersGetMoney(source)
        local playerData = exports.em_core:PlayersGetPlayerFromId(source)
        if (plrMoney < price) then
            TriggerClientEvent("armory_client:checkoutError",source)
            return
        end
        exports.em_core:PlayersTakeMoney(source, price)
        MySQL.Async.fetchAll("SELECT weapons FROM em_users_police_armory WHERE user_id=@uid",{['@uid']=playerData.UID}, function(result)
            local row = result[1]
            if (row and row.weapons) then
                local retVal = json.decode(row.weapons)
                table.insert(retVal,{weapon_hash=hash})
                MySQL.Async.execute("UPDATE em_users_police_armory SET weapons=@weapons WHERE user_id=@uid",{['@weapons']=json.encode(retVal),['@uid']=playerData.UID},function(result)
                    TriggerClientEvent("armory_client:checkoutSuccess",source,hash)
                    print(hash)
                end)
            end
        end)
    end
end
RegisterNetEvent("armory:checkout")
RegisterNetEvent("armory:getUserData")
AddEventHandler("armory:checkout",armory_checkout)
AddEventHandler("armory:getUserData",armory_getUserData)