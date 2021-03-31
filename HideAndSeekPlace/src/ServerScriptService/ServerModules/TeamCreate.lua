-- A module for creating teams
-- minhnormal

local Teams = game:GetService("Teams")

local TeamCreate = {}

function TeamCreate.create(teamName, teamBrickColor)
    assert(typeof(teamName) == "string", "Given argument: teamName needs to be a string")
    assert(typeof(teamBrickColor) == "BrickColor", "Given argument: teamBrickColor needs to be a BrickColor value")

    local newTeam = Instance.new("Team")
    newTeam.Name = teamName
    newTeam.TeamColor = teamBrickColor
    newTeam.Parent = Teams

    return newTeam
end

return TeamCreate
