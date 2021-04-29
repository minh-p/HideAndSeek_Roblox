-- Create timer module-function wrap
-- 4/28/2021
-- minhnormal

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.SharedModules.Roact)

local function getTime(timeInSecondsToDisplay)
    timeInSecondsToDisplay = tonumber(timeInSecondsToDisplay)
    return string.format("%.2d:%.2d", timeInSecondsToDisplay/60 % 60, timeInSecondsToDisplay % 60)
end


return function(timeInSecondsToDisplay)
    return Roact.createElement("ScreenGui", {}, {
        Frame = Roact.createElement("Frame", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0.1, 0, 0.08, 0),
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 0)
        }, {
            TimeDisplayer = Roact.createElement("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                Text = getTime(timeInSecondsToDisplay),
                TextScaled = true,
                BackgroundTransparency = 1
            })
        })
    })
end
