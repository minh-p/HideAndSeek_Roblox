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


function Team:assign(player)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")

    player.Team = self.teamInstance


    local playerCharacter = player.Character or player.CharacterAdded:Wait()
    local teamSpawns = self.spawns

    if self.teleportOnAssign and teamSpawns then
        TeleportationModule.teleportToBasePart(playerCharacter, teamSpawns[math.random(1, #teamSpawns)])
    end

    if self.onAssigning then
        assert(typeof(self.onAssigning) == "function", ".onAssigning is not a function")
        self:onAssigning(player)
    end

    if self.deAssignOnDead then
        playerCharacter:FindFirstChildWhichIsA("Humanoid").Died:Connect(function()
            -- This makes the character to fully load in.
            player.CharacterAdded:Wait()
            self:deassign(player)
        end)
    end
end


function Team:deassign(player)
    assert(typeof(player) == "Instance" and player:IsA("Player"), "Given argument: player needs to be an Instance Player")

    local playerOriginalTeam = player.Team
    if playerOriginalTeam ~= self.teamInstance then return end

    player.Team = self.teamToDeassignTo

    if self.teleportOnDeassign and self.teamToDeassignToSpawns then
        local playerCharacter = player.Character or player.CharacterAdded:Wait()
        local teamToDeassignToSpawns = self.teamToDeassignToSpawns
        TeleportationModule.teleportToBasePart(playerCharacter, teamToDeassignToSpawns[math.random(1, #teamToDeassignToSpawns)])
    end

    if self.onDeassigning then
        assert(typeof(self.onDeassigning) == "function", ".onDeassigning is not a function")
        self:onDeassigning(player)
    end
end

return Team
