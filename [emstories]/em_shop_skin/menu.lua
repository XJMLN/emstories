Character = {}

function LoadDefaultComponents()
	for i=1, #Components, 1 do
		Character[Components[i].name] = Components[i].value
	end
end
local pedModel = "mp_m_freemode_01"
function AddMenuPed(menu)
	
	local gender = {"none", "Male", "Female"}
	male = NativeUI.CreateItem('Mężczyzna',"Wciśnij ENTER aby kontynuować")
	menu:AddItem(male)
	female = NativeUI.CreateItem('Kobieta',"Wciśnij ENTER aby kontynuować")
	menu:AddItem(female)
	local newitem = nil
	appearancemenu = NativeUI.CreateItem('Zmień wygląd',"Naciśnij ENTER, aby dostosować swój model")

	mainMenu.OnMenuClosed = function(Menu)
		setCamera = false
		menuOpened = false
		SetEntityVisible(PlayerPedId(), true, 0)
			

		SetEntityCollision(PlayerPedId(), true, true)

		FreezeEntityPosition(PlayerPedId(), false)
	end
	freemodePedMenu.OnMenuClosed = function(Menu)
		TriggerServerEvent('em_shop_skins:save', Character)
		TriggerEvent('skinchanger:loadSkin', Character)
		

		menu:Visible(true)
	end
	otherPedMenu.OnMenuClosed = function(Menu)
		TriggerServerEvent('em_shop_skins:save', Character)
		TriggerEvent('skinchanger:loadSkin', Character)
		freemodePedMenu:Visible(true)
		if not clotheshop then
		end
	end
	menu.OnItemSelect = function(menu, item)
		if item == male then
			Character['sex'] = 0
			pedModel = "mp_m_freemode_01"
			changemodel("mp_m_freemode_01")
			freemodePedMenu:Visible(true)
			menu:Visible(false)

		elseif item == female then
			Character['sex'] = 1
			pedModel = "mp_f_freemode_01"
			changemodel("mp_f_freemode_01")
			freemodePedMenu:Visible(true)
			menu:Visible(false)
		end
	end

end
--[[
-MainMenu
	|_Mp FreeMode Peds
	|		|_Gender
	|		|_Inheritance
	|		|_Face Shape
	|		|_Apparence
	|		|_Clothes
	|		|_Accessories
	|		|_Tatoos
	|_Sp Male Peds<List-Item>
	|_Sp Female Peds<List-Item>
	|_Mp Peds<List-Item>
]]--
--############## Menu #####################
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Zmiana wyglądu", "~b~Stwórz swoją postać", Config.MenuX, Config.MenuY,nil,nil,nil,Config.MenuColor.r,Config.MenuColor.g,Config.MenuColor.b,Config.MenuColor.a)
freemodePedMenu = NativeUI.CreateMenu("Tworzenie postaci", "~b~Stwórz swoją postać", Config.MenuX, Config.MenuY,nil,nil,nil,Config.MenuColor.r,Config.MenuColor.g,Config.MenuColor.b,Config.MenuColor.a)
otherPedMenu = NativeUI.CreateMenu("Custom Ped Menu", "~b~Create your Ped", Config.MenuX, Config.MenuY,nil,nil,nil,Config.MenuColor.r,Config.MenuColor.g,Config.MenuColor.b,Config.MenuColor.a)
_menuPool:Add(mainMenu)
_menuPool:Add(freemodePedMenu)
_menuPool:Add(otherPedMenu)
--submenu2 = _menuPool:AddSubMenu(submenu1, "submenu2", "~b~Character Clothing Options", Config.MenuX, Config.MenuY,nil,nil,nil,Config.MenuColor.r,Config.MenuColor.g,Config.MenuColor.b,Config.MenuColor.a)


local submenuInheritance = _menuPool:AddSubMenu(freemodePedMenu, "Rodzina", "~b~Wybierz swoich rodziców", Config.MenuX, Config.MenuY,nil,nil,nil,Config.MenuColor.r,Config.MenuColor.g,Config.MenuColor.b,Config.MenuColor.a)
local submenuFaceShape = _menuPool:AddSubMenu(freemodePedMenu, "Twarz", "~b~Opcje dotyczące twarzy", Config.MenuX, Config.MenuY,nil,nil,nil,Config.MenuColor.r,Config.MenuColor.g,Config.MenuColor.b,Config.MenuColor.a)
	  submenuAppearance = _menuPool:AddSubMenu(freemodePedMenu, "Wygląd postaci", "~b~Opcje wyglądu postaci", Config.MenuX, Config.MenuY,nil,nil,nil,Config.MenuColor.r,Config.MenuColor.g,Config.MenuColor.b,Config.MenuColor.a)
	  submenuClothes = _menuPool:AddSubMenu(freemodePedMenu, "Odzież", "~b~Wybór odzieży postaci", Config.MenuX, Config.MenuY,nil,nil,nil,Config.MenuColor.r,Config.MenuColor.g,Config.MenuColor.b,Config.MenuColor.a)



	local cMum,cDad = 1
	local SkinMixData,ShapeMixData = 0.5
