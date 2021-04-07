fx_version 'cerulean'
game 'gta5'

shared_script 'fireMission_config.lua'
shared_script 'accidents/accidents_config.lua'
server_scripts {
    'accidents/accidents.lua',
    'fire/fires.lua',
    'fire/firesMission.lua'
}
client_scripts {
    'accidents/accidents_c.lua',
    'fire/fires_c.lua',
    'fire/firesMission_c.lua'
}