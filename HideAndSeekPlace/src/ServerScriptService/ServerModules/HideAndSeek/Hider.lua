-- The Hider Team. Anything about the hider
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")

local TeamCreateModule = require(ServerScriptService.ServerModules.TeamCreate)

local Hider = {}

function Hider:create(properties, teamName, teamBrickColor, teamToDeassignTo)
    properties = properties or {
        teamInstance = TeamCreateModule.create(teamName, teamBrickColor);
        teamToDeassignTo = teamToDeassignTo
    }

    self.__index = self
    return setmetatable(properties, self)
end


function Hider:getPlayersInHiderTeam()
    return self.teamInstance:GetPlayers()
end


function Hider:assign(player)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")

    player.Team = self.teamInstance
    -- Add more here
end


function Hider:deAssign(player)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")

    local playerOriginalTeam = player.Team
    if playerOriginalTeam ~= self.teamInstance then return end

    -- Do other things to de assign the players out of the hider team

    player.Team = self.teamToDeassignTo
end

return Hider
