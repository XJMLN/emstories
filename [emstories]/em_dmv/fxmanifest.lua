fx_version 'cerulean'
games { 'gta5' }

files {
	"ui/index.html",
	"ui/lib/axios.min.js",
	"ui/lib/vue.min.js",
	"ui/lib/vuetify.css",
	"ui/lib/vuetify.js",
    "ui/script.js",
	"ui/style.css",
	"ui/images/*"
}
ui_page "ui/index.html"

shared_script 'config.lua'
client_script 'dmv_c.lua'
server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'dmv.lua',
}
