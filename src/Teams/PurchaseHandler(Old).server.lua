local items = game.ReplicatedStorage.HouseModule:WaitForChild("Items")
local DataStore2 = require(game.ServerStorage.DataStore2)
game.ReplicatedStorage.HouseModule:WaitForChild("OnItemBought").OnServerEvent:Connect(function(plr, itemBought)
	
	if itemBought and itemBought.Parent == items then
		
		
		local cash = plr.leaderstats.Cash
		
		if cash.Value >= itemBought.ShopGuiInfo.Price.Value then
			local cashStore = DataStore2("Cash", plr)
			cashStore:Increment(-itemBought.ShopGuiInfo.Price.Value)
			plr.InventoryFolder:FindFirstChild(itemBought.Name).Value += 1
			local furnStore = DataStore2(itemBought.Name,plr)
			furnStore:Set(plr.InventoryFolder:FindFirstChild(itemBought.Name).Value)
		elseif cash.Value <= itemBought.ShopGuiInfo.Price.Value then
			game.ReplicatedStorage.HouseModule.NotEnoughCash:FireClient(plr)

		end
	end
end)