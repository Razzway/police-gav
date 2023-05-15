--[[
    Copyright (c) 2022 Razzway & Alcao - Tout droit réservé.
    Ce fichier a été créé pour Razzway - FiveM Store.
    Vous n'êtes pas autorisé à revendre/partager la ressource.
--]]

---@author Razzway, Alcao
---@version 1.0.0

---@class PoliceGAV
PoliceGAV = PoliceGAV or {}
PoliceGAV.PoolMenus = {}

PoliceGAV.serverName = "ServerRP"
PoliceGAV.getESX = "esx:getSharedObject"; --> Trigger de déclaration ESX (default : esx:getSharedObject)
PoliceGAV.SQLWrapperType = 1 --> Indiquez ce que vous utilisez : mysql-async (1) / oxmysql (2)
PoliceGAV.jobName = "police" --> Indiquez le nom du job qui accès au menu
PoliceGAV.setPrisonerOutfit = true --> Activer ou non la mise automatique d'une tenue de prisonnier lors de la mise en cellule

PoliceGAV.sendPoliceNotif = true --> Envoyer une notification lorqu'il reste x temps à l'individu avant sa sortie
PoliceGAV.sendPoliceNotifTime = 5 --> Temps restant à l'individu pour envoyer la notif aux flics (en minutes)

PoliceGAV.MenuPos = vector3(481.40, -1009.53, 26.27) --> Position de l'intéraction avec le menu
PoliceGAV.commandName = "gav" --> Nom de la commande pour ouvrir le menu de gestion cellule(s)

PoliceGAV.Items = { -- value = temps en minutes
    {label = "10 minutes", value = 10}, 
    {label = "20 minutes", value = 20}, 
    {label = "30 minutes", value = 30}, 
    {label = "45 minutes", value = 45}, 
    {label = "60 minutes", value = 60}, 
}

PoliceGAV.Cellules = {
    {id = 1, position = vector3(478.12, -1014.02, 26.27)},
    {id = 2, position = vector3(481.09, -1014.10, 26.27)},
    {id = 3, position = vector3(484.05, -1013.93, 26.27)},
    {id = 4, position = vector3(487.01, -1014.03, 26.27)},
    {id = 5, position = vector3(485.77, -1005.83, 26.27)},
}

PoliceGAV.clothes = { --> Configurer votre tenue de prisonnier
    ["male"] = {
        bags_1 = 0, bags_2 = 0,
        tshirt_1 = 15, tshirt_2 = 0,
        torso_1 = 146, torso_2 = 0,
        arms = 0,
        pants_1 = 3, pants_2 = 7,
        shoes_1 = 12, shoes_2 = 12,
        mask_1 = 0, mask_2 = 0,
        bproof_1 = 0, bproof_2 = 0,
        helmet_1 = -1, helmet_2 = 0,
        chain_1 = 0, chain_2 = 0,
        decals_1 = 0, decals_2 = 0,
    },
    ["female"] = {
        bags_1 = 0, bags_2 = 0,
        tshirt_1 = 3, tshirt_2 = 0,
        torso_1 = 38, torso_2 = 3,
        arms = 0,
        pants_1 = 3, pants_2 = 15,
        shoes_1 = 66, shoes_2 = 5,
        mask_1 = 0, mask_2 = 0,
        bproof_1 = 0, bproof_2 = 0,
        helmet_1 = -1, helmet_2 = 0,
        chain_1 = 0, chain_2 = 2,
        decals_1 = 0, decals_2 = 0
    },
}