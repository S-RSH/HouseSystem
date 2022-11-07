local LocalPlayer = game.Players.LocalPlayer
local IsRoomOpenedValue = LocalPlayer:WaitForChild("HouseInfo"):WaitForChild("IsRoomOpened")

local ToggleRoomLockEvent = game.ReplicatedStorage.HouseModule.ToggleRoomLock

local StarterGuiHouseModuleFolder = script.Parent.Parent
local TextButton = StarterGuiHouseModuleFolder.Gui:WaitForChild("LockDoor"):WaitForChild("TextButton")

TextButton.BackgroundColor3 = Color3.new(1, 0, 0.0156863)
TextButton.Text = "Room Locked"
ToggleRoomLockEvent:FireServer(false)

local cooldown = true
TextButton.Activated:Connect(function()
	if not cooldown then return end
	cooldown = false
	if IsRoomOpenedValue.Value then
		ToggleRoomLockEvent:FireServer(false)
		TextButton.BackgroundColor3 = Color3.new(1, 0, 0.0156863)
		TextButton.Text = "Room Locked"
	else
		IsRoomOpenedValue.Value = true
		ToggleRoomLockEvent:FireServer(true)
		TextButton.BackgroundColor3 = Color3.new(0, 1, 0.117647)
		TextButton.Text = "Room Opened"
	end
	wait(0.5)
	cooldown = true
end)