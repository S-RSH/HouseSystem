local ReplicatedStorageHouseModuleFolder = game.ReplicatedStorage.HouseModule
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

--OverlapParams.OverlapParamsObjectMaxParts=1 
--OverlapParams.BruteForceAllSlow=false
--OverlapParams.RespectCanCollide=false
--OverlapParams.CollisionGroup="Default" 
--OverlapParams.FilterDescendantsInstances={}
local OverlapParamsObject = OverlapParams.new()

local localPlayer = game.Players.LocalPlayer

local HouseInfo = localPlayer:WaitForChild("HouseInfo")
local Inventory = HouseInfo:WaitForChild("Inventory")

local FurnitureFolder = ReplicatedStorageHouseModuleFolder.Furniture
local FurnitureInventory = Inventory:WaitForChild("Furniture")
local RoomFurnitureFolder = Inventory:WaitForChild("Room"):WaitForChild("Furniture")

local StarterGuiHouseModuleFolder = script.Parent.Parent
local InventoryGui = StarterGuiHouseModuleFolder.Gui:WaitForChild("Inventory")
local scrollingFrame = InventoryGui:WaitForChild("ScrollingFrame")

local function GetAmountOfInventoryFurniture(name)
	return FurnitureInventory[name].Value
end
local function GetAmountOfRoomFurniture(name)
	local RoomFurniture = RoomFurnitureFolder:FindFirstChild(name)
	return RoomFurniture and RoomFurniture.Value or 0
end

local function UpdateAmountText(name, manualUpdateNumber)
	
	local AmountOfInventoryFurniture = GetAmountOfInventoryFurniture(name) 
	local AmountOfInventoryOnlyFurniture 
	if manualUpdateNumber then
		AmountOfInventoryOnlyFurniture = manualUpdateNumber
	else
		AmountOfInventoryOnlyFurniture= AmountOfInventoryFurniture - GetAmountOfRoomFurniture(name)
	end

	scrollingFrame[name].ItemAmount.Text 
		= string.format("(%s/%s)", AmountOfInventoryOnlyFurniture, AmountOfInventoryFurniture)
end

local function createNewFrame(intValue)
	local furnitureName = intValue.Name
	local Template = scrollingFrame.Parent.Template:Clone()
	Template.Name = furnitureName
	Template.Description.Text = FurnitureFolder[furnitureName].Description.Value
	Template.ItemName.Text = furnitureName
	local iconSize = Template.Icon.Size
	local iconPosition = Template.Icon.Position
	local iconSizeConstraint = Template.Icon.SizeConstraint
	Template.Icon:Destroy()
	local UseButtonScript = script.UseButton:Clone()
	UseButtonScript.Parent = Template:WaitForChild("Use")
	UseButtonScript.Enabled = true
	
	--itemView is created at FurnitureShop script
	local icon = FurnitureFolder[furnitureName]:FindFirstChild("ItemView")
	if icon then
		local clone = icon:Clone()
		clone.Name = "Icon"
		clone.AnchorPoint = Vector2.new(0,0)
		clone.Position = UDim2.new(0,0,0,0)
		clone.Size = UDim2.new(.8,0,.8,0)
		clone.SizeConstraint = Enum.SizeConstraint.RelativeYY
		clone.Parent = Template
	end
	Template.Parent = scrollingFrame
	Template.Visible = true
end


	
local function UpdateInventoryList()
	local FurnitureInventoryList = FurnitureInventory:GetChildren()
	if #FurnitureInventoryList == 0 then
		scrollingFrame.Empty.Visible = true
	else
		scrollingFrame.Empty.Visible = false
	end
	for i, intValue in ipairs(FurnitureInventoryList)do
		local FurnitureName = intValue.Name
		if not scrollingFrame:FindFirstChild(FurnitureName) then
			createNewFrame(intValue)
			UpdateAmountText(FurnitureName)
		else
			UpdateAmountText(FurnitureName)
		end
	end	
end
UpdateInventoryList()

scrollingFrame:GetPropertyChangedSignal("Visible"):Connect(function()
	UpdateInventoryList()
end)

---------autoResize--------
local lua_plus = require(script.Parent:WaitForChild("lua_plus"))
local UIListLayout = scrollingFrame:WaitForChild("UIGridLayout") 
local UpdateDirection = Enum.ScrollingDirection.Y 

