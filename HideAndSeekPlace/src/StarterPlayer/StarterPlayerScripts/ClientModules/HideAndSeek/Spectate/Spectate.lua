-- Handle player Spectating
-- minhnormal

-- How should we make the spectating system where we can switch players in an order?
--[[
    - Save an index of the player when switching. The player would need to be
    in either the seeker or hider team.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RNG = Random.new()

local sharedModules = ReplicatedStorage.SharedModules
local BazirRemote = require(sharedModules.BazirRemote)
local Roact = require(sharedModules.Roact)

local localPlayer = Players.LocalPlayer

local hideAndSeekModules = localPlayer.PlayerScripts.ClientModules.HideAndSeek

local roactComponents = hideAndSeekModules.RoactComponents
local SpectateGui = require(roactComponents.SpectateGui)

local Spectate = {}


local function tableIsEmpty(t)
    if not t then return end
    return next(t) == nil
end


function Spectate:_getRandomPlayerToBeSpectated()
    -- returns a random player that is valid to be spectated
    if tableIsEmpty(self.spectateList) then return end
    self.currentPlayerListIndex = RNG:NextInteger(1, #self.spectateList)
    return self.spectateList[self.currentPlayerListIndex]
end


local function getPlayerHumanoid()
    local playerCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    return playerCharacter:FindFirstChild("Humanoid") or playerCharacter:WaitForChild("Humanoid")
end


function Spectate:setPlayerWalkSpeedAndJumpPower(walkSpeed, jumpPower)
    self.setPlayerWalkSpeedAndJumpPowerRemote:FireServer(walkSpeed, jumpPower)
end


function Spectate:untoggle()
    self.currentPlayerSpectatingTo = nil

    local playerHumanoid = getPlayerHumanoid()
    self:setPlayerWalkSpeedAndJumpPower(self.originalWalkSpeed, self.originalJumpPower)

    workspace.CurrentCamera.CameraSubject = playerHumanoid
end


function Spectate:updatePlayerSpectatingList(exemptPlayer)
    self.spectateList = {}
    -- exemptPlayer is the player you one to get rid of.
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player ~= exemptPlayer and not table.find(self.spectateList, player) then
            if tableIsEmpty(self.teamsAllowedToBeSpectated) or table.find(self.teamsAllowedToBeSpectated, player.Team) then
                table.insert(self.spectateList, player)
            end
        end
    end
end


function Spectate:_playerIsSpectatable(player)
    if not player then return end
    if not player:IsA("Player") then return end

    if tableIsEmpty(self.teamsAllowedToBeSpectated) then
        return true
    end

    if table.find(self.teamsAllowedToBeSpectated, player.Team) then
        return true
    end
end


function Spectate:toggle(playerToSpectateTo)
    if not playerToSpectateTo then
        warn("No player to spectate to or invalid argument playerToSpectateTo needs to be a player")
        return
    end

    if not self:_playerIsSpectatable(playerToSpectateTo) then return end

    -- Renders player immovable.
    self:setPlayerWalkSpeedAndJumpPower(0, 0)

    local _, err = pcall(function()
        local playerToSpectateToCharacter = playerToSpectateTo.Character or playerToSpectateTo.CharacterAdded:Wait()
        workspace.CurrentCamera.CameraSubject = playerToSpectateToCharacter.Humanoid
    end)

    warn(err)
end


function Spectate:onPopUpActivated()
    if self.spectateToggled then
        self:untoggleGui()
    else
        self:toggleGui()
    end
end


function Spectate:untoggleGui()
    self.spectateToggled = false
    self:untoggle()
    if not self.spectateGuiTree then return end
    Roact.update(self.spectateGuiTree, self.createSpectateGui(self.spectateToggled, table.unpack(self.spectateGuiCreatingRequiredFunctions)))
end


function Spectate:toggleGui()
    self:untoggleGui()
    if #self.spectateList == 0 then return end
    self.spectateToggled = true

    local playerGui = localPlayer.PlayerGui

    if self.spectateGuiTree then
        self.spectateGuiTree = Roact.update(self.spectateGuiTree, self.createSpectateGui(self.spectateToggled, table.unpack(self.spectateGuiCreatingRequiredFunctions)))
    else
        print(self.createSpectateGui)
        self.spectateGuiTree = Roact.mount(self.createSpectateGui(self.spectateToggled, table.unpack(self.spectateGuiCreatingRequiredFunctions)), playerGui)
    end

    self:toggle(self:_getRandomPlayerToBeSpectated())
end


function Spectate:spectatePreviousPlayer()
    self.currentPlayerListIndex = self.currentPlayerListIndex - 1

    if self.currentPlayerListIndex < 1 then
        self.currentPlayerListIndex = math.clamp(#self.spectateList, 1, #Players:GetPlayers())
    end

    self:toggle(self.spectateList[self.currentPlayerListIndex])
end


function Spectate:spectateNextPlayer()
    self.currentPlayerListIndex = self.currentPlayerListIndex + 1

    if self.currentPlayerListIndex > #self.spectateList then
        self.currentPlayerListIndex = 1
    end

    self:toggle(self.spectateList[self.currentPlayerListIndex])
end


function Spectate:startSpectateListUpdating()
    self:updatePlayerSpectatingList()

    Players.PlayerAdded:Connect(function()
        -- The new player will be added to the spectate list automatically.
        self:updatePlayerSpectatingList()
    end)

    Players.PlayerRemoving:Connect(function(player)
        -- this player is being exempted from the spectate list
        self:updatePlayerSpectatingList(player)
    end)
end


function Spectate:create(object, createSpectateGui)
    object = object or {
        spectateList = {},
        currentPlayerListIndex = 1,-- this will be always be at least 1.
        currentPlayerSpectatingTo = nil,
        createSpectateGui = createSpectateGui or SpectateGui.create,
        originalWalkSpeed = 16,
        originalJumpPower = 50,
        teamsAllowedToBeSpectated = {},

        setPlayerWalkSpeedAndJumpPowerRemote = BazirRemote.new("setPlayerWalkSpeedAndJumpPower")
    }

    setmetatable(object, self)
    self.__index = self

    object.spectateGuiCreatingRequiredFunctions = {
        function()
            object:onPopUpActivated()
        end,

        function()
            object:spectatePreviousPlayer()
        end,

        function()
            object:spectateNextPlayer()
        end
    }

    object.spectateGuiTree = Roact.mount(object.createSpectateGui(false, table.unpack(object.spectateGuiCreatingRequiredFunctions)), localPlayer.PlayerGui)
    object:startSpectateListUpdating()

    return object
end


function Spectate:setTeamsAllowedToBeSpectated(teamsAllowedToBeSpectated)
    self.teamsAllowedToBeSpectated = teamsAllowedToBeSpectated
end


function Spectate:setOriginalWalkSpeedAndJumpPower(walkSpeed, jumpPower)
    self.originalWalkSpeed = walkSpeed or 16
    self.originalJumpPower = jumpPower or 50
end

return Spectate
