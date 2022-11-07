while wait() do
	wait()
 
	wait()
	repeat wait() until game.Players.LocalPlayer.Character
if script.Parent.Parent.Name == "Template" then return end
script.Parent.Text = "x" .. game.Players.LocalPlayer.InventoryFolder:FindFirstChild(tostring(script.Parent.Parent)).Value
	
end