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

function Spectate:create(object, spectateGuiCreateFunction)
    object = object or {
        playerSpectatingTo = nil,
        spectateGuiCreateFunction = spectateGuiCreateFunction or SpectateGui.create
    }

    setmetatable(object, self)
    self.__index = self

    object.spectateGuiTree = Roact.mount(object.spectateGuiCreateFunction(false, function() object:onPopUpActivated() end), localPlayer.PlayerGui)

    return object
end


function Spectate:toggle(playerToSpectate)

end


function Spectate:untoggle()

end


local function getRandomPlayer()
    local players = Players:GetPlayers()
    return players[RNG:NextInteger(1, #players)]
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
        self.spectateGuiTree = Roact.update(self.spectateGuiTree, self.spectateGuiCreateFunction(self.spectateToggled, function() self:onPopUpActivated() end))
    else
        self.spectateGuiTree = Roact.mount(self.spectateGuiCreateFunction(self.spectateToggled, function() self:onPopUpActivated() end), playerGui)
    end

    self:toggle(getRandomPlayer)
end


function Spectate:untoggleGui()
    self.spectateToggled = false
    if not self.spectateGuiTree then return end
    Roact.update(self.spectateGuiTree, self.spectateGuiCreateFunction(self.spectateToggled, function() self:onPopUpActivated() end))
    self:untoggle()
end

return Spectate
