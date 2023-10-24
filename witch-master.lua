local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Function to create parts
local function createPart(size, position, color, parent)
	local part = Instance.new("Part")
	part.Size = size
	part.Position = position
	part.BrickColor = BrickColor.new(color)
	part.Anchored = true
	part.CanCollide = false
	part.Parent = parent
	return part
end

-- Function to weld parts together
local function weldParts(parent, child)
	local weld = Instance.new("WeldConstraint")
	weld.Parent = parent
	weld.Part0 = parent
	weld.Part1 = child
end

local function createWitchMaster()
	local witchMaster = Instance.new("Model")
	witchMaster.Name = "WitchMaster"
	witchMaster.Parent = Workspace

	-- Create the head
	local head = createPart(Vector3.new(4, 4, 4), Vector3.new(0, 2, 0), "Really black", witchMaster)

	-- Create the nose
	local nose = createPart(Vector3.new(0.5, 2, 0.5), head.Position + Vector3.new(0, 0, 2.25), "Peach", witchMaster)

	-- Create the hat
	local hatBase = createPart(Vector3.new(4.5, 0.5, 4.5), head.Position + Vector3.new(0, 2.25, 0), "Really black", witchMaster)
	local hatCone = createPart(Vector3.new(4, 7, 4), hatBase.Position + Vector3.new(0, 3.75, 0), "Really black", witchMaster)
	local hatBand = createPart(Vector3.new(4.5, 0.25, 4.5), hatBase.Position + Vector3.new(0, 0.375, 0), "Bright red", witchMaster)

	-- Set the cone of the hat to have the pointy mesh
	local hatMesh = Instance.new("SpecialMesh", hatCone)
	hatMesh.MeshType = Enum.MeshType.FileMesh
	hatMesh.MeshId = "rbxassetid://9756362"
	hatMesh.Scale = Vector3.new(1.25, 1.5, 1.25)

	-- Weld parts together
	weldParts(head, nose)
	weldParts(head, hatBase)
	weldParts(hatBase, hatCone)
	weldParts(hatBase, hatBand)
	
	witchMaster.PrimaryPart = head

	return witchMaster
end

local function createMachine()
	local machine = Instance.new("Model", Workspace)
	machine.Name = "WitchMachine"

	local base = createPart(Vector3.new(6, 1, 6), Vector3.new(10, 0.5, 0), "Dark stone grey", machine)
	local leftWall = createPart(Vector3.new(1, 5, 6), base.Position + Vector3.new(-2.5, 2.5, 0), "Dark stone grey", machine)
	local rightWall = createPart(Vector3.new(1, 5, 6), base.Position + Vector3.new(2.5, 2.5, 0), "Dark stone grey", machine)

	machine.PrimaryPart = base

	return machine
end

local function moveWitchMasterToMachine(witchMaster, machine)
	local targetPos = machine.PrimaryPart.Position + Vector3.new(0, 3, 0)
	witchMaster:SetPrimaryPartCFrame(CFrame.new(targetPos))
	witchMaster.Parent = machine
end

createWitchMaster()
wait(5) -- Increased waiting time
local machine = createMachine()
wait(5)

local witchMaster = Workspace:WaitForChild("WitchMaster")
moveWitchMasterToMachine(witchMaster, machine)

local Players = game:GetService("Players")

while true do
	local allPlayers = Players:GetPlayers()
	local targetPlayer = allPlayers[math.random(#allPlayers)]
	local character = targetPlayer.Character or targetPlayer.CharacterAdded:Wait()

	local targetPos = character.HumanoidRootPart.Position
	local machinePos = machine.PrimaryPart.Position
	local direction = (targetPos - machinePos).unit
	local speed = 0.2
	local hasReachedTarget = false  -- Added condition to track if the machine reached the target

	while (targetPos - machinePos).Magnitude > 5 and not hasReachedTarget do
		machine:SetPrimaryPartCFrame(CFrame.new(machinePos + direction * speed))
		machinePos = machine.PrimaryPart.Position
		wait(0.1)

		-- Check if the machine has reached the target player
		if (targetPos - machinePos).Magnitude <= 5 then
			hasReachedTarget = true
		end
	end

	-- Allow the machine to keep moving towards other random players
	wait(2)  -- Adjust the wait time before selecting a new target player
end