local InventoryMod = require(game.ReplicatedStorage.HouseModule.InventoryModuleScript)
local RunService = game:GetService("RunService")
local PlacementFolder = game:GetService("ReplicatedStorage").HouseModule:WaitForChild("PlacementItem")
local UseEvent = game:GetService("ReplicatedStorage").HouseModule:WaitForChild("UseItem")
local plr = game.Players.LocalPlayer

local UIS = game:GetService("UserInputService")
local MaxDistance = 25
local CanPlace = false
local mouse = plr:GetMouse()
local maxplacingdistance = 25
local PlotClaimed = plr:WaitForChild("PlotClaimed")
local CanRotate = false
local placing = false
script.Parent.MouseButton1Click:Connect(function()

	if script.Parent.Parent.Name == "Template" or PlotClaimed.Value == false then return end

	if placing ==false then

		placing  = true

		wait(.1)
		script.Parent.Visible = false
		script.Parent.Parent.No.Visible = false

		script.Parent.Parent.Parent.Parent.Delete.Visible = false
		script.Parent.Parent.Use.Visible = true
		script.Parent.Parent.Parent.Visible = false
		script.Parent.Parent.Parent.Parent.Open.Visible= false
		script.Parent.Parent.Parent.Parent.SearchBar.Visible = false
		script.Parent.Parent.Parent.Parent.Exit.Visible = true
		script.Parent.Parent.Parent.Parent.RotateButton.Visible =true
		local PreviewClone = PlacementFolder:WaitForChild(tostring(script.Parent.Parent.Name)):Clone()
		PreviewClone.Parent= game.Workspace.HouseModule
		local RotateAmount= 0  
		for i ,v in pairs(PreviewClone:GetDescendants()) do
			if	v:IsA("BasePart") then
				v.Transparency = 0.5

				v.CanCollide = false

			end

		end
		PreviewClone.MovePart.Color  = Color3.fromRGB(43, 255, 60)

		CanRotate = true
		script.Parent.Parent.Parent.Parent.RotateButtonMobile.Visible = true
		script.Parent.Parent.Parent.Parent.RotateBar.Visible = true
		script.Parent.Parent.Parent.Parent.RotateButton.Text = "X(Rotate):On"
		script.Parent.Parent.Parent.Parent.RotateButton.BackgroundColor3=
			Color3.fromRGB(48, 255, 141)
		if	script.Parent.Parent.Parent.Parent.RotateBar.Text ~= ""
			or  tonumber(script.Parent.Parent.Parent.Parent.RotateBar.Text) ~= nil then
			if CanRotate == true then


				if tonumber(script.Parent.Parent.Parent.Parent.RotateBar.Text) > 180 then

					script.Parent.Parent.Parent.Parent.RotateBar.Text = "180"
					RotateAmount=180
				else 

					RotateAmount = RotateAmount+ tonumber(script.Parent.Parent.Parent.Parent.RotateBar.Text)
				end

			end
		end


		UIS.InputEnded:Connect(function(Key)

			if Key.KeyCode == Enum.KeyCode.X then

				CanRotate = false
				script.Parent.Parent.Parent.Parent.RotateButtonMobile.Visible = false
				script.Parent.Parent.Parent.Parent.RotateBar.Visible = false	
				script.Parent.Parent.Parent.Parent.RotateButton.Text = "R(Rotate):Off"

				script.Parent.Parent.Parent.Parent.RotateButton.BackgroundColor3=
					Color3.fromRGB(255,84,84)

			end  


		end)

		script.Parent.Parent.Parent.Parent.RotateButtonMobile.MouseButton1Click:Connect(function()
			if CanRotate == true then

				if tonumber(script.Parent.Parent.Parent.Parent.RotateBar.Text) > 180 then

					script.Parent.Parent.Parent.Parent.RotateBar.Text = "180"
					RotateAmount=180
				else 

					RotateAmount = RotateAmount+ tonumber(script.Parent.Parent.Parent.Parent.RotateBar.Text)
				end

			end
		end)
		RunService.RenderStepped:Connect(function()
			if placing  == true then
				mouse.TargetFilter = PreviewClone
				if PreviewClone:FindFirstChild("MovePart") then

					for i,v in pairs(game.Workspace.HouseModule.PlotFolder:GetDescendants()) do
						if v.Name== "PlayerName" and v:IsA("StringValue") then
							if v.Value ==tostring(plr.Name) then
								local Char = plr.Character or plr.CharacterAdded:Wait()
								local Mag=(v.Parent:FindFirstChild("DetectPart").Position-PreviewClone.PrimaryPart.Position).Magnitude

								local PreviewCframe = CFrame.new(mouse.Hit.Position.X,mouse.Hit.Position.Y
									+PreviewClone.PrimaryPart.Size.Y/2,
									mouse.Hit.Position.Z)
								local Angles = CFrame.Angles(0,math.rad(RotateAmount),0)
								PreviewClone:SetPrimaryPartCFrame(PreviewCframe*Angles)

								if Mag<= MaxDistance  then
									CanPlace = true
									PreviewClone.PrimaryPart.Color = Color3.fromRGB(48, 255, 141)
								else
									CanPlace = false
									PreviewClone.PrimaryPart.Color = Color3.fromRGB(255, 0, 0)
								end
							end
						end


					end
				end
			end
		end)

		script.Parent.Parent.Parent.Parent.Exit.MouseButton1Click:Connect(function()
			script.Parent.Parent.Parent.Parent.Open.Visible = true
			script.Parent.Parent.Parent.Parent.ScrollingFrame.Visible = true
			script.Parent.Parent.Parent.Parent.RotateButton.Visible = false
			script.Parent.Parent.Parent.Parent.SearchBar.Visible = true
			script.Parent.Parent.Parent.Parent.Delete.Visible = true
			script.Parent.Parent.Parent.Parent.Exit.Visible = false
			script.Parent.Parent.Parent.Parent.RotateBar.Visible = false

			PreviewClone:Destroy()
		end)

		mouse.Button1Up:Connect(function()
			if placing  == true and CanPlace == true then

				placing  = false


				script.Parent.Parent.Parent.Parent.Exit.Visible =false
				script.Parent.Parent.Parent.Parent.ScrollingFrame.Visible =true
				script.Parent.Parent.Parent.Parent.Open.Visible =true
				script.Parent.Parent.Parent.Parent.Delete.Visible = true
				script.Parent.Parent.Parent.Parent.RotateButton.Visible =false
				script.Parent.Parent.Parent.Parent.SearchBar.Visible =true
				script.Parent.Parent.Parent.Parent.RotateBar.Visible = false

				if PreviewClone~=nil then


					UseEvent:FireServer(PreviewClone.Name,PreviewClone.PrimaryPart.CFrame)
					PreviewClone:Destroy()
					script.Parent.Parent.Parent.Parent.Exit.Visible =false
					script.Parent.Parent.Parent.Parent.ScrollingFrame.Visible =true
					script.Parent.Parent.Parent.Parent.Open.Visible =true
					script.Parent.Parent.Parent.Parent.Delete.Visible = true
					script.Parent.Parent.Parent.Parent.RotateButton.Visible =false
					script.Parent.Parent.Parent.Parent.SearchBar.Visible =true
					script.Parent.Parent.Parent.Parent.RotateBar.Visible = false

				end

			end

		end)

	end

end)
