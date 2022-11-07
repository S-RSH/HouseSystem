local ReplicatedStorageHouseModuleFolder = game.ReplicatedStorage.HouseModule

local HouseDataModule = require(script.Parent.HouseDataModule)

local PRICE_OF_FLOOR = ReplicatedStorageHouseModuleFolder.PriceOfFloor.Value
local PRICE_OF_WALLPAPER = ReplicatedStorageHouseModuleFolder.PriceOfWallpaper.Value

local BuyFloorEvent= ReplicatedStorageHouseModuleFolder.BuyFloor
local BuyWallpaperEvent = ReplicatedStorageHouseModuleFolder.BuyWallpaper
local ChangeFloorEvent = ReplicatedStorageHouseModuleFolder.ChangeFloor
local ChangeWallpaperEvent = ReplicatedStorageHouseModuleFolder.ChangeWallpaper

local BuyFurnitureEvent = ReplicatedStorageHouseModuleFolder.BuyFurniture

local FloorFolder = ReplicatedStorageHouseModuleFolder.Floor
local WallFolder = ReplicatedStorageHouseModuleFolder.Wallpaper
local FurnitureFolder = ReplicatedStorageHouseModuleFolder.Furniture
--local function DoesPlayerAlreadyHaveItem(player, typeOf, nameOfBuyingItem)
--	local Inventory = player.HouseInfo.Inventory[typeOf]
--	local itemFound = Inventory:FindFirstChild(nameOfBuyingItem)
--	if itemFound then
--		return true
--	else
--		return false
--	end
--end

local function Buy(player, typeOf, nameOfBuyingItem, price, ReturnEvent)
	local leaderstats = player.leaderstats
	local Cash = leaderstats.Cash
	
	if Cash.Value > price then
		
		Cash.Value -= price -- cash data is handled from leaderboard script
		
		
		local updateData = {
			typeOf = "Inventory";
			inventoryType = typeOf;
			data = nameOfBuyingItem;
		}

		HouseDataModule:UpdateData(player, updateData)
		
		local Inventory = player.HouseInfo.Inventory
		local newItem = Inventory[typeOf]:FindFirstChild(nameOfBuyingItem)
		if not newItem then
			newItem = Instance.new("IntValue")
			newItem.Name = nameOfBuyingItem
			newItem.Parent = Inventory[typeOf]
		end
		newItem.Value += 1
		
		ReturnEvent:FireClient(player)
	else
		warn("not Enough Cash")
	end
end


local function GetPrice(typeOf, nameOfBuyingItem)
	if typeOf == "Floor" then
		local priceValue = FloorFolder[nameOfBuyingItem]:FindFirstChild("Price")
		return priceValue and priceValue.Value or PRICE_OF_FLOOR
		
	elseif typeOf == "Wallpaper" then
		local priceValue = WallFolder[nameOfBuyingItem]:FindFirstChild("Price")
		return priceValue and priceValue.Value or PRICE_OF_WALLPAPER
		
	elseif typeOf == "Furniture" then
		return FurnitureFolder[nameOfBuyingItem].Price.Value
	end
end

BuyFloorEvent.OnServerEvent:Connect(function(player, nameOfBuyingItem)
	local price = GetPrice("Floor", nameOfBuyingItem)
	Buy(player, "Floor", nameOfBuyingItem, price, BuyFloorEvent)
end)
BuyWallpaperEvent.OnServerEvent:Connect(function(player, nameOfBuyingItem)
	local price = GetPrice("Wallpaper", nameOfBuyingItem)
	Buy(player, "Wallpaper", nameOfBuyingItem, PRICE_OF_WALLPAPER, BuyWallpaperEvent)
end)
BuyFurnitureEvent.OnServerEvent:Connect(function(player, nameOfBuyingItem)
	local price = GetPrice("Furniture", nameOfBuyingItem) 
	Buy(player, "Furniture", nameOfBuyingItem, price, BuyFurnitureEvent)
end)

local ShopModule = {}


return ShopModule
