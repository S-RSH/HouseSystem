while wait() do
	local plr = game.Players.LocalPlayer
	repeat wait() until plr.Character
	if script.Parent.Name == "Template" then return end
	if plr.InventoryFolder:FindFirstChild(tostring(script.Parent.Name)).Value <= 0 then
		script.Parent:Destroy()
	end
end
