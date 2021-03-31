-- The Seeker team. Everything about the seeker.
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")

local TeamCreateModule = require(ServerScriptService.ServerModules.TeamCreate)

local Seeker = {}

function Seeker:create(properties, teamName, teamBrickColor, teamToDeassignTo)
    properties = properties or {
        teamInstance = TeamCreateModule.create(teamName, teamBrickColor);
        teamToDeassignTo = teamToDeassignTo
    }

    self.__index = self
    return setmetatable(properties, self)
end


function Seeker:getPlayersInSeekerTeam()
    return self.teamInstance:GetPlayers()
end

function Seeker:assign(player)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")
    
    player.Team = self.teamInstance
    -- Add more here
end


function Seeker:deAssign(player)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")
    
    local playerOriginalTeam = player.Team
    if not playerOriginalTeam ~= self.teamInstance then return end

    -- Do other things to de assign player out of the seeker team

    player.Team = self.teamToDeassignTo
end

return Seeker