lua_plus.update_canvas_based_on_children(scrollingFrame, UIListLayout, UpdateDirection)
scrollingFrame.DescendantAdded:Connect(function()
	wait(0.1)
	lua_plus.update_canvas_based_on_children(scrollingFrame, UIListLayout, UpdateDirection)
end)

scrollingFrame.DescendantRemoving:Connect(function()
	wait(0.1)
	lua_plus.update_canvas_based_on_children(scrollingFrame, UIListLayout, UpdateDirection)
end)

------------RotateBar----------------
local RotateBar  = InventoryGui:WaitForChild('RotateBar')
function UpdateRotateBar()
	RotateBar.Text = tonumber(RotateBar.Text) or "" -- nil인 경우엔 ""로
end

RotateBar.Changed:Connect(UpdateRotateBar)

-----------SearchBar-------------------
local SearchBar  = InventoryGui:WaitForChild('SearchBar')
function UpdateSearchBar()
	local search = string.lower(SearchBar.Text) or string.upper(SearchBar.Text)
	for i ,v in pairs(scrollingFrame:GetChildren()) do
		if v:IsA("Frame") then
			if search~="" then
				local Result = string.lower(v.ItemName.Text) or string.upper(v.ItemName.Text)
				if string.find(Result,search) then

					v.Visible = true
				else
					v.Visible = false

				end
			else
				v.Visible = true
			end
		end
	end
end
SearchBar.Changed:Connect(UpdateSearchBar)

---------------------------Furniture Placement------------------------------------------------------
local mouse = localPlayer:GetMouse()

local HouseInfo = localPlayer:WaitForChild("HouseInfo")
local Room = HouseInfo:WaitForChild("RoomModel").Value
local IsPlayerInRoomValue = HouseInfo:WaitForChild("IsPlayerInRoom")
local furnitureFolder = ReplicatedStorageHouseModuleFolder:WaitForChild("Furniture") 

local selectionBox = Instance.new("SelectionBox")
selectionBox.LineThickness = 0.05
selectionBox.SurfaceColor3 = Color3.new(0.0862745, 0.870588, 0)
selectionBox.Color3 = Color3.new(0.0862745, 0.870588, 0)
selectionBox.SurfaceTransparency = 0.8
selectionBox.Name = "PlacementSelection"

local CurrentRotation = 0

local CurrentFurnitureHoldingNameValue = scrollingFrame.CurrentFurnitureHolding
local CurrentFurnitureHolding = nil
local function DestroyCurrentFurnitureHolding()
	CurrentRotation = 0
	if CurrentFurnitureHolding then
		CurrentFurnitureHolding:Destroy()
	end
	CurrentFurnitureHolding = nil
	CurrentFurnitureHoldingNameValue.Value = ""
end


local DeleteButton = scrollingFrame.Parent:WaitForChild("Delete")
local IsItOn = scrollingFrame.Parent:WaitForChild("IsItOn")

local CanDelete = false
local function ExitDeleteMode() -- Delete Exit Button also used for furniture placement mode exit
	CanDelete  = false
	selectionBox.Parent = nil
	DestroyCurrentFurnitureHolding()

	DeleteButton.Parent.Exit.Visible = false
	if IsItOn.Value then
		DeleteButton.Parent.ScrollingFrame.Visible  = true
		DeleteButton.Parent.SearchBar.Visible = true
		DeleteButton.Parent.Delete.Visible = true
	else
		DeleteButton.Parent.ScrollingFrame.Visible  = false
		DeleteButton.Parent.SearchBar.Visible = false
		DeleteButton.Parent.Delete.Visible = false
	end

end



local RotateBar = scrollingFrame.Parent:WaitForChild("RotateBar")
local function rotateCurrentFurniture(actionName, inputState)
	if inputState and inputState ~= Enum.UserInputState.Begin then
		return
	end
	if CurrentFurnitureHolding then
		local rotateAngle = tonumber(RotateBar.Text) or 90
		CurrentRotation += rotateAngle
	end
end
scrollingFrame.Parent.RotateButton.Activated:Connect(function()
	rotateCurrentFurniture(nil, false) --actionName, inputState
end)
ContextActionService:BindAction("RotateFurniture", rotateCurrentFurniture, false, Enum.KeyCode.R)

