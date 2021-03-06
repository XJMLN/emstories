Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Config = {}
Config.Locale = 'en'
Config.MenuX = 5
Config.MenuY = 5
Config.MenuColor = {r = 180,g = 0,b = 0,a = 180 }

male_models = {'none','a_m_m_acult_01','a_m_m_afriamer_01','a_m_m_beach_01','a_m_m_beach_02','a_m_m_bevhills_01','a_m_m_bevhills_02','a_m_m_business_01','a_m_m_eastsa_01','a_m_m_eastsa_02','a_m_m_farmer_01','a_m_m_fatlatin_01','a_m_m_genfat_01','a_m_m_genfat_02','a_m_m_golfer_01','a_m_m_hasjew_01','a_m_m_hillbilly_01','a_m_m_hillbilly_02','a_m_m_indian_01','a_m_m_ktown_01','a_m_m_malibu_01','a_m_m_mexcntry_01','a_m_m_mexlabor_01','a_m_m_og_boss_01','a_m_m_paparazzi_01','a_m_m_polynesian_01','a_m_m_prolhost_01','a_m_m_rurmeth_01','a_m_m_salton_01','a_m_m_salton_02','a_m_m_salton_03','a_m_m_salton_04','a_m_m_skater_01','a_m_m_skidrow_01','a_m_m_socenlat_01','a_m_m_soucent_01','a_m_m_soucent_02','a_m_m_soucent_03','a_m_m_soucent_04','a_m_m_stlat_02','a_m_m_tennis_01','a_m_m_tourist_01','a_m_m_trampbeac_01','a_m_m_tramp_01','a_m_m_tranvest_01','a_m_m_tranvest_02','a_m_o_acult_01','a_m_o_acult_02','a_m_o_beach_01','a_m_o_genstreet_01','a_m_o_ktown_01','a_m_o_salton_01','a_m_o_soucent_01','a_m_o_soucent_02','a_m_o_soucent_03','a_m_o_tramp_01','a_m_y_acult_01','a_m_y_acult_02','a_m_y_beachvesp_01','a_m_y_beachvesp_02','a_m_y_beach_01','a_m_y_beach_02','a_m_y_beach_03','a_m_y_bevhills_01','a_m_y_bevhills_02','a_m_y_breakdance_01','a_m_y_busicas_01','a_m_y_business_01','a_m_y_business_02','a_m_y_business_03','a_m_y_cyclist_01','a_m_y_dhill_01','a_m_y_downtown_01','a_m_y_eastsa_01','a_m_y_eastsa_02','a_m_y_epsilon_01','a_m_y_epsilon_02','a_m_y_gay_01','a_m_y_gay_02','a_m_y_genstreet_01','a_m_y_genstreet_02','a_m_y_golfer_01','a_m_y_hasjew_01','a_m_y_hiker_01','a_m_y_hippy_01','a_m_y_hipster_01','a_m_y_hipster_02','a_m_y_hipster_03','a_m_y_indian_01','a_m_y_jetski_01','a_m_y_juggalo_01','a_m_y_ktown_01','a_m_y_ktown_02','a_m_y_latino_01','a_m_y_methhead_01','a_m_y_mexthug_01','a_m_y_motox_01','a_m_y_motox_02','a_m_y_musclbeac_01','a_m_y_musclbeac_02','a_m_y_polynesian_01','a_m_y_roadcyc_01','a_m_y_runner_01','a_m_y_runner_02','a_m_y_salton_01','a_m_y_skater_01','a_m_y_skater_02','a_m_y_soucent_01','a_m_y_soucent_02','a_m_y_soucent_03','a_m_y_soucent_04','a_m_y_stbla_01','a_m_y_stbla_02','a_m_y_stlat_01','a_m_y_stwhi_01','a_m_y_stwhi_02','a_m_y_sunbathe_01','a_m_y_surfer_01','a_m_y_vindouche_01','a_m_y_vinewood_01','a_m_y_vinewood_02','a_m_y_vinewood_03','a_m_y_vinewood_04','a_m_y_yoga_01','csb_anton','csb_ballasog','csb_burgerdrug','csb_car3guy1','csb_car3guy2','csb_chef','csb_chin_goon','csb_cletus', 'csb_customer', 'csb_fos_rep', 'csb_g', 'csb_groom', 'csb_grove_str_dlr', 'csb_hao', 'csb_hugh', 'csb_imran', 'csb_janitor', 'csb_ortega', 'csb_oscar', 'csb_porndudes', 'csb_prologuedriver', 'csb_ramp_gang',  'csb_ramp_hic', 'csb_ramp_hipster', 'csb_ramp_mex', 'csb_reporter', 'csb_roccopelosi', 'csb_trafficwarden','cs_bankman', 'cs_barry', 'cs_beverly', 'cs_brad', 'cs_carbuyer', 'cs_chengsr', 'cs_chrisformage', 'cs_clay', 'cs_dale', 'cs_davenorton', 'cs_devin', 'cs_dom', 'cs_dreyfuss', 'cs_drfriedlander', 'cs_fabien', 'cs_floyd', 'cs_hunter', 'cs_jimmyboston', 'cs_jimmydisanto', 'cs_joeminuteman', 'cs_johnnyklebitz', 'cs_josef', 'cs_josh', 'cs_lazlow', 'cs_lestercrest', 'cs_lifeinvad_01', 'cs_manuel', 'cs_martinmadrazo', 'cs_milton', 'cs_movpremmale', 'cs_mrk', 'cs_nervousron', 'cs_nigel', 'cs_old_man1a', 'cs_old_man2', 'cs_omega', 'cs_orleans', 'cs_paper', 'cs_priest', 'cs_prolsec_02', 'cs_russiandrunk', 'cs_siemonyetarian', 'cs_solomon', 'cs_stevehains', 'cs_stretch', 'cs_taocheng', 'cs_taostranslator', 'cs_tenniscoach', 'cs_terry', 'cs_tom', 'cs_tomepsilon', 'cs_wade', 'cs_zimbor', 'g_m_m_armboss_01','g_m_m_armgoon_01','g_m_m_armlieut_01','g_m_m_chemwork_01','g_m_m_chiboss_01','g_m_m_chicold_01','g_m_m_chigoon_01','g_m_m_chigoon_02','g_m_m_korboss_01','g_m_m_mexboss_01','g_m_m_mexboss_02','g_m_y_armgoon_02','g_m_y_azteca_01','g_m_y_ballaeast_01','g_m_y_ballaorig_01','g_m_y_ballasout_01','g_m_y_famca_01','g_m_y_famdnf_01','g_m_y_famfor_01','g_m_y_korean_01','g_m_y_korean_02','g_m_y_korlieut_01','g_m_y_lost_01','g_m_y_lost_02','g_m_y_lost_03','g_m_y_mexgang_01','g_m_y_mexgoon_01','g_m_y_mexgoon_02','g_m_y_mexgoon_03','g_m_y_pologoon_01','g_m_y_pologoon_02','g_m_y_salvaboss_01','g_m_y_salvagoon_01','g_m_y_salvagoon_02','g_m_y_salvagoon_03','g_m_y_strpunk_01','g_m_y_strpunk_02','hc_driver', 'hc_gunman', 'hc_hacker', 's_m_m_ammucountry','s_m_m_autoshop_01','s_m_m_autoshop_02','s_m_m_bouncer_01','s_m_m_ciasec_01','s_m_m_cntrybar_01','s_m_m_dockwork_01','s_m_m_doctor_01','s_m_m_fiboffice_02','s_m_m_gaffer_01','s_m_m_gardener_01','s_m_m_gentransport','s_m_m_hairdress_01','s_m_m_highsec_01','s_m_m_highsec_02','s_m_m_janitor','s_m_m_lathandy_01','s_m_m_lifeinvad_01','s_m_m_linecook','s_m_m_lsmetro_01','s_m_m_mariachi_01','s_m_m_migrant_01','s_m_m_movprem_01','s_m_m_movspace_01','s_m_m_pilot_01','s_m_m_pilot_02','s_m_m_postal_01','s_m_m_postal_02','s_m_m_scientist_01','s_m_m_strperf_01','s_m_m_strpreach_01','s_m_m_strvend_01','s_m_m_trucker_01','s_m_m_ups_01','s_m_m_ups_02','s_m_o_busker_01','s_m_y_airworker','s_m_y_ammucity_01','s_m_y_armymech_01','s_m_y_autopsy_01','s_m_y_barman_01','s_m_y_baywatch_01','s_m_y_busboy_01','s_m_y_chef_01','s_m_y_clown_01','s_m_y_construct_01','s_m_y_construct_02','s_m_y_dealer_01','s_m_y_devinsec_01','s_m_y_dockwork_01','s_m_y_dwservice_01','s_m_y_dwservice_02','s_m_y_factory_01','s_m_y_garbage','s_m_y_grip_01','s_m_y_mime','s_m_y_pestcont_01','s_m_y_pilot_01','s_m_y_prismuscl_01','s_m_y_prisoner_01','s_m_y_robber_01','s_m_y_shop_mask','s_m_y_strvend_01','s_m_y_uscg_01','s_m_y_valet_01','s_m_y_waiter_01','s_m_y_winclean_01','s_m_y_xmech_01','s_m_y_xmech_02','u_m_m_aldinapoli','u_m_m_bankman','u_m_m_bikehire_01','u_m_m_fibarchitect','u_m_m_filmdirector','u_m_m_glenstank_01','u_m_m_griff_01','u_m_m_jesus_01','u_m_m_jewelsec_01','u_m_m_jewelthief','u_m_m_markfost','u_m_m_partytarget','u_m_m_promourn_01','u_m_m_rivalpap','u_m_m_spyactor','u_m_m_willyfist','u_m_o_finguru_01','u_m_o_taphillbilly','u_m_o_tramp_01','u_m_y_abner','u_m_y_antonb','u_m_y_babyd','u_m_y_baygor','u_m_y_burgerdrug_01','u_m_y_chip','u_m_y_cyclist_01','u_m_y_fibmugger_01','u_m_y_guido_01','u_m_y_gunvend_01','u_m_y_hippie_01','u_m_y_imporage','u_m_y_justin','u_m_y_mani','u_m_y_militarybum','u_m_y_paparazzi','u_m_y_party_01','u_m_y_pogo_01','u_m_y_prisoner_01','u_m_y_proldriver_01','u_m_y_rsranger_01','u_m_y_sbike','u_m_y_staggrm_01','u_m_y_tattoo_01'}
female_models = {'none','a_f_m_beach_01','a_f_m_bevhills_01','a_f_m_bevhills_02','a_f_m_bodybuild_01','a_f_m_business_02','a_f_m_downtown_01','a_f_m_eastsa_01','a_f_m_eastsa_02','a_f_m_fatbla_01','a_f_m_fatcult_01','a_f_m_fatwhite_01','a_f_m_ktown_01','a_f_m_ktown_02','a_f_m_prolhost_01','a_f_m_salton_01','a_f_m_skidrow_01','a_f_m_soucentmc_01','a_f_m_soucent_01','a_f_m_soucent_02','a_f_m_tourist_01','a_f_m_trampbeac_01','a_f_m_tramp_01','a_f_o_genstreet_01','a_f_o_indian_01','a_f_o_ktown_01','a_f_o_salton_01','a_f_o_soucent_01','a_f_o_soucent_02','a_f_y_beach_01','a_f_y_bevhills_01','a_f_y_bevhills_02','a_f_y_bevhills_03','a_f_y_bevhills_04','a_f_y_business_01','a_f_y_business_02','a_f_y_business_03','a_f_y_business_04','a_f_y_eastsa_01','a_f_y_eastsa_02','a_f_y_eastsa_03','a_f_y_epsilon_01','a_f_y_fitness_01','a_f_y_fitness_02','a_f_y_genhot_01','a_f_y_golfer_01','a_f_y_hiker_01','a_f_y_hippie_01','a_f_y_hipster_01','a_f_y_hipster_02','a_f_y_hipster_03','a_f_y_hipster_04','a_f_y_indian_01','a_f_y_juggalo_01','a_f_y_runner_01','a_f_y_rurmeth_01','a_f_y_scdressy_01','a_f_y_skater_01','a_f_y_soucent_01','a_f_y_soucent_02','a_f_y_soucent_03','a_f_y_tennis_01','a_f_y_topless_01','a_f_y_tourist_01','a_f_y_tourist_02','a_f_y_vinewood_01','a_f_y_vinewood_02','a_f_y_vinewood_03','a_f_y_vinewood_04','a_f_y_yoga_01','cs_tracydisanto','cs_tanisha', 'cs_patricia', 'cs_mrsphillips', 'cs_mrs_thornhill', 'cs_natalia', 'cs_molly', 'cs_movpremf_01', 'cs_maryann', 'cs_michelle', 'cs_marnie', 'cs_magenta', 'cs_janet', 'cs_jewelass', 'cs_guadalope', 'cs_gurk',  'cs_debra', 'cs_denise', 'cs_amandatownley',  'cs_ashley', 'csb_screen_writer', 'csb_stripper_01', 'csb_stripper_02', 'csb_tonya', 'csb_maude', 'csb_denise_friend', 'csb_abigail', 'csb_anita', 'g_f_y_ballas_01','g_f_y_families_01','g_f_y_lost_01','g_f_y_vagos_01','s_f_m_fembarber','s_f_m_maid_01','s_f_m_shop_high','s_f_m_sweatshop_01','s_f_y_airhostess_01','s_f_y_bartender_01','s_f_y_baywatch_01','s_f_y_factory_01','s_f_y_hooker_01','s_f_y_hooker_02','s_f_y_hooker_03','s_f_y_migrant_01','s_f_y_movprem_01','s_f_y_shop_low','s_f_y_shop_mid','s_f_y_stripperlite','s_f_y_stripper_01','s_f_y_stripper_02','s_f_y_sweatshop_01','u_f_m_corpse_01','u_f_m_miranda','u_f_m_promourn_01','u_f_o_moviestar','u_f_o_prolhost_01','u_f_y_bikerchic','u_f_y_comjane','u_f_y_hotposh_01','u_f_y_jewelass_01','u_f_y_mistress','u_f_y_poppymich','u_f_y_princess','u_f_y_spyactress'}
animal_models = {'none'}--{'none','a_c_chickenhawk','a_c_chimp','a_c_cormorant','a_c_cow','a_c_coyote','a_c_crow','a_c_hen','a_c_deer','a_c_fish','a_c_seagull','a_c_pig','a_c_pigeon','a_c_rat'}
ems_models = {'none','csb_mweather','csb_prolsec','csb_ramp_marine','cs_casey','cs_fbisuit_01','ig_andreas','s_f_y_ranger_01','s_f_y_scrubs_01','s_f_y_sheriff_01','s_m_m_armoured_01','s_m_m_armoured_02','s_m_m_chemsec_01','s_m_m_fiboffice_01','s_m_m_marine_01','s_m_m_marine_02','s_m_m_paramedic_01','s_m_m_prisguard_01','s_m_m_security_01','s_m_m_snowcop_01','s_m_y_blackops_01','s_m_y_blackops_02','s_m_y_doorman_01','s_m_y_fireman_01','s_m_y_hwaycop_01','s_m_y_marine_01','s_m_y_marine_02','s_m_y_marine_03','s_m_y_ranger_01','s_m_y_sheriff_01','s_m_y_swat_01'}
mp_models = {'none','mp_f_deadhooker','mp_f_misty_01','mp_f_stripperlite','mp_g_m_pros_01','mp_m_claude_01','mp_m_exarmy_01','mp_m_famdd_01','mp_m_fibsec_01','mp_m_marston_01','mp_m_niko_01','mp_m_shopkeep_01','mp_s_m_armoured_01'}
freemode_models = {'none','mp_m_freemode_01','mp_f_freemode_01'}

Config.table = {freemode_models, male_models, female_models, animal_models, mp_models}

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