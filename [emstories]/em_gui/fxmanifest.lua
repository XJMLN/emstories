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
	"ui/sounds/notification.ogg",
}
ui_page "ui/index.html"

client_script 'playernames_c.lua'
client_script 'notifications_system_c.lua'
client_script 'version_c.lua'