-- The Seeker team. Everything about the seeker.
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local serverModules = ServerScriptService.ServerModules
local TeleportationModule = require(serverModules.Teleportation)

local hideAndSeekModules = serverModules.HideAndSeek
local TeamClass = require(hideAndSeekModules.Team)
local SeekerNameBillboard = require(hideAndSeekModules.RoactComponents.SeekerNameBillboard)

local Roact = require(ReplicatedStorage.SharedModules.Roact)

local Seeker = TeamClass:create()

function Seeker:create(object, teamName, teamBrickColor, teamToDeassignTo)
    object = object or TeamClass:create(object, teamName, teamBrickColor, teamToDeassignTo)
    setmetatable(object, self)
    self.__index = self

    object.seekerBillboardGuiText = "It"
    object.capturingEvents = {}
    object.seekerBillboardTrees = {}

    return object
end


function Seeker:setHiderTeam(team)
    assert(typeof(team) == "Instance" and team:IsA("Team"), "Given argument team needs to be Instance Team")
    self.hiderTeam = team
end


function Seeker:setCapturedTeam(team, spawns)
    assert(typeof(team) == "Instance" and team:IsA("Team"), "Given argument team needs to be Instance Team")
    self.capturedTeam = team

    if typeof(spawns) == "Instance" then
        spawns = spawns:GetChildren()
    end

    assert(typeof(spawns) == "table", "Given argument spawns needs to be a table or an Instance.")
    self.capturedTeamSpawns = spawns
end


function Seeker:handleCapturing(partHit, seekerCharacter)
    if not self.capturedTeam then warn("Have not set captured team. Use :setCapturedTeam(team) to do it.") return end
    if not self.hiderTeam then warn("Have not set hider team. Use :setHiderTeam(team) to do it.") return end

    local potentialHiderCharacter = partHit.Parent

    if not potentialHiderCharacter:IsA("Model") then return end
    if potentialHiderCharacter == seekerCharacter then return end
    
    local player = Players:GetPlayerFromCharacter(potentialHiderCharacter)
    if not player or not player.Team == self.hiderTeam then return end

    player.Team = self.capturedTeam

    local capturedTeamSpawns = self.capturedTeamSpawns

    if not capturedTeamSpawns then return end

    local randomCapturedTeamSpawn = capturedTeamSpawns[math.random(1, #capturedTeamSpawns)]
    TeleportationModule.teleportToBasePart(potentialHiderCharacter, randomCapturedTeamSpawn)
end


function Seeker:_disableHiderCapturing(seeker)
    local capturingEvents = self.capturingEvents[seeker]
    if not capturingEvents then return end

    for eventIndex, event in ipairs(capturingEvents) do
        event:Disconnect()
        self.capturingEvents[seeker][eventIndex] = nil
    end
end


function Seeker:_enableHiderCapturing(seeker)
    self:_disableHiderCapturing(seeker)

    local seekerCharacter = seeker.Character or seeker.CharacterAdded:Wait()

    self.capturingEvents[seeker] = {}

    for _, part in ipairs(seekerCharacter:GetChildren()) do
        if part:IsA("BasePart") then
            local aCapturingEvent = part.Touched:Connect(function(partHit)
                self:handleCapturing(partHit, seekerCharacter)
            end)
            table.insert(self.capturingEvents[seeker], aCapturingEvent)
        end
    end
end


function Seeker:_mountSeekerBillboard(player)
    local playerIsSeeker = player.Team == self.teamInstance
    if not playerIsSeeker then return end

    local playerCharacter = player.Character or player.CharacterAdded:Wait()
    -- A random thing I came up with. Not sure if the offset works or not.
    local studsOffsetY = playerCharacter:GetExtentsSize().Y / 2 + 1
    local seekerNameBillboard = SeekerNameBillboard.create(self.seekerBillboardGuiText, studsOffsetY)
    local playerHumanoidRootPart = playerCharacter:FindFirstChild("HumanoidRootPart")

    if not playerHumanoidRootPart then playerHumanoidRootPart = playerCharacter:WaitForChild("HumanoidRootPart") end
    self.seekerBillboardTrees[player] = Roact.mount(seekerNameBillboard, playerCharacter:WaitForChild("HumanoidRootPart"))
end


function Seeker:onAssigning(player)
    self:_enableHiderCapturing(player)
    self:_mountSeekerBillboard(player)
end


function Seeker:_unmountSeekerBillboard(player)
    local seekerNameBillboardTree = self.seekerBillboardTrees[player]
    if not seekerNameBillboardTree then return end
    Roact.unmount(seekerNameBillboardTree)
end


function Seeker:onDeassigning(player)
    self:_disableHiderCapturing(player)
    self:_unmountSeekerBillboard(player)
end

return Seeker
