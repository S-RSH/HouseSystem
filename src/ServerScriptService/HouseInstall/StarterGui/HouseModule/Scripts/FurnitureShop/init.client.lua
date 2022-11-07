local ReplicatedStorageHouseModuleFolder = game.ReplicatedStorage.HouseModule
local localPlayer = game.Players.LocalPlayer

local StarterGuiHouseModuleFolder = script.Parent.Parent
local ShopBG = StarterGuiHouseModuleFolder.Gui:WaitForChild("FurnitureShop"):WaitForChild("ShopBG")
local itemScroller = ShopBG:WaitForChild("ItemScroller")
local itemPreview = ShopBG:WaitForChild("ItemPreview")


ShopBG.Visible = false
itemPreview.Visible = false

local HouseInfo = localPlayer:WaitForChild("HouseInfo")
local Inventory = HouseInfo:WaitForChild("Inventory")

local FurnitureFolder = ReplicatedStorageHouseModuleFolder.Furniture
local FurnitureInventory = Inventory:WaitForChild("Furniture")


local UIGridLayoutHandler = script.UIGridLayoutHandler:Clone()
UIGridLayoutHandler.Parent = itemScroller:WaitForChild("UIGridLayout")
UIGridLayoutHandler.Enabled = true

for i, item in pairs(FurnitureFolder:GetChildren()) do
	
	local name = item.Name
	local price = item.Price.Value
	local desc = item.Description.Value
	local topView = item:FindFirstChild("TopView") and true or false	
	
	local itemSelection = ShopBG.ItemSelection:Clone()
	itemSelection.Name = item.Name
	
	local cam = Instance.new("Camera")
	cam.Parent = itemSelection.ItemView
	itemSelection.ItemView.CurrentCamera = cam
	
	local displayPart = item:Clone()
	displayPart.Anchored = true
	displayPart.CFrame = CFrame.new()
	displayPart.Parent = itemSelection.ItemView
	
	if topView then
		cam.CFrame = CFrame.new(displayPart.Position 
			+ (displayPart.CFrame.UpVector * displayPart.Size.Magnitude)
			, displayPart.Position) * CFrame.Angles(0, 0, math.rad(90))
	else
		cam.CFrame = CFrame.new(displayPart.Position 
			+ (displayPart.CFrame.LookVector * displayPart.Size.Magnitude)
			, displayPart.Position)
	end
	
	itemSelection.Parent = itemScroller
	itemSelection.Visible = true
	
	itemSelection.ItemView:Clone().Parent = item -- create ItemSelection Clone for Inventory Image
	
	
	itemSelection.MouseButton1Click:Connect(function()
		
		local itemInInventory = FurnitureInventory:FindFirstChild(name)
		local itemAmount = itemInInventory and itemInInventory.Value or 0
		
		itemPreview.ItemName.Text = name
		itemPreview.BuyButton.Text = "Buy for "..price.."$"
		itemPreview.ItemDescription.Text = desc
		itemPreview.ItemAmount.Text = "ItemAmount: x"..itemAmount
		
		local previousPart = itemPreview.ItemImage:FindFirstChildWhichIsA("BasePart")
		if previousPart then previousPart:Destroy() end
		if itemPreview.ItemImage:FindFirstChild("Camera") then itemPreview.ItemImage.Camera:Destroy() end
		
		local cam2 = cam:Clone()
		cam2.Parent = itemPreview.ItemImage
		itemPreview.ItemImage.CurrentCamera = cam2
		
		displayPart:Clone().Parent = itemPreview.ItemImage
		
		itemPreview.Visible = true
	end)
end

local previousItemName = ""
itemPreview.BuyButton.MouseButton1Click:Connect(function()
	itemPreview.BuyButton.Active = false
	previousItemName = itemPreview.ItemName.Text
	ReplicatedStorageHouseModuleFolder.BuyFurniture:FireServer(itemPreview.ItemName.Text)
	wait(0.5)
	if previousItemName == itemPreview.ItemName.Text then -- 1초 기다리는 사이 다른 상품 고른 경우 제외하기
		
		--update ItemAmount
		local itemInInventory = FurnitureInventory:FindFirstChild(itemPreview.ItemName.Text)
		local itemAmount = itemInInventory and itemInInventory.Value or 0
		itemPreview.ItemAmount.Text = "ItemAmount: x"..itemAmount
	end
	itemPreview.BuyButton.Active = true
end)


local lua_plus = require(script.Parent:WaitForChild("lua_plus"))
local UIListLayout = itemScroller.UIGridLayout
local UpdateDirection = Enum.ScrollingDirection.Y 

lua_plus.update_canvas_based_on_children(itemScroller, UIListLayout, UpdateDirection)
itemScroller.DescendantAdded:Connect(function()
	wait(0.1)
	lua_plus.update_canvas_based_on_children(itemScroller, UIListLayout, UpdateDirection)
end)

itemScroller.DescendantRemoving:Connect(function()
	wait(0.1)
	lua_plus.update_canvas_based_on_children(itemScroller, UIListLayout, UpdateDirection)
end)



ShopBG.XButton.MouseButton1Click:Connect(function()
	ShopBG.Visible = false
end)