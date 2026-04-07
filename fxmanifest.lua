fx_version 'cerulean'
game 'gta5'

author 'CaliLifeRP'
description 'Marked Bills Exchange System for QBCore'

shared_script 'config.lua'

client_scripts {
    'client.lua',
    'npc_spawner.lua',
    'utils.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
    'utils.lua',
}

dependencies {
    'qb-core',
    'qb-target',
}