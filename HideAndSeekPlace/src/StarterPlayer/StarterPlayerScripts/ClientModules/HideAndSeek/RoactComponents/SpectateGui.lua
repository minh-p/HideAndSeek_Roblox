-- Spectate Gui using Roact
-- minhnormal

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.SharedModules.Roact)

local SpectateGui = {}

function SpectateGui.create(spectateToggled)
    return Roact.createElement("ScreenGui", {
        Name = "Spectate",
        Enabled = spectateToggled
    }, {
        UpperFrame = Roact.createElement("Frame", {
            Name = "UpperFrame",
            Size = UDim2.new(1, 0, 0.18, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.035, 0),
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            BackgroundTransparency = 0.45
        }, {}),

        LowerFrame = Roact.createElement("Frame", {
            Name = "LowerFrame",
            Size = UDim2.new(1, 0, 0.18, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.92, 0),
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            BackgroundTransparency = 0.45
        }, {})
    })
end

return SpectateGui
