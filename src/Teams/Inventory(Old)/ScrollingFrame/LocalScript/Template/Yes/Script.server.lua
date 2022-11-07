local DataStore2 = require(game.ServerStorage.DataStore2)
game.ReplicatedStorage.HouseModule.UseItem.OnServerEvent:Connect(function(player,Item)
	local furnStore = DataStore2(tostring(Item),player)
	player.InventoryFolder:FindFirstChild(tostring(Item)).Value =
		player.InventoryFolder:FindFirstChild(tostring(Item)).Value  - 1
	furnStore:Set(player.InventoryFolder:FindFirstChild(tostring(Item)).Value)
end)