function AddMenuInheritance(submenu)

	local Mum = { "Hannah", "Aubrey", "Jasmine", "Gisele", "Amelia", "Isabella", "Zoe", "Ava", "Camila", "Violet", "Sophia", "Evelyn", "Nicole", "Ashley", "Gracie", "Brianna", "Natalie", "Olivia", "Elizabeth", "Charlotte", "Emma" };
	local Dad = { "Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Juan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony", " Claude", "Niko" };
	
	local window = NativeUI.CreateHeritageWindow(cMum, cDad)
	submenu.SubMenu:AddWindow(window)
	
	local MumItem = NativeUI.CreateListItem("Mom", Mum, 1, "")
    submenu.SubMenu:AddItem(MumItem)
	
	local DadItem = NativeUI.CreateListItem("Dad", Dad, 1, "")
    submenu.SubMenu:AddItem(DadItem)
	
	local amount = { 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0 };
	
	local DescriptionShape = "Wybierz, jaka część Twojego kształtu głowy powinna być odziedziczona po ojcu lub matce. Po lewej stronie jest ojciec, po prawej stronie matka."
	local DescriptionSkin = "Wybierz, w jakim stopniu odcień skóry Twojego ciała ma być odziedziczony po ojcu lub matce.Po lewej stronie jest ojciec, po prawej stronie matka."
	local ShapeMixItem = NativeUI.CreateSliderHeritageItem("Podobieństwo", amount, 1, DescriptionShape)
	local SkinMixItem = NativeUI.CreateSliderHeritageItem("Odcień skóry", amount, 1, DescriptionSkin)
	ShapeMixItem:Index(6)
	SkinMixItem:Index(6)
	submenu.SubMenu:AddItem(ShapeMixItem)
	submenu.SubMenu:AddItem(SkinMixItem)
	submenu.SubMenu.OnListChange = function(sender, item, index)
		if item == MumItem then
			cMum = index
			
		else
			cDad = index
			--ShowNotification("your Dad ~b~" .. cDad .. "~w~...")
		end
		Character['mom'] = cMum
		Character['dad'] = cDad
		window:Index(cMum, cDad)
		SetPedHeadBlendData(GetPlayerPed(-1), cDad, cMum, nil, cDad, cMum, nil, ShapeMixData, SkinMixData, nil, true);

	end
	submenu.SubMenu.OnSliderChange = function(sender, item, index)
		if item == ShapeMixItem then
			--ShowNotification(item:IndexToItem(index))
			ShapeMixData = item:IndexToItem(index)
		else
			SkinMixData = item:IndexToItem(index)
		end
		Character['face'] = ShapeMixData
		Character['skin'] = SkinMixData
		SetPedHeadBlendData(GetPlayerPed(-1), cDad, cMum, nil, cDad, cMum, nil, ShapeMixData, SkinMixData, nil, true);
	end
	
end
	
