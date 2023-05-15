fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'

version '1.0.0'
author 'Razzway & Alcao'

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua",

    "client/*.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "configs/sv_*.lua",
    "server/*.lua"
}

shared_scripts {
    'configs/cl_*.lua'
}