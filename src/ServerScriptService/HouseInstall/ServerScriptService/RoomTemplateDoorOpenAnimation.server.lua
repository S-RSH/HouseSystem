local TweenService = game:GetService("TweenService")

local RoomTemplate = game.ServerStorage.HouseModule.RoomTemplate
local DoorModel = RoomTemplate.Door

local WorkspaceHouseModuleFolder = workspace:WaitForChild("HouseModule")
local RoomsFolder = WorkspaceHouseModuleFolder:WaitForChild("Rooms")

local function OnDetectorTouched(hit, tweenOpen, tweenClose)
	if game.Players:FindFirstChild(hit.Parent.Name) then 
		local player = game.Players:FindFirstChild(hit.Parent.Name)
		tweenOpen:Play()
		wait(5)
		tweenClose:Play()
	elseif game.Players:FindFirstChild(hit.Parent.Parent.Name) then 
		local player = game.Players:FindFirstChild(hit.Parent.Parent.Name)
		tweenOpen:Play()
		wait(5)
		tweenClose:Play()
	end
end

local function ConnectDoorAnimation(DoorModel)
	local hinge = DoorModel.Doorframe.Hinge
	local detector = DoorModel.Doorframe.Detector

	local goalOpen = {}
	goalOpen.CFrame = hinge.CFrame * CFrame.Angles(0, math.rad(90), 0)

	local goalClose = {}
	goalClose.CFrame = hinge.CFrame * CFrame.Angles(0, 0, 0)

	local tweenInfo = TweenInfo.new(1)
	local tweenOpen = TweenService:Create(hinge, tweenInfo, goalOpen)
	local tweenClose = TweenService:Create(hinge, tweenInfo, goalClose)


	detector.Touched:Connect(function(hit)
		OnDetectorTouched(hit, tweenOpen, tweenClose)
	end)
end
RoomsFolder.ChildAdded:Connect(function(child)
	if child:FindFirstChild("Door") then
		ConnectDoorAnimation(child.Door)
	end
end)
