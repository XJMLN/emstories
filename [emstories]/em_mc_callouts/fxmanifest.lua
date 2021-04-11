fx_version 'cerulean'
game 'gta5'

shared_script 'global_config.lua'
shared_script 'ped/ped_callouts_config.lua'
server_scripts {
    'mission.lua',
    'ped/ped_callouts.lua'
}
client_scripts {
    'mission_c.lua',
    'ped/ped_callouts_c.lua'
}