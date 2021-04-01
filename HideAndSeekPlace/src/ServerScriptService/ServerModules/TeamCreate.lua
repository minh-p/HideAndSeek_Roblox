-- A module for creating teams
-- minhnormal

local Teams = game:GetService("Teams")

local TeamCreate = {}

function TeamCreate.create(teamName, teamBrickColor)
    if not teamName or not teamBrickColor then return end

    local newTeam = Instance.new("Team")
    newTeam.Name = teamName
    newTeam.TeamColor = teamBrickColor
    newTeam.Parent = Teams

    return newTeam
end

return TeamCreate
