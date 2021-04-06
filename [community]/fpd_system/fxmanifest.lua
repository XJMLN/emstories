fx_version 'cerulean'
games { 'gta5' }

files {
    "config/questions.json",
    "config/jails.json",
}
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

client_scripts {
    'system_c.lua',
    'system_gui_c.lua',
}
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'system.lua'
}