fx_version 'cerulean'
games { 'gta5' }

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
}
shared_script 'ai_scripts/ai_config.lua'
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'dutyGUI.lua',
}
client_scripts {
    '@skinchanger/locale.lua',
    'ai_scripts/ai_client.lua',
    'dutyGUI_gui_c.lua',
    'dutyGUI_c.lua',
}
