--[[
    Copyright (c) 2022 Razzway & Alcao - Tout droit réservé.
    Ce fichier a été créé pour Razzway - FiveM Store.
    Vous n'êtes pas autorisé à revendre/partager la ressource.
--]]

---@author Razzway, Alcao
---@version 1.0.0

announceString = false

sendGAVMessage = function(scaleform, nameAgent)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString("~r~Vous avez été placé en cellule")
    PushScaleformMovieFunctionParameterString(("Par l'agent : %s"):format(nameAgent))
    PopScaleformMovieFunctionVoid()
    return scaleform
end

gavMessage = function(nameAgent)
    CreateThread(function()
        while (announceString) do
            scaleform = sendGAVMessage("mp_big_message_freemode", nameAgent)
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            Wait(0)
        end
    end)
end