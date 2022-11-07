local prompt = script.Parent.ProximityPrompt
local claimedValue = script.Parent.Parent.Parent.Claimed
local houseValue = script.Parent.Parent.Parent.HouseNumber
local roomsFolder = game:GetService("Workspace").HouseModule:WaitForChild("PlotFolder")

local claimEvent = game:GetService("ReplicatedStorage").HouseModule:WaitForChild("PlayerClaimed")
local lockEvent = game:GetService("ReplicatedStorage").HouseModule.Lock
local unlockEvent = game:GetService("ReplicatedStorage").HouseModule.Unlock
local occupyflag = false

function claimHouse(player)
	local playerInventory = player.PlayerGui.HouseModule.InventoryGui
	local playerWallpapers = player.PlayerGui.HouseModule.WallpaperInventory
	local playerFloors = player.PlayerGui.HouseModule.FloorInventory
	local playerFurnShop = player.PlayerGui.HouseModule.FurnitureShop
	if claimedValue.Value == "none" and prompt.ActionText == "Claim" and player.Claimed.Value == false then
		local plotModel = game:GetService("ReplicatedStorage").HouseModule:WaitForChild("PlotFolder"):FindFirstChild("Room"..houseValue.Value)
		claimedValue.Value = player.Name
		prompt.ActionText =  "Enter"
		local plotClone = plotModel:Clone()
		plotClone.Name = player.Name
		plotClone.Parent = game.Workspace.HouseModule.PlotFolder
		local plotClaim = plotClone.Plot.PlotClaim
		local playerName = plotClone.Plot.PlayerName
		plotClaim.Value = true
		playerName.Value = player.Name
		local PlotClaimed = player.PlotClaimed
		PlotClaimed.Value = true
		player.Claimed.Value = true
		player.HouseNo.Value = houseValue.Value
		claimEvent:Fire(player)
	end
	if claimedValue.Value == player.Name then
		local room = roomsFolder:FindFirstChild(player.Name)
		local teleportPart = room.Spawn
		player.Character:FindFirstChild("HumanoidRootPart").CFrame = teleportPart.CFrame
		playerInventory.Enabled = true
		playerInventory.ScrollingFrame.Visible = false
		playerWallpapers.Enabled = true
		playerWallpapers.ScrollingFrame.Visible = false
		playerFloors.Enabled = true
		playerFurnShop.Enabled = true
	end

	if claimedValue.Value ~= player.Name then
		local playerHouse = game:GetService("Workspace").HouseModule:WaitForChild("PlotFolder"):FindFirstChild(claimedValue.Value)
		local isLocked = playerHouse.isLocked
		if isLocked.Value == false then
		local teleportPart = playerHouse.Spawn
			player.Character:FindFirstChild("HumanoidRootPart").CFrame = teleportPart.CFrame
		elseif isLocked.Value == true then
			prompt.ActionText =  "Door locked!"
			wait(3)
			prompt.ActionText =  "Enter"
		end


	end

end



function playerRemovalHandle(player)
	local playerHouse = game:GetService("Workspace").HouseModule:WaitForChild("PlotFolder"):FindFirstChild(claimedValue.Value)
	if player.Name == claimedValue.Value then
		claimedValue.Value = "none"
		prompt.ActionText =  "Claim"
		--playerHouse:Destroy()
	end
end

lockEvent.OnServerEvent:Connect(function(player)
	local playerHouse = game:GetService("Workspace").HouseModule:WaitForChild("PlotFolder"):FindFirstChild(player.Name)
	local isLocked = playerHouse.isLocked
	isLocked.Value = true
	
end)
unlockEvent.OnServerEvent:Connect(function(player)
	local playerHouse = game:GetService("Workspace").HouseModule:WaitForChild("PlotFolder"):FindFirstChild(player.Name)
	local isLocked = playerHouse.isLocked
	isLocked.Value = false
end)


game.Players.PlayerAdded:Connect(function(player)
	if claimedValue.Value == "none" and prompt.ActionText == "Claim" and player:WaitForChild("Claimed").Value == false then
		if occupyflag then
			return
		end
		occupyflag = true
		local plotModel = game:GetService("ReplicatedStorage").HouseModule:WaitForChild("PlotFolder"):FindFirstChild("Room"..houseValue.Value)
		claimedValue.Value = player.Name
		prompt.ActionText =  "Enter"
		local plotClone = plotModel:Clone()
		plotClone.Name = player.Name
		plotClone.Parent = game.Workspace.HouseModule.PlotFolder
		local plotClaim = plotClone.Plot.PlotClaim
		local playerName = plotClone.Plot.PlayerName
		plotClaim.Value = true
		playerName.Value = player.Name
		local PlotClaimed = player.PlotClaimed
		PlotClaimed.Value = true
		player.Claimed.Value = true
		player.HouseNo.Value = houseValue.Value
		claimEvent:Fire(player)
		wait(1)
		occupyflag = false
	end
	
end)


game.Players.PlayerRemoving:Connect(playerRemovalHandle)

prompt.Triggered:Connect(claimHouse)