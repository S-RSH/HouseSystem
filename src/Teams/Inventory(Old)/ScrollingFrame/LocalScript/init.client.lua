local plr = game.Players.LocalPlayer
local InventoryModule = require(game.ReplicatedStorage.HouseModule.InventoryModuleScript)
repeat wait()until plr.Character
while wait() do

	for i,v in pairs(plr:GetChildren()) do
		if v.Name == "InventoryFolder"and v:IsA("Folder") then
			for _, InventoryFol in pairs(v:GetChildren()) do
				if InventoryFol:IsA("IntValue") or InventoryFol:IsA("NumberValue")  then

					if script.Parent:FindFirstChild(tostring(InventoryFol.Name)) then  
					else
						if   plr.InventoryFolder:FindFirstChild(tostring(InventoryFol.Name)).Value  > 0 then
							local Template = script.Template:Clone()
							Template.Parent = script.Parent
							Template.Name = InventoryFol.Name

							Template.Description.Text = tostring(InventoryModule.InventoryInfo[InventoryFol.Name].Description)
							Template.ItemName.Text = tostring(InventoryModule.InventoryInfo[InventoryFol.Name].ItemName)
							Template.Icon.Image  = tostring(InventoryModule.InventoryInfo[InventoryFol.Name].Icon)
						end
					end

				end
			end
		end

	end
	wait(1)
end