function AddMenuFaceShape(submenu)

	local ListItem = {
        "Modyfikuj",
    }
		--submenu.SubMenu:SetLeftBadge(BadgeStyle.Star)
		--submenu.SubMenu:SetRightBadge(BadgeStyle.Tick)
		--Nose Up Down Narrow Wide
		local GridItem =  NativeUI.CreateListItem("Nos", ListItem, 1)
		local GridPanel = NativeUI.CreateGridPanel("Do góry", "Wąski", "Szeroki", "Do dołu")
		submenu.SubMenu:AddItem(GridItem)
		GridItem:AddPanel(GridPanel)
		GridItem.Base.ActivatedPanel = function(_, item, panel, panelvalue)
			SetPedFaceFeature(GetPlayerPed(-1), 0, panelvalue.X);						--"Nose Width",               // 0
			SetPedFaceFeature(GetPlayerPed(-1), 1, panelvalue.Y);						--"Noes Peak Height",         // 1
			Character['nose_1'] = panelvalue.X
			Character['nose_2'] = panelvalue.Y
			--print(panelvalue.X.."---"..panelvalue.Y)
		end
		--Nose Profile Crooked Curved Short Long
		local GridItem =  NativeUI.CreateListItem("Profil nosa", ListItem, 1)
		local GridPanel = NativeUI.CreateGridPanel("Krzywy", "Krótki", "Długi", "Zakrzywiony")
		submenu.SubMenu:AddItem(GridItem)
		GridItem:AddPanel(GridPanel)
		GridItem.Base.ActivatedPanel = function(_, item, panel, panelvalue)
			SetPedFaceFeature(GetPlayerPed(-1), 2, panelvalue.X);						--"Nose Peak Length",         // 2
			SetPedFaceFeature(GetPlayerPed(-1), 3, panelvalue.Y);						--"Nose Bone Height",         // 3
			Character['nose_3'] = panelvalue.X
			Character['nose_4'] = panelvalue.Y
		end
		--Nose Tip Tip Up Tip Down Broken Left Broken Right
		local GridItem =  NativeUI.CreateListItem("Końcówka nosa", ListItem, 1)
		local GridPanel = NativeUI.CreateGridPanel("Przechylona w górę", "Złamana z lewej", "Złamana z prawej", "Przechylona w dół")
		submenu.SubMenu:AddItem(GridItem)
		GridItem:AddPanel(GridPanel)
		GridItem.Base.ActivatedPanel = function(_, item, panel, panelvalue)
			SetPedFaceFeature(GetPlayerPed(-1), 4, panelvalue.X);						--"Nose Peak Lowering",       // 4
			SetPedFaceFeature(GetPlayerPed(-1), 5, panelvalue.Y);						--"Nose Bone Twist",          // 5
			Character['nose_5'] = panelvalue.X
			Character['nose_6'] = panelvalue.Y
		end
		
		--Eye Brows-- up down in out
		local GridItem =  NativeUI.CreateListItem("Brwi", ListItem, 1)
		local GridPanel = NativeUI.CreateGridPanel("Wyżej", "Wewnątrz", "Na zewnątrz", "Niżej")
		submenu.SubMenu:AddItem(GridItem)
		GridItem:AddPanel(GridPanel)
		GridItem.Base.ActivatedPanel = function(_, item, panel, panelvalue)
			SetPedFaceFeature(GetPlayerPed(-1), 7, panelvalue.X);						--"Eyebrows Depth",            // 6
            SetPedFaceFeature(GetPlayerPed(-1), 6, panelvalue.Y);						--"Eyebrows Height",           // 7
			Character['eyebrows_5'] = panelvalue.X
			Character['eyebrows_6'] = panelvalue.Y
		end
		
		--Cheeks Bones Up Down In Out
		local GridItem =  NativeUI.CreateListItem("Kości policzkowe", ListItem, 1)
		local GridPanel = NativeUI.CreateGridPanel("Wyżej", "Wewnątrz", "Na zewnątrz", "Niżej")
		submenu.SubMenu:AddItem(GridItem)
		GridItem:AddPanel(GridPanel)
		GridItem.Base.ActivatedPanel = function(_, item, panel, panelvalue)
			SetPedFaceFeature(GetPlayerPed(-1), 8, panelvalue.X);						--"Cheekbones Height",        // 8
            SetPedFaceFeature(GetPlayerPed(-1), 9, panelvalue.Y);						--"Cheekbones Width",         // 9
			Character['cheeks_1'] = panelvalue.X
			Character['cheeks_2'] = panelvalue.Y
		end
		
		--Cheeks Gaunt Puffed
		local GridItem =  NativeUI.CreateListItem("Policzki", ListItem, 1)
		local GridPanel = NativeUI.CreateHorizontalGridPanel("Wychudzone", "Bufiaste")
		submenu.SubMenu:AddItem(GridItem)
		GridItem:AddPanel(GridPanel)
		GridItem.Base.ActivatedPanel = function(_, item, panel, panelvalue)
			SetPedFaceFeature(GetPlayerPed(-1), 10, panelvalue.X);						--"Cheeks Width",             // 10
			Character['cheeks_3'] = panelvalue.X
		end
		
		--Eyes-- Squint Wide
		local GridItem =  NativeUI.CreateListItem("Oczy", ListItem, 1)
		local GridPanel = NativeUI.CreateHorizontalGridPanel("Zmrużone", "Szerokie")
		submenu.SubMenu:AddItem(GridItem)
		GridItem:AddPanel(GridPanel)
		GridItem.Base.ActivatedPanel = function(_, item, panel, panelvalue)
			SetPedFaceFeature(GetPlayerPed(-1), 11, panelvalue.X);						--"Eyes Opening",             // 11
			Character['eye_open'] = panelvalue.X
		end

		--Lips Thin Fat
		local GridItem =  NativeUI.CreateListItem("Usta", ListItem, 1)
		local GridPanel = NativeUI.CreateHorizontalGridPanel("Cienkie", "Grube")
		submenu.SubMenu:AddItem(GridItem)
		GridItem:AddPanel(GridPanel)
		GridItem.Base.ActivatedPanel = function(_, item, panel, panelvalue)
			SetPedFaceFeature(GetPlayerPed(-1), 12, panelvalue.X);						--"Lips Thickness",           // 12
			Character['lips_thick'] = panelvalue.X
		end
		--Jaw Round Square Narrow Wide
		local GridItem =  NativeUI.CreateListItem("Szczęka", ListItem, 1)
		local GridPanel = NativeUI.CreateGridPanel("Okrągła", "Wąska", "Szeroka", "Kwadratowa")
		submenu.SubMenu:AddItem(GridItem)
		GridItem:AddPanel(GridPanel)
		GridItem.Base.ActivatedPanel = function(_, item, panel, panelvalue)
			SetPedFaceFeature(GetPlayerPed(-1), 13, panelvalue.X);						--"Jaw Bone Width",           // 13
            SetPedFaceFeature(GetPlayerPed(-1), 14, panelvalue.Y);						--"Jaw Bone Depth/Length",    // 14
			Character['jaw_1'] = panelvalue.X
			Character['jaw_2'] = panelvalue.Y
		end
		--Chin Profile Up Down In Out
		local GridItem =  NativeUI.CreateListItem("Broda", ListItem, 1)
		local GridPanel = NativeUI.CreateGridPanel("Wyżej", "Wewnątrz", "Na zewnątrz", "Niżej")
		submenu.SubMenu:AddItem(GridItem)
		GridItem:AddPanel(GridPanel)
		GridItem.Base.ActivatedPanel = function(_, item, panel, panelvalue)
			SetPedFaceFeature(GetPlayerPed(-1), 15, panelvalue.X);						--"Chin Height",              // 15
            SetPedFaceFeature(GetPlayerPed(-1), 16, panelvalue.Y);						--"Chin Depth/Length",        // 16
			Character['chin_height'] = panelvalue.X
			Character['chin_lenght'] = panelvalue.Y
		end
		-- Chin Shape Rounded Bum Square Pointed
		local GridItem =  NativeUI.CreateListItem("Kształt podbródka", ListItem, 1)
		local GridPanel = NativeUI.CreateGridPanel("Okrągły", "Kwadratowy", "Spiczasty", "Oddzielony")
		submenu.SubMenu:AddItem(GridItem)
		GridItem:AddPanel(GridPanel)
		GridItem.Base.ActivatedPanel = function(_, item, panel, panelvalue)
			SetPedFaceFeature(GetPlayerPed(-1), 17, panelvalue.X);						--"Chin Width",               // 17
            SetPedFaceFeature(GetPlayerPed(-1), 18, panelvalue.Y);						--"Chin Hole Size",           // 18
			Character['chin_width'] = panelvalue.X
			Character['chin_hole'] = panelvalue.Y
		end
		--Neck Thickness Thin Fat
		local GridItem =  NativeUI.CreateListItem("Grubość szyi", ListItem, 1)
		local GridPanel = NativeUI.CreateHorizontalGridPanel("Cienka", "Gruba")
		submenu.SubMenu:AddItem(GridItem)
		GridItem:AddPanel(GridPanel)
		GridItem.Base.ActivatedPanel = function(_, item, panel, panelvalue)
			SetPedFaceFeature(GetPlayerPed(-1), 19, panelvalue.X);						--"Neck Thickness"            // 19
			Character['neck_thick'] = panelvalue.X
		end

    submenu.SubMenu.OnListChange = function(sender, item, index)
		local currentSelectedIndex = item:IndexToItem(index)
		-- Perform your actions here.
		message = currentSelectedIndex
		--ShowNotification(submenu.SubMenu:CurrentSelection())
    end
