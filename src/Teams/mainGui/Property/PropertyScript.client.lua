local Frame = script.Parent
local gemsFrame = Frame:WaitForChild("gems")
local moneyFrame = Frame:WaitForChild("money")

local player = game.Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local gemsValue = player:WaitForChild("Gems")
local moneyValue = player:WaitForChild("Money")

local function onValueChanged(valueObject, frameToChange)
	frameToChange.text.Text = valueObject.Value
end

moneyValue.Changed:Connect(function()
	onValueChanged(moneyValue, moneyFrame)
end)
gemsValue.Changed:Connect(function()
	onValueChanged(gemsValue, gemsFrame)
end)