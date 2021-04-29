-- Create timer module-function wrap
-- 4/28/2021
-- minhnormal

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.SharedModules.Roact)

return function()
    return Roact.createElement("ScreenGui", {}, {})
end
