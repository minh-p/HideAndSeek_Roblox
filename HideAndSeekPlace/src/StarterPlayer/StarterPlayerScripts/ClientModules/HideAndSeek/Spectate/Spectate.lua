-- Handle player Spectating
-- minhnormal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Roact = require(ReplicatedStorage.SharedModules.Roact)

local localPlayer = Players.LocalPlayer

local hideAndSeekModules = localPlayer.PlayerScripts.ClientModules.HideAndSeek
local SpectateGui = require(hideAndSeekModules.RoactComponents.SpectateGui)

local Spectate = {}

function Spectate:create(object, spectateGuiElement)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    local playerGui = localPlayer.PlayerGui
    object.spectateGuiTree = Roact.mount(spectateGuiElement, playerGui)
    return object
end


function Spectate:toggle()
    if self.spectateToggled then return end
    self.spectateToggled = true

    local playerGui = localPlayer.PlayerGui

    if self.spectateGuiTree then
        self.spectateGuiTree = Roact.update(self.spectateGuiTree, SpectateGui.create(self.spectateToggled))
    else
        self.spectateGuiTree = Roact.mount(SpectateGui.create(self.spectateToggled), playerGui)
    end

end


function Spectate:untoggle()
    if not self.spectateToggled then return end
    if not self.spectateGuiTree then return end

    self.spectateToggled = false

    Roact.update(self.spectateGuiTree, SpectateGui.create(self.spectateToggled))
end

return Spectate
