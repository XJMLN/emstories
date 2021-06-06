MENUS = {}
MENUS.MainMenu = RageUI.CreateMenu("Służba","Wybierz opcje")
MENUS.garage = RageUI.CreateSubMenu(MENUS.MainMenu,"Garaż","Wybierz swój pojazd")
MENUS.skins = RageUI.CreateSubMenu(MENUS.MainMenu,"Szafka","Wybierz swój uniform")
MENUS.MainMenu:DisplayGlare(false)
MENUS.MainMenu.EnableMouse = true
MENUS.garage.EnableMouse = true
MENUS.garage:DisplayGlare(false)
MENUS.skins.EnableMouse = true
MENUS.skins:DisplayGlare(false)
MENUS.garage.Closed = function()
    backToDefault()
end
menusVariables = {
    vehiclesMarkIndex = 1,
    vehiclesUMarkIndex = 1,
    vehicleData = {},
    vehicleSelected = false,
    skinSelected = false,
    showExtras = false,
    extras = nil,
    error = false,
    names = {
        [3]={marked="Wozy Strażackie",unmarked="Pojazdy Użytkowe"},
        [2]={marked="Ambulanse",unmarked="Pojazdy Użytkowe"},
        [1]={marked="Oznakowane",unmarked="Nieoznakowane"},
    }
}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1.0)
        RageUI.IsVisible(MENUS.MainMenu, function()
            MENUS.MainMenu.Controls.Back.Enabled = false
            RageUI.Button("Szafka","Wybierz swój uniform",{},true,{
                onSelected = function()
                    MENUS.skins.Controls.Back.Enabled = true
                    menusVariables.error = false
            end},MENUS.skins)
            RageUI.Button("Garaż","Wybierz pojazd",{},true,{
                onSelected = function()
                    setGarageCam()
                    menusVariables.error = false
            end})
            RageUI.Button("Wejdź na służbę","Rozpocznij służbę!",{RightBadge = RageUI.BadgeStyle.Tick,Color = {BackgroundColor={38,85,150,160},HighLightColor={102,155,228,160}}},true,{
            onSelected = function()
                if menusVariables.skinSelected and menusVariables.vehicleSelected then
                    RageUI.Visible(MENUS['MainMenu'],false)
                    startDuty(menusVariables.vehicleData,menusVariables.extras)
                else
                    menusVariables.error = true
                end
            end})
            if (menusVariables.error) then
                RageUI.Separator("~r~Musisz wybrać strój oraz pojazd!")
            end
        end)
        RageUI.IsVisible(MENUS.skins,function()
            for i,v in ipairs(skins) do
                RageUI.Button(v.Name,"Wciśnij ~g~ENTER~w~ aby wybrać strój.",{},true,{
                    onSelected = function()
                        loadSkin(v.skin_data)
                        menusVariables.skinSelected = true
                    end
                })
            end
        end)

        RageUI.IsVisible(MENUS.garage, function()
            RageUI.List(menusVariables.names[plrFactionID]['marked'],vehicles[1],menusVariables.vehiclesMarkIndex,"Wciśnij ~g~ENTER~w~ aby wybrać pojazd.",{},true,{
                onSelected = function(Index, Items)
                    showRoom(vehicles[1][menusVariables.vehiclesMarkIndex]['hash'])
                    local item = vehicles[1][menusVariables.vehiclesMarkIndex]
                    menusVariables.vehicleData = item
                    menusVariables.vehicleSelected = true
                    menusVariables.showExtras = true
                    menusVariables.extras = getAvailableExtras()
                end,
                onListChange = function(Index, Items)
                    menusVariables.vehiclesMarkIndex = Index
                    local item = vehicles[1][menusVariables.vehiclesMarkIndex]
                    menusVariables.vehicleData = item
                    
                end
            })
            RageUI.List(menusVariables.names[plrFactionID]['unmarked'],vehicles[0],menusVariables.vehiclesUMarkIndex,"Wciśnij ~g~ENTER~w~ aby wybrać pojazd.",{},true,{
                onSelected = function(Index, Items)
                    showRoom(vehicles[0][menusVariables.vehiclesUMarkIndex]['hash'])
                    local item = vehicles[0][menusVariables.vehiclesUMarkIndex]
                    menusVariables.vehicleSelected = true
                    menusVariables.showExtras = true
                    menusVariables.extras = getAvailableExtras()
                    menusVariables.vehicleData = item
                end,
                onListChange = function(Index, Items)
                    menusVariables.vehiclesUMarkIndex = Index
                    local item = vehicles[0][menusVariables.vehiclesUMarkIndex]
                    menusVariables.vehicleData = item
                end
                })

            if (menusVariables.extras and menusVariables.showExtras) then
                RageUI.Separator("~g~Modyfikacje pojazdu")
                for i,v in ipairs(menusVariables.extras) do
                    RageUI.Checkbox(v.Name, "Dodaj/Usuń dodatek", v.state, {}, {
                        onChecked = function()
                            v.state = 1
                        end,
                        onUnChecked = function()
                            v.state = 0
                        end,
                        onSelected = function(Index)
                            local state = 0
                            if (not v.state) then
                                state = 1
                            end
                            SetVehicleExtra(vehicleRoom,v.extraId,state)
                        end
                    })
                end
            end
        end)
    end
end)