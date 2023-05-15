--[[
    Copyright (c) 2022 Razzway & Alcao - Tout droit réservé.
    Ce fichier a été créé pour Razzway - FiveM Store.
    Vous n'êtes pas autorisé à revendre/partager la ressource.
--]]

---@author Razzway, Alcao
---@version 1.0.0

local time, inGAV, duration = 0, false, 0

ESX = nil

CreateThread(function()
    TriggerEvent(PoliceGAV.getESX, function(obj) ESX = obj end)
    while ESX == nil do Wait(10) end
    while ESX.GetPlayerData()['job'] == nil do Wait(100) end 

    ESX.PlayerData = ESX.GetPlayerData()
    
    if ESX.PlayerData.job.name == PoliceGAV.jobName then
        prisonThread()
    end
end)

local isMenuOpen = false

local mainMenu = RageUI.CreateMenu(PoliceGAV.serverName, "Mettre en détention")
local choose = RageUI.CreateSubMenu(mainMenu, PoliceGAV.serverName, "Choisissez une cellule")
mainMenu.Closed = function()
    isMenuOpen = false
    Visual.Subtitle("", 1)
end
choose.Closed = function()
    Visual.Subtitle("", 1)
end

openGAVMenu = function()
    if (isMenuOpen) then
        return
    end
    isMenuOpen = true
    RageUI.Visible(mainMenu, true)
    CreateThread(function()
        while (isMenuOpen) do
            Wait(0)
            RageUI.IsVisible(mainMenu, function()
                for _,v in pairs(PoliceGAV.Items) do
                    RageUI.Button(v.label, "Placer en détention", {LeftBadge = RageUI.BadgeStyle.Star}, true, {
                        onSelected = function()
                            time = v.value
                        end
                    }, choose)
                end
            end)
            RageUI.IsVisible(choose, function()
                RageUI.Info("Informations", {"Temps :"}, {("%s minutes"):format(time)})
                for _,v in pairs(PoliceGAV.Cellules) do
                    RageUI.Button(("Cellule numéro n° ~b~%s~s~"):format(v.id), ("Appuyez sur [~b~ENTRER~s~] pour valider la mise en cellule de l'individu."), {LeftBadge = RageUI.BadgeStyle.Star}, true, {
                        onActive = function()
                            DrawMarker(0, v.position, 0, 0, 0, 0, nil, nil, 2.0, 2.0, 2.0, 28, 252, 3, 170, 0, 1, 0, 0, nil, nil, 0)
                            Visual.Subtitle("Veuillez ~y~sélectionner~s~ la cellule de l'individu", 9999999)
                        end,
                        onSelected = function()
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer ~= -1 and closestDistance <= 3 then
                                TriggerServerEvent('police-gav:putInDetention', GetPlayerServerId(closestPlayer), (time*60), v.position, v.id)
                            else
                                ESX.ShowNotification("~r~Il semblerait que personne ne soit à proximité.")
                            end
                        end
                    })
                end
            end)
        end
    end)
end

RegisterNetEvent('police-gav:openGestion', function(data)
    local gestionMenu = RageUI.CreateMenu(PoliceGAV.serverName, "Gestion des prisonniers")

    RageUI.Visible(gestionMenu, not RageUI.Visible(gestionMenu))

    while gestionMenu do
        RageUI.IsVisible(gestionMenu, function()
            for _,v in pairs(data) do
                if v.isOnline then
                    RageUI.Button(v.pName, ("Etat : ~g~En ligne~s~\nMis en cellule par : ~b~%s~s~\nNuméro de cellule : ~y~%s~s~"):format(v.agentName, v.cellule), {LeftBadge = RageUI.BadgeStyle.Star, RightLabel = "~g~Sortir de prison"}, true, {
                        onSelected = function()
                            TriggerServerEvent('police-gav:forceUnjail', v.pId)
                            RageUI.CloseAll()
                        end
                    })
                else
                    RageUI.Button(v.pName, ("Etat : ~r~Hors ligne~s~\nMis en cellule par : ~b~%s~s~\nNuméro de cellule : ~y~%s~s~"):format(v.agentName, v.cellule), {LeftBadge = RageUI.BadgeStyle.Star, RightLabel = "~g~Sortir de prison"}, true, {
                        onSelected = function()
                            ESX.ShowNotification("~r~Le joueur n'est pas en ligne.")
                        end
                    })
                end
            end
        end)

        if not RageUI.Visible(gestionMenu) then
            gestionMenu = RMenu:DeleteType(gestionMenu, true)
        end
        Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    TriggerServerEvent('checkJailTime')
end)

