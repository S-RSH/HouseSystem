local floorRE = game:GetService("ReplicatedStorage").HouseModule:WaitForChild("Floor")
local texture = script.Parent.Parent.TextureId
script.Parent.MouseButton1Click:Connect(function(player)
	floorRE:FireServer(texture.Value)
end)