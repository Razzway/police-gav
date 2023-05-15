--[[
    Copyright (c) 2022 Razzway & Alcao - Tout droit réservé.
    Ce fichier a été créé pour Razzway - FiveM Store.
    Vous n'êtes pas autorisé à revendre/partager la ressource.
--]]

---@author Razzway, Alcao
---@version 1.0.0

ScreenCoords = { baseX = 0.918, baseY = 0.984, titleOffsetX = 0.035, titleOffsetY = -0.018, valueOffsetX = 0.0785, valueOffsetY = -0.0165, pbarOffsetX = 0.047, pbarOffsetY = 0.0015 }
Sizes = { timerBarWidth = 0.165, timerBarHeight = 0.035 , timerBarMargin = 0.038, pbarWidth = 0.0616, pbarHeight = 0.0105 } 

activeBars = {}

TimeBar = {
    add = function(title, itemData)
        if not itemData then return end
        RequestStreamedTextureDict("timerbars", true)
        local barIndex = #activeBars + 1
        activeBars[barIndex] = {
            title = title,
            text = itemData.text,
            textColor = itemData.color or { 255, 255, 255, 255 },
            percentage = itemData.percentage,
            endTime = itemData.endTime,
            pbarBgColor = itemData.bg or { 155, 155, 155, 255 },
            pbarFgColor = itemData.fg or { 255, 255, 255, 255 }
        }
        return barIndex
    end,
    remove = function()
        activeBars = {}
        SetStreamedTextureDictAsNoLongerNeeded("timerbars")
    end,
    SecondsToClock = function(seconds)
        if seconds <= 0 then
            return "00:00"
        else
            local mins = string.format("%02.f", math.floor(seconds / 60))
            local secs = string.format("%02.f", math.floor(seconds - mins * 60))
            return string.format("%s:%s", mins, secs)
        end
    end,
    DrawTxt = function(intFont, stirngText, floatScale, intPosX, intPosY, color, boolShadow, intAlign, addWarp)
        SetTextFont(intFont)
        SetTextScale(floatScale, floatScale)
        if boolShadow then
            SetTextDropShadow(0, 0, 0, 0, 0)
            SetTextEdge(0, 0, 0, 0, 0)
        end
        SetTextColour(color[1], color[2], color[3], 255)
        if intAlign == 0 then
            SetTextCentre(true)
        else
            SetTextJustification(intAlign or 1)
            if intAlign == 2 then
                SetTextWrap(.0, addWarp or intPosX)
            end
        end
        SetTextEntry("STRING")
        AddTextComponentString(stirngText)
        DrawText(intPosX, intPosY)
    end
}