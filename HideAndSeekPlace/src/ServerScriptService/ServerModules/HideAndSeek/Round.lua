-- Hide and Seek Round System. Gonna use Roact for the Gui
-- minhnormal

local Round = {}

function Round:create(properties)
    properties = properties or {
        roundDurationInMinutes = 5;
        roundIntermissionInSeconds = 15;

        timerGuiComponent = nil;

        onRoundStop = function() end;
        onRoundStart = function() end
    }
end


function Round:stop()
    -- Stops the timer
    -- Call function when round stops
    self.onRoundStop()
end


function Round:start(skipIntermission)
    if skipIntermission then
        -- Skip the intermission
    else
        -- Go on with the intermission
    end

    self.onRoundStart()

    -- Run timer. After the timer, the round will automatically stops.
end

return Round
