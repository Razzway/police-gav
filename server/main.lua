--[[
    Copyright (c) 2022 Razzway & Alcao - Tout droit réservé.
    Ce fichier a été créé pour Razzway - FiveM Store.
    Vous n'êtes pas autorisé à revendre/partager la ressource.
--]]

---@author Razzway, Alcao
---@version 1.0.0

ESX = nil TriggerEvent(PoliceGAV.getESX, function(obj) ESX = obj end)

local JailTable = {}

RegisterNetEvent('police-gav:putInDetention')
AddEventHandler('police-gav:putInDetention', function(playerId, seconds, pos, cellule)
    local source = source
    if (source) then
        local xPlayer = ESX.GetPlayerFromId(source)
        local xTarget = ESX.GetPlayerFromId(playerId)
        if (xPlayer) and (xTarget) then
            if (xPlayer.job.name) ~= PoliceGAV.jobName then
                if (Server.enableLogs) then
                    logs.send(Server.wehbook.url, Server.wehbook.name, nil, ("**Police GAV - Anticheat**\n%s\nNom : %s\nID du joueur : %s\nDiscord : %s\nIdentifier : %s\nAdresse IP : ||%s||\n```› A TENTE DE TRICHER !```"):format(MESSAGE_LINE, xPlayer.getName(), source, logs.getPlayerInfo(source, "discord"), xPlayer.identifier, logs.getPlayerInfo(source, "ip")), Server.wehbook.color.red)
                end
                print(("^1Cardinal Anticheat^7 : [^3%s^7] Le joueur ^4%s^7 (id : ^4%s^7) a tenté de tricher."):format(GetCurrentResourceName(), xPlayer.getName(), source))
                return
            end
            if JailTable[xTarget.identifier] == nil then
                JailTable[xTarget.identifier] = {}
            else
                print(("(%s) est déjà en prison !"):format(playerId))
                return
            end
            if JailTable[xTarget.identifier] ~= nil then
                SetEntityCoords(GetPlayerPed(playerId), pos)
                if (Server.enableLogs) then
                    logs.send(Server.wehbook.url, Server.wehbook.name, nil, ("**Police GAV - Nouvelle intéraction**\n%s\nNom : %s\nID du joueur : %s\nDiscord : %s\nIdentifier : %s\n```› Mis en cellule n°%s pour %s minutes```%s\nNom de l'agent : %s\nID de l'agent : %s\nDiscord de l'agent : %s\nIdentifier : %s"):format(MESSAGE_LINE, xTarget.getName(), playerId, logs.getPlayerInfo(playerId, "discord"), xTarget.identifier, cellule, ESX.Math.Round(seconds/60), MESSAGE_LINE, xPlayer.getName(), source, logs.getPlayerInfo(source, "discord"), xPlayer.identifier), Server.wehbook.color.darkblue)
                end
                SetTimeout(500, function()
                    if (PoliceGAV.SQLWrapperType) == 1 then
                        MySQL.Async.execute('INSERT INTO police_gav (identifier, time, celluleid, agentName, pName) VALUES (@identifier, @time, @celluleid, @agentName, @pName)', {
                            ['@identifier'] = xTarget.identifier,
                            ['@time'] = tonumber(seconds),
                            ['@celluleid'] = cellule,
                            ['@agentName'] = xPlayer.getName(),
                            ['@pName'] = xTarget.getName()
                        })
                    elseif (PoliceGAV.SQLWrapperType) == 2 then
                        MySQL.insert("INSERT INTO police_gav (identifier, time, celluleid, agentName, pName) VALUES (?, ?, ?, ?, ?)", {
                            xTarget.identifier, tonumber(seconds), cellule, xPlayer.getName(), xTarget.getName()
                        })
                    else
                        print("^5[police-gav] ^1Code: Le type de SQL que vous utilisez n'a pas été retrouvé. Assurez vous qu'il est bien indiqué dans le fichier cl_config.^0")
                        return StopResource(GetCurrentResourceName())
                    end
                    if (cellule) == 1 then
                        xPlayer.showNotification(("Vous avez placé ~m~(~b~%s~m~)~s~ en cellule n°~b~ 1~s~ pour une durée de ~y~%s minutes~s~ !"):format(xTarget.getName(), ESX.Math.Round(seconds/60)));
                    else
                        xPlayer.showNotification(("Vous avez placé ~m~(~b~%s~m~)~s~ en cellule n°~b~ %s~s~ pour une durée de ~y~%s minutes~s~ !"):format(xTarget.getName(), tostring(cellule), ESX.Math.Round(seconds/60)));
                    end
                    xTarget.showNotification(("~r~Vous avez été placé en cellule pour une durée de %s minutes par l'agent %s"):format(ESX.Math.Round(seconds/60), xPlayer.getName()));
                    xTarget.triggerEvent('police-gav:goInJail', seconds, pos, xPlayer.getName());
                    JailTable[xTarget.identifier] = {
                        identifier = xTarget.identifier,
                        time = tonumber(seconds),
                        agentName = xPlayer.getName(),
                        cellule = cellule,
                        pName = xTarget.getName(),
                        pId = playerId,
                        isOnline = true
                    }
                end)
            end
        else
            print("[EXCEPTION] Failed to retrieve players.")
        end
    else
        print("[EXCEPTION] Failed to retrieve source.")
    end
end)

