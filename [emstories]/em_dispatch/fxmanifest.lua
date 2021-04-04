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
	"ui/sounds/code3.ogg",
	"ui/sounds/respond1.ogg",
	"ui/sounds/respond2.ogg",
	"ui/sounds/respond3.ogg",
	"ui/sounds/respond4.ogg",
}
ui_page "ui/index.html"


server_script "dispatch.lua"
client_script "dispatch_gui_c.lua"