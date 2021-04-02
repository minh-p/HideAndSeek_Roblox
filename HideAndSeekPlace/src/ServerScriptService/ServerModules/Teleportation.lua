-- Teleportation module
-- minhnormal

local Teleportation = {}

function Teleportation.teleportToBasePart(object, basePart)
    assert(typeof(object) == "Instance", "Object being teleported needs to be an Instance Model with a Primary Part or BasePart")

    local verticalOffset = 0

    if object:IsA("Model") then
        assert(object.PrimaryPart, "Model needs to have Primary Part.")
        verticalOffset = object:GetExtents().Y + basePart.Size.Y / 2
        object = object.PrimaryPart
    else
        verticalOffset = object.Size.Y + basePart.Size.Y / 2
    end

    assert(object:IsA("BasePart"), "Object or object's primary part needs to be a base part.")

    object.CFrame = basePart.CFrame + Vector3.new(0, verticalOffset, 0)
end

return Teleportation
