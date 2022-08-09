-----------------------------------------------------------------------------------------------------------------------------------------
-- PENDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
src = {}
Tunnel.bindInterface("strixBuyMuni", src)
vCLIENT = Tunnel.getInterface("strixBuyMuni")

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

    if saldoFac < quantidade then
        TriggerClientEvent("Notify", source, "aviso", "Esta facção não tem esta quantidade em estoque.")
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

        local quantidade = tonumber(vRP.prompt(source, "Quantas unidades?", ""))

        if quantidade == nil then

            TriggerClientEvent(
                "Notify",
                source,
                "aviso",
                "Aceitamos apenas numeros..."
            )
    
            return false
        else

            local value = vRP.getSData("strix:EstoqueMuni"..fac.."Five")
            local saldofac = json.decode(value) or 0

            saldoReal = saldofac + quantidade
            
            if vRP.tryGetInventoryItem(user_id, "wammo_WEAPON_PISTOL_MK2", quantidade) then
                vRP.setSData("strix:EstoqueMuni"..fac.."Five", saldofac + quantidade)
                TriggerClientEvent("Notify", source, "aviso", "Estoque de Munição de FiveSeven atual >>> " .. saldoReal)
            else
                TriggerClientEvent("Notify", source, "aviso", "Você não tem "..quantidade.." munições de FiveSeven");
                return false
            end
        end
    elseif tipo == "tec" then

        local quantidade = tonumber(vRP.prompt(source, "Quantas unidades?", ""))

        if quantidade == nil then

            TriggerClientEvent(
                "Notify",
                source,
                "aviso",
                "Aceitamos apenas numeros..."
            )
    
            return false
        else

            local value = vRP.getSData("strix:EstoqueMuni"..fac.."Tec")
            local saldofac = json.decode(value) or 0

            saldoReal = saldofac + quantidade
            
            if vRP.tryGetInventoryItem(user_id, "wammo_WEAPON_MACHINEPISTOL", quantidade) then
                vRP.setSData("strix:EstoqueMuni"..fac.."Tec", saldofac + quantidade)
                TriggerClientEvent("Notify", source, "aviso", "Estoque de Munição de Tec9 atual >>> " .. saldoReal)
            else
                TriggerClientEvent("Notify", source, "aviso", "Você não tem "..quantidade.." munições de Tec-9");
                return false
            end
        end
    elseif tipo == "mp5" then

        local quantidade = tonumber(vRP.prompt(source, "Quantas unidades?", ""))

        if quantidade == nil then

            TriggerClientEvent(
                "Notify",
                source,
                "aviso",
                "Aceitamos apenas numeros..."
            )
    
            return false
        else

            local value = vRP.getSData("strix:EstoqueMuni"..fac.."Mp5")
            local saldofac = json.decode(value) or 0

            saldoReal = saldofac + quantidade
            
            if vRP.tryGetInventoryItem(user_id, "wammo_WEAPON_SMG", quantidade) then
                vRP.setSData("strix:EstoqueMuni"..fac.."Mp5", saldofac + quantidade)
                TriggerClientEvent("Notify", source, "aviso", "Estoque de Munição de Mp5 atual >>> " .. saldoReal)
            else
                TriggerClientEvent("Notify", source, "aviso", "Você não tem "..quantidade.." munições de MP5");
                return false
            end
        end
    elseif tipo == "g36" then

        local quantidade = tonumber(vRP.prompt(source, "Quantas unidades?", ""))

        if quantidade == nil then

            TriggerClientEvent(
                "Notify",
                source,
                "aviso",
                "Aceitamos apenas numeros..."
            )
    
            return false
        else

            local value = vRP.getSData("strix:EstoqueMuni"..fac.."G36")
            local saldofac = json.decode(value) or 0

            saldoReal = saldofac + quantidade
            
            if vRP.tryGetInventoryItem(user_id, "wammo_WEAPON_SPECIALCARBINE_MK2", quantidade) then
                vRP.setSData("strix:EstoqueMuni"..fac.."G36", saldofac + quantidade)
                TriggerClientEvent("Notify", source, "aviso", "Estoque de Munição de G36 atual >>> " .. saldoReal)
            else
                TriggerClientEvent("Notify", source, "aviso", "Você não tem "..quantidade.." munições de G36");
                return false
            end
        end
    elseif tipo == "ak" then

        local quantidade = tonumber(vRP.prompt(source, "Quantas unidades?", ""))

        if quantidade == nil then

            TriggerClientEvent(
                "Notify",
                source,
                "aviso",
                "Aceitamos apenas numeros..."
            )
    
            return false
        else

            local value = vRP.getSData("strix:EstoqueMuni"..fac.."AK")
            local saldofac = json.decode(value) or 0

            saldoReal = saldofac + quantidade
            
            if vRP.tryGetInventoryItem(user_id, "wammo_WEAPON_ASSAULTRIFLE_MK2", quantidade) then
                vRP.setSData("strix:EstoqueMuni"..fac.."AK", saldofac + quantidade)
                TriggerClientEvent("Notify", source, "aviso", "Estoque de Munição de AK-47 atual >>> " .. saldoReal)
            else
                TriggerClientEvent("Notify", source, "aviso", "Você não tem "..quantidade.." munições de AK-47");
                return false
            end
        end
    end

