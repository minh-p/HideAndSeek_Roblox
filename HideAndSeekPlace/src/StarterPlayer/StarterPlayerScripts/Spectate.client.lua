-- Handles Spectating: Client
-- minhnormal

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

local localPlayer = Players.LocalPlayer

local hideAndSeekModules = localPlayer.PlayerScripts:WaitForChild("ClientModules").HideAndSeek
local SpectateGui = require(hideAndSeekModules.RoactComponents.SpectateGui)
local spectate = require(hideAndSeekModules.Spectate.Spectate):create(nil, SpectateGui.create)

local teamsAllowedToBeSpectated = {
    Teams.Seeker,
    Teams.Hider
}

spectate:setTeamsAllowedToBeSpectated(teamsAllowedToBeSpectated)
