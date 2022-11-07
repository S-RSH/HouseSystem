
local LocalPlayer = game.Players.LocalPlayer
local HouseInfo = LocalPlayer:WaitForChild("HouseInfo")
local IsPlayerInRoomValue = HouseInfo:WaitForChild("IsPlayerInRoom")
local PlayerGuiHouseModuleFolder = script.Parent.Parent

IsPlayerInRoomValue.Changed:Connect(function()
	local isPlayerInRoom = IsPlayerInRoomValue.Value
	for i, screenGui in ipairs(PlayerGuiHouseModuleFolder.Gui:GetChildren()) do
		screenGui.Enabled = isPlayerInRoom and true or false
	end
	PlayerGuiHouseModuleFolder.Gui.LockDoor.Enabled = true
end)

for i, screenGui in ipairs(PlayerGuiHouseModuleFolder.Gui:GetChildren()) do
	screenGui.Enabled = false
end
PlayerGuiHouseModuleFolder.Gui.LockDoor.Enabled = true