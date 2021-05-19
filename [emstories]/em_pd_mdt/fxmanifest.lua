fx_version 'cerulean'
game 'gta5'
files {
    'ui/index.html',
    'ui/js/app.js',
    'ui/js/chunk-vendors.js',
    'ui/css/app.css',
    'ui/css/chunk-vendors.css',
    'ui/img/department-5.png'
}

ui_page 'ui/index.html'

client_script 'mdt_c.lua'
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'mdt.lua'
}