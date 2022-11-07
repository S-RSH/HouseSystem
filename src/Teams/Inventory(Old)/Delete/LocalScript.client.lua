local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local CanDelete = false

script.Parent.MouseButton1Click:Connect(function()
	if CanDelete == false then
		CanDelete = true

		script.Parent.Visible = false
		script.Parent.Parent.ScrollingFrame.Visible = false
		script.Parent.Parent.Open.Visible = false
		script.Parent.Parent.SearchBar.Visible = false
		script.Parent.Parent.Exit.Visible = true

		mouse.Button1Up:Connect(function()
			if mouse.Target ~=nil then
				if CanDelete == true then
					game.ReplicatedStorage.HouseModule.DeleteItem:FireServer(mouse.Target)

				end
			end


			mouse.Move:Connect(function()
				if CanDelete == true then
					if mouse.Target~=nil then
						if mouse.Target.Name == "MovePart" and mouse.Target:IsA("BasePart") then
							mouse.Target.Color = Color3.fromRGB(255, 65, 65)
							mouse.Target.Transparency = 0.5

						else
							for _,Move in pairs(game.Workspace:GetDescendants()) do
								if Move.Name == "MovePart" and Move:IsA("BasePart")  then
									Move.Transparency=1
								end
							end
						end
					end


				end

			end)

		end)

		script.Parent.Parent.Exit.MouseButton1Click:Connect(function()
			if CanDelete == true then
				CanDelete  = false

				script.Parent.Parent.Exit.Visible = false
				script.Parent.Parent.ScrollingFrame.Visible  = true
				script.Parent.Parent.SearchBar.Visible = true
				script.Parent.Parent.Delete.Visible = true

				script.Parent.Parent.Open.Visible = true
				for i ,v in pairs(game.Workspace:GetDescendants()) do
					if v.Name == "MovePart" and v:IsA("BasePart") then
						v.Transparency = 1
					end
				end
			end


		end)
	end
end)