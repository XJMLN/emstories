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
}

server_script 'scoreboard.lua'
client_script 'scoreboard_c.lua'

ui_page 'ui/index.html'