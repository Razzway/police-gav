--[[
    Copyright (c) 2022 Razzway & Alcao - Tout droit réservé.
    Ce fichier a été créé pour Razzway - FiveM Store.
    Vous n'êtes pas autorisé à revendre/partager la ressource.
--]]

---@author Razzway, Alcao
---@version 1.0.0

MESSAGE_LINE = "───────────────────────────"

local info = false

---@class logs
logs = {
    getPlayerInfo = function(player, info)
        for _, v in pairs(GetPlayerIdentifiers(player)) do
            if string.sub(v, 1, string.len("steam:")) == "steam:" then
                if info == "steam" then
                    info = v
                end
            elseif string.sub(v, 1, string.len("license:")) == "license:" then
                if info == "license" then
                    info = v
                end
            elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
                if info == "xbl" then
                    info = v
                end
            elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
                if info == "ip" then
                    ip = string.sub(v, 4)
                    info = ip
                end
            elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
                if info == "discord" then
                    discordid = string.sub(v, 9)
                    info = "<@"..discordid..">"
                end
            elseif string.sub(v, 1, string.len("live:")) == "live:" then
                if info == "live" then
                    info = v
                end
            end
        end
        return info
    end,
    send = function(wehbook, name, title, message, color)
        if message == nil or message == '' then return false end

        local date = os.date('*t')
    
        if date.day < 10 then date.day = '' .. tostring(date.day) end
        if date.month < 10 then date.month = '' .. tostring(date.month) end
        if date.hour < 10 then date.hour = '' .. tostring(date.hour) end
        if date.min < 10 then date.min = '' .. tostring(date.min) end
        if date.sec < 10 then date.sec = '' .. tostring(date.sec) end
    
        local logsDate = date.day.."/"..date.month.."/"..date.year.." - "..date.hour..":"..date.min..":"..date.sec
    
        local embeds = {
            {
                ["color"] = color,
                ["title"] = title,
                ["description"] = message,
                ["footer"] = {
                    ["text"] = logsDate,
                    ["icon_url"] = Server.wehbook.logo
                },
            }
        }
    
        PerformHttpRequest(Server.wehbook.url, function() end, 'POST', json.encode({username = name, embeds = embeds}), {['Content-Type'] = 'application/json'})
    end
}