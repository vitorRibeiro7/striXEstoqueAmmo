client_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

author 'Vitor Ribeiro'
description 'Faction NPC Saller FiveM / vRP Framework'
repository 'https://github.com/vitorRibeiro7/striXEstoqueAmmo'
fx_version "bodacious"
game "gta5"

client_scripts {
	"@vrp/lib/utils.lua",
	"client-side/client.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server-side/server.lua"
}              