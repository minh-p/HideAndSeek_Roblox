-- Main Server Scripts for handling the Hide and Seek Game.
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local serverModules = ServerScriptService.ServerModules
local HideAndSeekClass = require(serverModules.HideAndSeek.HideAndSeek)
local TeamCreateModule = require(serverModules.TeamCreate)

local SEEKER_TEAM_NAME = "Seeker"
local SEEKER_TEAM_BRICKCOLOR = BrickColor.new("Really red")

local HIDER_TEAM_NAME = "Hider"
local HIDER_TEAM_BRICKCOLOR = BrickColor.new("Bright blue")

local TEAM_TO_DEASSIGN_TO_NAME = "Spectator"
local TEAM_TO_DEASSIGN_TO_BRICKCOLOR = BrickColor.new("White")

local teamToDeassignTo = TeamCreateModule.create(TEAM_TO_DEASSIGN_TO_NAME, TEAM_TO_DEASSIGN_TO_BRICKCOLOR)

local hideAndSeek = HideAndSeekClass:create(nil, SEEKER_TEAM_NAME, SEEKER_TEAM_BRICKCOLOR, HIDER_TEAM_NAME, HIDER_TEAM_BRICKCOLOR, teamToDeassignTo)

local function selectSeekers()
    return {
        Players:WaitForChild("minhnormal")
    }
end


local function selectHiders()
    return {
    }
end

local seekers = selectSeekers()
local hiders = selectHiders()

hideAndSeek.seeker:setHiderTeam(hideAndSeek.hider.teamInstance)
hideAndSeek.seeker:setCapturedTeam(teamToDeassignTo, {workspace.Spectator})
hideAndSeek:assignPlayersToTeam(hiders, seekers)
