-- Hide and Seek Round System. Gonna use Roact for the Gui
-- minhnormal

--[[
    timerGuiComponent directions:
    
]]

local Round = {}

function Round:create(properties)
    properties = properties or {
        roundDurationInMinutes = 5,
        roundIntermissionInSeconds = 15,

        timerGuiCreateFunc = function end(),
        timerRoactTree = nil,

        onRoundStop = function() end,
        onRoundStart = function() end
    }
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
    
    self.timerRoactTree = self.timerRoactTree or self.timerGuiCreateFunc()
    -- Pass in parameters: seconds.
end


function Round:start(skipIntermission)
    self:_handleIntermission(skipIntermission)

    self.onRoundStart()

    -- Run timer. After the timer, the round will automatically stops.
end

return Round