RegisterCommand(PoliceGAV.commandName, function(source, args)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.job.name == PoliceGAV.jobName then
        xPlayer.triggerEvent("police-gav:openGestion", JailTable)
    end
end)

RegisterNetEvent('police-gav:forceUnjail')
AddEventHandler('police-gav:forceUnjail', function(playerId)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)
    if (source) then
        if (xPlayer) and (xTarget) then
            if (xPlayer.job.name) ~= PoliceGAV.jobName then
                if (Server.enableLogs) then
                    logs.send(Server.wehbook.url, Server.wehbook.name, nil, ("**Police GAV - Anticheat**\n%s\nNom : %s\nID du joueur : %s\nDiscord : %s\nIdentifier : %s\nAdresse IP : ||%s||\n```› A TENTE DE TRICHER !```"):format(MESSAGE_LINE, xPlayer.getName(), source, logs.getPlayerInfo(source, "discord"), xPlayer.identifier, logs.getPlayerInfo(source, "ip")), Server.wehbook.color.red)
                end
                print(("^1Cardinal Anticheat^7 : [^3%s^7] Le joueur ^4%s^7 (id : ^4%s^7) a tenté de tricher."):format(GetCurrentResourceName(), xPlayer.getName(), source))
                return
            end
            if (Server.enableLogs) then
                logs.send(Server.wehbook.url, Server.wehbook.name, nil, ("**Police GAV - Nouvelle intéraction**\n%s\nNom : %s\nID du joueur : %s\nDiscord : %s\nIdentifier : %s\n```› Sortie de force de la cellule n°%s```%s\nNom de l'agent : %s\nID de l'agent : %s\nDiscord de l'agent : %s\nIdentifier : %s"):format(MESSAGE_LINE, xTarget.getName(), playerId, logs.getPlayerInfo(playerId, "discord"), xTarget.identifier, JailTable[xTarget.identifier].cellule, MESSAGE_LINE, xPlayer.getName(), source, logs.getPlayerInfo(source, "discord"), xPlayer.identifier), Server.wehbook.color.yellow)
            end
            xTarget.triggerEvent('police-gav:unjail')
            JailTable[xTarget.identifier] = nil
            xTarget.triggerEvent("police-gav:resetOutfit")
            SetEntityCoords(GetPlayerPed(playerId), PoliceGAV.MenuPos)
            if (PoliceGAV.SQLWrapperType) == 1 then
                MySQL.Async.execute('DELETE FROM police_gav WHERE identifier = @identifier', {
                    ["@identifier"] = xTarget.identifier,
                })
            elseif (PoliceGAV.SQLWrapperType) == 2 then
                MySQL.update('DELETE FROM police_gav WHERE identifier = ?', {xTarget.identifier})
            else
                print("^5[police-gav] ^1Code: Le type de SQL que vous utilisez n'a pas été retrouvé. Assurez vous qu'il est bien indiqué dans le fichier cl_config.^0")
                return StopResource(GetCurrentResourceName())
            end
        else
            print("[EXCEPTION] Failed to retrieve players.")
        end
    else
        print("[EXCEPTION] Failed to retrieve source.")
    end
end)

