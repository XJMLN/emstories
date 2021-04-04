fx_version 'cerulean'
games { 'gta5' }

ui_page "ui/index.html"
files {
    "ui/cone.png",
    "ui/barrier.png",
    "ui/ammo.png",
	"ui/index.html",
	"ui/lib/axios.min.js",
	"ui/lib/vue.min.js",
	"ui/lib/vuetify.css",
    "ui/lib/raphael.min.js",
    "ui/lib/wheelnav.min.js",
	"ui/lib/vuetify.js",
    "ui/script.js",
	"ui/style.css"
}

client_script 'veh_inv_c.lua'

export 'vehicleInventory_deleteAllObjects'