-- The Hider Team. Anything about the hider
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")

local TeamCreateModule = require(ServerScriptService.ServerModules.TeamCreate)

local Hider = {}

function Hider:create(properties, teamName, teamBrickColor)
    properties = properties or {
        teamInstance = TeamCreateModule.create(teamName, teamBrickColor)
    }

    self.__index = self
    return setmetatable(properties, self)
end


function Hider:assign(player)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")

    player.Team = self.teamInstance
    -- Add more here
end

return Hider