CurrentFurnitureHoldingNameValue.Changed:Connect(function()
	local furnitureName = CurrentFurnitureHoldingNameValue.Value
	if furnitureName ~= "" and furnitureFolder:FindFirstChild(furnitureName) then
		DeleteButton.Visible = false
		scrollingFrame.Visible = false
		DeleteButton.Parent.SearchBar.Visible = false
		DeleteButton.Parent.Exit.Visible = true
		
		selectionBox.Parent = nil
		selectionBox.SurfaceColor3 = Color3.new(0.0862745, 0.870588, 0)
		selectionBox.Color3 = Color3.new(0.0862745, 0.870588, 0)
		DestroyCurrentFurnitureHolding()
		local clone = furnitureFolder[furnitureName]:Clone()
		clone.Transparency = 0.5
		CurrentFurnitureHolding = clone
		clone.CanCollide = false
		clone.Anchored = true
		selectionBox.Parent = workspace
		selectionBox.Adornee = CurrentFurnitureHolding
		clone.Parent = workspace
		mouse.TargetFilter = clone
	end
end)

scrollingFrame:GetPropertyChangedSignal("Visible"):Connect(function()
	CurrentFurnitureHoldingNameValue.Value = ""
end)

local function IsWithinBoundary(pos)
	local MaxHeight = Room.Ceiling.Position.Y
	local floor = Room.Floor
	local fp = floor.Position
	local fs = floor.Size

	if pos.X > fp.X - fs.X/2 
		and pos.X < fp.X + fs.X/2 
		and pos.Z > fp.Z - fs.Z/2 
		and pos.Z < fp.Z + fs.Z/2  
		and pos.Y > fp.Y 
		and pos.Y < MaxHeight then
		return true
	else
		return false
	end
end

local function IsPartOverlapping(part)
	if #workspace:GetPartsInPart(part, OverlapParamsObject) >= 1 then
		return true
	else
		return false
	end
end


local cooldown =true
mouse.Button1Up:Connect(function()
	
	if IsPlayerInRoomValue.Value and  CurrentFurnitureHolding and IsWithinBoundary(CurrentFurnitureHolding.Position)  and not IsPartOverlapping(CurrentFurnitureHolding) and cooldown then
		cooldown = false

		local AmountOfInventoryFurniture = GetAmountOfInventoryFurniture(CurrentFurnitureHolding.Name) 
		local AmountOfRoomFurniture = GetAmountOfRoomFurniture(CurrentFurnitureHolding.Name)
		print(AmountOfInventoryFurniture , AmountOfRoomFurniture)
		local AmountOfInventoryOnlyFurniture = AmountOfInventoryFurniture - AmountOfRoomFurniture
		
		ReplicatedStorageHouseModuleFolder.PlaceFurniture:FireServer(CurrentFurnitureHolding.Name, CurrentFurnitureHolding.CFrame)
		
		local CurrentFurnitureHoldingNameSave = CurrentFurnitureHolding.Name
		if AmountOfInventoryOnlyFurniture <= 1 then
			ExitDeleteMode()
		end
		-- update after exit delete mode becuase ExitDeleteMode() also calls UpdateInventoryList()
		UpdateAmountText(CurrentFurnitureHoldingNameSave, AmountOfInventoryOnlyFurniture -1)
		
		task.wait(1)
		UpdateInventoryList()
		cooldown = true
	end
end)

-- leave room while holding furniture
IsPlayerInRoomValue.Changed:Connect(function()
	selectionBox.Parent = nil
	ExitDeleteMode()
end)


----------------------Inventory DeleteButton---------------------

local Room = HouseInfo:WaitForChild("RoomModel").Value
local IsPlayerInRoomValue = HouseInfo:WaitForChild("IsPlayerInRoom")




IsItOn.Changed:Connect(function()
	ExitDeleteMode()
end)

DeleteButton.MouseButton1Click:Connect(function()
	if not IsPlayerInRoomValue.Value then
		-- nothing happens when player is outside room
		CanDelete = false
		return
	end
	if CanDelete == false then
		CanDelete = true

		DeleteButton.Visible = false
		DeleteButton.Parent.ScrollingFrame.Visible = false
		--DeleteButton.Parent.Open.Visible = false
		DeleteButton.Parent.SearchBar.Visible = false
		DeleteButton.Parent.Exit.Visible = true
	end
end)




