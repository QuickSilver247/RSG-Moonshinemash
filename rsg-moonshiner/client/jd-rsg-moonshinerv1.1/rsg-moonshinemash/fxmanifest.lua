fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

author 'JD McCandles#9139'
description 'rsg-moonshinemash'

shared_scripts {
    '@rsg-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua',
}

client_script {
    'client/client.lua',
}

server_script {
    'server/server.lua',
    '@oxmysql/lib/MySQL.lua',
}

dependencies {
    'rsg-core',
    'rsg-menu',
    'rsg-input',
    'map-moonshineshacks'
}

lua54 'yes'