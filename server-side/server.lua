-----------------------------------------------------------------------------------------------------------------------------------------
-- PENDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
src = {}
Tunnel.bindInterface("strixBuyArmaMuni", src)
vCLIENT = Tunnel.getInterface("strixBuyArmaMuni")


-----------------------------------------------------------------------------------------------------------------------------------------
--  PREPARE DATABASE
-----------------------------------------------------------------------------------------------------------------------------------------

vRP:prepare("vRP/base_tables",[[
CREATE TABLE IF NOT EXISTS strix_estoquemunicoes(
	`faccao` VARCHAR(100) NOT NULL COLLATE 'latin1_swedish_ci',
	`estoque` TEXT NULL DEFAULT NULL COLLATE 'latin1_swedish_ci',
	PRIMARY KEY (`faccao`) USING BTREE
)
COLLATE='latin1_swedish_ci'
ENGINE=InnoDB
;
]])

async(function() vRP:execute("vRP/base_tables") end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
function VerificarMembro(fac, perm)
    if fac == "Yardie" then
        return true
    -- elseif fac == "Russkaya" then
    --     return true
    -- elseif fac == "Bloods" then
    --     return true
    -- elseif fac == "Crips" then
    --     return true
    end
    return false
end

function checkEstoque(fac)
    local source = source
    local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id, "russkaya.parmissao") or vRP.hasPermission(user_id, "yardie.permissao") then

        local valueFive = vRP.getSData("haven:EstoqueMuni" .. fac .. "Five")
        local valueTec = vRP.getSData("haven:EstoqueMuni" .. fac .. "Tec")
        local valueMp5 = vRP.getSData("haven:EstoqueMuni" .. fac .. "Mp5")
        local valueG36 = vRP.getSData("haven:EstoqueMuni" .. fac .. "G36")
        local valueAK = vRP.getSData("haven:EstoqueMuni" .. fac .. "AK")

        local saldoFive = json.decode(valueFive) or 0
        local saldoTec = json.decode(valueTec) or 0
        local saldoMp5= json.decode(valueMp5) or 0
        local saldoG36 = json.decode(valueG36) or 0
        local saldoAK = json.decode(valueAK) or 0

        local saldofac = saldoFive + saldoTec + saldoMp5 + saldoG36 + saldoAk

        if saldofac > 0 then
            return true
        else
            TriggerEvent("Notify", source, "Não há estoque nesta facção.")
            return false
        end
    elseif vRP.hasPermission(user_id, "bloods.parmissao") or vRP.hasPermission(user_id, "crips.permissao") then

        local valueFive = vRP.getSData("haven:EstoqueArma" .. fac .. "Five")
        local valueTec = vRP.getSData("haven:EstoqueArma" .. fac .. "Tec")
        local valueMp5 = vRP.getSData("haven:EstoqueArma" .. fac .. "Mp5")
        local valueG36 = vRP.getSData("haven:EstoqueArma" .. fac .. "G36")
        local valueAK = vRP.getSData("haven:EstoqueArma" .. fac .. "AK")

        local saldoFive = json.decode(valueFive) or 0
        local saldoTec = json.decode(valueTec) or 0
        local saldoMp5= json.decode(valueMp5) or 0
        local saldoG36 = json.decode(valueG36) or 0
        local saldoAK = json.decode(valueAK) or 0

        local saldofac = saldoFive + saldoTec + saldoMp5 + saldoG36 + saldoAk

        if saldofac > 0 then
            return true
        else
            TriggerClientEvent("Notify", source,"importante", "Não há estoque nesta facção.")
            return false
        end
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

    if not vRP.hasPermission(user_id, "armamuni.menu") then
        return false
    end
    
    if vRP.hasPermission(user_id, "yardie.permissao") then
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

                local value = vRP.getSData("haven:EstoqueMuniYardieFive")
                local saldofac = json.decode(value) or 0

                saldoReal = saldofac + quantidade
                
                if vRP.tryGetInventoryItem(user_id, "wammo_WEAPON_PISTOL_MK2", quantidade) then
                    vRP.setSData("haven:EstoqueMuniYardieFive", saldofac + quantidade)
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

                local value = vRP.getSData("haven:EstoqueMuniYardieTec")
                local saldofac = json.decode(value) or 0

                saldoReal = saldofac + quantidade
                
                if vRP.tryGetInventoryItem(user_id, "wammo_WEAPON_MACHINEPISTOL", quantidade) then
                    vRP.setSData("haven:EstoqueMuniYardieTec", saldofac + quantidade)
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

                local value = vRP.getSData("haven:EstoqueMuniYardieMp5")
                local saldofac = json.decode(value) or 0

                saldoReal = saldofac + quantidade
                
                if vRP.tryGetInventoryItem(user_id, "wammo_WEAPON_SMG", quantidade) then
                    vRP.setSData("haven:EstoqueMuniYardieMp5", saldofac + quantidade)
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

                local value = vRP.getSData("haven:EstoqueMuniYardieG36")
                local saldofac = json.decode(value) or 0

                saldoReal = saldofac + quantidade
                
                if vRP.tryGetInventoryItem(user_id, "wammo_WEAPON_SPECIALCARBINE_MK2", quantidade) then
                    vRP.setSData("haven:EstoqueMuniYardieG36", saldofac + quantidade)
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

                local value = vRP.getSData("haven:EstoqueMuniYardieAK")
                local saldofac = json.decode(value) or 0

                saldoReal = saldofac + quantidade
                
                if vRP.tryGetInventoryItem(user_id, "wammo_WEAPON_ASSAULTRIFLE_MK2", quantidade) then
                    vRP.setSData("haven:EstoqueMuniYardieAK", saldofac + quantidade)
                    TriggerClientEvent("Notify", source, "aviso", "Estoque de Munição de AK-47 atual >>> " .. saldoReal)
                else
                    TriggerClientEvent("Notify", source, "aviso", "Você não tem "..quantidade.." munições de AK-47");
                    return false
                end
            end
        end
    end -- prox
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETIRADA DE ESTOQUE
-----------------------------------------------------------------------------------------------------------------------------------------
function retirarQTD(fac, valor)
    local value = vRP.getSData("haven:EstoqueDroga" .. fac)
    local saldofac = json.decode(value) or 0
    valor = tonumber(valor)
    if tonumber(valor) > saldofac then
        return false
    else
        vRP.setSData("haven:EstoqueDroga" .. fac, saldofac - valor)
        return true
    end
