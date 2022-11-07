local Players = game:GetService("Players")
-- local ServerScriptService = game:GetService("ServerScriptService")
--local Workspace = game:GetService("Workspace")
local dataStore = game:GetService("DataStoreService")
local DataStore2 = require(game.ServerStorage.DataStore2)
DataStore2.Combine("DATA","Cash","Chair","Sofa","Lamp",
	"Trunk_01",	"Bench_01",	"Bench_02",	"Bench_03",	"Bookshelf_01",
	"Bookshelf_02",	"Bookshelf_03",	"Chair_01",	"Chair_02",	"Chair_03",
	"Closet_01",	"Closet_02",	"Closet_03",	"Closet_04",	"RoundTable_01",
	"RoundTable_02",	"Shelf_01",	"Shelf_02",	"Stool_01",	"Stool_02",	"Table_01",
	"Table_02",	"Table_03",	"Table_04"
)

Players.PlayerAdded:Connect(function(player)
	print(player.Name)
	local cashStore = DataStore2("Cash", player)
	local furnStore = DataStore2("FurnitureStore",player)
	local chairStore = DataStore2("Chair",player)
	local sofaStore = DataStore2("Sofa",player)
	local lampStore = DataStore2("Lamp",player)
	local Trunk_01Store = DataStore2("Trunk_01",player)
	local Bench_01Store = DataStore2("Bench_01",player)
	local Bench_02Store = DataStore2("Bench_02",player)
	local Bench_03Store = DataStore2("Bench_03",player)
	local Bookshelf_01Store = DataStore2("Bookshelf_01",player)
	local Bookshelf_02Store = DataStore2("Bookshelf_02",player)
	local Bookshelf_03Store = DataStore2("Bookshelf_03",player)
	local Chair_01Store = DataStore2("Chair_01",player)
	local Chair_02Store = DataStore2("Chair_02",player)
	local Chair_03Store = DataStore2("Chair_03",player)
	local Closet_01Store = DataStore2("Closet_01",player)
	local Closet_02Store = DataStore2("Closet_02",player)
	local Closet_03Store = DataStore2("Closet_03",player)
	local Closet_04Store = DataStore2("Closet_04",player)
	local RoundTable_01Store = DataStore2("RoundTable_01",player)
	local RoundTable_02Store = DataStore2("RoundTable_02",player)
	local Shelf_01Store = DataStore2("Shelf_01",player)
	local Shelf_02Store = DataStore2("Shelf_02",player)
	local Stool_01Store = DataStore2("Stool_01",player)
	local Stool_02Store = DataStore2("Stool_02",player)
	local Table_01Store = DataStore2("Table_01",player)
	local Table_02Store = DataStore2("Table_02",player)
	local Table_03Store = DataStore2("Table_03",player)
	local Table_04Store = DataStore2("Table_04",player)

	--Leaderstats start
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	

	local cash = Instance.new("IntValue")
	cash.Name = "Cash" 
	cash.Value = cashStore:Get(10)
	cash.Parent = leaderstats
	
	local claimed = Instance.new("BoolValue")
	claimed.Name = "Claimed" 
	claimed.Value = false
	claimed.Parent = player

	
	local houseNumber = Instance.new("IntValue")
	houseNumber.Name = "HouseNo" 
	houseNumber.Value = 0
	houseNumber.Parent = player

	
	local InventoryFolder = Instance.new("Folder")
	InventoryFolder.Name = "InventoryFolder"
	InventoryFolder.Parent = player
	
	local pItems = game:GetService("ReplicatedStorage").HouseModule:WaitForChild("Items")
	for i,v in pairs(pItems:GetChildren()) do
		if(v:IsA("Model")) then
			print(v)
			local value = Instance.new("IntValue")
			value.Name = v.Name
			local store = DataStore2(v.Name,player)
			value.Value = store:Get(0)
			value.Parent = InventoryFolder
		end
	end
  
	
	
	local PlotClaimed = Instance.new("BoolValue",player)
	PlotClaimed.Value = false
	PlotClaimed.Name = "PlotClaimed"

	

	cashStore:OnUpdate(function(newValue)
		cash.Value = newValue
	end)
	chairStore:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Chair").Value = newValue
	end)
	sofaStore:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Sofa").Value = newValue
	end)
	lampStore:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Lamp").Value = newValue
	end)
	Trunk_01Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Trunk_01").Value = newValue
	end)
	Bench_01Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Bench_01").Value = newValue
	end)
	Bench_02Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Bench_02").Value = newValue
	end)
	Bench_03Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Bench_03").Value = newValue
	end)
	Bookshelf_01Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Bookshelf_01").Value = newValue
	end)
	Bookshelf_02Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Bookshelf_02").Value = newValue
	end)
	Bookshelf_03Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Bookshelf_03").Value = newValue
	end)
	Chair_01Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Chair_01").Value = newValue
	end)
	Chair_02Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Chair_02").Value = newValue
	end)
	Chair_03Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Chair_03").Value = newValue
	end)
	Closet_01Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Closet_01").Value = newValue
	end)
	Closet_02Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Closet_02").Value = newValue
	end)
	Closet_03Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Closet_03").Value = newValue
	end)
	Closet_04Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Closet_04").Value = newValue
	end)
	RoundTable_01Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("RoundTable_01").Value = newValue
	end)
	RoundTable_02Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("RoundTable_02").Value = newValue
	end)
	Shelf_01Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Shelf_01").Value = newValue
	end)
	Shelf_02Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Shelf_02").Value = newValue
	end)
	Stool_01Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Stool_01").Value = newValue
	end)
	Stool_02Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Stool_02").Value = newValue
	end)
	Table_01Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Table_01").Value = newValue
	end)
	Table_02Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Table_02").Value = newValue
	end)
	Table_03Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Table_03").Value = newValue
	end)
	Table_04Store:OnUpdate(function(newValue)
		player.InventoryFolder:FindFirstChild("Table_04").Value = newValue
	end)
	leaderstats.Parent = player
end)