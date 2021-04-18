-- Use the PlayerWalkSpeedAndJumpPowerSetter class
-- minhnormal

local ServerScriptService = game:GetService("ServerScriptService")

local playerWalkSpeedAndJumpPowerSetter = require(ServerScriptService.ServerModules.PlayerWalkSpeedAndJumpPowerSetter):create()

playerWalkSpeedAndJumpPowerSetter:initialize()
