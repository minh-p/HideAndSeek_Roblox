-- The Seeker team. Everything about the seeker.
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")

local serverModules = ServerScriptService.ServerModules
local TeamClass = require(serverModules.HideAndSeek.Team)

local Seeker = TeamClass:create()

function Seeker:create(object, teamName, teamBrickColor, teamToDeassignTo)
    object = object or TeamClass:create(object, teamName, teamBrickColor, teamToDeassignTo)
    setmetatable(object, self)
    self.__index = self
    return object
end


function Seeker.onAssigning(player)

end


function Seeker.onDeassigning(player)

end

return Seeker
