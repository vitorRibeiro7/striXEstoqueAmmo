-----------------------------------------------------------------------------------------------------------------------------------------
-- PENDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
src = {}
Tunnel.bindInterface("striXestoqueAmmo", src)
vCLIENT = Tunnel.getInterface("striXestoqueAmmo")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
function VerificarMembro()
	local source = source
	local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id, "lideryardie.permissao") then
        return "Yardie"
    elseif vRP.hasPermission(user_id, "liderrusskaya.permissao") then
        return "Russkaya"
    end
end

function checkEstoque(fac, quantidade, tipo)
    local source = source
    local user_id = vRP.getUserId(source)

    local saldo = vRP.getSData("strix:EstoqueMuni"..fac..""..tipo)
    local saldoFac = json.decode(saldo) or 0

    if saldoFac < quantidade then
        return false
    else
        return true
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADIÇÃO ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.addEstoque(markName, hooklink)
    local source = source
	local user_id = vRP.getUserId(source)
    
    local numSaldo = 0
    local saldoReal = 0

    local fac

    if VerificarMembro() then
        fac = VerificarMembro()
    else
        TriggerClientEvent('Notify', source, 'aviso', 'Você não tem permissão.')
        return false
    end

    if not vRP.hasPermission(user_id, "muni.menu") then
        TriggerClientEvent('Notify', source, 'aviso', 'Você não tem permissão')
        return false
    end

    if  fac ~= markName then
        TriggerClientEvent('Notify', source, 'aviso', 'Você não é desta facção.')
        return false
    end
    
    local tipo = vRP.prompt(source, "Que tipo de munição deseja adicionar? (five, tec, mp5, g36 ou ak)", "")

    if tipo == "five" then
        tipo = "Five"
        municao = "wammo_WEAPON_PISTOL_MK2"
    elseif tipo == "tec" then
        tipo = "Tec"
        municao = "wammo_WEAPON_MACHINEPISTOL"
    elseif tipo == "mp5" then
        tipo = "Mp5"
        municao = "wammo_WEAPON_SMG_MK2"
    elseif tipo == "g36" then
        tipo = "G36"
        municao = "wammo_WEAPON_SPECIALCARBINE_MK2"
    elseif tipo == "ak" then
        tipo = "AK"
        municao = "wammo_WEAPON_ASSAULTRIFLE_MK2"
    else
        TriggerClientEvent("Notify", source, "Aviso", "Modelo não encontrado.")
        return false
    end

    local quantidade = tonumber(vRP.prompt(source, "Quantas unidades de munições de "..tipo.."?", ""))

    if quantidade < 0 then 
        TriggerClientEvent("Notify", source, "aviso", "Numeros negativos não são aceitos.")
        return false
    end
    
    if quantidade == nil then
        TriggerClientEvent("Notify", source, "aviso", "Aceitamos apenas numeros...")    -- AAAAAAAAAAAAAAAAAA
        return false
    else

        local value = vRP.getSData("strix:EstoqueMuni"..fac..""..tipo)
        local saldofac = json.decode(value) or 0

        saldoReal = saldofac + quantidade
        
        if vRP.tryGetInventoryItem(user_id, municao, quantidade) then
            vRP.setSData("strix:EstoqueMuni"..fac..""..tipo, saldofac + quantidade)
            TriggerClientEvent("Notify", source, "aviso", "Estoque de Munição de "..tipo.." atual >>> " .. saldoReal)
            local identity = vRP.getUserIdentity(user_id)
		    SendWebhookMessage(hooklink,"```prolog\n[COLOCOU NO ESTOQUE]: "..vRP.format(parseInt(quantidade)).." munições de "..tipo.."\n[ID]: "..user_id.." "..string.upper(identity.name).." "..string.upper(identity.firstname)..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
        else
            TriggerClientEvent("Notify", source, "aviso", "Você não tem "..quantidade.." munições de "..tipo);
            return false
        end
    end

end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETIRADA DE ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
function retirarQTD(faccao, quantidade, arma)

    local value = vRP.getSData("strix:EstoqueMuni"..faccao..""..arma)
    local saldofac = json.decode(value) or 0

    if quantidade > saldofac then
        TriggerClientEvent("Notify", source, "aviso", "Esta facção não tem "..quantidade.." munições de "..arma.." em estoque!")
        return false
    else
        vRP.setSData("strix:EstoqueMuni" ..faccao.. "" ..arma, saldofac - quantidade)
        return true
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VENDA DE MUNIÇÃO
-----------------------------------------------------------------------------------------------------------------------------------------
local delayVMochila = {}

function src.buyMuni(faccao, hooklink)
    local source = source
    local user_id = vRP.getUserId(source)

    local precoDaMuni = 0
    local municao = ""
    local qtd 
    local whatType

    TriggerClientEvent(
        "Notify",
        source,
        "aviso",
        "Cada pack de munições custam: <br> FiveSeven = $125K <br> Tec-9 = $265K <br> Mp5 = $346K <br> G36 = $468K <br> AK-47 = $532K"
    )

    
    whatType = vRP.prompt(source, "Qual tipo de munição deseja comprar? (five, tec, mp5, g36 ou ak)", "")

    if whatType == "five" then
        precoDaMuni = 500
        whatType = "Five"
        municao = "wammo_WEAPON_PISTOL_MK2"
    elseif whatType == "tec" then
        precoDaMuni = 1060
        whatType = "Tec"
        municao = "wammo_WEAPON_MACHINEPISTOL"
    elseif whatType == "mp5" then
        precoDaMuni = 1384
        whatType = "Mp5"
        municao = "wammo_WEAPON_SMG_MK2"
    elseif whatType == "g36" then
        precoDaMuni = 1872
        whatType = "G36"
        municao = "wammo_WEAPON_SPECIALCARBINE_MK2"
    elseif whatType == "ak" then
        precoDaMuni = 2128
        whatType = "AK"
        municao = "wammo_WEAPON_ASSAULTRIFLE_MK2"
    else

        TriggerClientEvent("Notify", source,"Aviso", "Modelo não encontrado.")

        return false
    end

    qtd = tonumber(vRP.prompt(source, "Quantas unidades de munição de "..whatType.."?", ""))


    if qtd == nil then
        TriggerClientEvent( "Notify", source, "aviso", "Aceitamos apenas numeros...")

        return false
    else
        if not delayVMochila[user_id] or os.time() > (delayVMochila[user_id] + 1) then
            delayVMochila[user_id] = os.time()
            if user_id then
                if checkEstoque(faccao, qtd, whatType)  then
                    if vRP.getInventoryWeight(user_id)+(vRP.getItemWeight(municao)*qtd) <= vRP.getInventoryMaxWeight(user_id) then
                        local pagamento = qtd * precoDaMuni
                        TriggerClientEvent("cancelando", source, true)
                        if vRP.tryFullPayment(user_id, qtd * precoDaMuni) then
                            if retirarQTD(faccao, qtd, whatType) then
                                paymentFac(faccao, pagamento)
                                vRP.giveInventoryItem(user_id, municao, qtd)
                                local identity = vRP.getUserIdentity(user_id)
                                SendWebhookMessage(hooklink,"```prolog\n[COMPROU]: "..vRP.format(parseInt(qtd)).." munições de "..whatType.."\n[ID]: "..user_id.." "..string.upper(identity.name).." "..string.upper(identity.firstname).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
                            end
                        else
                            TriggerClientEvent("Notify", source, "aviso", "Você não tem dinheiro suficiente.")
                        end
                    else
                        TriggerClientEvent("Notify", source, "aviso", "Você não tem espaço na mochila.")
                    end
                else
                    TriggerClientEvent("Notify", source, 'aviso', 'Não temos essa munição no momento!')
                end
            end
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function paymentFac(QualFac, qtd)
    local source = source
    local user_id = vRP.getUserId(source)
    local value = vRP.getSData("strix:Salario" .. QualFac)
    local resultado = json.decode(value) or 0

    vRP.setSData("strix:salario"..QualFac, resultado + qtd)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SACAR
-----------------------------------------------------------------------------------------------------------------------------------------
function src.sacarDinDin(hooklink)
    local source = source
    local user_id = vRP.getUserId(source)

    local fac

    if VerificarMembro() then
        fac = VerificarMembro()
    else
        TriggerClientEvent('Notify', source, 'aviso', 'Você não tem permissão.')
    end

    local value = vRP.getSData("strix:Salario" ..fac)
    local resultado = json.decode(value) or 0
    local saldoantes = resultado
    TriggerClientEvent("Notify", source, "aviso", "Saldo De Vendas: $" .. vRP.format(parseInt(resultado)))
    local qtd = vRP.prompt(source, "Digite o valor  que deseja Sacar:", "")
    qtd = tonumber(qtd)

    if qtd == nil then return false end

    if string.sub(tonumber(qtd), 1, 1) == "-" then
        TriggerClientEvent("Notify", source, "aviso", "Quantia inválida (valor negativo).")
        return
    end
    if resultado >= qtd then
        resultado = saldoantes - qtd
        vRP.setSData("strix:Salario" .. fac, resultado)
        vRP.giveMoney(user_id, qtd)
        TriggerClientEvent("Notify", source, "aviso", "Você Sacou: $" .. vRP.format(parseInt(qtd)))
        local identity = vRP.getUserIdentity(user_id)
        SendWebhookMessage(hooklink,"```prolog\n[SACOU]: $"..vRP.format(parseInt(qtd)).."\n[ID]: "..user_id.." "..string.upper(identity.name).." "..string.upper(identity.firstname).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    else
        TriggerClientEvent("Notify", source, "aviso", "Quantia inválida.")
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
function SendWebhookMessage(webhook,message)
    if webhook ~= nil and webhook ~= "" then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VER ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand(
    "estoquemuni",
    function(source, args, rawCommand)
        
        local source = source
        local user_id = vRP.getUserId(source)
        
        if args[1] then
            local facName
            local fac = args[1]

            if fac == "russkaya" then
                facName = "Russkaya"
            elseif fac == "yardie" then
                facName = "Yardie"
            else
                TriggerClientEvent('Notify', source, 'aviso', 'Facção não encontrada.')
            end
    
            local muniFive = vRP.getSData("strix:EstoqueMuni"..fac.."Five")
            muniFive = json.decode(muniFive) or 0
            local muniTec = vRP.getSData("strix:EstoqueMuni"..fac.."Tec")
            muniTec = json.decode(muniTec) or 0
            local muniMp5 = vRP.getSData("strix:EstoqueMuni"..fac.."Mp5")
            muniMp5 = json.decode(muniMp5) or 0
            local muniG36 = vRP.getSData("strix:EstoqueMuni"..fac.."G36")
            muniG36 = json.decode(muniG36) or 0
            local muniAK = vRP.getSData("strix:EstoqueMuni"..fac.."AK")
            muniAK = json.decode(muniAK) or 0
    
            TriggerClientEvent(
                "Notify",
                source,
                "aviso",
                "Estoque da "..facName..":<br>Munição de Five: "..muniFive.."<br> Munição de Tec: "..muniTec.."<br> Munição de Mp5: "..muniMp5.."<br> Munição de G36: "..muniG36.."<br> Munição de AK: "..muniAK.."")
        else
            TriggerClientEvent('Notify', source, 'aviso', 'Você precisa especificar uma facção.')
        end

    end
)