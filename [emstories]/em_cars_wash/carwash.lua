function carwash_checkPlayerMoney(wash_id)
    local plrMoney = exports.em_core:PlayersGetMoney(source)
    local callback = "OK"
    if (plrMoney and plrMoney<10) then
        callback = "Nie posiadasz ~g~$10~w~."
    end
    exports.em_core:PlayersTakeMoney(source,10)
    TriggerClientEvent("em_carwash:startWash",source,callback,wash_id)
    
end

RegisterNetEvent("em_carwash:checkPlayerMoney")
AddEventHandler("em_carwash:checkPlayerMoney",carwash_checkPlayerMoney)