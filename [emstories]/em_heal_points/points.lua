function heal_checkPlayer()
    local money = exports.em_core:PlayersGetMoney(source)
    if (money < HEAL_PRICE) then
        TriggerClientEvent("em_heal:healPlayer",source,false)
        return
    end
    exports.em_core:PlayersTakeMoney(source,HEAL_PRICE)
    TriggerClientEvent("em_heal:healPlayer",source,true)
end

RegisterNetEvent("em_heal:buyHeal")
AddEventHandler("em_heal:buyHeal",heal_checkPlayer)