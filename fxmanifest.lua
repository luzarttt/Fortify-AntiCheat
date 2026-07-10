fx_version 'cerulean'
game 'gta5'

name 'Fortify Anti-Cheat'
description 'Advanced Anti-Cheat System for FiveM'
author 'Fortify'
version '2.0.0'

shared_scripts {
    'shared/utils.lua',
    'config.lua'
}

server_scripts {
    'server/discord.lua',
    'server/ban.lua',
    'server/main.lua'
}

client_scripts {
    'client/detections.lua',
    'client/spectate.lua',
    'client/main.lua'
}

lua54 'yes'
