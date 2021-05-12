GUI = {}
GUI.pullover = RageUI.CreateMenu("Zatrzymanie", "Wybierz opcje")
GUI['pullover']:DisplayGlare(false)
GUI['pullover'].EnableMouse = true
GUI.Variables = {
    player = {
        distance = false,
        currentPed = nil,
    },
    pullover ={
        docNumber = 1,
        docValue = nil,
    }
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        RageUI.IsVisible(GUI.pullover, function()
            RageUI.List("Sprawdź", {
                { Name = "Dowód osobisty", Value = 0},
                { Name = "Prawo jazdy", Value = 1},
                { Name = "Licencja na broń", Value = 2},
            },GUI.Variables.pullover.docNumber, "Wybierz dokument", {}, true, {
                onListChange = function(Index, Item)
                    GUI.Variables.pullover.docNumber = Index
                    GUI.Variables.pullover.docValue = Item.Value
                end,
                onSelected = function(Index, Item)
                    GUI.Variables.pullover.docValue = Item.Value
                    ai_prepareDocumentsData(Item.Value, GUI.Variables.player.currentPed)
                end
            })
        end)
    end
end)

function gui_pulloverShow()
    if (not GUI.Variables.player.distance) then return end
    if (not GUI.Variables.player.currentPed) then return end
    RageUI.Visible(GUI['pullover'],not RageUI.Visible(GUI['pullover']))
end

Keys.Register("E","E","Menu zatrzymania (osoba)", gui_pulloverShow)