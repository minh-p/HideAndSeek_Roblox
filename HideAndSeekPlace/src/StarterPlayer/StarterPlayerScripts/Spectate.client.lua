-- Handles Spectating: Client
-- minhnormal

local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer

local hideAndSeekModules = localPlayer.PlayerScripts:WaitForChild("ClientModules").HideAndSeek
local SpectateGui = require(hideAndSeekModules.RoactComponents.SpectateGui)
local spectate = require(hideAndSeekModules.Spectate.Spectate):create(nil, SpectateGui.create)