end
RegisterCommand(
    "droga",
    function(source, args, rawCommand)
        
        local user_id = vRP.getUserId(source)
        local groove2 = vRP.getSData("haven:EstoqueDrogaGroove")
        local groove = json.decode(groove2) or 0
        local vagos2 = vRP.getSData("haven:EstoqueDrogaVagos")
        local vagos = json.decode(vagos2) or 0
        local ballas2 = vRP.getSData("haven:EstoqueDrogaBallas")
        local ballas = json.decode(ballas2) or 0
        TriggerClientEvent(
            "Notify",
            source,
            "aviso",
            "Estoque disponivel de cada facção: </b><br><b></b><br>GROOVE: <b> " ..
                groove .. "</b><br>VAGOS: <b>" .. vagos .. "</b><br>BALLAS: <b>" .. ballas .. ""
        )
    end
)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VENDA DE DROGAS
-----------------------------------------------------------------------------------------------------------------------------------------
local delayVMochila = {}
local PrecoDaDroga = 2500
function src.buyDrugs(TipoDaVenda)
    local user_id = vRP.getUserId(source)
    TriggerClientEvent(
        "Notify",
        source,
        "aviso",
        "O preço de cada droga será: " ..
            vRP.format(parseInt(PrecoDaDroga)) .. "$. Para ver a quantidade de droga disponivel digite /droga."
    )
    local qtd = tonumber(vRP.prompt(source, "Quantas Unidades Deseja Comprar:", ""))
    if qtd == nil then

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
                if vRP.tryFullPayment(user_id, qtd * PrecoDaDroga) then
                    local pagamento = qtd * PrecoDaDroga
                    TriggerClientEvent("cancelando", source, true)
                    if TipoDaVenda == "groove" then
                        if checkEstoque("Groove") then
                            if retirarQTD("Groove", qtd) then
                                paymentFac("Groove", pagamento)
                                vRP.giveInventoryItem(user_id, "maconha", qtd)
                            end
                        end
                    elseif TipoDaVenda == "ballas" then
                        if checkEstoque("Ballas") then
                            if retirarQTD("Ballas", qtd) then
                                paymentFac("Ballas", pagamento)
                                vRP.giveInventoryItem(user_id, "metanfetamina", qtd)
                            end
                        end
                    elseif TipoDaVenda == "vagos" then
                        if checkEstoque("Vagos") then
                            if retirarQTD("Vagos", qtd) then
                                paymentFac("Vagos", pagamento)
                                vRP.giveInventoryItem(user_id, "cocaina", qtd)
                            end
                        end
                        TriggerClientEvent("cancelando", source, false)
                    end
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
    local value = vRP.getSData("haven:EstoqueDroga" .. QualFac)
    local resultado = json.decode(value) or 0

    if QualFac == "Groove" then
        vRP.setSData("haven:salario" .. "Groove", resultado + qtd)
    elseif QualFac == "Vagos" then
        vRP.setSData("haven:salario" .. "Vagos", resultado + qtd)
    elseif QualFac == "Ballas" then
        vRP.setSData("haven:salario" .. "Ballas", resultado + qtd)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SACAR
-----------------------------------------------------------------------------------------------------------------------------------------
function src.sacarDinDin()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "groove.permissao") then
        local value = vRP.getSData("haven:salario" .. "Groove")
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
            vRP.setSData("haven:salario" .. "Groove", resultado)
            vRP.giveMoney(user_id, qtd)
            TriggerClientEvent("Notify", source, "aviso", "Você Sacou: $" .. vRP.format(parseInt(qtd)))
        else
            TriggerClientEvent("Notify", source, "aviso", "Quantia inválida.")
        end
    elseif vRP.hasPermission(user_id, "ballas.permissao") then
        local value = vRP.getSData("haven:salario" .. "Ballas")
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
            vRP.setSData("haven:salario" .. "Ballas", resultado)
            vRP.giveMoney(user_id, qtd)
            TriggerClientEvent("Notify", source, "aviso", "Você Sacou: $" .. vRP.format(parseInt(qtd)))
        else
            TriggerClientEvent("Notify", source, "aviso", "Quantia inválida.")
        end
    elseif vRP.hasPermission(user_id, "vagos.permissao") then
        local value = vRP.getSData("haven:salario" .. "Vagos")
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
            vRP.setSData("haven:salario" .. "Vagos", resultado)
            vRP.giveMoney(user_id, qtd)
            TriggerClientEvent("Notify", source, "aviso", "Você Sacou: $" .. vRP.format(parseInt(qtd)))
            SendWebhookMessage(vagos,"```prolog\n[ID]: " ..user_id .. "\n[RETIROU]: " ..qtd .."$\n[FACCAO]: VAGOS \n[SALDO ANTIGO]: " ..resultado .. "" .. os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S") .. " \r```")
        else
            TriggerClientEvent("Notify", source, "aviso", "Quantia inválida.")
        end
    end
end

function eNumero(valor)
    local banana = 0;

    

end