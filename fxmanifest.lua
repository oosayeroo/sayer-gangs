fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'oosayeroo' 
description 'sayer-gangs'
version '1.1'

shared_scripts {
	'@ox_lib/init.lua',
    'shared/config.lua',
	'shared/gangs.lua',
	'shared/business.lua',
}

client_scripts {
	'client/main.lua',
	'client/utils.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/utils.lua',
	'server/gangs.lua',
	'server/zones.lua',
	'server/main.lua',
}
