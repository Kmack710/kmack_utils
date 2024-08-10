
fx_version "cerulean"
use_experimental_fxv2_oal 'yes'
game 'gta5'
lua54 'yes'
version '1.0.0'

files {
	'config.lua',
    'locales.lua',
    'modules/**/*.lua',
}

shared_scripts {
 	"@ox_lib/init.lua",
}

client_scripts {
	'data/client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
	'data/server/main.lua',
}

dependancies {
    'ox_lib',
    'kmack_bridge'
}