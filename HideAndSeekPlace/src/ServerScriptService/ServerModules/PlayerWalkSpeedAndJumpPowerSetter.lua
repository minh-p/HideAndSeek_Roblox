-- Set player walk speed and jump power. Also enables client communication as well.
-- minhnormal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local sharedModules = ReplicatedStorage.SharedModules
local BazirRemote = require(sharedModules.BazirRemote)

local PlayerWalkSpeedAndJumpPowerSetter = {}

function PlayerWalkSpeedAndJumpPowerSetter:create(object)
    object = object or {
        jumpPowerLimit = 50,
        walkSpeedLimit = 16,
        enableChecker = true,
        -- with user ids
        -- might wanna do some HTTP service with this.
        whitelist = {},
        kickingEnabled = true,

        setPlayerWalkSpeedAndJumpPowerRemote = BazirRemote.new("setPlayerWalkSpeedAndJumpPower")
    }

    self.__index = self
    setmetatable(object, self)
    return object
end


local function getPlayerHumanoid(player)
    local playerCharacter = player.Character or player.CharacterAdded:Wait()
    return playerCharacter:FindFirstChild("Humanoid") or playerCharacter:WaitForChild("Humanoid")
end


function PlayerWalkSpeedAndJumpPowerSetter:set(player, walkSpeed, jumpPower)
    local playerHumanoid = getPlayerHumanoid(player)

    -- This makes this method be a checker/limitter.
    walkSpeed = walkSpeed or playerHumanoid.WalkSpeed
    jumpPower = jumpPower or playerHumanoid.JumpPower

    playerHumanoid.WalkSpeed = math.clamp(walkSpeed, 0, self.walkSpeedLimit)
    playerHumanoid.JumpPower = math.clamp(jumpPower, 0, self.jumpPowerLimit)

    return walkSpeed > self.walkSpeedLimit, jumpPower > self.jumpPowerLimit
end


function PlayerWalkSpeedAndJumpPowerSetter:check(player)
    local playerIsWhiteListed = table.find(self.whitelist, player.UserId)
    if playerIsWhiteListed then return end

    local function check()
        local walkSpeedIsOverLimit, jumpPowerIsOverLimit = self:set(player)

        if walkSpeedIsOverLimit or jumpPowerIsOverLimit then
            if not self.kickingEnabled then return end
            player:Kick("Suspicious JumpPower or WalkSpeed")
        end
    end

    check()

    local playerHumanoid = getPlayerHumanoid(player)
    playerHumanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(check)
    playerHumanoid:GetPropertyChangedSignal("JumpPower"):Connect(check)
end


function PlayerWalkSpeedAndJumpPowerSetter:initialize()
    for _, player in ipairs(Players:GetPlayers()) do
        self:check(player)

        player.CharacterAdded:Connect(function()
            self:check(player)
        end)
    end

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            self:check(player)
        end)
    end)

    self.setPlayerWalkSpeedAndJumpPowerRemote.OnServerEvent:Connect(function(player, walkSpeed, jumpPower)
        -- This might make sense, because I would not think you want players to have the walk speed/ jumppower limit.
        walkSpeed = walkSpeed or self.walkSpeedLimit / 2
        jumpPower = jumpPower or self.jumpPowerLimit / 2
        self:set(player, walkSpeed, jumpPower)
    end)
end

return PlayerWalkSpeedAndJumpPowerSetter
