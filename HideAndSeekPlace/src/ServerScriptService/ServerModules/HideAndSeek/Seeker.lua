-- The Seeker team. Everything about the seeker.
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")

local TeamCreateModule = require(ServerScriptService.ServerModules.TeamCreate)

local Seeker = {}

function Seeker:create(properties, teamName, teamBrickColor)
    properties = properties or {
        teamInstance = TeamCreateModule.create(teamName, teamBrickColor)
    }

    self.__index = self
    return setmetatable(properties, self)
end


function Seeker:assign(player)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")
    -- Add more here
end

return Seeker
