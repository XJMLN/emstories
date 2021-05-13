fx_version 'cerulean'
games { 'gta5' }

files {
    "config/jails.json",
}
shared_script 'config.lua'
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
    'ai_c.lua',
    'pullover_gui_c.lua',
    'ai_pedData_c.lua',
}
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'ai.lua'
}