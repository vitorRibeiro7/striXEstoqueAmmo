local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
--------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("striXestoqueAmmo", src)
vSERVER = Tunnel.getInterface("striXestoqueAmmo")

-- coordenadax,y,z,'facção','webhooks'

local marcacoesVenda = {
	{-1467.88,864.23,183.64,'Yardie','https://discord.com/api/webhooks/'},  -- YARDIE
	{1077.92,-1955.27,31.04,'Russkaya','https://discord.com/api/webhooks/'}  -- RUSSKAYA
}

local Estoque = {
	{-1488.97,842.39,177.0,'Yardie','https://discord.com/api/webhooks/'},  -- YARDIE
	{1077.61,-1972.7,31.48,'Russkaya','https://discord.com/api/webhooks/'}  -- RUSSKAYA
}
local Banquinhos = {
	{-1503.23,838.81,181.6,'Yardie','https://discord.com/api/webhooks/'},  -- YARDIE
	{1042.33,-1970.41,34.97,'Russkaya','https://discord.com/api/webhooks/'}  -- RUSSKAYA
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- COMPRA DE MUNIÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for _,mark in pairs(marcacoesVenda) do
			local x,y,z,text,hook = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			local ped = PlayerPedId()
			if distance <= 2.0 then	
				DrawText3D(x,y,z+0.1,"~r~E~w~   COMPRAR")
				if IsControlJustPressed(0,38) then
					vSERVER.buyMuni(text, hook)
					TriggerEvent('cancelando', true)
					Wait(1000)
					TriggerEvent('cancelando', false)
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
	while true do
		Citizen.Wait(1)
		for _,mark in pairs(Estoque) do
			local x,y,z,text,hook = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			local ped = PlayerPedId()
			if distance <= 2.0  then 	
				DrawText3D(x,y,z+0.1,"~r~E~w~   ADICIONAR ESTOQUE")
				if IsControlJustPressed(0,38) then
					if vSERVER.addEstoque(text, hook) then
						TriggerEvent('cancelando', true)
						vRP.playAnim(false,{{"mp_common","givetake1_a"}},false)
						Wait(1000)
						TriggerEvent('cancelando', false)
					end
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- SACAR DIN DIN
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand('saque', function(source,args)
--     local user_id = vRP.getUserId(source)
--     for _,mark in pairs(Banquinhos) do
-- 		local x,y,z,text,hook = table.unpack(mark)
--         local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
-- 		if distance <= 2.0  then 	
-- 			DrawText3D(x,y,z+0.1,"~r~E~w~   SACAR")
-- 			if IsControlJustPressed(0,38) then
-- 				vSERVER.sacarDinDin(hook)
-- 			end
-- 		end
--     end
-- end)

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(1)
		for _,mark in pairs(Banquinhos) do
			local x,y,z,text,hook = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			local ped = PlayerPedId()
			if distance <= 2.0  then 	
				DrawText3D(x,y,z+0.1,"~r~E~w~   SACAR")
				if IsControlJustPressed(0,38) then
					vSERVER.sacarDinDin(hook)
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	SetTextFont(4)
	SetTextCentre(1)
	SetTextEntry("STRING")
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z,0)
	DrawText(0.0,0.0)
	local factor = (string.len(text) / 450) + 0.01
	DrawRect(0.0,0.0125,factor,0.03,40,36,52,240)
	ClearDrawOrigin()
end