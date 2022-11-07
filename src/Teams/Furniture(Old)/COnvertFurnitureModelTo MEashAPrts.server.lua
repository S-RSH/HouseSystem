for i, model in pairs(game.ReplicatedStorage.HouseModule.Furniture:GetChildren())do
	local Handle = model.Handle
	local ShopGuiInfo = model.ShopGuiInfo
	for ii, v in ipairs(ShopGuiInfo:GetChildren())do
		v.Parent = Handle
	end
	ShopGuiInfo:Destroy()
	Handle.Name = model.Name
	Handle.Parent = game.ReplicatedStorage.HouseModule.Furniture
	model:Destroy()
end