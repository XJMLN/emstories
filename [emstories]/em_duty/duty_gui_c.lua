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
local menusVariables = {
    vehiclesMarkIndex = 1,
    vehiclesUMarkIndex = 1,
    vehicleData = {},
    vehicleSelected = false,
    skinSelected = false,
    error = false,
}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1.0)
        RageUI.IsVisible(MENUS.MainMenu, function()
            MENUS.MainMenu.Controls.Back.Enabled = false
            RageUI.Button("Garaż","Wybierz pojazd",{},true,{
                onSelected = function()
                    MENUS.garage.Controls.Back.Enabled = true
                    setGarageCam()
                    menusVariables.error = false
            end},MENUS.garage)
            RageUI.Button("Szafka","Wybierz swój uniform",{},true,{
                onSelected = function()
                    MENUS.skins.Controls.Back.Enabled = true
                    menusVariables.error = false
            end},MENUS.skins)
            RageUI.Button("Wejdź na służbę","Rozpocznij służbę!",{RightBadge = RageUI.BadgeStyle.Tick,Color = {BackgroundColor={38,85,150,160},HighLightColor={102,155,228,160}}},true,{
            onSelected = function()
                if menusVariables.skinSelected and menusVariables.vehicleSelected then
                    RageUI.Visible(MENUS['MainMenu'],false)
                    startDuty(menusVariables.vehicleData)
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
            RageUI.List("Oznakowane",vehicles[1],menusVariables.vehiclesMarkIndex,"Wciśnij ~g~ENTER~w~ aby wybrać pojazd.",{},true,{
                onSelected = function(Index, Items)
                    showRoom(vehicles[1][menusVariables.vehiclesMarkIndex]['hash'])
                    local item = vehicles[1][menusVariables.vehiclesMarkIndex]
                    menusVariables.vehicleData = item
                    menusVariables.vehicleSelected = true
                end,
                onListChange = function(Index, Items)
                    menusVariables.vehiclesMarkIndex = Index
                    local item = vehicles[1][menusVariables.vehiclesMarkIndex]
                    menusVariables.vehicleData = item
                    
                end
            })
            if plrFactionID == 1 then
                RageUI.List("Oznakowane",vehicles[0],menusVariables.vehiclesUMarkIndex,"Wciśnij ~g~ENTER~w~ aby wybrać pojazd.",{},true,{
                    onSelected = function(Index, Items)
                        showRoom(vehicles[0][menusVariables.vehiclesUMarkIndex]['hash'])
                        menusVariables.vehicleSelected = true
                    end,
                    onListChange = function(Index, Items)
                        menusVariables.vehiclesUMarkIndex = Index
                        local item = vehicles[0][menusVariables.vehiclesUMarkIndex]
                        menusVariables.vehicleData = item
                    end
                })
            end
        end)
    end
end)