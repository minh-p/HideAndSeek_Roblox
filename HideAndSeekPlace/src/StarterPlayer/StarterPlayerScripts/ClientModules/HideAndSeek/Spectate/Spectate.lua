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
local createSpectatePopUpButton = require(roactComponents.createSpectatePopUpButton)

local Spectate = {}

function Spectate:create(object, spectateGuiElement)
    object = object or {
        playerSpectatingTo = nil,
        spectateGuiTree = Roact.mount(spectateGuiElement, localPlayer.PlayerGui)
    }

    setmetatable(object, self)
    self.__index = self
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


function Spectate:toggleGui()
    self.spectateToggled = true

    local playerGui = localPlayer.PlayerGui

    if self.spectateGuiTree then
        self.spectateGuiTree = Roact.update(self.spectateGuiTree, SpectateGui.create(self.spectateToggled))
    else
        self.spectateGuiTree = Roact.mount(SpectateGui.create(self.spectateToggled), playerGui)
    end

    self:toggle(getRandomPlayer)
end


function Spectate:untoggleGui()
    self.spectateToggled = false
    if not self.spectateGuiTree then return end
    Roact.update(self.spectateGuiTree, SpectateGui.create(self.spectateToggled))
    self:untoggle()
end


function Spectate:initializeGuis()
    local spectatePopUp = createSpectatePopUpButton(function()
        if self.spectateToggled then
            self:untoggleGui()
        else
            self:toggleGui()
        end
    end)

    Roact.mount(spectatePopUp, localPlayer.PlayerGui)
end

return Spectate
