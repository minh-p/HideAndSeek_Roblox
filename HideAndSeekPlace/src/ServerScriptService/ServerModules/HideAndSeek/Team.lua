-- Handles Team methods: assign, deassign
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")

local TeamCreateModule = require(ServerScriptService.ServerModules.TeamCreate)

local Team = {}

function Team:create(object, teamName, teamBrickColor, teamToDeassignTo)
    object = object or {
        teamInstance = TeamCreateModule.create(teamName, teamBrickColor);
        teamToDeassignTo = teamToDeassignTo
    }

    setmetatable(object, self)
    self.__index = self
    return object
end


function Team:setSpawns(spawns)
    spawns = spawns or {}

    if typeof(spawns) == "Instance" then
        spawns = spawns:GetChildren()
    end

    assert(typeof(spawns) == "table", "Given argument spawns needs to be an Instance or table")
    self.spawns = spawns
end


function Team:getPlayersInTeam()
    return self.teamInstance:GetPlayers()
end


function Team:assign(player)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")

    player.Team = self.teamInstance

    if self.onAssigning then
        assert(typeof(self.onAssigning) == "function", ".onAssigning is not a function")
        self:onAssigning(player)
    end
end


function Team:deassign(player)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")

    local playerOriginalTeam = player.Team
    if playerOriginalTeam ~= self.teamInstance then return end

    player.Team = self.teamToDeassignTo

    if self.onDeassigning then
        assert(typeof(self.onDeassigning) == "function", ".onDeassigning is not a function")
        self:onDeassigning(player)
    end
end

return Team
