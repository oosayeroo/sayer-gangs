fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'oosayeroo' 
description 'sayer-gangs'
version '1.0'

shared_scripts {
	'@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
	'client/main.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
}
