-- Not made by me but its so cool i decided to add it lol credits to some guy on forum


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local FloodModel = ReplicatedStorage:WaitForChild("Flood"):Clone()
FloodModel.Parent = workspace

local FloodPart = FloodModel.PrimaryPart or FloodModel:FindFirstChildWhichIsA("BasePart")
assert(FloodPart, "Flood model requires PrimaryPart or BasePart")

local DieModule = require(ReplicatedStorage:WaitForChild("Die"))

local CurrentHeight = 0
local BaseSpeed = 0.65
local Amplitude = 1.4
local Frequency = 2.8
local SecondaryFreq = 1.6
local AccelRate = 0.0025
local DeathThreshold = 0
local SlowThreshold = 3
local SplashEmitter = FloodPart:FindFirstChild("SplashParticles")

local ActivePlayers = {}

local function CalculateWave(Time)
	return math.sin(Time * Frequency) * Amplitude +
	       math.cos(Time * SecondaryFreq) * (Amplitude * 0.5)
end

local function GetAcceleration(Height)
	return AccelRate * Height * 0.06
end

local function UpdateFlood(DeltaTime)
	local Wave = CalculateWave(tick())
	local Accel = GetAcceleration(CurrentHeight)
	local Speed = BaseSpeed + Accel + Wave * 0.1
	
	CurrentHeight = CurrentHeight + Speed * DeltaTime
	
	local TargetY = CurrentHeight - FloodPart.Size.Y / 2
	local NewCFrame = CFrame.new(FloodPart.Position.X, TargetY, FloodPart.Position.Z)
	
	local Tween = TweenService:Create(
		FloodPart,
		TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{CFrame = NewCFrame}
	)
	Tween:Play()
	
	if SplashEmitter then
		SplashEmitter:Emit(math.clamp(math.floor(Speed * 5), 5, 25))
	end
end

local function GetLegHeight(Character)
	local Root = Character:FindFirstChild("HumanoidRootPart")
	if not Root then return nil end
	
	local Humanoid = Character:FindFirstChild("Humanoid")
	local HipOffset = Humanoid and Humanoid.HipHeight + 1 or 3
	
	return Root.Position.Y - (Root.Size.Y / 2) - HipOffset
end

local function CheckPlayer(Player, FloodTopY)
	local Character = Player.Character
	if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
	
	local LegY = GetLegHeight(Character)
	if not LegY then return end
	
	local HeightAbove = LegY - FloodTopY
	
	if HeightAbove <= SlowThreshold then
		local Humanoid = Character:FindFirstChild("Humanoid")
		if Humanoid then
			local SlowFactor = math.clamp(1 - HeightAbove / SlowThreshold, 0, 1)
			Humanoid.WalkSpeed = 16 * (1 - SlowFactor * 0.5)
			Humanoid.JumpPower = 50 * (1 - SlowFactor * 0.7)
		end
	end
	
	if HeightAbove <= DeathThreshold then
		DieModule(Player)
		ActivePlayers[Player] = nil
	end
end

local function AddPlayer(Player)
	ActivePlayers[Player] = true
	
	if Player.Character then
		local Humanoid = Player.Character:FindFirstChild("Humanoid")
		if Humanoid then
			Humanoid.WalkSpeed = 16
			Humanoid.JumpPower = 50
		end
	end
	
	Player.CharacterAdded:Connect(function()
		task.wait()
		local Humanoid = Player.Character:FindFirstChild("Humanoid")
		if Humanoid then
			Humanoid.WalkSpeed = 16
			Humanoid.JumpPower = 50
		end
	end)
end

local function RemovePlayer(Player)
	ActivePlayers[Player] = nil
end

for _, Player in ipairs(Players:GetPlayers()) do
	AddPlayer(Player)
end

Players.PlayerAdded:Connect(AddPlayer)
Players.PlayerRemoving:Connect(RemovePlayer)

RunService.Heartbeat:Connect(function(DeltaTime)
	local FloodTopY = CurrentHeight + FloodPart.Size.Y / 2
	
	for Player in pairs(ActivePlayers) do
		if Player.Character then
			CheckPlayer(Player, FloodTopY)
		end
	end
	
	UpdateFlood(DeltaTime)
end)
