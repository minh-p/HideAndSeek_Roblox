-- Hide and Seek Round System. Gonna use Roact for the Gui
-- minhnormal

--[[
    timerGuiComponent directions:
    Method:
        timerGuiCreateFunc(timeInSecondsToDisplay) -> void:
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.SharedModules.Roact)

local Round = {}

function Round:create(object)
    object = object or {
        roundDurationInMinutes = 5,
        roundIntermissionInSeconds = 15,

        timerGuiCreateFunc = function() end,
        timerRoactTree = nil,

        onRoundStop = function() end,
        onRoundStart = function() end,

        playerTimerTrees = {}
    }

    self.__index = self
    setmetatable(object, self)
    return object
end


function Round:stop()
    -- Stops the timer
    -- Call function when round stops
    self.onRoundStop()
end


function Round:_handleIntermission(skipIntermission)
    if skipIntermission then return end
    -- Do the intermission

    if not self.timerGuiCreateFunc then warn("Have not set up timerGuiCreateFunc") return end
    
    -- Going to mount/update the timerGui on the client
    for timeLeftInSeconds = self.roundIntermissionInSeconds, 0, -1 do
        for _, player in ipairs(Players:GetPlayers()) do
            local updatedTimerRoactTree = self.timerGuiCreateFunc(timeLeftInSeconds)

            local existingPlayerTimerTree = self.playerTimerTrees[player]

            if existingPlayerTimerTree then
                self.playerTimerTrees[player] = Roact.update(existingPlayerTimerTree, updatedTimerRoactTree)
            else
                self.playerTimerTrees[player] = Roact.mount(updatedTimerRoactTree, player.PlayerGui)
            end
        end

        wait(1)
    end

    -- Clear out the gui:
    for _, roactTree in pairs(self.playerTimerTrees) do
        Roact.unmount(roactTree)
    end

    self.playerTimerTrees = nil
end


function Round:start(skipIntermission)
    self:_handleIntermission(skipIntermission)
    self.onRoundStart()

    -- Run timer. After the timer, the round will automatically stops.
end

return Round
