--[[
    Animation Stealer (R6) with Full GUI
    Вор анимации с настройками через графический интерфейс
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Части тела для R6
local BODY_PARTS = {
    "Head",
    "Torso",
    "Left Arm",
    "Right Arm",
    "Left Leg",
    "Right Leg"
}

-- Функция для создания главного GUI
local function createMainGUI()
    -- Проверяем, есть ли уже GUI
    local existingGui = LocalPlayer.PlayerGui:FindFirstChild("AnimationStealerGUI")
    if existingGui then
        existingGui:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AnimationStealerGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Основной фрейм
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.new(0, 1, 0)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.Text = "Animation Stealer v2.0"
    title.TextColor3 = Color3.new(0, 1, 0)
    title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.Parent = mainFrame
    
    -- Кнопка закрытия
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 0, 0)
    closeBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 20
    closeBtn.Parent = mainFrame
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Выбор цели
    local targetLabel = Instance.new("TextLabel")
    targetLabel.Size = UDim2.new(0, 100, 0, 25)
    targetLabel.Position = UDim2.new(0, 10, 0, 40)
    targetLabel.Text = "Цель:"
    targetLabel.TextColor3 = Color3.new(1, 1, 1)
    targetLabel.BackgroundTransparency = 1
    targetLabel.TextXAlignment = Enum.TextXAlignment.Left
    targetLabel.Parent = mainFrame
    
    local targetBox = Instance.new("TextBox")
    targetBox.Size = UDim2.new(0, 150, 0, 25)
    targetBox.Position = UDim2.new(0, 60, 0, 40)
    targetBox.Text = LocalPlayer.Name
    targetBox.PlaceholderText = "Имя игрока"
    targetBox.TextColor3 = Color3.new(0, 0, 0)
    targetBox.BackgroundColor3 = Color3.new(1, 1, 1)
    targetBox.Parent = mainFrame
    
    -- Длительность записи
    local durationLabel = Instance.new("TextLabel")
    durationLabel.Size = UDim2.new(0, 100, 0, 25)
    durationLabel.Position = UDim2.new(0, 10, 0, 75)
    durationLabel.Text = "Секунд:"
    durationLabel.TextColor3 = Color3.new(1, 1, 1)
    durationLabel.BackgroundTransparency = 1
    durationLabel.TextXAlignment = Enum.TextXAlignment.Left
    durationLabel.Parent = mainFrame
    
    local durationBox = Instance.new("TextBox")
    durationBox.Size = UDim2.new(0, 150, 0, 25)
    durationBox.Position = UDim2.new(0, 60, 0, 75)
    durationBox.Text = "3"
    durationBox.PlaceholderText = "1-10"
    durationBox.TextColor3 = Color3.new(0, 0, 0)
    durationBox.BackgroundColor3 = Color3.new(1, 1, 1)
    durationBox.Parent = mainFrame
    
    -- FPS записи
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size = UDim2.new(0, 100, 0, 25)
    fpsLabel.Position = UDim2.new(0, 10, 0, 110)
    fpsLabel.Text = "FPS:"
    fpsLabel.TextColor3 = Color3.new(1, 1, 1)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.Parent = mainFrame
    
    local fpsBox = Instance.new("TextBox")
    fpsBox.Size = UDim2.new(0, 150, 0, 25)
    fpsBox.Position = UDim2.new(0, 60, 0, 110)
    fpsBox.Text = "30"
    fpsBox.PlaceholderText = "15-60"
    fpsBox.TextColor3 = Color3.new(0, 0, 0)
    fpsBox.BackgroundColor3 = Color3.new(1, 1, 1)
    fpsBox.Parent = mainFrame
    
    -- Формат вывода
    local formatLabel = Instance.new("TextLabel")
    formatLabel.Size = UDim2.new(0, 100, 0, 25)
    formatLabel.Position = UDim2.new(0, 10, 0, 145)
    formatLabel.Text = "Формат:"
    formatLabel.TextColor3 = Color3.new(1, 1, 1)
    formatLabel.BackgroundTransparency = 1
    formatLabel.TextXAlignment = Enum.TextXAlignment.Left
    formatLabel.Parent = mainFrame
    
    local formatDropdown = Instance.new("TextButton")
    formatDropdown.Size = UDim2.new(0, 150, 0, 25)
    formatDropdown.Position = UDim2.new(0, 60, 0, 145)
    formatDropdown.Text = "Полный (части тела)"
    formatDropdown.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    formatDropdown.TextColor3 = Color3.new(1, 1, 1)
    formatDropdown.Parent = mainFrame
    
    -- Статус
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 25)
    statusLabel.Position = UDim2.new(0, 10, 0, 180)
    statusLabel.Text = "Готов к записи"
    statusLabel.TextColor3 = Color3.new(0, 1, 0)
    statusLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    statusLabel.Parent = mainFrame
    
    -- Кнопка записи
    local recordBtn = Instance.new("TextButton")
    recordBtn.Size = UDim2.new(0, 150, 0, 40)
    recordBtn.Position = UDim2.new(0.5, -75, 1, -50)
    recordBtn.Text = "НАЧАТЬ ЗАПИСЬ"
    recordBtn.TextColor3 = Color3.new(1, 1, 1)
    recordBtn.BackgroundColor3 = Color3.new(0, 0.5, 0)
    recordBtn.Font = Enum.Font.SourceSansBold
    recordBtn.TextSize = 18
    recordBtn.Parent = mainFrame
    
    local function startRecording()
        local targetName = targetBox.Text
        local duration = tonumber(durationBox.Text) or 3
        local fps = tonumber(fpsBox.Text) or 30
        
        -- Валидация
        if duration < 1 then duration = 1 end
        if duration > 10 then duration = 10 end
        if fps < 15 then fps = 15 end
        if fps > 60 then fps = 60 end
        
        -- Поиск цели
        local targetPlayer = Players:FindFirstChild(targetName)
        if not targetPlayer then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Name:lower():find(targetName:lower()) then
                    targetPlayer = player
                    break
                end
            end
        end
        
        if not targetPlayer then
            statusLabel.Text = "Игрок не найден!"
            statusLabel.TextColor3 = Color3.new(1, 0, 0)
            return
        end
        
        local targetChar = targetPlayer.Character
        if not targetChar then
            statusLabel.Text = "Персонаж не загружен!"
            statusLabel.TextColor3 = Color3.new(1, 0, 0)
            return
        end
        
        local rootPart = targetChar:FindFirstChild("HumanoidRootPart")
        if not rootPart then
            statusLabel.Text = "RootPart не найден!"
            statusLabel.TextColor3 = Color3.new(1, 0, 0)
            return
        end
        
        statusLabel.Text = "Запись... 0/" .. duration .. " сек"
        statusLabel.TextColor3 = Color3.new(1, 1, 0)
        recordBtn.Visible = false
        
        local framesData = {}
        local totalFrames = duration * fps
        local frameCount = 0
        local startTime = tick()
        
        local connection
        connection = RunService.Stepped:Connect(function()
            frameCount = frameCount + 1
            local elapsed = tick() - startTime
            
            statusLabel.Text = string.format("Запись... %.1f/%d сек", elapsed, duration)
            
            if frameCount > totalFrames then
                connection:Disconnect()
                showResult(framesData, targetName, duration, fps)
                screenGui:Destroy()
                return
            end
            
            local rootCF = rootPart.CFrame
            local keyframeString = ""
            
            for i, partName in ipairs(BODY_PARTS) do
                local part = targetChar:FindFirstChild(partName)
                if part then
                    local relativeCF = rootCF:ToObjectSpace(part.CFrame)
                    local pos = relativeCF.Position
                    local rot = relativeCF.Rotation
                    
                    keyframeString = keyframeString .. string.format("%s:%.3f:%.3f:%.3f:%.1f:%.1f:%.1f", 
                        partName, pos.X, pos.Y, pos.Z, rot.X, rot.Y, rot.Z)
                    
                    if i < #BODY_PARTS then
                        keyframeString = keyframeString .. "|"
                    end
                end
            end
            table.insert(framesData, keyframeString)
        end)
    end
    
    local function showResult(frames, targetName, duration, fps)
        local resultGui = Instance.new("ScreenGui")
        resultGui.Name = "AnimationResultGUI"
        resultGui.ResetOnSpawn = false
        resultGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        local resultFrame = Instance.new("Frame")
        resultFrame.Size = UDim2.new(0, 600, 0, 500)
        resultFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
        resultFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
        resultFrame.BorderSizePixel = 2
        resultFrame.BorderColor3 = Color3.new(0, 1, 0)
        resultFrame.Active = true
        resultFrame.Draggable = true
        resultFrame.Parent = resultGui
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 30)
        title.Text = string.format("Анимация игрока %s (%d сек, %d fps)", targetName, duration, fps)
        title.TextColor3 = Color3.new(0, 1, 0)
        title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        title.Parent = resultFrame
        
        local fullText = table.concat(frames, ";")
        
        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.new(1, -20, 1, -80)
        textBox.Position = UDim2.new(0, 10, 0, 40)
        textBox.Text = fullText
        textBox.TextWrapped = true
        textBox.TextScaled = true
        textBox.MultiLine = true
        textBox.Font = Enum.Font.Code
        textBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        textBox.TextColor3 = Color3.new(0, 1, 0)
        textBox.ClearTextOnFocus = false
        textBox.Parent = resultFrame
        
        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(0, 150, 0, 30)
        copyBtn.Position = UDim2.new(0.5, -175, 1, -40)
        copyBtn.Text = "Копировать в буфер"
        copyBtn.BackgroundColor3 = Color3.new(0, 0.5, 0)
        copyBtn.TextColor3 = Color3.new(1, 1, 1)
        copyBtn.Parent = resultFrame
        copyBtn.MouseButton1Click:Connect(function()
            if setclipboard then
                setclipboard(fullText)
                copyBtn.Text = "Скопировано!"
                wait(1)
                copyBtn.Text = "Копировать в буфер"
            else
                copyBtn.Text = "setclipboard не доступен"
            end
        end)
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 150, 0, 30)
        closeBtn.Position = UDim2.new(0.5, 25, 1, -40)
        closeBtn.Text = "Закрыть"
        closeBtn.BackgroundColor3 = Color3.new(0.5, 0, 0)
        closeBtn.TextColor3 = Color3.new(1, 1, 1)
        closeBtn.Parent = resultFrame
        closeBtn.MouseButton1Click:Connect(function()
            resultGui:Destroy()
        end)
    end
    
    recordBtn.MouseButton1Click:Connect(startRecording)
end

-- Создаем GUI при запуске
createMainGUI()

-- Горячая клавиша для открытия (F2)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F2 then
        createMainGUI()
    end
end)

print("Animation Stealer GUI загружен! Нажми F2 для открытия")