end
	

function AddMenuAppearance(submenu)
	
	-- Hair Color
	local mHairNames = { "Close Shave", "Buzzcut", "Faux Hawk", "Hipster", "Rozczesanie z boku", "Krótszy krój", "Rowerzysta", "Ogon kucyka", "Cornrows", "Śliski", "Krótki szczotkowany", "Spiczasty", 
	"Cesarz", "Posiekany", "Dredy", "Długie włosy", "Shaggy Curls", "Surfer Dude", "Krótka część z boku", "Wysokie bśliskie boki", "Długie śliskie", "Młodość hipstera", "Cefal", "Nightvision" };
	fHairNames = { "Close Shave", "Short", "Layered Bob", "Pigtails", "Ponytail", "Braided Mohawk", "Braids", "Bob", "Faux Hawk", "French Twist", "Long Bob", "Loose Tied", 
	"Pixie", "Shaved Bangs", "Top Knot", "Wavy Bob", "Pin Up Girl", "Messy Bun", "Unknown", "Tight Bun", "Twisted Bob", "Big Bangs", "Braided Top Knot", "Mullet", "Nightvision"};
	if gender == "Male" then
		HairNames = mHairNames
	else
		HairNames = fHairNames
	end
	local Description = "Zmień fryzurę i kolor włosów!"
	local Select = NativeUI.CreateListItem("Włosy", HairNames , 1, Description )
	local BaseColor = NativeUI.CreateColourPanel("Kolor", ColoursPanel.HairCut)
	Select:AddPanel(BaseColor)
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		SetPedComponentVariation(GetPlayerPed(-1), 2,Index-1,0, 2)						-- Hair
		local ActiveItem = SelectedItem:IndexToItem(Index)
		local color = (ActiveItem.Panels and ActiveItem.Panels[1] or 1)
		SetPedHairColor(GetPlayerPed(-1),color-1,0)					-- Hair Color
		Character['hair_1'] = Index-1
		Character['hair_color_1'] = color-1
	end
	
