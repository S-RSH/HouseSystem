local UseEvent =game:GetService("ReplicatedStorage").HouseModule:WaitForChild("UseItem")

local PlaceFolder = game:GetService("ReplicatedStorage").HouseModule:WaitForChild("PlacementItem")
local DeleteItem=game:GetService("ReplicatedStorage").HouseModule:WaitForChild("DeleteItem")
UseEvent.OnServerEvent:Connect(function(Player,PreviewClone,PreviewCframe)
	local Real=  PlaceFolder:FindFirstChild(PreviewClone):Clone()
 
	Real:SetPrimaryPartCFrame(PreviewCframe)
	Real.Parent = game:GetService("Workspace").HouseModule:WaitForChild("PlotFolder"):FindFirstChild(Player.Name).PlacedFurniture
 
	
end)
local DataStore2 = require(game.ServerStorage.DataStore2)

DeleteItem.OnServerEvent:Connect(function(Player,mouseTarget)
	
	if mouseTarget.Name == "MovePart" and mouseTarget:IsA("BasePart") then
		if mouseTarget~=nil then
			local furnStore = DataStore2(mouseTarget.Parent.Name,Player)
			Player.InventoryFolder:FindFirstChild(mouseTarget.Parent.Name).Value += 1
			furnStore:Set(Player.InventoryFolder:FindFirstChild(mouseTarget.Parent.Name).Value)
			if mouseTarget.Parent ~= nil then
				mouseTarget.Parent:Destroy()
			end
			
	 end
	end
end)
 