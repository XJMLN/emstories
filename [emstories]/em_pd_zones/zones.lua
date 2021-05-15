function zones_timer()
	TriggerClientEvent("zones:xpNotification",-1)
	SetTimeout(timeToPay,zones_timer)
end
zones_timer()

function zones_giveXP()
    exports.em_core:givePlayerXP(50,source)
end

RegisterNetEvent("zones:givePlayerXP")
AddEventHandler("zones:givePlayerXP",zones_giveXP)