-- Eyebrows + opacity Color
local eyebrow =	{ "None", "Balanced", "Fashion", "Cleopatra", "Quizzical", "Femme", "Seductive", "Pinched", "Chola", "Triomphe", "Carefree", "Curvaceous", "Rodent", 
	"Double Tram", "Thin", "Penciled", "Mother Plucker", "Straight and Narrow", "Natural", "Fuzzy", "Unkempt", "Caterpillar", "Regular", "Mediterranean", "Groomed", "Bushels", 
	"Feathered", "Prickly", "Monobrow", "Winged", "Triple Tram", "Arched Tram", "Cutouts", "Fade Away", "Solo Tram" }
	
	local Description = "Zmień swój wygląd!"
	local Select = NativeUI.CreateListItem("Brwi", eyebrow , 1, Description )
	local BaseColor = NativeUI.CreateColourPanel("Kolor", ColoursPanel.HairCut)
	local PercentageItem = NativeUI.CreatePercentagePanel("0%", "Przeźroczystość", "100%")
	Select:AddPanel(PercentageItem)
	Select:AddPanel(BaseColor)
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		local ActiveItem = SelectedItem:IndexToItem(Index)
        local percentage = (ActiveItem.Panels and ActiveItem.Panels[1] or 1.0)
		local color = (ActiveItem.Panels and ActiveItem.Panels[2] or 1)
		SetPedHeadOverlay(GetPlayerPed(-1), 2,Index-1,percentage)						-- -- Eyebrows + opacity size type color 1 color2
		SetPedHeadOverlayColor(GetPlayerPed(-1), 2, 1,	color-1,0)					-- Eyebrows Color
		Character['eyebrows_1'] = Index-1
		Character['eyebrows_2'] = percentage*10
		Character['eyebrows_3'] = color-1
	end
	
	
