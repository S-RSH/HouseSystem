local PlayerGuiHouseModuleFolder = script.Parent.Parent
local ReplicatedStorageHouseModuleFolder = game.ReplicatedStorage.HouseModule


local function ChangeFloorShopVisible(IsVisible)
	PlayerGuiHouseModuleFolder.Gui.FloorShop.ScrollingFrame.Visible = IsVisible
end
local function ChangeWallpaperShopVisible(IsVisible)
	PlayerGuiHouseModuleFolder.Gui.WallpaperShop.ScrollingFrame.Visible = IsVisible
end
local function ChangeFurnitureShopVisible(IsVisible)
	PlayerGuiHouseModuleFolder.Gui.FurnitureShop.ShopBG.Visible = IsVisible
end
local function ChangeInventoryVisible(IsVisible)
	PlayerGuiHouseModuleFolder.Gui.Inventory.ScrollingFrame.Visible = IsVisible
	PlayerGuiHouseModuleFolder.Gui.Inventory.SearchBar.Visible = IsVisible
	PlayerGuiHouseModuleFolder.Gui.Inventory.Delete.Visible = IsVisible
	PlayerGuiHouseModuleFolder.Gui.Inventory.RotateBar.Visible = IsVisible
	PlayerGuiHouseModuleFolder.Gui.Inventory.RotateButton.Visible = IsVisible
	PlayerGuiHouseModuleFolder.Gui.Inventory.IsItOn.Value = IsVisible
end


local FloorShop = PlayerGuiHouseModuleFolder.Gui.FloorShop
local WallpaperShop = PlayerGuiHouseModuleFolder.Gui.WallpaperShop
local FurnitureShop = PlayerGuiHouseModuleFolder.Gui.FurnitureShop
local Inventory = PlayerGuiHouseModuleFolder.Gui.Inventory




ChangeFloorShopVisible(false)
ChangeWallpaperShopVisible(false)
ChangeFurnitureShopVisible(false)
ChangeInventoryVisible(false)

FloorShop:WaitForChild("Open").Activated:Connect(function()
	local IsShopVisible = FloorShop.ScrollingFrame.Visible

	if IsShopVisible then
		ChangeFloorShopVisible(false)
	else
		ChangeFloorShopVisible(true)
		ChangeWallpaperShopVisible(false)
		ChangeFurnitureShopVisible(false)
		ChangeInventoryVisible(false)
	end
end)
WallpaperShop:WaitForChild("Open").Activated:Connect(function()
	local IsShopVisible = WallpaperShop.ScrollingFrame.Visible

	if IsShopVisible then
		ChangeWallpaperShopVisible(false)
	else
		ChangeFloorShopVisible(false)
		ChangeWallpaperShopVisible(true)
		ChangeFurnitureShopVisible(false)
		ChangeInventoryVisible(false)
	end
end)
FurnitureShop:WaitForChild("Open").Activated:Connect(function()
	local IsShopVisible = FurnitureShop.ShopBG.Visible

	if IsShopVisible then
		ChangeFurnitureShopVisible(false)
	else
		ChangeFloorShopVisible(false)
		ChangeWallpaperShopVisible(false)
		ChangeFurnitureShopVisible(true)
		ChangeInventoryVisible(false)
	end
end)


Inventory:WaitForChild("Open").Activated:Connect(function()
	local IsShopVisible = Inventory.IsItOn.Value

	if IsShopVisible then
		ChangeInventoryVisible(false)
	else
		ChangeFloorShopVisible(false)
		ChangeWallpaperShopVisible(false)
		ChangeFurnitureShopVisible(false)
		ChangeInventoryVisible(true)
	end
end)
