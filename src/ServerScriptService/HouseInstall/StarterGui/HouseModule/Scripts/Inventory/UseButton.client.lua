if script.Parent:IsA("Script") then script.Enabled = false return end

local OUT_TEXT = "Out"
local EXIT_TEXT = "Exit"

local furnitureName = script.Parent.Parent.Name
local scrollingFrame = script.Parent.Parent.Parent
local CurrentFurnitureHoldingNameValue

local originText = script.Parent.Text
local originColor = script.Parent.BackgroundColor3

local ItemAmount = script.Parent.Parent:WaitForChild("ItemAmount")
local function IsAmountZero()
	local itemAmount = ItemAmount.Text:find("0")
	if itemAmount == 2 then
		return true
	else 
		return false
	end 
end
ItemAmount.Changed:Connect(function()
	if IsAmountZero() then
		script.Parent.Text = OUT_TEXT
		script.Parent.BackgroundColor3 = Color3.new(1, 0.145098, 0.156863)
	else
		script.Parent.Text = originText
		script.Parent.BackgroundColor3 = originColor
	end
end)

if furnitureName ~= "Template" then
	
	CurrentFurnitureHoldingNameValue  = scrollingFrame:WaitForChild("CurrentFurnitureHolding")
	
	CurrentFurnitureHoldingNameValue.Changed:Connect(function()
		if CurrentFurnitureHoldingNameValue.Value == furnitureName then
			script.Parent.Text = EXIT_TEXT
			script.Parent.BackgroundColor3 = Color3.new(1, 0.145098, 0.156863)
		elseif IsAmountZero() then
			script.Parent.Text = OUT_TEXT
			script.Parent.BackgroundColor3 = Color3.new(1, 0.145098, 0.156863)
		else
			script.Parent.Text = originText
			script.Parent.BackgroundColor3 = originColor
		end
	end)
	scrollingFrame:GetPropertyChangedSignal("Visible"):Connect(function()
		if IsAmountZero() then
			script.Parent.Text =OUT_TEXT
			script.Parent.BackgroundColor3 = Color3.new(1, 0.145098, 0.156863)
		else
			script.Parent.Text = originText
			script.Parent.BackgroundColor3 = originColor
		end
	end)
end


script.Parent.Activated:Connect(function()
	print("aaaaa", IsAmountZero())
	if IsAmountZero() then return end
	if CurrentFurnitureHoldingNameValue.Value == furnitureName then
		CurrentFurnitureHoldingNameValue.Value = ""
	else
		CurrentFurnitureHoldingNameValue.Value = furnitureName 
	end
end)


