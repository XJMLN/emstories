fx_version 'cerulean'
game 'gta5'

client_scripts {
    'callouts/pd/reverse_c.lua',
    'callouts/pd/bicycle_c.lua',
    'callouts/pd/fight_c.lua',
    'callouts/pd/shootout_c.lua',
    'callouts/pd/escort_c.lua',
    'fireManager/fires_c.lua',
    'callouts/fd/fires_c.lua',
    'callouts/fd/accidents_c.lua',
    'callouts/mc/accidents_c.lua',
    'callouts/mc/transport_c.lua',
    'callouts/mc/train_c.lua',
    'callouts/mc/sick_transport_c.lua',
    'callouts_c.lua'
}
server_scripts {
    'fireManager/fires.lua'
}
shared_script 'callouts_config.lua'
server_script 'callouts.lua'