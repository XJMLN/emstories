fx_version 'cerulean'
game 'gta5'

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
server_script '@mysql-async/lib/MySQL.lua'
shared_script 'armory_config.lua'
server_script 'armory.lua'
client_script 'armory_c.lua'