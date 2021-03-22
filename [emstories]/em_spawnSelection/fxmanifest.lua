fx_version 'cerulean'
game 'gta5'
resource_type 'gametype' { name = 'EmergencyStories' }
files {
	"ui/index.html",
	"ui/lib/axios.min.js",
	"ui/lib/vue.min.js",
	"ui/lib/vuetify.css",
	"ui/lib/vuetify.js",
    "ui/script.js",
	"ui/style.css",
	'ui/images/fd.png',
	'ui/images/md.png',
	'ui/images/pd.png',
}
ui_page "ui/index.html"

client_script 'spawnSelection_c.lua'