local BUYBUTTON_USE_TEXT = "Use"
local BUYBUTTON_USE_COLOR3 = Color3.new(0, 0.533333, 1)
local BUYBUTTON_NOT_ENOUGH_MONEY_TEXT = "Not Enough money"
local BUYBUTTON_COOLDOWN = 1
local BUYBUTTON_BUY_TEXT = "Buy for $%i"
local TypeOfItem = "Wallpaper"  -- "Wallpaper"

local StarterGuiHouseModuleFolder = script.Parent.Parent
local ScrollingFrame = StarterGuiHouseModuleFolder.Gui:WaitForChild("WallpaperShop"):WaitForChild("ScrollingFrame")
local TileTemplate = ScrollingFrame:WaitForChild("TileTemplate")
local ReplicatedStorageHouseModule = game.ReplicatedStorage.HouseModule

local TileListFolder = ReplicatedStorageHouseModule[TypeOfItem] --Wallpaper

local Price = ReplicatedStorageHouseModule["PriceOf"..TypeOfItem].Value

local localPlayer = game.Players.LocalPlayer
local leaderstats = localPlayer:WaitForChild("leaderstats")
local CashValue = leaderstats:WaitForChild("Cash")

local HouseInfoFolder = localPlayer:WaitForChild("HouseInfo")
local Inventory = HouseInfoFolder:WaitForChild("Inventory")
local function CheckInventoryInfo(typeOf, Name)
	if Inventory[typeOf]:FindFirstChild(Name) then 
		return true
	else
		return false
	end
end

local function ApplyInventoryInfoInList(typeOf)
	for i, frame in ipairs(ScrollingFrame:GetChildren())do
		if frame:FindFirstChild("Buy") then 
			if CheckInventoryInfo(typeOf, frame.Name) then
				frame.Buy.IsOwned.Value = true
				frame.Buy.Text = BUYBUTTON_USE_TEXT
				frame.Buy.BackgroundColor3 = BUYBUTTON_USE_COLOR3
			end
		end
	end
end

local function ChangeLayoutOrder()
	for i, frame in ipairs(ScrollingFrame:GetChildren())do
		if frame:FindFirstChild("Buy") then 
			if frame.Buy.IsOwned.Value == true then
				frame.LayoutOrder = -1
			end
		end
	end
end

local function SetUpShop(typeOf)
	for i, texture in ipairs(TileListFolder:GetChildren()) do
		local FrameClone = TileTemplate:Clone()
		FrameClone.Name = texture.Name
		FrameClone:WaitForChild("Description").Text = texture.Name
		FrameClone:WaitForChild("TextureId").Value = texture.Texture
		FrameClone:WaitForChild("TexturePreview").Image = texture.Texture
		local DoesPlayerHaveThisItem = CheckInventoryInfo(typeOf, texture.Name)
		FrameClone:WaitForChild("Buy"):WaitForChild("IsOwned").Value = DoesPlayerHaveThisItem
		if DoesPlayerHaveThisItem then
			FrameClone.Buy.Text = BUYBUTTON_USE_TEXT
			FrameClone.Buy.BackgroundColor3 = BUYBUTTON_USE_COLOR3
			FrameClone.LayoutOrder = -1
		else
			local price = texture:FindFirstChild("Price") and texture.Price.Value or Price
			FrameClone.Buy:WaitForChild("Price").Value = price
			FrameClone.Buy.Text = string.format(BUYBUTTON_BUY_TEXT, price)
		end
		FrameClone.Parent = ScrollingFrame
	end
	TileTemplate:Destroy()
end


local function OnBuyButtonActivated(name, IsOwned, typeOf, price) -- action == "Buy" or "Use"
	local action = IsOwned and "Use" or "Buy"
	if action == "Use"then
		ReplicatedStorageHouseModule["Change"..typeOf]:FireServer(name)
		return true -- send back success = true
	elseif action == "Buy" then
		if CashValue.Value > price then
			ReplicatedStorageHouseModule["Buy"..typeOf]:FireServer(name)
			-- will send back signal if bought successfully
			return true
		else
			return false
		end
	end
end

local function ConnectBuyButtonActivatedEvent(typeOf)
	for i, frame in ipairs(ScrollingFrame:GetChildren())do
		if frame:FindFirstChild("Buy") then -- waitforchild already done on ApplyInventoryInfo()
			frame.Buy.Activated:Connect(function()
				frame.Buy.Active = false
				local success = OnBuyButtonActivated(frame.Name, frame.Buy.IsOwned.Value, typeOf, frame.Buy.Price.Value)
				if success then
					wait(BUYBUTTON_COOLDOWN) -- cooldown
					frame.Buy.Active = true
				else
					local textSave = frame.Buy.Text
					frame.Buy.Text = BUYBUTTON_NOT_ENOUGH_MONEY_TEXT
					wait(1)
					frame.Buy.Text = textSave
					frame.Buy.Active = true
				end
			end)
		end
	end
end


SetUpShop(TypeOfItem)
ScrollingFrame:GetPropertyChangedSignal("Visible"):Connect(function()
	ApplyInventoryInfoInList(TypeOfItem)
	ChangeLayoutOrder()
end)
ConnectBuyButtonActivatedEvent(TypeOfItem)

ReplicatedStorageHouseModule["Buy"..TypeOfItem].OnClientEvent:Connect(function()
	ApplyInventoryInfoInList(TypeOfItem)
end)

ScrollingFrame.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder


-----autoResize----
local lua_plus = require(script.Parent:WaitForChild("lua_plus"))
local UIListLayout = ScrollingFrame:WaitForChild("UIListLayout") 
local UpdateDirection = Enum.ScrollingDirection.Y 

lua_plus.update_canvas_based_on_children(ScrollingFrame, UIListLayout, UpdateDirection)
ScrollingFrame.DescendantAdded:Connect(function()
	wait(0.1)
	lua_plus.update_canvas_based_on_children(ScrollingFrame, UIListLayout, UpdateDirection)
end)

ScrollingFrame.DescendantRemoving:Connect(function()
	wait(0.1)
	lua_plus.update_canvas_based_on_children(ScrollingFrame, UIListLayout, UpdateDirection)
end)