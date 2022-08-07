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

function checkEstoque(fac)
    local source = source
    local user_id = vRP.getUserId(source)

    local valueFive = vRP.getSData("strix:EstoqueMuni" .. fac .. "Five")
    local valueTec = vRP.getSData("strix:EstoqueMuni" .. fac .. "Tec")
    local valueMp5 = vRP.getSData("strix:EstoqueMuni" .. fac .. "Mp5")
    local valueG36 = vRP.getSData("strix:EstoqueMuni" .. fac .. "G36")
    local valueAK = vRP.getSData("strix:EstoqueMuni" .. fac .. "AK")

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
function retirarQTD(fac, valor)
    local value = vRP.getSData("strix:EstoqueDroga" .. fac)
    local saldofac = json.decode(value) or 0
    valor = tonumber(valor)
    if tonumber(valor) > saldofac then
        return false
    else
        vRP.setSData("strix:EstoqueDroga" .. fac, saldofac - valor)
        return true
    end
end
RegisterCommand(
    "droga",
    function(source, args, rawCommand)
        
        local user_id = vRP.getUserId(source)
        local groove2 = vRP.getSData("strix:EstoqueDrogaGroove")
        local groove = json.decode(groove2) or 0
        local vagos2 = vRP.getSData("strix:EstoqueDrogaVagos")
        local vagos = json.decode(vagos2) or 0
        local ballas2 = vRP.getSData("strix:EstoqueDrogaBallas")
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
    local value = vRP.getSData("strix:EstoqueDroga" .. QualFac)
    local resultado = json.decode(value) or 0

    if QualFac == "Groove" then
        vRP.setSData("strix:salario" .. "Groove", resultado + qtd)
    elseif QualFac == "Vagos" then
        vRP.setSData("strix:salario" .. "Vagos", resultado + qtd)
    elseif QualFac == "Ballas" then
        vRP.setSData("strix:salario" .. "Ballas", resultado + qtd)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SACAR
-----------------------------------------------------------------------------------------------------------------------------------------
function src.sacarDinDin()
    local source = source
    local user_id = vRP.getUserId(source)

    local fac = VerificarMembro()

    local value = vRP.getSData("strix:salario" ..fac)
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
        vRP.setSData("strix:salario" .. fac, resultado)
        vRP.giveMoney(user_id, qtd)
        TriggerClientEvent("Notify", source, "aviso", "Você Sacou: $" .. vRP.format(parseInt(qtd)))
    else
        TriggerClientEvent("Notify", source, "aviso", "Quantia inválida.")
    end
end