end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETIRADA DE ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
function retirarQTD(faccao, quantidade, arma)

    local value = vRP.getSData("strix:EstoqueMuni"..faccao..""..arma)
    local saldofac = json.decode(value) or 0

    -- OK

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

    local user_id = vRP.getUserId(source)

    local precoDaMuni = 0
    local municao = ""

    TriggerClientEvent(
        "Notify",
        source,
        "aviso",
        "Cada pack de munições custam: <br> FiveSeven = $125K <br> Tec-9 = $265K <br> Mp5 = $346K <br> G36 = $468K <br> AK-47 = $532K"
    )
    
    local tipo = tostring(vRP.prompt(source, "Qual tipo de munição deseja comprar? (five, tec, mp5, g36 ou ak)", ""))

    -- if tipo ~= "five" or tipo ~= "tec" or tipo ~= "mp5" or tipo ~= "g36" or tipo ~= "ak" then
    --     TriggerClientEvent(
    --         "Notify",
    --         source,
    --         "aviso",
    --         "Item não identificado"
    --     )
    --     return false
    -- end

    local quantidade = 250

    if tipo == "five" then
        precoDaMuni = 500
        tipo = "Five"
        municao = "wammo_WEAPON_PISTOL_MK2"
    elseif tipo == "tec" then
        precoDaMuni = 1060
        tipo = "Tec"
        municao = "wammo_WEAPON_MACHINEPISTOL"
    elseif tipo == "mp5" then
        precoDaMuni = 1384
        tipo = "Mp5"
        municao = "wammo_WEAPON_SMG"
    elseif tipo == "g36" then
        precoDaMuni = 1872
        tipo = "G36"
        municao = "wammo_WEAPON_SPECIALCARBINE_MK2"
    elseif tipo == "ak" then
        precoDaMuni = 2128
        tipo = "AK"
        municao = "wammo_WEAPON_ASSAULTRIFLE_MK2"
    end

    if quantidade == nil then

        TriggerClientEvent(
            "Notify",
            source,
            "aviso",
            "Aceitamos apenas numeros..."
        )

        return false
    else
        if not delayVMochila[user_id] or os.time() > (delayVMochila[user_id] + 1) then
            delayVMochila[user_id] = os.time()
            if user_id then
                if vRP.tryFullPayment(user_id, quantidade * precoDaMuni) then
                    if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(municao) <= vRP.getInventoryMaxWeight(user_id) then
                        local pagamento = quantidade * precoDaMuni
                        TriggerClientEvent("cancelando", source, true)
                        if checkEstoque(faccao, quantidade, tipo) then
                            if retirarQTD(faccao, quantidade, tipo) then
                                paymentFac(faccao, pagamento)
                                vRP.giveInventoryItem(user_id, municao, quantidade)
                            end
                        else
                            TriggerClientEvent("Notify", source, 'aviso', 'Não temos essa munição no momento!')
                            TriggerClientEvent(
                                "Notify",
                                source,
                                "aviso",
                                "teste"
                            )
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