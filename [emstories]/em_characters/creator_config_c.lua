Character = {}
cam, cam2, cam3, camSkin, isCameraActive = nil, nil, nil, nil, nil
lastCam = 'body'
clothingCategoryNames = {"Maski", "Włosy", "Rękawice", "Spodnie", "Plecaki i spadochrony", "Buty", "Naszyjniki i krawaty", "Podkoszulek", "Zbroja", "Kalkomanie i logo", "Koszule i kurtki" }
list = {
    ['masks']=963,
    ['hats']=911,
    ['ears']=100,
    ['glasses']=71,
    ['neckarms']=317,
    ['lefthands']=73,
    ['righthands']=12,
    ['topsover']=2015,
    ['topsunder']=949,
    ['pants']=482,
    ['shoes']=496,
}
Components = {
	{label = _U('sex'),						name = 'sex',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('face'),					name = 'face',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('skin'),					name = 'skin',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('hair_1'),					name = 'hair_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('hair_2'),					name = 'hair_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('hair_color_1'),			name = 'hair_color_1',		value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('hair_color_2'),			name = 'hair_color_2',		value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('tshirt_1'),				name = 'tshirt_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('tshirt_2'),				name = 'tshirt_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'tshirt_1'},
	{label = _U('torso_1'),					name = 'torso_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('torso_2'),					name = 'torso_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'torso_1'},
	{label = _U('decals_1'),				name = 'decals_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('decals_2'),				name = 'decals_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'decals_1'},
	{label = _U('arms'),					name = 'arms',				value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('arms_2'),					name = 'arms_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('pants_1'),					name = 'pants_1',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.5},
	{label = _U('pants_2'),					name = 'pants_2',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.5,	textureof	= 'pants_1'},
	{label = _U('shoes_1'),					name = 'shoes_1',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.8},
	{label = _U('shoes_2'),					name = 'shoes_2',			value = 0,		min = 0,	zoomOffset = 0.8,		camOffset = -0.8,	textureof	= 'shoes_1'},
	{label = _U('mask_1'),					name = 'mask_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('mask_2'),					name = 'mask_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'mask_1'},
	{label = _U('bproof_1'),				name = 'bproof_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('bproof_2'),				name = 'bproof_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bproof_1'},
	{label = _U('chain_1'),					name = 'chain_1',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('chain_2'),					name = 'chain_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'chain_1'},
	{label = _U('helmet_1'),				name = 'helmet_1',			value = -1,		min = -1,	zoomOffset = 0.6,		camOffset = 0.65,	componentId	= 0 },
	{label = _U('helmet_2'),				name = 'helmet_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'helmet_1'},
	{label = _U('glasses_1'),				name = 'glasses_1',			value = -1,		min = -1,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = _U('glasses_2'),				name = 'glasses_2',			value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'glasses_1'},
	{label = _U('watches_1'),				name = 'watches_1',			value = -1,		min = -1,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('watches_2'),				name = 'watches_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'watches_1'},
	{label = _U('bracelets_1'),				name = 'bracelets_1',		value = -1,		min = -1,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('bracelets_2'),				name = 'bracelets_2',		value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bracelets_1'},
	{label = _U('bag'),						name = 'bags_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('bag_color'),				name = 'bags_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bags_1'},
	{label = _U('eye_color'),				name = 'eye_color',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_size'),			name = 'eyebrows_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_type'),			name = 'eyebrows_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_color_1'),			name = 'eyebrows_3',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('eyebrow_color_2'),			name = 'eyebrows_4',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('makeup_type'),				name = 'makeup_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('makeup_thickness'),		name = 'makeup_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('makeup_color_1'),			name = 'makeup_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('makeup_color_2'),			name = 'makeup_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lipstick_type'),			name = 'lipstick_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lipstick_thickness'),		name = 'lipstick_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lipstick_color_1'),		name = 'lipstick_3',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('lipstick_color_2'),		name = 'lipstick_4',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('ear_accessories'),			name = 'ears_1',			value = -1,		min = -1,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('ear_accessories_color'),	name = 'ears_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65,	textureof	= 'ears_1'},
	{label = _U('chest_hair'),				name = 'chest_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('chest_hair_1'),			name = 'chest_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('chest_color'),				name = 'chest_3',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('bodyb'),					name = 'bodyb_1',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('bodyb_size'),				name = 'bodyb_2',			value = 0,		min = 0,	zoomOffset = 0.75,		camOffset = 0.15},
	{label = _U('wrinkles'),				name = 'age_1',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('wrinkle_thickness'),		name = 'age_2',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('blemishes'),				name = 'blemishes_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('blemishes_size'),			name = 'blemishes_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('blush'),					name = 'blush_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('blush_1'),					name = 'blush_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('blush_color'),				name = 'blush_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('complexion'),				name = 'complexion_1',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('complexion_1'),			name = 'complexion_2',		value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('sun'),						name = 'sun_1',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('sun_1'),					name = 'sun_2',				value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('freckles'),				name = 'moles_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('freckles_1'),				name = 'moles_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('beard_type'),				name = 'beard_1',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('beard_size'),				name = 'beard_2',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('beard_color_1'),			name = 'beard_3',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = _U('beard_color_2'),			name = 'beard_4',			value = 0,		min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Inherit Mom",					name = 'mom',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Inherit Dad",					name = 'dad',				value = 0,		min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Nose Width",					name = 'nose_1',			value = 0.0,	min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Noes Peak Height",			name = 'nose_2',			value = 0.0,	min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Nose Peak Length",			name = 'nose_3',			value = 0.0,	min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Nose Bone Height",			name = 'nose_4',			value = 0.0,	min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Nose Peak Lowering",			name = 'nose_5',			value = 0.0,	min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Nose Bone Twist",				name = 'nose_6',			value = 0.0,	min = 0,	zoomOffset = 0.6,		camOffset = 0.65},
	{label = "Eyebrows Depth",				name = 'eyebrows_5',		value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Eyebrows Height",				name = 'eyebrows_6',		value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Cheekbones Height",			name = 'cheeks_1',			value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Cheekbones Width",			name = 'cheeks_2',			value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Cheeks Width",				name = 'cheeks_3',			value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Eyes Opening",				name = 'eye_open',			value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Lips Thickness",				name = 'lips_thick',		value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Jaw Bone Width",				name = 'jaw_1',				value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Jaw Bone Length",				name = 'jaw_2',				value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Chin Height",					name = 'chin_height',		value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Chin Length",					name = 'chin_lenght',		value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Chin Width",					name = 'chin_width',		value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Chin Hole Size",				name = 'chin_hole',			value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Neck Thickness",				name = 'neck_thick',		value = 0.0,	min = 0,	zoomOffset = 0.4,		camOffset = 0.65},
	{label = "Player Model Hash",			name = 'model_hash',			value = GetHashKey("mp_m_freemode_01"),		min = 0,	zoomOffset = 0.4,		camOffset = 0.65}
}

Panel = {
	GridPanel = {
		x = 0.5,
		y = 0.5,
		Top = "Góra",
        Bottom = "Dół",
        Left = "Lewo",
        Right = "Prawo",
		enable = false
	},

	GridPanelHorizontal = {
		x = 0.5,
        Left = "Lewo",
        Right = "Prawo",
		enable = false
	},

	ColourPanel = {
		itemIndex = 1,
        index_one = 1,
        index_two = 1,
		name = "Kolor",
        Color = RageUI.PanelColour.HairCut,
		enable = false
	},

	PercentagePanel = {
		index = 0,
        itemIndex = 1,
        MinText = '0%',
        HeaderText = "Przeźroczystość",
        MaxText = '100%',
		enable = false
	}
}

Apperance = {
	{
		item = 'hair',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'component',
		itemID = 2,
		PercentagePanel = false,
		ColourPanel = true,
        desc='Włosy',
	},
	{
		item = 'eyebrows',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 2,
		PercentagePanel = true,
		ColourPanel = true,
        desc="Brwi",
	},
	{
		item = 'beard',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 1,
		PercentagePanel = true,
		ColourPanel = true,
        desc="Broda"
	},
	{
		item = 'bodyb',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11},
		index = 1,
		indextwo = 1,
		cam = 'body',
		itemType = 'headoverlay',
		itemID = 11,
		PercentagePanel = true,
        desc="Pieprzyki na ciele"
	},
	{
		item = 'age',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 3,
		PercentagePanel = true,
        desc = "Starzenie się"
	},
	{
		item = 'blemishes',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 0,
		PercentagePanel = true,
        desc = "Skazy",
	},
	{
		item = 'moles',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 9,
		PercentagePanel = true,
        desc = "Pieprzyki"
	},
	{
		item = 'sun',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 7,
		PercentagePanel = true,
        desc = "Zniszczenia od słońca"
	},
	{
		item = 'eyes_color',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'eye',
        desc = "Kolor oczu"
	},
	{
		item = 'makeup',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 4,
		PercentagePanel = true,
		ColourPanel = true,
        desc = "Makijaż"
	},
	{
		item = 'lipstick',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 8,
		PercentagePanel = true,
		ColourPanel = true,
        desc = "Szminka"
	},
	{
		item = 'chest',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16},
		index = 1,
		indextwo = 1,
		cam = 'body',
		itemType = 'headoverlay',
		itemID = 10,
		PercentagePanel = true,
		ColourPanel = true,
        desc = "Włosy na ciele"
	},
	{
		item = 'blush',
		List = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ,16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32},
		index = 1,
		indextwo = 1,
		cam = 'face',
		itemType = 'headoverlay',
		itemID = 5,
		PercentagePanel = true,
		ColourPanel = true,
        desc = "Rumieńce"
	},
}

function GetComponentDataFromHash(hash)
    local blob = string.rep('\0\0\0\0\0\0\0\0', 9 + 16)
    if not Citizen.InvokeNative(0x74C0E2A57EC66760, hash, blob) then
        return nil
    end

    -- adapted from: https://gist.github.com/root-cause/3b80234367b0c856d60bf5cb4b826f86
    local lockHash = string.unpack('<i4', blob, 1)
    local hash = string.unpack('<i4', blob, 9)
    local locate = string.unpack('<i4', blob, 17)
    local drawable = string.unpack('<i4', blob, 25)
    local texture = string.unpack('<i4', blob, 33)
    local field5 = string.unpack('<i4', blob, 41)
    local component = string.unpack('<i4', blob, 49)
    local field7 = string.unpack('<i4', blob, 57)
    local field8 = string.unpack('<i4', blob, 65)
    local gxt = string.unpack('c64', blob, 73)

    return component, drawable, texture, gxt, field5, field7, field8
end

function GetPropDataFromHash(hash)
    local blob = string.rep('\0\0\0\0\0\0\0\0', 9 + 16)
    if not Citizen.InvokeNative(0x5D5CAFF661DDF6FC, hash, blob) then
        return nil
    end

    -- adapted from: https://gist.github.com/root-cause/3b80234367b0c856d60bf5cb4b826f86
    local lockHash = string.unpack('<i4', blob, 1)
    local hash = string.unpack('<i4', blob, 9)
    local locate = string.unpack('<i4', blob, 17)
    local drawable = string.unpack('<i4', blob, 25)
    local texture = string.unpack('<i4', blob, 33)
    local field5 = string.unpack('<i4', blob, 41)
    local prop = string.unpack('<i4', blob, 49)
    local field7 = string.unpack('<i4', blob, 57)
    local field8 = string.unpack('<i4', blob, 65)
    local gxt = string.unpack('c64', blob, 73)

    return prop, drawable, texture, gxt, field5, field7, field8
end

function GetComponentsData(id)
    local result = {}

    local playerPed = PlayerPedId()
    local componentBlacklist = nil

    if blacklist ~= nil then
        if GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
           -- componentBlacklist = blacklist.components.male
        elseif GetEntityModel(playerPed) == GetHashKey('mp_f_freemode_01') then
            --componentBlacklist = blacklist.components.female
        end
    end

    local drawableCount = GetNumberOfPedDrawableVariations(playerPed, id) - 1

    for drawable = 0, drawableCount do
        local textureCount = GetNumberOfPedTextureVariations(playerPed, id, drawable) - 1

        for texture = 0, textureCount do
            local hash = GetHashNameForComponent(playerPed, id, drawable, texture)

            if hash ~= 0 then
                local component, drawable, texture, gxt = GetComponentDataFromHash(hash)
                -- only named components
                if gxt ~= '' then
                    label = GetLabelText(gxt)
                    if label ~= 'NULL' then
                        local blacklisted = false

                       -- if componentBlacklist ~= nil then
                         --   if componentBlacklist[component] ~= nil then
                           --     if componentBlacklist[component][drawable] ~= nil then
                             --       if componentBlacklist[component][drawable][texture] ~= nil then
                               --         blacklisted = true
                                 --   end
                               -- end
                           -- end
                        --end
    
                        if not blacklisted then
                            table.insert(result, {
                                Name = tostring(label),
                                component = component,
                                drawable = drawable,
                                texture = texture
                            })
                        end
                    end
                end
            end
        end
    end

    return result
end

function GetPropsData(id)
    local result = {}

    local playerPed = PlayerPedId()
    local propBlacklist = nil

    if blacklist ~= nil then
        if GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
            --propBlacklist = blacklist.props.male
        elseif GetEntityModel(playerPed) == GetHashKey('mp_f_freemode_01') then
            --propBlacklist = blacklist.props.female
        end
    end

    local drawableCount = GetNumberOfPedPropDrawableVariations(playerPed, id) - 1

    for drawable = 0, drawableCount do
        local textureCount = GetNumberOfPedPropTextureVariations(playerPed, id, drawable) - 1

        for texture = 0, textureCount do
            local hash = GetHashNameForProp(playerPed, id, drawable, texture)

            if hash ~= 0 then
                local prop, drawable, texture, gxt = GetPropDataFromHash(hash)
                if gxt ~= '' then
                    label = GetLabelText(gxt)
                    if label ~= 'NULL' then
                        local blacklisted = false

                        --if propBlacklist ~= nil then
                          --  if propBlacklist[prop] ~= nil then
                            --    if propBlacklist[prop][drawable] ~= nil then
                              --      if propBlacklist[prop][drawable][texture] ~= nil then
                                --        blacklisted = true
                                  --  end
                                --end
                            --end
                        --end

                        if not blacklisted then
                            table.insert(result, {
                                Name = tostring(label),
                                prop = prop,
                                drawable = drawable,
                                texture = texture
                            })
                        end
                    end
                end
            end
        end
    end

    return result
end