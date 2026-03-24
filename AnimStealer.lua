local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local lastRecordedData = ""

local ScreenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "R6_Universal_Recorder"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 320)
Frame.Position = UDim2.new(0.5, -150, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "R6 LOOP DETECTOR"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Font = Enum.Font.GothamBold

local TargetInput = Instance.new("TextBox", Frame)
TargetInput.PlaceholderText = "Target Username"
TargetInput.Size = UDim2.new(0.8, 0, 0, 35)
TargetInput.Position = UDim2.new(0.1, 0, 0.2, 0)
TargetInput.Text = Players.LocalPlayer.Name

local DurationInput = Instance.new("TextBox", Frame)
DurationInput.PlaceholderText = "Max Sec"
DurationInput.Size = UDim2.new(0.35, 0, 0, 35)
DurationInput.Position = UDim2.new(0.1, 0, 0.35, 0)
DurationInput.Text = "15"

local FPSInput = Instance.new("TextBox", Frame)
FPSInput.PlaceholderText = "FPS"
FPSInput.Size = UDim2.new(0.35, 0, 0, 35)
FPSInput.Position = UDim2.new(0.55, 0, 0.35, 0)
FPSInput.Text = "30"

local RecordBtn = Instance.new("TextButton", Frame)
RecordBtn.Text = "START RECORDING"
RecordBtn.Size = UDim2.new(0.8, 0, 0, 45)
RecordBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
RecordBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
RecordBtn.TextColor3 = Color3.new(1, 1, 1)
RecordBtn.Font = Enum.Font.GothamBold

local CopyBtn = Instance.new("TextButton", Frame)
CopyBtn.Text = "COPY TO CLIPBOARD"
CopyBtn.Size = UDim2.new(0.8, 0, 0, 45)
CopyBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CopyBtn.TextColor3 = Color3.new(1, 1, 1)
CopyBtn.Visible = false

local function round(num)
	return math.floor(num * 1000 + 0.5) / 1000
end

local function getFrameHash(frameData)
	local hash = ""
	for jointName, cf in pairs(frameData) do
		hash = hash .. jointName .. table.concat(cf, ",")
	end
	return hash
end

local function record()
	local targetName = TargetInput.Text:lower()
	local maxDuration = tonumber(DurationInput.Text) or 15
	local fps = tonumber(FPSInput.Text) or 30
	local targetPlayer = nil
	
	for _, p in pairs(Players:GetPlayers()) do
		if p.Name:lower():sub(1, #targetName) == targetName then
			targetPlayer = p; break
		end
	end
	
	if not targetPlayer or not targetPlayer.Character then 
		RecordBtn.Text = "NOT FOUND"; task.wait(1); RecordBtn.Text = "START RECORDING"; return 
	end
	
	local char = targetPlayer.Character
	local torso = char:FindFirstChild("Torso")
	local root = char:FindFirstChild("HumanoidRootPart")
	
	local joints = {
		["RootJoint"] = root:FindFirstChild("RootJoint"),
		["Neck"] = torso:FindFirstChild("Neck"),
		["Right Shoulder"] = torso:FindFirstChild("Right Shoulder"),
		["Left Shoulder"] = torso:FindFirstChild("Left Shoulder"),
		["Right Hip"] = torso:FindFirstChild("Right Hip"),
		["Left Hip"] = torso:FindFirstChild("Left Hip")
	}
	
	local frames = {}
	local hashes = {} 
	local stopRecording = false
	local loopFoundIndex = nil
	
	RecordBtn.Text = "SCANNING FOR LOOP..."
	RecordBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	CopyBtn.Visible = false
	
	local startTime = tick()
	local interval = 1/fps
	local threshold = 12 
	
	while (tick() - startTime < maxDuration) and not stopRecording do
		local frameData = {}
		for name, joint in pairs(joints) do
			if joint then
				local x, y, z, R00, R01, R02, R10, R11, R12, R20, R21, R22 = joint.Transform:GetComponents()
				frameData[name] = {round(x),round(y),round(z),round(R00),round(R01),round(R02),round(R10),round(R11),round(R12),round(R20),round(R21),round(R22)}
			end
		end
		
		local currentHash = getFrameHash(frameData)
		
		if #frames > 30 then
			for i = 1, #frames - threshold do
				if hashes[i] == currentHash then
					local isMatch = true
					loopFoundIndex = i
					stopRecording = true
					break
				end
			end
		end
		
		if not stopRecording then
			table.insert(frames, frameData)
			table.insert(hashes, currentHash)
		end
		task.wait(interval)
	end
	
	if stopRecording and loopFoundIndex then
		local loopedFrames = {}
		for i = loopFoundIndex, #frames do
			table.insert(loopedFrames, frames[i])
		end
		frames = loopedFrames
		RecordBtn.Text = "LOOP CAPTURED!"
	else
		RecordBtn.Text = "MAX TIME REACHED"
	end
	
	lastRecordedData = HttpService:JSONEncode({FPS = fps, Frames = frames})
	RecordBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
	CopyBtn.Visible = true
end

CopyBtn.MouseButton1Click:Connect(function()
	if lastRecordedData ~= "" then
		if setclipboard then
			setclipboard(lastRecordedData)
			CopyBtn.Text = "COPIED!"
			task.wait(2)
			CopyBtn.Text = "COPY TO CLIPBOARD"
		else
			warn("Executor doesn't support clipboard. Data in F9.")
			print(lastRecordedData)
		end
	end
end)

RecordBtn.MouseButton1Click:Connect(record)
