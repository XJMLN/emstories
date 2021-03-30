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
shared_script 'duty_config_c.lua'
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'duty.lua',
}
client_scripts {
    '@skinchanger/locale.lua',
    'duty_gui_c.lua',
    'duty_c.lua',
}
