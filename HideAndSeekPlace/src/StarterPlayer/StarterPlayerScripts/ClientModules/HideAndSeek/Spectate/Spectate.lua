-- Handle player Spectating
-- minhnormal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RNG = Random.new()
local Roact = require(ReplicatedStorage.SharedModules.Roact)

local localPlayer = Players.LocalPlayer

local hideAndSeekModules = localPlayer.PlayerScripts.ClientModules.HideAndSeek

local roactComponents = hideAndSeekModules.RoactComponents
local SpectateGui = require(roactComponents.SpectateGui)

local Spectate = {}

local function getRandomPlayer()
    local players = Players:GetPlayers()
    return players[RNG:NextInteger(1, #players)]
end


function Spectate:untoggle()
    self.currentPlayerSpectatingTo = nil
end


function Spectate:toggle(playerToSpectate)

end


function Spectate:onPopUpActivated()
    if self.spectateToggled then
        self:untoggleGui()
    else
        self:toggleGui()
    end
end


function Spectate:toggleGui()
    self.spectateToggled = true

    local playerGui = localPlayer.PlayerGui

    if self.spectateGuiTree then
        self.spectateGuiTree = Roact.update(self.spectateGuiTree, self.spectateGuiCreateFunction(self.spectateToggled, table.unpack(self.spectateGuiCreatingRequiredFunctions)))
    else
        print(self.spectateGuiCreateFunction)
        self.spectateGuiTree = Roact.mount(self.spectateGuiCreateFunction(self.spectateToggled, table.unpack(self.spectateGuiCreatingRequiredFunctions)), playerGui)
    end

    self:toggle(getRandomPlayer)
end


function Spectate:untoggleGui()
    self.spectateToggled = false
    if not self.spectateGuiTree then return end
    Roact.update(self.spectateGuiTree, self.spectateGuiCreateFunction(self.spectateToggled, table.unpack(self.spectateGuiCreatingRequiredFunctions)))
    self:untoggle()
end


function Spectate:spectatePreviousPlayer()
end


function Spectate:spectateNextPlayer()
end


function Spectate:create(object, spectateGuiCreateFunction)
    object = object or {
        currentPlayerSpectatingTo = nil,
        spectateGuiCreateFunction = spectateGuiCreateFunction or SpectateGui.create
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

    object.spectateGuiTree = Roact.mount(object.spectateGuiCreateFunction(false, table.unpack(object.spectateGuiCreatingRequiredFunctions)), localPlayer.PlayerGui)

    return object
end

return Spectate
