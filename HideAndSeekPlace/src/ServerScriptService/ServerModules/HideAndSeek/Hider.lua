-- The Hider Team. Anything about the hider
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")

local serverModules = ServerScriptService.ServerModules
local TeamClass = require(serverModules.HideAndSeek.Team)

local Hider = TeamClass:create()

function Hider:create(object, teamName, teamBrickColor, teamToDeassignTo)
    object = object or TeamClass:create(object, teamName, teamBrickColor, teamToDeassignTo)
    setmetatable(object, self)
    self.__index = self
    return object
end


function Hider.onAssigning(player)

end


function Hider.onDeassigning(player)

end

return Hider
