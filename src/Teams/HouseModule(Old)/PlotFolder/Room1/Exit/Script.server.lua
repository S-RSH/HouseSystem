local prompt = script.Parent.ProximityPrompt




function exitHouse(player)
	local frontDoor = game:GetService("Workspace").HouseModule:FindFirstChild("SuberbanHouse" .. 1).FrontDoorTp
	local playerInventory = player.PlayerGui.HouseModule.InventoryGui
	local playerWallpaperInv = player.PlayerGui.HouseModule.WallpaperInventory
	local playerFloorInv = player.PlayerGui.HouseModule.FloorInventory
	local lockGui = player.PlayerGui.HouseModule.LockGui
	local partyGui = player.PlayerGui.HouseModule.Party
	local FurnShopGui = player.PlayerGui.HouseModule.FurnitureShop
	playerInventory.Enabled = false
	playerWallpaperInv.Enabled = false
	playerFloorInv.Enabled = false
	lockGui.Enabled = false
	partyGui.Enabled = false
	playerInventory.ScrollingFrame.Visible = false
	FurnShopGui.Enabled = false
	player.Character:FindFirstChild("HumanoidRootPart").CFrame = frontDoor.CFrame
	
end






prompt.Triggered:Connect(exitHouse)











