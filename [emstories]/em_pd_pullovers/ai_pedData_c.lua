
function ai_prepareDocumentsData(documentID, ped)
    if (not ped) then return end
    local pedData = STOPPED_PEDS[ped]
    exports.fpd_3dtext:DrawNotification("Centrala","Centrala","~b~Trwa łączenie z centralą...",true)
    TriggerServerEvent("pullover:getPedData", ped, pedData.pedType, documentID)
end