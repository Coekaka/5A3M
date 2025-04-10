local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local backpack = player.Backpack
local userInputService = game:GetService("UserInputService")

-- Ensure required folders exist
local specs = replicatedStorage:FindFirstChild("Specs") or Instance.new("Folder", replicatedStorage)
specs.Name = "Specs"

local traitsFolder = specs:FindFirstChild("Traits") or Instance.new("Folder", specs)
traitsFolder.Name = "Traits"

local traitFolder = specs:FindFirstChild("Trait") or Instance.new("Folder", specs)
traitFolder.Name = "Trait"
-- Updated list of traits
local availableTraits = {"Clamps", "Tireless", "Bunnys", "NoLook", "QuickDraw", "Surf", "Destruction"}
local activeTraits = {}

-- Create GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "TraitSelector"
screenGui.Enabled = false

-- Main Frame
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 10)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "TRAIT HUB"
title.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Create trait toggles
for i, traitName in ipairs(availableTraits) do
    local container = Instance.new("Frame", frame)
    container.Size = UDim2.new(1, -20, 0, 40)
    container.Position = UDim2.new(0, 10, 0, 60 + (i - 1) * 45)
    container.BackgroundColor3 = Color3.fromRGB(40, 40, 50)

    local containerCorner = Instance.new("UICorner", container)
    containerCorner.CornerRadius = UDim.new(0, 8)

    -- Trait Label
    local traitLabel = Instance.new("TextLabel", container)
    traitLabel.Size = UDim2.new(0.7, 0, 1, 0)
    traitLabel.Text = traitName
    traitLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    traitLabel.BackgroundTransparency = 1
    traitLabel.Font = Enum.Font.Gotham
    traitLabel.TextSize = 16
    traitLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Toggle Button
    local toggleButton = Instance.new("TextButton", container)
    toggleButton.Size = UDim2.new(0.25, 0, 0.8, 0)
    toggleButton.Position = UDim2.new(0.7, 0, 0.1, 0)
    toggleButton.Text = "OFF"
    toggleButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 14
    toggleButton.AutoButtonColor = false

    local toggleCorner = Instance.new("UICorner", toggleButton)
    toggleCorner.CornerRadius = UDim.new(0, 8)

    -- Toggle functionality
    local enabled = false
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggleButton.Text = enabled and "ON" or "OFF"
        toggleButton.BackgroundColor3 = enabled and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(120, 120, 120)
        
        if enabled then
            -- Activate trait
            local trait = backpack:FindFirstChild("Trait")
            if trait then
                trait.Parent = specs
            end

            for _, obj in pairs(traitsFolder:GetChildren()) do
                if obj.Name == traitName then
                    obj.Parent = traitFolder
                end
            end
            traitFolder.Parent = backpack
            activeTraits[traitName] = true
        else
            -- Deactivate trait
            for _, obj in pairs(traitFolder:GetChildren()) do
                if obj.Name == traitName then
                    obj.Parent = traitsFolder
                end
            end
            activeTraits[traitName] = false
        end
    end)
end

-- Erase Button
local eraseButton = Instance.new("TextButton", frame)
eraseButton.Size = UDim2.new(1, -20, 0, 40)
eraseButton.Position = UDim2.new(0, 10, 0, 70 + #availableTraits * 45)
eraseButton.Text = "REMOVE GUI"
eraseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
eraseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
eraseButton.Font = Enum.Font.GothamBold
eraseButton.TextSize = 16

local eraseCorner = Instance.new("UICorner", eraseButton)
eraseCorner.CornerRadius = UDim.new(0, 8)

eraseButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Toggle GUI visibility with Right Ctrl or End
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl or input.KeyCode == Enum.KeyCode.End then
        screenGui.Enabled = not screenGui.Enabled
    end
end)
