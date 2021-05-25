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

RegisterCommand("setBag",function(source)
    local plr = Player(source)
    plr.state.departmentID = 5
    print(plr.state.departmentID)
end)