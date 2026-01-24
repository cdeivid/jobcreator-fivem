fx_version 'cerulean'
game 'gta5'

author 'Jobcreator FiveM'
description 'Advanced Job Creator for FiveM - Compatible with ESX and QBCore'
version '1.0.0'

shared_scripts {
    'config.lua',
    'locales/locale.lua',
    'locales/*.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/framework.lua',
    'server/database.lua',
    'server/jobs.lua',
    'server/grades.lua',
    'server/markers.lua',
    'server/actions.lua',
    'server/nexus.lua',
    'server/statistics.lua',
    'server/main.lua'
}

client_scripts {
    'client/framework.lua',
    'client/utils.lua',
    'client/markers.lua',
    'client/actions.lua',
    'client/ui.lua',
    'client/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    'mysql-async'
}
