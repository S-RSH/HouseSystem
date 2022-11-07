local wallpaperRE = game:GetService("ReplicatedStorage").HouseModule:WaitForChild("Wallpaper")
local floorRE = game:GetService("ReplicatedStorage").HouseModule:WaitForChild("Floor")
wallpaperRE.OnServerEvent:Connect(function(player,texture)
	local playerHouse = game:GetService("Workspace").HouseModule:WaitForChild("PlotFolder"):FindFirstChild(player.Name)
	for i,v in pairs(playerHouse:GetChildren()) do
		if(v.Name == "Wall") then
			v.Texture.Texture = "rbxassetid://"..texture
		end
	end
	
end)

floorRE.OnServerEvent:Connect(function(player,texture)
	local playerHouse = game:GetService("Workspace").HouseModule:WaitForChild("PlotFolder"):FindFirstChild(player.Name)
	for i,v in pairs(playerHouse:GetChildren()) do
		if(v.Name == "Floor") then
			v.Texture.Texture = "rbxassetid://"..texture
		end
	end

end)
