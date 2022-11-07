
a = game.ReplicatedStorage.HouseModule.Floor
for i, v in ipairs(a:GetChildren())do
	v.Texture.Parent = a
	v:Destroy()
end