--Facial Hair : color Opa
local beard = { "Clean Shaven", "Light Stubble", "Balbo", "Circle Beard", "Goatee", "Chin", "Chin Fuzz", "Pencil Chin Strap", "Scruffy", "Musketeer", "Mustache", 
	"Trimmed Beard", "Stubble", "Thin Circle Beard", "Horseshoe", "Pencil and Chops", "Chin Strap Beard", "Balbo and Sideburns", "Mutton Chops", "Scruffy Beard", "Curly", 
	"Curly and Deep Stranger", "Handlebar", "Faustic", "Otto and Patch", "Otto and Full Stranger", "Light Franz", "The Hampstead", "The Ambrose", "Lincoln Curtain" }
	
	local Description = "Zmień swój wygląd!"
	local Select = NativeUI.CreateListItem("Broda", beard , 1, Description )
	local BaseColor = NativeUI.CreateColourPanel("Kolor", ColoursPanel.HairCut)
	local PercentageItem = NativeUI.CreatePercentagePanel("0%", "Przeźroczystość", "100%")
	Select:AddPanel(PercentageItem)
	Select:AddPanel(BaseColor)
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		local ActiveItem = SelectedItem:IndexToItem(Index)
        local percentage = (ActiveItem.Panels and ActiveItem.Panels[1] or 1.0)
		local color = (ActiveItem.Panels and ActiveItem.Panels[2] or 1)
		SetPedHeadOverlay(GetPlayerPed(-1), 1,Index-1,percentage)						-- -- Beard + opacity
		SetPedHeadOverlayColor(GetPlayerPed(-1), 1, 1,	color-1,0)					-- Beard Color
		Character['beard_1'] = Index-1
		Character['beard_2'] = percentage*10
		Character['beard_3'] = color-1
	end
	--Skin Blemishes Opacity
	local blemishes = { "None", "Measles", "Pimples", "Spots", "Break Out", "Blackheads", "Build Up", "Pustules", "Zits", "Full Acne", "Acne", "Cheek Rash", "Face Rash",
	"Picker", "Puberty", "Eyesore", "Chin Rash", "Two Face", "T Zone", "Greasy", "Marked", "Acne Scarring", "Full Acne Scarring", "Cold Sores", "Impetigo" }
	
	local Description = "Zmień swój wygląd!"
	local Select = NativeUI.CreateListItem("Skazy skórne", blemishes , 1, Description )
	local PercentageItem = NativeUI.CreatePercentagePanel("0%", "Przeźroczystość", "100%")
	Select:AddPanel(PercentageItem)
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		local ActiveItem = SelectedItem:IndexToItem(Index)
        local percentage = (ActiveItem.Panels and ActiveItem.Panels[1] or 1.0)
		SetPedHeadOverlay(GetPlayerPed(-1), 11,Index-1,percentage)						-- -- Beard + opacity
		Character['bodyb_1'] = Index-1
		Character['bodyb_2'] = percentage*10
	end
	
	--Skin Ageing : Opacity
	local aging = { "None", "Crow's Feet", "First Signs", "Middle Aged", "Worry Lines", "Depression", "Distinguished", "Aged", "Weathered", "Wrinkled", "Sagging", "Tough Life", 
	"Vintage", "Retired", "Junkie", "Geriatric" }
	
	local Description = "Zmień swój wygląd!"
	local Select = NativeUI.CreateListItem("Starzenie się skóry", aging , 1, Description )
	local PercentageItem = NativeUI.CreatePercentagePanel("0%", "Przeźroczystość", "100%")
	Select:AddPanel(PercentageItem)
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		local ActiveItem = SelectedItem:IndexToItem(Index)
        local percentage = (ActiveItem.Panels and ActiveItem.Panels[1] or 1.0)
		SetPedHeadOverlay(GetPlayerPed(-1), 3,Index-1,percentage)						-- -- Skin Ageing + Opacity
		Character['age_1'] = Index-1
		Character['age_2'] = percentage*10
	end
	
	--Skin Complexion : opa
	local complexion = { "None", "Rosy Cheeks", "Stubble Rash", "Hot Flush", "Sunburn", "Bruised", "Alchoholic", "Patchy", "Totem", "Blood Vessels", "Damaged", "Pale", "Ghostly" }

	local Description = "Zmień swój wygląd!"
	local Select = NativeUI.CreateListItem("Kompleksy skórne", complexion , 1, Description )
	local PercentageItem = NativeUI.CreatePercentagePanel("0%", "Przeźroczystość", "100%")
	
	Select:AddPanel(PercentageItem)
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		local ActiveItem = SelectedItem:IndexToItem(Index)
        local percentage = (ActiveItem.Panels and ActiveItem.Panels[1] or 1.0)
		SetPedHeadOverlay(GetPlayerPed(-1), 6,Index-1,percentage)						-- -- Skin Complexion + opa
		Character['complexion_1'] = Index-1
		Character['complexion_2'] = percentage*10
	end
	
	--Mole & Freckles opa
	local molefreckle = { "None", "Cherub", "All Over", "Irregular", "Dot Dash", "Over the Bridge", "Baby Doll", "Pixie", "Sun Kissed", "Beauty Marks", "Line Up", "Modelesque",
	"Occasional", "Speckled", "Rain Drops", "Double Dip", "One Sided", "Pairs", "Growth" }
	
	local Description = "Zmień swój wygląd!"
	local Select = NativeUI.CreateListItem("Piegi", molefreckle , 1, Description )
	local PercentageItem = NativeUI.CreatePercentagePanel("0%", "Przeźroczystość", "100%")
	Select:AddPanel(PercentageItem)
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		local ActiveItem = SelectedItem:IndexToItem(Index)
        local percentage = (ActiveItem.Panels and ActiveItem.Panels[1] or 1.0)
		SetPedHeadOverlay(GetPlayerPed(-1), 9,Index-1,percentage)						-- -- Mole & Freckles opa
		Character['moles_1'] = Index-1
		Character['moles_2'] = percentage*10
	end
	
	--Skin Damage opa
	local sundamage = { "None", "Uneven", "Sandpaper", "Patchy", "Rough", "Leathery", "Textured", "Coarse", "Rugged", "Creased", "Cracked", "Gritty" }
	
	local Description = "Zmień swój wygląd!"
	local Select = NativeUI.CreateListItem("Opalenizna", sundamage , 1, Description )
	local PercentageItem = NativeUI.CreatePercentagePanel("0%", "Przeźroczystość", "100%")
	Select:AddPanel(PercentageItem)
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		local ActiveItem = SelectedItem:IndexToItem(Index)
        local percentage = (ActiveItem.Panels and ActiveItem.Panels[1] or 1.0)
		SetPedHeadOverlay(GetPlayerPed(-1), 7,Index-1,percentage)						-- -- Skin Damage opa
		Character['sun_1'] = Index-1
		Character['sun_2'] = percentage*10
	end
	
	--Eye Color color
	eyeColorNames = { "Zielone", "Emeraldowe", "Jasnoniebieskie", "Oceaniczny niebieski", "Jasnobrązowe", "Ciemnobrązowe", "Piwne", "Ciemnoszare", "Jasnoszare", "Różowe", "Żółte", "Pomarańczowe", "Zaciemnienie", 
	"Odcienie szarego", "Tequila Sunrise", "Atomowe", "Osnowe", "ECola", "Space Ranger", "Ying Yang", "Strzał w dziesiątkę", "Jaszczurka", "Smok", "Extra Terrestrial", "Koza", "Śmieszek", "Opętane", 
	"Demon", "Zainfekowany", "Kosmita", "Nieumarły", "Zombie"};

	local Description = "Zmień fryzurę i kolor włosów!"
	local Select = NativeUI.CreateListItem("Kolor oczu", eyeColorNames , 1, Description )
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		SetPedEyeColor(GetPlayerPed(-1), Index - 1, 0, 1)												-- Eyes color
		Character['eye_color'] = Index-1
	end
	
	--Eye Makeup color opa
	local makeup = { "None", "Czarne smoliste", "Brązowe", "Ciepłe szare", "Retro Glam", "Naturalnie wyglądające", "Kocie oczy", "Chola", "Wampirze", "Glamura Vinewood", "Guma balonowa", "Wodny sen", 
	"Pin up", "Filotowa pasja", "Smoliste kocie oczy", "Tlący się rubin", "Księżniczka Popu",
	--face paint
	"Kiss My Axe", "Panda Pussy", "The Bat", "Skull in Scarlet", "Serpentine", "The Veldt", "Unknown 1", "Unknown 2", "Unknown 3", "Unknown 4", "Tribal Lines", "Tribal Swirls",
	"Tribal Orange", "Tribal Red", "Trapped in A Box", "Clowning",
	-- makeup pt 2
	"Guyliner", "Unknown 5","Blood Tears", "Heavy Metal", "Sorrow", "Prince of Darkness", "Rocker", "Goth", "Punk", "Devastated" }
	
	local Description = "Zmień swój wygląd!"
	local Select = NativeUI.CreateListItem("Makeup", makeup , 1, Description )
	local BaseColor = NativeUI.CreateColourPanel("Kolor", ColoursPanel.HairCut)
	local PercentageItem = NativeUI.CreatePercentagePanel("0%", "Przeźroczystość", "100%")
	Select:AddPanel(PercentageItem)
	Select:AddPanel(BaseColor)
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		local ActiveItem = SelectedItem:IndexToItem(Index)
        local percentage = (ActiveItem.Panels and ActiveItem.Panels[1] or 1.0)
		local color = (ActiveItem.Panels and ActiveItem.Panels[2] or 1)
		SetPedHeadOverlay(GetPlayerPed(-1), 4,Index-1,percentage)						-- -- Makeup + opacity
		SetPedHeadOverlayColor(GetPlayerPed(-1), 4, 1,	color-1,0)					-- Makeup Color
		Character['makeup_1'] = Index-1
		Character['makeup_2'] = percentage*10
		Character['makeup_3'] = color-1
	end
	
	--Lipstick opa Color
	local lipstick =  { "None", "Color Matte", "Color Gloss", "Lined Matte", "Lined Gloss", "Heavy Lined Matte", "Heavy Lined Gloss", "Lined Nude Matte", "Liner Nude Gloss", 
	"Smudged", "Geisha" }
	
	local Description = "Zmień swój wygląde!"
	local Select = NativeUI.CreateListItem("Szminka", lipstick , 1, Description )
	local BaseColor = NativeUI.CreateColourPanel("Kolor", ColoursPanel.HairCut)
	local PercentageItem = NativeUI.CreatePercentagePanel("0%", "Przeźroczystość", "100%")
	Select:AddPanel(PercentageItem)
	Select:AddPanel(BaseColor)
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		local ActiveItem = SelectedItem:IndexToItem(Index)
        local percentage = (ActiveItem.Panels and ActiveItem.Panels[1] or 1.0)
		local color = (ActiveItem.Panels and ActiveItem.Panels[2] or 1)
		SetPedHeadOverlay(GetPlayerPed(-1), 8,Index-1,percentage)						-- -- Lipstick + opacity
		SetPedHeadOverlayColor(GetPlayerPed(-1), 8, 1,	color-1,0)					-- Lipstick Color
		Character['lipstick_1'] = Index-1
		Character['lipstick_2'] = percentage*10
		Character['lipstick_3'] = color-1
	end
	
	--Chest Hair opa Color
	local lipstick =  { "None", "Color Matte", "Color Gloss", "Lined Matte", "Lined Gloss", "Heavy Lined Matte", "Heavy Lined Gloss", "Lined Nude Matte", "Liner Nude Gloss", 
	"Smudged", "Geisha" }
	
	local Description = "Zmień swój wygląd!"
	local Select = NativeUI.CreateListItem("Włosy na klacie", lipstick , 1, Description )
	local BaseColor = NativeUI.CreateColourPanel("Kolor", ColoursPanel.HairCut)
	local PercentageItem = NativeUI.CreatePercentagePanel("0%", "Przeźroczystość", "100%")
	Select:AddPanel(PercentageItem)
	Select:AddPanel(BaseColor)
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		local ActiveItem = SelectedItem:IndexToItem(Index)
        local percentage = (ActiveItem.Panels and ActiveItem.Panels[1] or 1.0)
		local color = (ActiveItem.Panels and ActiveItem.Panels[2] or 1)
		SetPedHeadOverlay(GetPlayerPed(-1), 10,Index-1,percentage)						-- -- Chest Hair + opacity
		SetPedHeadOverlayColor(GetPlayerPed(-1), 10, 1,	color-1,0)					-- Chest Hair Color
		Character['chest_1'] = Index-1
		Character['chest_2'] = percentage*10
		Character['chest_3'] = color-1
	end
	
	-- Blush + opacity Blush Color
	local blush = { "None", "Full", "Angled", "Round", "Horizontal", "High", "Sweetheart", "Eighties" }
	local Description = "Zmień swój wygląd!"
	local Select = NativeUI.CreateListItem("Rumieńce", blush , 1, Description )
	local BaseColor = NativeUI.CreateColourPanel("Kolor", ColoursPanel.HairCut)
	local PercentageItem = NativeUI.CreatePercentagePanel("0%", "Przeźroczystość", "100%")
	Select:AddPanel(PercentageItem)
	Select:AddPanel(BaseColor)
	submenu.SubMenu:AddItem(Select)
	Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
		local ActiveItem = SelectedItem:IndexToItem(Index)
        local percentage = (ActiveItem.Panels and ActiveItem.Panels[1] or 1.0)
		local color = (ActiveItem.Panels and ActiveItem.Panels[2] or 1)
		SetPedHeadOverlay(GetPlayerPed(-1), 5,Index-1,percentage)						-- -- Chest Hair + opacity
		SetPedHeadOverlayColor(GetPlayerPed(-1), 5, 2,	color-1,0)					-- Chest Hair Color
		Character['blush_1'] = Index-1
		Character['blush_2'] = percentage*10
		Character['blush_3'] = color-1
	end
