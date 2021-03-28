MENUS = {}
MotherList = { "Hannah", "Aubrey", "Jasmine", "Gisele", "Amelia", "Isabella", "Zoe", "Ava", "Camila", "Violet", "Sophia", "Evelyn", "Nicole", "Ashley", "Gracie", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte", "Emma" }
FatherList = { "Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Juan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony",  "Claude", "Niko" }
MENUS.MainMenu = RageUI.CreateMenu("Kreator Postaci","Nowa postac")
MENUS.heritage = RageUI.CreateSubMenu(MENUS.MainMenu,"Podobieństwo","Podobieństwo postaci")
MENUS.features = RageUI.CreateSubMenu(MENUS.MainMenu,"Cechy","Cechy postaci")
MENUS.apearance = RageUI.CreateSubMenu(MENUS.MainMenu,"Wygląd","Wygląd postaci")
MENUS['MainMenu']:DisplayGlare(false)
MENUS['heritage']:DisplayGlare(false)
MENUS['features']:DisplayGlare(false)
MENUS['apearance']:DisplayGlare(false)
MENUS['MainMenu'].Closed = function() end
MENUS['MainMenu'].EnableMouse = true
MENUS['heritage'].EnableMouse = true
MENUS['features'].EnableMouse = true
MENUS['apearance'].EnableMouse = true
MENUS['apearance'].Closed = function()
    CreateSkinCam("body")
end
MENUS['features'].Closed = function()
    CreateSkinCam("body")
end
MENUS['heritage'].Closed = function()
    CreateSkinCam("body")
end

local PlayerCustomizationData = {
    sex=1,
    mom=1,
    dad=1,
    shapeMix=0.5,
    skinMix=0.5,
    resemblance=5,
    skin=5,
}

function ManagePanel(type, data)
    if data.Top then
    	Panel[type].Top = data.Top
    end

    if data.Bottom then
    	Panel[type].Bottom = data.Bottom
    end

    if data.Left then
    	Panel[type].Left = data.Left
    end

    if data.Right then
    	Panel[type].Right = data.Right
    end

    if data.x then
    	Panel[type].PFF = data.x
    end

    if data.y then
    	Panel[type].PFF2 = data.y
    end

    if type ~= 'ColourPanel' and type ~= 'PercentagePanel' and type ~= '' then

	    if not Panel[type].currentItem then
	        Panel[type].lastItem = data.x[2]
		else
			Panel[type].lastItem = Panel[type].currentItem
		end	
		Panel[type].currentItem = data.x[2]
		if not Panel[type][Panel[type].currentItem] then
			Panel[type][Panel[type].currentItem] = {
				x = 0.5,
				y = 0.5
			}
		end
	end

	if type == 'ColourPanel' or type == 'PercentagePanel' then

		Panel[type].itemIndex = data.index
		if data.Panel then
			Panel[data.Panel].itemIndex = data.index
		end

		if not Panel[type].currentItem then
	        Panel[type].lastItem = data.item
		else
			Panel[type].lastItem = Panel[type].currentItem
		end	
		Panel[type].currentItem = data.item

		if not Panel[type][Panel[type].currentItem] then
			Panel[type][Panel[type].currentItem] = {
				index = type == 'ColourPanel' and 1 or 0,
				minindex = 1
			}
		end

		if data.Panel then
			if not Panel[data.Panel].currentItem then
		        Panel[data.Panel].lastItem = data.item
			else
				Panel[data.Panel].lastItem = Panel[data.Panel].currentItem
			end	
			Panel[data.Panel].currentItem = data.item

			if not Panel[data.Panel][Panel[data.Panel].currentItem] then
				Panel[data.Panel][Panel[data.Panel].currentItem] = {
					index = data.Panel == 'PercentagePanel' and 0 or 1,
					minindex = 1
				}
			end
		end
	end

	for k,v in pairs(Panel) do
		if data.Panel then
			if k == type or k == data.Panel then
				v.enable = true
			else
				v.enable = false
			end
		else
	        if k == type then
	            v.enable = true
	        else
	            v.enable = false
	        end
	    end
    end
end
gridNumber = 1
gridNumberHorizontal = 2
appearanceNumber = 1
Citizen.CreateThread(function()
    while (true) do 
        Citizen.Wait(1.0)
        RageUI.IsVisible(MENUS['MainMenu'], function()
           MENUS['MainMenu'].Controls.Back.Enabled = false
           RageUI.List("Płeć", {"Mężczyzna","Kobieta"}, PlayerCustomizationData.sex, "Wybierz płeć postaci", {}, true, {
                onListChange = function(Index, Items)
                    PlayerCustomizationData['sex'] = Index
                    creator_changeSex(Index)
                end,
           })
           RageUI.Button("Podobieństwo", nil, {}, true, {
               onSelected = function()
                MENUS.heritage.Controls.Back.Enabled = true
                CreateSkinCam('face')
               end
           }, MENUS.heritage)
           RageUI.Button("Cechy", "Zmień cechy postaci",{},true, {
               onSelected = function()
                MENUS.features.Controls.Back.Enabled = true
                CreateSkinCam('face')
               end
           }, MENUS.features)

           RageUI.Button("Wygląd", "Zmień wygląd postaci",{},true, {
               onSelected = function()
                MENUS.apearance.Controls.Back.Enabled = true
                CreateSkinCam("face")
               end
           }, MENUS.apearance)
           RageUI.Button("Zapisz i wyjdź", "Wyglądu postaci nie możesz zmienić.",{RightBadge = RageUI.BadgeStyle.Tick,Color = {BackgroundColor={38,85,150,160},HighLightColor={102,155,228,160}}},true,{
               onSelected = function()
                    RageUI.Visible(MENUS['MainMenu'],false)
                    EndCharCreator()
               end
           })
        end)
        RageUI.IsVisible(MENUS['heritage'], function()
            RageUI.Window.Heritage(PlayerCustomizationData['mom'], PlayerCustomizationData['dad'])

            RageUI.List("Matka", MotherList, PlayerCustomizationData['mom'], "Wybierz swoją Matkę.",{},true,{
                onListChange = function(Index, Item)
                    PlayerCustomizationData['mom'] = Index
                    Character['mom'] = Index
                    SetPedHeadBlendData(GetPlayerPed(-1), PlayerCustomizationData['mom'], PlayerCustomizationData['dad'], nil, PlayerCustomizationData['mom'], PlayerCustomizationData['dad'], nil, PlayerCustomizationData['shapeMix'], PlayerCustomizationData['skinMix'],nil,true)
                end
            })
            RageUI.List("Ojciec", FatherList, PlayerCustomizationData['dad'], "Wybierz swojego Ojca.",{},true,{
                onListChange = function(Index, Item)
                    PlayerCustomizationData['dad'] = Index
                    Character['dad'] = Index
                    SetPedHeadBlendData(GetPlayerPed(-1), PlayerCustomizationData['mom'], PlayerCustomizationData['dad'], nil, PlayerCustomizationData['mom'], PlayerCustomizationData['dad'], nil, PlayerCustomizationData['shapeMix'], PlayerCustomizationData['skinMix'],nil,true)
                end
            })
            RageUI.UISliderHeritage("Podobieństwo",PlayerCustomizationData['resemblance'],"Stopień podobieństwa do rodzica",{
                onSliderChange = function(Float, Index)
                    PlayerCustomizationData['resemblance'] = Index
                    PlayerCustomizationData['shapeMix'] = Index/10
                    Character['face_md_weight'] = Index/10
                    SetPedHeadBlendData(GetPlayerPed(-1), PlayerCustomizationData['mom'], PlayerCustomizationData['dad'], nil, PlayerCustomizationData['mom'], PlayerCustomizationData['dad'], nil, PlayerCustomizationData['shapeMix'], PlayerCustomizationData['skinMix'],nil,true)
                end
            })

            RageUI.UISliderHeritage("Odcień skóry",PlayerCustomizationData['skin'],"Odziedziczony odcień skóry", {
                onSliderChange = function(Float, Index)
                    PlayerCustomizationData['skin'] = Index
                    PlayerCustomizationData['skinMix'] = Index/10
                    Character['skin_md_weight'] = Index/10
                    SetPedHeadBlendData(GetPlayerPed(-1), PlayerCustomizationData['mom'], PlayerCustomizationData['dad'], nil, PlayerCustomizationData['mom'], PlayerCustomizationData['dad'], nil, PlayerCustomizationData['shapeMix'], PlayerCustomizationData['skinMix'],nil,true)
                end})
        end)

        RageUI.IsVisible(MENUS['features'], function()
            RageUI.Button("Brwi","Zmień wygląd brwi",{}, true, {
                onSelected = function()
                    ManagePanel('GridPanel', {x = {6, 'eyebrows_5'}, y = {7, 'eyebrows_6'}, Top = "W górę", Bottom = "W dół", Left = "Na zewnątrz", Right = "Do wewnątrz"})
                    gridNumber = 1
                end})
                RageUI.Button("Oczy","Zmień wygląd oczu",{}, true, {
                    onSelected = function()
                        ManagePanel('GridPanelHorizontal', {x = {11, 'eye_open'}, Left ="Otwarte", Right ="Zwężone"})
                        gridNumberHorizontal = 2
                end})
                RageUI.Button("Nos","Zmień wygląd nosa",{},true, {
                    onSelected = function()
                        ManagePanel('GridPanel', {x = {0, 'nose_1'}, y = {1, 'nose_2'}, Top = "W górę", Bottom ="W dół", Left ="Zwężony", Right ="Duży"})
                        gridNumber = 3
                end})
                RageUI.Button("Profil nosa","Zmień profil nosa",{},true, {
                    onSelected = function()
                        ManagePanel('GridPanel', {x = {2, 'nose_3'}, y = {3, 'nose_4'}, Top = "Prosty", Bottom ="Zakrzywiony", Left ="Krótki", Right ="Długi"})
                        gridNumber = 4
                end})
                RageUI.Button("Końcówka nosa","Zmień końcówkę nosa",{},true, {
                    onSelected = function()
                        ManagePanel('GridPanel', {x = {4, 'nose_5'}, y = {5, 'nose_6'}, Top = "Złamany w lewo", Bottom ="Złamany w prawo", Left ="Wysoko", Right ="Nisko"})
                        gridNumber = 5
                end})
                RageUI.Button("Kości policzkowe","Zmień kości policzkowe",{},true, {
                    onSelected = function()
                        ManagePanel('GridPanel', {x = {9, 'cheeks_1'}, y = {8, 'cheeks_2'}, Top = "W górę", Bottom ="W dół", Left ="Na zewnątrz", Right ="Do wewnątrz"})
                        gridNumber = 6
                end})
                RageUI.Button("Policzki","Zmień wygląd policzków",{},true, {
                    onSelected = function()
                        ManagePanel('GridPanelHorizontal', {x = {10, 'cheeks_3'}, Left ="Wypukłe", Right ="Wklęsłe"})
                        gridNumberHorizontal = 7
                end})
                RageUI.Button("Usta","Zmień wygląd ust",{},true, {
                    onSelected = function()
                        ManagePanel('GridPanelHorizontal', {x = {12, 'lips_thick'}, Left ="Grube", Right ="Cienkie"})
                        gridNumberHorizontal = 8
                end})
                RageUI.Button("Szczęka","Zmień wygląd szczęki",{},true, {
                    onSelected = function()
                        ManagePanel('GridPanel', {x = {13, 'jaw_1'}, y = {14, 'jaw_2'}, Top = "Zaokrąglona", Bottom ="Kwadratowa", Left ="Wąska", Right ="Szeroka"})
                        gridNumber = 9
                end})
                RageUI.Button("Podbródek", "Zmień wygląd podbródka",{},true, {
                    onSelected = function()
                        ManagePanel('GridPanel', {x = {15, 'chin_height'}, y = {16, 'chin_lenght'}, Top = "W górę", Bottom ="W dół", Left ="Wklęsły", Right ="Wypukły"})
                        gridNumber = 10
                end})
                RageUI.Button("Kształt podbródka", "Zmień kształt podbródka",{},true, {
                    onSelected = function()
                        ManagePanel('GridPanel', {x = {17, 'chin_width'}, y = {18, 'chin_hole'}, Top = "Ostry?", Bottom ="bum?", Left ="Zaokrąglony", Right ="Kwadratowy"})
                        gridNumber = 11
                end})
                RageUI.Button("Grubość szyi","Zmień grubość szyi",{},true, {
                    onSelected = function()
                        ManagePanel('GridPanelHorizontal', {x = {19, 'neck_thick'}, Left ="Chuda", Right ="Gruba"})
                        gridNumberHorizontal = 12
                end})
        end, function()
            if Panel.GridPanel.enable then
                RageUI.Grid(Panel.GridPanel.x, Panel.GridPanel.y, Panel.GridPanel.Top, Panel.GridPanel.Bottom, Panel.GridPanel.Left, Panel.GridPanel.Right, {
                    onSelected = function(IndexX, IndexY, X, Y)

                    end,
                    onPositionChange = function(IndexX, IndexY, X, Y)
                        if Panel.GridPanel.lastItem == Panel.GridPanel.currentItem then
                            Panel.GridPanel.x = IndexX
                            Panel.GridPanel.y = IndexY
                        else
                            Panel.GridPanel.x = Panel.GridPanel[Panel.GridPanel.currentItem].x
                            Panel.GridPanel.y = Panel.GridPanel[Panel.GridPanel.currentItem].y
                        end
                        SetPedFaceFeature(GetPlayerPed(-1), Panel.GridPanel.PFF[1], IndexX)
                        SetPedFaceFeature(GetPlayerPed(-1), Panel.GridPanel.PFF2[1], IndexY)

                        Character[Panel.GridPanel.PFF[2]] = IndexX
                        Character[Panel.GridPanel.PFF2[2]] = IndexY
                    end
                },gridNumber)
            end
            if Panel.GridPanelHorizontal.enable then
                RageUI.GridHorizontal(Panel.GridPanelHorizontal.x, Panel.GridPanelHorizontal.Left, Panel.GridPanelHorizontal.Right, {
                    onPositionChange = function(X,Y,_,_)
                        if Panel.GridPanelHorizontal.lastItem == Panel.GridPanelHorizontal.currentItem then
                            Panel.GridPanelHorizontal.x = X
                        else
                            Panel.GridPanelHorizontal.x = Panel.GridPanelHorizontal[Panel.GridPanelHorizontal.currentItem].x
                        end
                        Panel.GridPanelHorizontal[Panel.GridPanelHorizontal.currentItem].x = X
                        SetPedFaceFeature(GetPlayerPed(-1), Panel.GridPanelHorizontal.PFF[1], X)
                        Character[Panel.GridPanelHorizontal.PFF[2]] = X
                    end

                },gridNumberHorizontal)
            end
        end)

        RageUI.IsVisible(MENUS['apearance'], function()
            for k, v in ipairs(Apperance) do
                RageUI.List(v.desc, v.List, v.index,"",{},true,{
                    onActive = function(Index, Item)
                        if v.ColourPanel and v.PercentagePanel then
                            ManagePanel('ColourPanel', {Panel = 'PercentagePanel', index = k, item = v.item})
                        elseif v.ColourPanel and not v.PercentagePanel then
                            ManagePanel('ColourPanel', {index = k, item = v.item})
                        elseif not v.ColourPanel and v.PercentagePanel then
                            ManagePanel('PercentagePanel', {index = k, item = v.item})
                        elseif not v.ColourPanel and not v.PercentagePanel then
                            ManagePanel('', {})
                        end
                        
                        appearanceNumber = k 
                        if v.cam ~= lastCam then
                            lastCam = v.cam
                            CreateSkinCam(v.cam)
                        end
                    end,
                    onListChange = function(Index,Item)
                        v.index = Index
                        updateApperance(k)
                end})
            end
        end, function()
            if Panel.ColourPanel.enable then
                RageUI.ColourPanel(Panel.ColourPanel.name, Panel.ColourPanel.Color, Panel.ColourPanel[Panel.ColourPanel.currentItem].minindex, Panel.ColourPanel[Panel.ColourPanel.currentItem].index,{
                    onColorChange = function(MinimumIndex, CurrentIndex)
                        if Panel.ColourPanel.lastItem == Panel.ColourPanel.currentItem then
                            Panel.ColourPanel.index_one = MinimumIndex
                            Panel.ColourPanel.index_two = CurrentIndex
                        else
                            Panel.ColourPanel.index_one = Panel.ColourPanel[Panel.ColourPanel.currentItem].minindex
                            Panel.ColourPanel.index_two = Panel.ColourPanel[Panel.ColourPanel.currentItem].index
                        end
                        Panel.ColourPanel[Panel.ColourPanel.currentItem].minindex = MinimumIndex
                        Panel.ColourPanel[Panel.ColourPanel.currentItem].index = CurrentIndex
    
                        Apperance[Panel.ColourPanel.itemIndex].indextwo = math.floor(CurrentIndex+0.0)
                        updateApperance(Panel.ColourPanel.itemIndex, true, false)
                end},appearanceNumber)
            end
            if Panel.PercentagePanel.enable then
                RageUI.PercentagePanel(Panel.PercentagePanel[Panel.PercentagePanel.currentItem].index, Panel.PercentagePanel.HeaderText, Panel.PercentagePanel.MinText, Panel.PercentagePanel.MaxText,{
                    onProgressChange = function(Percent)
                        if Panel.PercentagePanel.lastItem == Panel.PercentagePanel.currentItem then
                            Panel.PercentagePanel.index = Percent
                        else
                            Panel.PercentagePanel.index = Panel.PercentagePanel[Panel.PercentagePanel.currentItem].index
                        end
                        Panel.PercentagePanel[Panel.PercentagePanel.currentItem].index = Percent
    
                        Apperance[Panel.PercentagePanel.itemIndex].indextwo = math.floor(Percent*10)
                        updateApperance(Panel.PercentagePanel.itemIndex, false)
                    end
                },appearanceNumber)
            end
        end)
    end
end)