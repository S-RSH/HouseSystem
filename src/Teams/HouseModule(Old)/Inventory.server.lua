
local DataStoreService = game:GetService("DataStoreService"):GetDataStore("SaveData")
local placedItems = game:GetService("DataStoreService"):GetDataStore("PlacedItemsDataStore2")




local claimEvent = game:GetService("ReplicatedStorage").HouseModule:WaitForChild("PlayerClaimed")
claimEvent.Event:Connect(function(player)
	local pItems = placedItems:GetAsync(player.UserId)
	local lab = workspace.HouseModule.PlotFolder:WaitForChild(player.Name)
	local furnThing = lab.PlacedFurniture
	
	for i=1,#pItems do
		local v = pItems[i]
		local furn = game.ReplicatedStorage.HouseModule.Items:FindFirstChild(v[1]):Clone()
		furn.Parent = furnThing
		furn:SetPrimaryPartCFrame(lab.Plot.Floor.CFrame + Vector3.new(v[2],v[3],v[4]))
		furn:SetPrimaryPartCFrame(furn:GetPrimaryPartCFrame() * CFrame.Angles(0,v[5],0))
	end

end)
game.Players.PlayerRemoving:Connect(function(plr)
	
	

	local items = {}
	local players = game.Workspace.HouseModule:FindFirstChild("PlotFolder"):GetChildren()
	
	local lab = game.Workspace.HouseModule.PlotFolder:FindFirstChild(plr.Name) 
	local theItems = lab:WaitForChild("PlacedFurniture")
	for i,v in pairs(theItems:GetChildren()) do
		if(v:IsA("Model")) then
			local vector,axis = v:GetPrimaryPartCFrame():toAxisAngle()
			local pos = v.PrimaryPart.Position - lab.Plot.Floor.Position
			table.insert(items,{v.Name,pos.x,pos.y,pos.z,axis})
		end
	end

	placedItems:SetAsync(plr.UserId,items)
	
	lab:Destroy()
end)
