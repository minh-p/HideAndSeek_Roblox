-- Handles Spectating: Client
-- minhnormal

local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local hideAndSeekModules = localPlayer.PlayerScripts:WaitForChild("ClientModules").HideAndSeek
local spectateGuiElement = require(hideAndSeekModules.RoactComponents.SpectateGui).create(false)
local spectate = require(hideAndSeekModules.Spectate.Spectate):create(nil, spectateGuiElement)

spectate:toggle()
