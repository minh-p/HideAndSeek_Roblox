-- Hide and Seek main class
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")

local hideAndSeekModules = ServerScriptService.ServerModules.HideAndSeek

local HideAndSeek = {}

function HideAndSeek:create(properties)
    properties = properties or {
        round = require(hideAndSeekModules.Round):create(nil);
        seeker = require(hideAndSeekModules.Seeker):create(nil, "Seeker", BrickColor.new("Really red"));
        hider = require(hideAndSeekModules.Hider):create(nil, "Hider", BrickColor.new("Bright blue"))
    }

    self.__index = self
    return setmetatable(properties, self)
end


function HideAndSeek:assignPlayersToTeam(chosenHiders, chosenSeekers)
    chosenHiders = chosenHiders or {}
    chosenSeekers = chosenSeekers or {}

    assert(typeof(chosenHiders) == "table", "Given argument: chosenHiders needs to be a table")
    assert(typeof(chosenSeekers) == "table", "Given argument: chosenSeekers needs to be a table")

    for _, player in ipairs(chosenHiders) do
        assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")
        self.hider:assign(player)
    end

    for _, player in ipairs(chosenSeekers) do
        assert(typeof(player) == "Instance", "Given argument: player needs to be an Instance Player")
        self.seeker:assign(player)
    end
end

return HideAndSeek
