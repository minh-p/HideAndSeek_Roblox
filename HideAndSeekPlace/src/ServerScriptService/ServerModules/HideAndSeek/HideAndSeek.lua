-- Hide and Seek main class
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local hideAndSeekModules = ServerScriptService.ServerModules.HideAndSeek

local HideAndSeek = {}

function HideAndSeek:create(object, seekerTeamName, seekerTeamBrickColor, hiderTeamName, hiderTeamBrickColor, teamToDeassignTo)
    object = object or {
        round = require(hideAndSeekModules.Round):create(nil);
        seeker = require(hideAndSeekModules.Seeker):create(nil, seekerTeamName, seekerTeamBrickColor, teamToDeassignTo);
        hider = require(hideAndSeekModules.Hider):create(nil, hiderTeamName, hiderTeamBrickColor, teamToDeassignTo)
    }

    self.__index = self
    return setmetatable(object, self)
end


function HideAndSeek:assignPlayersToTeam(chosenHiders, chosenSeekers)
    chosenHiders = chosenHiders or {}
    chosenSeekers = chosenSeekers or {}

    assert(typeof(chosenHiders) == "table", "Given argument: chosenHiders needs to be a table")
    assert(typeof(chosenSeekers) == "table", "Given argument: chosenSeekers needs to be a table")

    for _, player in ipairs(chosenHiders) do
        self.hider:assign(player)
    end

    for _, player in ipairs(chosenSeekers) do
        assert(typeof(player) == "Instance", "Given argument: player needs to be an Instance Player")
        self.seeker:assign(player)
    end
end


function HideAndSeek:deAssignAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        -- The methods will check if the player is in their team or not.
        -- No need to worry.
        self.hider:deAssign(player)
        self.seeker:deAssign(player)
    end
end

return HideAndSeek
