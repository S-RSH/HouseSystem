local DataManager = require(game.ServerStorage.DataManager) 
 
game.Players.PlayerAdded:connect(function(plr)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	
	local Cash = Instance.new("IntValue")
	Cash.Name = "Cash" 
	Cash.Parent = leaderstats
	
	
	
----------------dataSave/Load-----------------	
	local data = DataManager:GetData(plr)
	repeat 
		task.wait() 
		data = DataManager:GetData(plr)
	until data
	
	Cash.Value = data.Cash
	
	Cash.Changed:Connect(function()
		DataManager:UpdateData(plr, "Cash", Cash.Value)
	end)
end)