RegisterNetEvent("police-gav:goInJail", function(seconds, posGAV, agentName)
	inGAV = true
    duration = tonumber(seconds)
    announceString = true
    RageUI.PlaySound("HUD_AWARDS", "FLIGHT_SCHOOL_LESSON_PASSED")
    if (announceString) then
        gavMessage(agentName, duration*1000)
    end
    TimeBar.add("Temps restants", {endTime=GetGameTimer()+((duration+1)*1000)})
    if (PoliceGAV.setPrisonerOutfit) then
        TriggerEvent('skinchanger:getSkin', function(skin)
            local uniformObject
            if skin.sex == 0 then uniformObject = PoliceGAV.clothes["male"]
            else uniformObject = PoliceGAV.clothes["female"] end
            if uniformObject then TriggerEvent('skinchanger:loadClothes', skin, uniformObject) end
        end)
    end
    CreateThread(function()
        while (inGAV) do
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)
            BlockWeaponWheelThisFrame()
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 199, true) 
            local pCoords = GetEntityCoords(PlayerPedId())
            if #(pCoords - posGAV) > 4 then
                ESX.ShowNotification("~r~Vous avez tenté de vous échapper, mais ce n'est pas possible !")
                SetEntityCoords(PlayerPedId(), posGAV)
            end
            local safeZone = GetSafeZoneSize()
            local safeZoneX = (1.0 - safeZone) * 0.5
            local safeZoneY = (1.0 - safeZone) * 0.5
            if #activeBars > 0 then
                HideHudComponentThisFrame(6)
                HideHudComponentThisFrame(7)
                HideHudComponentThisFrame(8)
                HideHudComponentThisFrame(9)
                for i,v in pairs(activeBars) do
                    local drawY = (ScreenCoords.baseY - safeZoneY) - (i * Sizes.timerBarMargin);
                    DrawSprite("timerbars", "all_black_bg", ScreenCoords.baseX - safeZoneX, drawY, Sizes.timerBarWidth, Sizes.timerBarHeight, 0.0, 255, 255, 255, 160)
                    TimeBar.DrawTxt(0, v.title, 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.titleOffsetX, drawY + ScreenCoords.titleOffsetY, v.textColor, false, 2)

                    if v.percentage then
                        local pbarX = (ScreenCoords.baseX - safeZoneX) + ScreenCoords.pbarOffsetX;
                        local pbarY = drawY + ScreenCoords.pbarOffsetY;
                        local width = Sizes.pbarWidth * v.percentage;

                        DrawRect(pbarX, pbarY, Sizes.pbarWidth, Sizes.pbarHeight, v.pbarBgColor[1], v.pbarBgColor[2], v.pbarBgColor[3], v.pbarBgColor[4])

                        DrawRect((pbarX - Sizes.pbarWidth / 2) + width / 2, pbarY, width, Sizes.pbarHeight, v.pbarFgColor[1], v.pbarFgColor[2], v.pbarFgColor[3], v.pbarFgColor[4])
                    elseif v.text then
                        TimeBar.DrawTxt(0, v.text, 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, v.textColor, false, 2)
                    elseif v.endTime then
                        local remainingTime = math.floor(v.endTime - GetGameTimer())
                        TimeBar.DrawTxt(0, TimeBar.SecondsToClock(remainingTime / 1000), 0.425, (ScreenCoords.baseX - safeZoneX) + ScreenCoords.valueOffsetX, drawY + ScreenCoords.valueOffsetY, remainingTime <= 0 and textColor or v.textColor, false, 2)
                    end
                end
            end
            Wait(0)
        end
    end)
    CreateThread(function()
		while inGAV do
            print("Temps restant :" ..duration)
            TriggerServerEvent('police-gav:updateTime')
			Wait(1000)
			if (inGAV) and (duration) > 0 then
				duration = duration - 1.0
			else
                inGAV = false
                TimeBar.remove()
                announceString = false
				return
			end
		end
	end)
end)

RegisterNetEvent('police-gav:unjail', function()
    duration = 0
    inGAV = false
end)

RegisterNetEvent("police-gav:resetOutfit", function()
    ESX.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin, jobSkin)
        TriggerEvent("skinchanger:loadSkin", skin)
    end)
end)

prisonThread = function()
    CreateThread(function()
        while true do
            local interval = 750
            local pCoords = GetEntityCoords(PlayerPedId())
            if ESX.PlayerData.job.name == PoliceGAV.jobName then
                if #(pCoords - PoliceGAV.MenuPos) <= 3 then
                    interval = 1
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour placer quelqu'un en détention")
                    if IsControlJustPressed(0, 38) then
                        openGAVMenu()
                    end
                end
                Wait(interval)
            else
                break
            end
        end
    end)
end

RegisterNetEvent('esx:setJob', function(job)
    local currJob = ESX.PlayerData.job.name
    ESX.PlayerData.job = job
    if job.name == PoliceGAV.jobName and currJob ~= PoliceGAV.jobName then
        prisonThread()
    end
end)

-- << Crédits >> --

VERSION = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)

print(
        "^0======================================================================^7\n" ..
        ("^0[^1Script^0]^7 :^0 ^6%s^7\n"):format(GetCurrentResourceName()) ..
        "^0[^4Author^0]^7 :^0 ^2Alcao & Razzway^7\n" ..
        ("^0[^3Version^0]^7 :^0 ^0%s^7\n"):format(VERSION) ..
        "^0[^2Download^0]^7 :^0 ^5https://discord.gg/EtWdxsCv94^7\n" ..
        "^0======================================================================^7"
)