DeleteButton.Parent.Exit.MouseButton1Click:Connect(function()
	if CanDelete then
	--DeleteButton.Parent.Open.Visible = true
		for i ,v in pairs(Room.PlacedFurniture:GetChildren()) do
			if v:FindFirstChild("SelectionBox") then
				v.SelectionBox:Destroy()
			end
		end
	end
	ExitDeleteMode()
end)

local deleteSelectionBox = Instance.new("SelectionBox")
deleteSelectionBox.LineThickness = 0.1
deleteSelectionBox.SurfaceColor3 = Color3.new(1, 0, 0)
deleteSelectionBox.Color3 = Color3.new(1, 0, 0)
deleteSelectionBox.SurfaceTransparency = 0.7
mouse.Move:Connect(function()
	if CanDelete == true and mouse.Target~=nil 
		and mouse.Target.Parent.Name == "PlacedFurniture" 
		and mouse.Target.Parent.Parent == Room  then

		deleteSelectionBox.Parent = mouse.Target
		deleteSelectionBox.Adornee = mouse.Target

	else
		deleteSelectionBox.Parent = nil
		deleteSelectionBox.Adornee = nil
	end
end)

mouse.Button1Up:Connect(function()
	if CanDelete == true and mouse.Target then
		ReplicatedStorageHouseModuleFolder.DeleteFurniture:FireServer(mouse.Target)
	end
end)




local function CalculateCurrentFurnitureHoldingCFrame()
	local TargetSurfaceName = mouse.TargetSurface.Name
	local mousePosition = mouse.Hit.Position
	if TargetSurfaceName == "Top" then
		return CFrame.new(mousePosition) * CFrame.Angles(0,math.rad(CurrentRotation),0)  + Vector3.new(0,CurrentFurnitureHolding.Size.Y/2,0)
	elseif TargetSurfaceName == "Bottom" then
		return CFrame.new(mousePosition) * CFrame.Angles(math.rad(180),math.rad(CurrentRotation),0)  - Vector3.new(0,CurrentFurnitureHolding.Size.Y/2,0)
	else

		local unitRay  = workspace.CurrentCamera:ScreenPointToRay(mouse.X, mouse.Y, 1) --origin, Vector3.new(0, -1, 0));
		local ray = Ray.new(unitRay.Origin, unitRay.Direction * 1000)
		local hit, pos, normal = workspace:FindPartOnRayWithIgnoreList(ray,{CurrentFurnitureHolding, localPlayer.Character} ) 
		return CFrame.new(pos,pos+normal*15) * CFrame.Angles(-math.rad(90),math.rad(CurrentRotation),0) * CFrame.new(0,CurrentFurnitureHolding.Size.Y/2,0)
		
		--local SurfacePart = mouse.Target
		--local ZOrientation = SurfacePart.Orientation.Y
		--if TargetSurfaceName == "Left" then
		--	ZOrientation -= -90
		--elseif TargetSurfaceName == "Right" then
		--	ZOrientation -= 90
		--elseif TargetSurfaceName == "Front" then
		--	ZOrientation -= 0
		--elseif TargetSurfaceName == "Back" then
		--	ZOrientation -= 180
		--end	
		--print(SurfacePart.Orientation.Y, ZOrientation, TargetSurfaceName)
		--return CFrame.new(mousePosition) * CFrame.Angles(math.rad(90),0,math.rad(ZOrientation)) * CFrame.new(0,CurrentFurnitureHolding.Size.Y/2,0)* CFrame.Angles(0,math.rad(CurrentRotation),0) 
	end
end

while true do
	repeat
		local step = RunService.Heartbeat:Wait()
	until CurrentFurnitureHolding
	CurrentFurnitureHolding.CFrame = CalculateCurrentFurnitureHoldingCFrame()
	if not mouse.Target or ( not IsWithinBoundary(CurrentFurnitureHolding.Position) or IsPartOverlapping(CurrentFurnitureHolding) ) then
		selectionBox.SurfaceColor3 = Color3.new(1, 0, 0)
		selectionBox.Color3 = Color3.new(1,0,0)
	else
		selectionBox.SurfaceColor3 = Color3.new(0.0862745, 0.870588, 0)
		selectionBox.Color3 = Color3.new(0.0862745, 0.870588, 0)
	end
end

