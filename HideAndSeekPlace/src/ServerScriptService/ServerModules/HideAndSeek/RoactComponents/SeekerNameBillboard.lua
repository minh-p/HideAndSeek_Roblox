-- Seeker "It" Billboard Gui using Roact
-- minhnormal

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.SharedModules.Roact)

local SeekerNameBillboard = {textSizeScaled = Vector2.new(0.4, 0.8)}

local function getNumberOfLinesInText(text)
    if not text or text == "" then return 0 end
    local _, numberOfLines = text:gsub("\n", "\n")
    return numberOfLines + 1
end


local function getMaxCollumnLengthInLine(text)
    if not text then return 0 end

    local startingStringLoopIndex = 0
    local currentBiggestCollumnStringLength = 0

    for textPos = 1, #text do
        local textIsNewLineSyntax = text:sub(textPos, textPos) == "\n"

        if textIsNewLineSyntax then
            local stringLineLength = string.len(text:sub(startingStringLoopIndex, textPos - 1))

            if stringLineLength > currentBiggestCollumnStringLength then
                currentBiggestCollumnStringLength = stringLineLength
            end

            startingStringLoopIndex = textPos + 1
        end
    end

    -- lastStringLine or the only string line.
    local lastStringLineLength = string.len(text:sub(startingStringLoopIndex, -1))
    
    if lastStringLineLength > currentBiggestCollumnStringLength then
        currentBiggestCollumnStringLength = lastStringLineLength
    end

    return currentBiggestCollumnStringLength
end


function SeekerNameBillboard.getBillboardGuiSizeAccordingToText(text)
    local numberOfLinesInText = getNumberOfLinesInText(text)
    local maxCollumnLength = getMaxCollumnLengthInLine(text)

    local textSizeScaled = SeekerNameBillboard.textSizeScaled

    return UDim2.new(
        textSizeScaled.X * maxCollumnLength,
        0,
        textSizeScaled.Y * numberOfLinesInText
    )
end


function SeekerNameBillboard.create(text, studsOffsetY)
    local nameBillboardSize = SeekerNameBillboard.getBillboardGuiSizeAccordingToText(text)

    local NameBillboard = Roact.createElement("BillboardGui", {
        Name = "NameBillboard",
        Size = nameBillboardSize,
        StudsOffsetWorldSpace = Vector3.new(0, studsOffsetY + nameBillboardSize.Y.Scale, 0),
        AlwaysOnTop = true
    }, {
        BillboardText = Roact.createElement("TextLabel", {
            Text = text,
            TextScaled = true,
            BackgroundTransparency = 0.4,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(1, 0, 1, 0)
        })
    })

    return NameBillboard
end

return SeekerNameBillboard
