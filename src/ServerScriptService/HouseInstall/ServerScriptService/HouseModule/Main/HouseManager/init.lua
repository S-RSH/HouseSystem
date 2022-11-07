--Services--
local Players = game.Players
local ServerStorageHouseModuleFolder = game.ServerStorage.HouseModule

--Modules--
local HouseListModule = require(script.HouseListModule)
local HouseSignModule = require(script.HouseSignModule)
local HouseDataModule = require(script.HouseDataModule)
local RoomModule = require(script.RoomModule)
local HouseProximityPromptModule = require(script.HouseProximityPromptModule)
local ShopModule = require(script.ShopModule)


local HouseManager = {}

local function SetUpHouseInfo(player)
	local folderClone = ServerStorageHouseModuleFolder.SetUp:Clone()
	folderClone.Name = "HouseInfo"
	folderClone.Parent = player
	return folderClone
end

local function ApplyDataInInventory(inventoryData, Inventory)
	local folder = {
		Floor = Inventory:WaitForChild("Floor");
		Wallpaper = Inventory:WaitForChild("Wallpaper");
		Furniture = Inventory:WaitForChild("Furniture");
	}
	local function AddDataInFolder(folder, dataArray)
		for i, v in pairs(dataArray)do
			if folder:FindFirstChild(v) then
				--already has one(increase number of it)
				folder[v].Value += 1
			else
				-- create new data
				local item = Instance.new("IntValue")
				item.Name = v
				item.Value = 1
				item.Parent = folder
			end
		end
	end
	
	for i, v in pairs(inventoryData)do
		AddDataInFolder(folder[i], v)
	end
	--AddDataInFolder(Floor, inventoryData["Floor"])
	--AddDataInFolder(Wallpaper, inventoryData["Wallpaper"])
	--AddDataInFolder(Furniture, inventoryData["Furniture"])
end

local function OnPlayerAdded(player)
	local HouseInfoFolder = SetUpHouseInfo(player)
	
	local assignedHouse = HouseListModule:AssignEmptyHouseToPlayer(player)
	
	HouseSignModule:UpdateSignOf(assignedHouse, player.Name)
	local room = RoomModule:AddRoom(assignedHouse)
	HouseProximityPromptModule:SetupPromptInRoom(room)
	RoomModule:EmptyRoom(assignedHouse)
	
	HouseInfoFolder:WaitForChild("RoomModel").Value = room
	
	local data = HouseDataModule:GetDataAsync(player)
	local Inventory = HouseInfoFolder:WaitForChild("Inventory")
	ApplyDataInInventory(data.Inventory, Inventory)
	RoomModule:ApplyRoomData(player, room, data)
end
Players.PlayerAdded:Connect(OnPlayerAdded)

local houseList = HouseListModule.HouseList
HouseProximityPromptModule:SetupPrompt(houseList)

local function OnPlayerRemoving(player)
	local playerHouse = HouseListModule:GetHouseFromPlayer(player)

	HouseListModule:EmptyHouse(playerHouse)
	HouseSignModule:UpdateSignOf(playerHouse)
	RoomModule:EmptyRoom(playerHouse)
end
Players.PlayerRemoving:Connect(OnPlayerRemoving)

--OnRoomUpdateEvent:Connect(function(player, updateData)
--	HouseDataModule:UpdateData(player, updateData)
--end)

return HouseManager
