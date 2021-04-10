-- Create SpectateGui pop up button
-- minhnormal

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.SharedModules.Roact)

return function(activatedFunc)
    return Roact.createElement("ScreenGui", {Name = "SpectatePopUp"}, {
        SpectatePopUpButton = Roact.createElement("TextButton", {
            Name = "PopUpButton",
            BackgroundTransparency = 0.8,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0.1, 0, 0.1, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.9, 0, 0.5, 0),

            [Roact.Event.Activated] = activatedFunc or function() end
        }, {})
    })
end