RegisterNetEvent("police-gav:updateTime")
AddEventHandler("police-gav:updateTime", function()
    local source = source
    if (source) then
        local xPlayer = ESX.GetPlayerFromId(source)
        if (xPlayer) then
            if JailTable[xPlayer.identifier] ~= nil then
                SetTimeout(1000, function()
                    if JailTable[xPlayer.identifier] ~= nil and JailTable[xPlayer.identifier].time <= 0 then
                        if (Server.enableLogs) then
                            logs.send(Server.wehbook.url, Server.wehbook.name, nil, ("**Police GAV - Nouvelle intéraction**\n%s\nNom : %s\nID du joueur : %s\nDiscord : %s\nIdentifier : %s\n```› Sortie de la cellule n° %s```"):format(MESSAGE_LINE, xPlayer.getName(), source, logs.getPlayerInfo(source, "discord"), xPlayer.identifier, JailTable[xPlayer.identifier].cellule), Server.wehbook.color.red)
                        end
                        if (PoliceGAV.SQLWrapperType) == 1 then
                            MySQL.Async.execute('DELETE FROM police_gav WHERE identifier = @identifier', {
                                ["@identifier"] = xPlayer.identifier,
                            })
                        elseif (PoliceGAV.SQLWrapperType) == 2 then
                            MySQL.update('DELETE FROM police_gav WHERE identifier = ?', {xPlayer.identifier})
                        else
                            print("^5[police-gav] ^1Code: Le type de SQL que vous utilisez n'a pas été retrouvé. Assurez vous qu'il est bien indiqué dans le fichier cl_config.^0")
                            return StopResource(GetCurrentResourceName())
                        end
                        xPlayer.showNotification("Votre temps en cellule est terminé !")
                        SetEntityCoords(GetPlayerPed(source), PoliceGAV.MenuPos)
                        local xPlayers = ESX.GetPlayers()
                        for i = 1, #xPlayers do
                            local tPlayer = ESX.GetPlayerFromId(xPlayers[i])
                            if tPlayer.job.name == PoliceGAV.jobName then
                                if (JailTable[xPlayer.identifier].cellule == 1) then 
                                    tPlayer.showNotification(("L'individu ~b~%s~s~ est sorti de la cellule n° 1 après avoir purgé sa peine."):format(xPlayer.getName()))
                                else
                                    tPlayer.showNotification(("L'individu ~b~%s~s~ est sorti de la cellule n° ~b~%s~s~ après avoir purgé sa peine."):format(xPlayer.getName(), tostring(JailTable[xPlayer.identifier].cellule)))
                                end
                            end
                        end
                        if (PoliceGAV.setPrisonerOutfit) then
                            xPlayer.triggerEvent("police-gav:resetOutfit")
                        end
                        JailTable[xPlayer.identifier] = nil
                    elseif JailTable[xPlayer.identifier] ~= nil then
                        JailTable[xPlayer.identifier].time = JailTable[xPlayer.identifier].time - 1
                    end
                    if (PoliceGAV.sendPoliceNotif) then
                        if JailTable[xPlayer.identifier] ~= nil and JailTable[xPlayer.identifier].time == (PoliceGAV.sendPoliceNotifTime*60) then
                            local xPlayers = ESX.GetPlayers()
                            for i = 1, #xPlayers do
                                local tPlayer = ESX.GetPlayerFromId(xPlayers[i])
                                if tPlayer.job.name == PoliceGAV.jobName then
                                    tPlayer.showNotification(("Il reste %s minutes à %s avant sa libération. N'oubliez pas de retourner au commisariat."):format(PoliceGAV.sendPoliceNotifTime ,xPlayer.getName()))
                                end
                            end
                        end
                    end
                end)
            end
        else
            print("[EXCEPTION] Failed to retrieve player.")
        end
    else
        print("[EXCEPTION] Failed to retrieve source.")
    end
end)

RegisterNetEvent('checkJailTime')
AddEventHandler('checkJailTime', function()
    local source = source
    if (source) then
        local xPlayer = ESX.GetPlayerFromId(source)
        if (xPlayer) then
            if JailTable[xPlayer.identifier] ~= nil then
                for _,v in pairs(PoliceGAV.Cellules) do
                    if JailTable[xPlayer.identifier].cellule == v.id then
                        xPlayer.triggerEvent('police-gav:goInJail', JailTable[xPlayer.identifier].time, v.position, JailTable[xPlayer.identifier].agentName)
                        JailTable[xPlayer.identifier] = {
                            identifier = JailTable[xPlayer.identifier].identifier,
                            time = JailTable[xPlayer.identifier].time,
                            agentName = JailTable[xPlayer.identifier].agentName,
                            cellule = JailTable[xPlayer.identifier].cellule,
                            pName = JailTable[xPlayer.identifier].pName,
                            pId = source,
                            isOnline = true
                        }
                    end
                end
            end
        else
            print("[EXCEPTION] Failed to retrieve player.")
        end
    else
        print("[EXCEPTION] Failed to retrieve source.")
    end
end)

AddEventHandler('onResourceStart', function(resName)
    if (GetCurrentResourceName() == resName) then
        MySQL.Async.fetchAll('SELECT * FROM police_gav', {
        }, function(data)
            for k,v in pairs(data) do
                JailTable[v.identifier] = {
                    identifier = v.identifier,
                    time = tonumber(v.time),
                    agentName = v.agentName,
                    cellule = v.celluleid,
                    pName = v.pName,
                    isOnline = false
                }
            end
        end)
    end
end)

AddEventHandler('playerDropped', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if JailTable[xPlayer.identifier] ~= nil then
        JailTable[xPlayer.identifier] = {
            identifier = JailTable[xPlayer.identifier].identifier,
            time = JailTable[xPlayer.identifier].time,
            agentName = JailTable[xPlayer.identifier].agentName,
            cellule = JailTable[xPlayer.identifier].cellule,
            pName = JailTable[xPlayer.identifier].pName,
            pId = source,
            isOnline = false
        }
    end
end)