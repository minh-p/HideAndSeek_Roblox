-- Handles Team methods: assign, deassign
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")

local serverModules = ServerScriptService.ServerModules
local TeamCreateModule = require(serverModules.TeamCreate)
local TeleportationModule = require(serverModules.Teleportation)

local Team = {}

function Team:create(object, teamName, teamBrickColor, teamToDeassignTo)
    object = object or {
        teamInstance = TeamCreateModule.create(teamName, teamBrickColor),
        teleportOnAssign = true,
        teamToDeassignTo = teamToDeassignTo,
        teleportOnDeassign = true,
        deAssignOnDead = true
    }

    setmetatable(object, self)
    self.__index = self
    return object
end


local function checkGivenSpawns(spawns)
    spawns = spawns or {}

    if typeof(spawns) == "Instance" then
        spawns = spawns:GetChildren()
    end

    assert(typeof(spawns) == "table", "Given argument spawns needs to be an Instance or table")

    return spawns
end


function Team:setTeamToDeassignToSpawns(spawns)
    -- For setting a teleport pad for players to go to.
    spawns = checkGivenSpawns(spawns)
    self.teamToDeassignToSpawns = spawns
end


function Team:setSpawns(spawns)
    spawns = checkGivenSpawns(spawns)
    self.spawns = spawns
end


function Team:getPlayersInTeam()
    return self.teamInstance:GetPlayers()
end


function Team:_handleTeleporting(player, spawns)
    local playerCharacter = player.Character or player.CharacterAdded:Wait()
    if not self.teleportOnAssign or not spawns then return end
    TeleportationModule.teleportToBasePart(playerCharacter, spawns[math.random(1, #spawns)])
end


function Team:_handleDeassignOnDead(player)
    if not self.deAssignOnDead then return end

    local playerCharacter = player.Character or player.CharacterAdded:Wait()

    playerCharacter:FindFirstChildWhichIsA("Humanoid").Died:Connect(function()
        -- This makes the character to fully load in. But not teleported to spawn yet (if there is).
        player.CharacterAdded:Wait()
        self:deassign(player)
    end)
end


function Team:assign(player)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")

    self:_handleTeleporting(player, self.spawns)
    self:_handleDeassignOnDead(player)
    player.Team = self.teamInstance

    if not self.onAssigning then return end
    assert(typeof(self.onAssigning) == "function", ".onAssigning is not a function")
    self:onAssigning(player)
end


function Team:deassign(player)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")

    local playerIsNotFromTeamInstance = player.Team ~= self.teamInstance
    if playerIsNotFromTeamInstance then return end

    player.Team = self.teamToDeassignTo

    self:_handleTeleporting(player, self.teamToDeassignToSpawns)

    if not self.onDeassigning then return end
    assert(typeof(self.onDeassigning) == "function", ".onDeassigning is not a function")
    self:onDeassigning(player)
end

return Team
