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

    if vRP.hasPermission(user_id, "yardie.permissao") then
        return "Yardie"
    elseif vRP.hasPermission(user_id, "russkaya.permissao") then
        return "Russkaya"
    end
end

function checkEstoque(fac, quantidade, tipo)
    local source = source
    local user_id = vRP.getUserId(source)

    local saldo = vRP.getSData("strix:EstoqueMuni"..fac..""..tipo)
    local saldoFac = json.decode(saldo) or 0
    print(type(saldoFac))

    if saldoFac < quantidade then
        return false
    else
        return true
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADIÇÃO ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.addEstoque()
    local source = source
    local user_id = vRP.getUserId(source)

    local numSaldo = 0
    local saldoReal = 0

    local fac = VerificarMembro()

    if not vRP.hasPermission(user_id, "armamuni.menu") then
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
        municao = "wammo_WEAPON_SMG"
    elseif tipo == "g36" then
        tipo = "G36"
        municao = "wammo_WEAPON_SPECIALCARBINE_MK2"
    elseif tipo == "ak" then
        tipo = "AK"
        municao = "wammo_WEAPON_ASSAULTRIFLE_MK2"
    else
        return false
        TriggerClientEvent("Notify", source,"Aviso", "Modelo não encontrado.")
    end

    local quantidade = tonumber(vRP.prompt(source, "Quantas unidades de munições de "..tipo.."?", ""))
    
    if quantidade == nil then
            TriggerClientEvent("Notify", source, "aviso", "Aceitamos apenas numeros...")   
            return false
        else

            local value = vRP.getSData("strix:EstoqueMuni"..fac..""..tipo)
            local saldofac = json.decode(value) or 0

            saldoReal = saldofac + quantidade
            
            if vRP.tryGetInventoryItem(user_id, municao, quantidade) then
                vRP.setSData("strix:EstoqueMuni"..fac..""..tipo, saldofac + quantidade)
                TriggerClientEvent("Notify", source, "aviso", "Estoque de Munição de "..tipo.." atual >>> " .. saldoReal)
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

function src.buyMuni(faccao)
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
        municao = "wammo_WEAPON_SMG"
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

    qtd = tonumber(vRP.prompt(source, "Quantas unidades de munição de "..tipo.."?", ""))


    if qtd == nil then
        TriggerClientEvent( "Notify", source, "aviso", "Aceitamos apenas numeros...")

        return false
    else
        if not delayVMochila[user_id] or os.time() > (delayVMochila[user_id] + 1) then
            delayVMochila[user_id] = os.time()
            if user_id then
                if vRP.tryFullPayment(user_id, qtd * precoDaMuni) then
                    if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(municao) <= vRP.getInventoryMaxWeight(user_id) then
                        local pagamento = qtd * precoDaMuni
                        TriggerClientEvent("cancelando", source, true)
                        if checkEstoque(faccao, qtd, whatType) then
                            if retirarQTD(faccao, qtd, whatType) then
                                paymentFac(faccao, pagamento)
                                vRP.giveInventoryItem(user_id, municao, qtd)
                            end
                        else
                            TriggerClientEvent("Notify", source, 'aviso', 'Não temos essa munição no momento!')
                        end
                    else
                        TriggerClientEvent("Notify", source, "aviso", "Você não tem espaço na mochila.")
                    end
                else
                    TriggerClientEvent("Notify", source, "aviso", "Você não tem dinheiro suficiente.")
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
function src.sacarDinDin()
    local source = source
    local user_id = vRP.getUserId(source)

    local fac = VerificarMembro()

    local value = vRP.getSData("strix:Salario" ..fac)
    local resultado = json.decode(value) or 0
    local saldoantes = resultado
    TriggerClientEvent("Notify", source, "aviso", "Saldo De Vendas: $" .. vRP.format(parseInt(resultado)))
    local qtd = vRP.prompt(source, "Digite o valor  que deseja Sacar:", "")
    qtd = tonumber(qtd)
    if string.sub(tonumber(qtd), 1, 1) == "-" then
        TriggerClientEvent("Notify", source, "aviso", "Quantia inválida (valor negativo).")
        return
    end
    if resultado >= qtd then
        resultado = saldoantes - qtd
        vRP.setSData("strix:Salario" .. fac, resultado)
        vRP.giveMoney(user_id, qtd)
        TriggerClientEvent("Notify", source, "aviso", "Você Sacou: $" .. vRP.format(parseInt(qtd)))
    else
        TriggerClientEvent("Notify", source, "aviso", "Quantia inválida.")
    end
end