end


function AddMenuClothes(submenu)
	
	clothingCategoryNames = {"Maski", "Włosy", "Rękawice", "Spodnie", "Plecaki i spadochrony", "Buty", "Naszyjniki i krawaty", "Podkoszulek", "Zbroja", "Kalkomanie i logo", "Koszule i kurtki" }
	local amount = {}
	
	for i = 0, 12 do
		if i == 1 or i == 3 or i == 4 or i == 6 or i == 7 or i == 8 or i == 9 or i == 11 then
			local maxDrawables = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), i);
			--local maxTextures = GetNumberOfPedTextureVariations(GetPlayerPed(-1), i, currentVariationIndex);
			maxDrawables = maxDrawables - 1
			amount = {}
			for i = 1, maxDrawables do
				amount[i] = "item "..i.."/"..maxDrawables
			end
			local Select = NativeUI.CreateListItem(clothingCategoryNames[i], amount , 1, "Wybór:  "..clothingCategoryNames[i] )
			local BaseColor = NativeUI.CreateColourPanel("Tekstura", ColoursPanel.Texture)
			
			if submenu.SubMenu ~= nil then
				submenu.SubMenu:AddItem(Select)
				Select:AddPanel(BaseColor)
			else
				submenu:AddItem(Select)
			end	
			Select.OnListChanged = function(ParentMenu, SelectedItem, Index)
				local ActiveItem = SelectedItem:IndexToItem(Index)
				local color = (ActiveItem.Panels and ActiveItem.Panels[1] or 1)

				SetPedComponentVariation(GetPlayerPed(-1), i,Index-1,color-1, 2)
				if i == 1 then
					Character['mask_1'] = Index-1
					Character['mask_2'] = color-1
				elseif i == 3 then
					Character['arms'] = Index-1
					Character['arms_2'] = color-1
				elseif i == 4 then
					Character['pants_1'] = Index-1
					Character['pants_2'] = color-1
				elseif i == 6 then
					Character['shoes_1'] = Index-1
					Character['shoes_2'] = color-1
				elseif i == 7 then
					Character['chain_1'] = Index-1
					Character['chain_2'] = color-1
				elseif i == 8 then
					Character['tshirt_1'] = Index-1
					Character['tshirt_2'] = color-1
				elseif i == 9 then
					Character['bproof_1'] = Index-1
					Character['bproof_2'] = color-1
				elseif i == 11 then
					Character['torso_1'] = Index-1
					Character['torso_2'] = color-1
				end
			end
		end
	
	end

end

AddMenuPed(mainMenu)
AddMenuInheritance(submenuInheritance)
AddMenuFaceShape(submenuFaceShape)
AddMenuAppearance(submenuAppearance)
AddMenuClothes(submenuClothes)
AddMenuClothes(otherPedMenu)
_menuPool:RefreshIndex()
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		_menuPool:ProcessMenus()
		_menuPool:MouseEdgeEnabled(false)
		_menuPool:ControlDisablingEnabled(true)
    end
end)