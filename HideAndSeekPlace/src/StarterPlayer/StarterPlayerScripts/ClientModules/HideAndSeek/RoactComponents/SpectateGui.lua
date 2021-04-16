-- Spectate Gui using Roact
-- minhnormal

--[[
    Including the pop up button and the Next and Previous Spectate Buttons.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.SharedModules.Roact)

local SpectateGui = {}

function SpectateGui.create(spectateToggled, popUpActivatedFunc, spectatePreviousPlayerFunc, spectateNextPlayerFunc)
    return Roact.createElement("ScreenGui", {
        Enabled = true
    }, {
        Interface = Roact.createElement("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            Visible = spectateToggled,
            BackgroundTransparency = 1
        }, {
            UpperFrame = Roact.createElement("Frame", {
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
            }, {}),

            PreviousButton = Roact.createElement("ImageButton", {
                Size = UDim2.new(0.15, 0, 0.15, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.2, 0, 0.5, 0),
                Image = "",

                [Roact.Event.Activated] = spectatePreviousPlayerFunc or function() end
            }),

            NextButton = Roact.createElement("ImageButton", {
                Size = UDim2.new(0.15, 0, 0.15, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.8, 0, 0.5, 0),
                Image = "",
                
                [Roact.Event.Activated] = spectateNextPlayerFunc or function() end
            }),
        }),

        PopUp = Roact.createElement("ImageButton", {
            BackgroundTransparency = 0.8,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0.1, 0, 0.1, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.9, 0, 0.5, 0),

            [Roact.Event.Activated] = popUpActivatedFunc or function() end
        })
    })
end

return SpectateGui
