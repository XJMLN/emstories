local activeCallouts = {
    [1]={},
    [2]={},
    [3]={},
}
local playersOnCallout = {
    [1]={},
    [2]={},
    [3]={},
}

function callouts_checkCallout(ID,FID)
    if (activeCallouts[FID][ID]) then
        TriggerClientEvent("3dtext:DrawNotification",source,"Centrala","Centrala","~r~Wybrane wezwanie jest aktualnie wygenerowane dla innego gracza, odczekaj chwilę.",true)
        return
    end
    if (playersOnCallout[FID][source]) then
        TriggerClientEvent("3dtext:DrawNotification",source,"Centrala","Centrala","~r~Musisz anulować poprzednie wezwanie.",true)
        return
    end
    TriggerClientEvent("em_duty_gui:returnCalloutState",source,true,ID)
end

function callouts_end(ID, success)
    local FID = Player(source).state.factionID
    if (playersOnCallout[FID][source] == ID) then
        playersOnCallout[FID][source] = nil
        Player(source).state.onCallout = false
        activeCallouts[FID][ID] = nil
        if (success) then
            exports.em_core:givePlayerXP(40, source)
            TriggerClientEvent("3dtext:DrawNotification",source,"System","System","Otrzymujesz ~g~40~w~ XP za wykonane wezwanie.",true)
        end
    end
end
function callouts_request(ID,FID)
    TriggerClientEvent("callouts_initDispatch",source,CALLOUTS[FID][ID])
end

function callouts_start(data, player)
    local fid = Player(player).state.factionID
    playersOnCallout[fid][player] = data.id
    activeCallouts[fid][data.id] = true
    Player(player).state.onCallout = true
    TriggerClientEvent("callouts_createRoute",player,data)
end

function callouts_playerDropped()
    local source = source
    local fid = Player(source).state.factionID
    playersOnCallout[FID][source] = nil
    Player(source).state.onCallout = false
    activeCallouts[FID][ID] = nil
end
exports("callouts_start",callouts_start)

RegisterNetEvent("callouts_request")
AddEventHandler("callouts_request",callouts_request)
RegisterNetEvent("callouts_end")
AddEventHandler("callouts_end",callouts_end)
RegisterNetEvent("em_core:playerDropped")
AddEventHandler("em_core:playerDropped",callouts_playerDropped)
RegisterNetEvent("callouts_checkCallout")
AddEventHandler("callouts_checkCallout",callouts_checkCallout)