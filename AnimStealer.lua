--[[
    Animation Stealer (R6) by nizshiy
    Сохраняет анимацию в текстовый Keyframe формат.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local BODY_PARTS = {
    "Head",
    "Torso",
    "Left Arm",
    "Right Arm",
    "Left Leg",
    "Right Leg"
}

local RECORDING_DURATION = 5 
local FRAMES_PER_SECOND = 30
local TOTAL_FRAMES = RECORDING_DURATION * FRAMES_PER_SECOND

local function requestDuration()
    local success, result = pcall(function()
        return tonumber(UserInputService:GetStringFromUserAsync("Animation Stealer", "Введите количество секунд для записи (рекомендуется 1-5):", 1, 5))
    end)
    if success and result then
        return result
    else
        return 1 
    end
end

local function createPoseString(partName, cfOffset)
    local pos = cfOffset.Position
    local rot = cfOffset.Rotation 
    return string.format("%s:%.3f:%.3f:%.3f:%.1f:%.1f:%.1f", partName, pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z)
end

local function startRecording(duration)
    duration = duration or RECORDING_DURATION
    TOTAL_FRAMES = duration * FRAMES_PER_SECOND
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then
        warn("HumanoidRootPart not found")
        return
    end

    local framesData = {}
    local frameCount = 0


    local connection
    connection = RunService.Stepped:Connect(function()
        frameCount = frameCount + 1
        if frameCount > TOTAL_FRAMES then
            connection:Disconnect()
            generateOutput(framesData)
            return
        end

        local rootCF = RootPart.CFrame
        local keyframeString = ""
        for _, partName in ipairs(BODY_PARTS) do
            local part = Character:FindFirstChild(partName)
            if part then
                local relativeCF = rootCF:ToObjectSpace(part.CFrame)
                keyframeString = keyframeString .. createPoseString(partName, relativeCF)
                if partName ~= BODY_PARTS[#BODY_PARTS] then
                    keyframeString = keyframeString .. "|" 
                end
            end
        end
        table.insert(framesData, keyframeString)
    end)
end

local function generateOutput(frames)
    local fullText = table.concat(frames, ";")

    -- Создаем GUI для копирования
    local screenGui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    local textBox = Instance.new("TextBox")
    local closeBtn = Instance.new("TextButton")

    screenGui.Name = "AnimationStealerGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    frame.Size = UDim2.new(0, 600, 0, 400)
    frame.Position = UDim2.new(0.5, -300, 0.5, -200)
    frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.new(0, 1, 0)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    textBox.Size = UDim2.new(1, -20, 1, -50)
    textBox.Position = UDim2.new(0, 10, 0, 10)
    textBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    textBox.TextColor3 = Color3.new(0, 1, 0)
    textBox.Text = fullText
    textBox.TextWrapped = true
    textBox.TextScaled = true
    textBox.Font = Enum.Font.Code
    textBox.ClearTextOnFocus = false
    textBox.MultiLine = true
    textBox.Parent = frame

    closeBtn.Size = UDim2.new(0, 100, 0, 30)
    closeBtn.Position = UDim2.new(0.5, -50, 1, -40)
    closeBtn.Text = "Копировать и Закрыть"
    closeBtn.BackgroundColor3 = Color3.new(0, 0.5, 0)
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.MouseButton1Click:Connect(function()
        setclipboard and setclipboard(fullText) -- Функция эксплойта для копирования
        screenGui:Destroy()
    end)
    closeBtn.Parent = frame
end

local sec = requestDuration()
if sec then
    startRecording(sec)
end