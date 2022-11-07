local Players = game.Players

local HouseListModule = require(script.Parent.HouseListModule) 
local RoomModule = require(script.Parent.RoomModule)

local function UpdateIsPlayerInRoom(player, IsPlayerInRoom)
	local IsPlayerInRoomValue = player.HouseInfo.IsPlayerInRoom
	IsPlayerInRoomValue.Value = IsPlayerInRoom
end

local HouseProximityPromptModule = {}

local ProximityPromptService = game:GetService("ProximityPromptService")
ProximityPromptService.PromptTriggered:Connect(function(ProximityPrompt, player)
	if ProximityPrompt.Name == "DoorPrompt" then
		local DoorModel = ProximityPrompt.Parent.Parent
		local houseModel = DoorModel.Parent
		local Claimed = houseModel.Claimed
		
		local room = RoomModule:GetRoomFromNumber(houseModel.HouseNumber.Value)
		if player.Name == Claimed.Value then
			print("owner")
			
			player.Character:PivotTo(room.Spawn.CFrame)
			UpdateIsPlayerInRoom(player, true)
		else
			print("not owner")
			
			local Owner = game.Players[Claimed.Value]
			local IsRoomOpened = Owner.HouseInfo.IsRoomOpened.Value
			if IsRoomOpened then
				print("Room Opened")
				player.Character:PivotTo(room.Spawn.CFrame)
			else
				print("Room Locked")
			end
		end
	elseif ProximityPrompt.Name == "ExitPrompt" then
		local roomModel = ProximityPrompt.Parent.Parent
		local roomNumber = tonumber(roomModel.Name)
		local houseModel = HouseListModule:GetHouseFromNumber(roomNumber)
		
		if houseModel then
			player.Character:PivotTo(houseModel.FrontDoorTp.CFrame)
			UpdateIsPlayerInRoom(player, false)
		else
			warn("roomNumber", roomNumber,"not found")
			player:LoadCharacter()
			UpdateIsPlayerInRoom(player, false)
		end
	end
end)

function HouseProximityPromptModule:SetupPrompt(houseList)
	for i, v in ipairs(houseList) do -- house outside door
		if v:FindFirstChild("Door") and v.Door:FindFirstChild("Door") then		
			local Prompt = Instance.new("ProximityPrompt")
			Prompt.Name = "DoorPrompt"
			Prompt.ActionText = "들어가기"
			Prompt.RequiresLineOfSight = false
			Prompt.Parent = v.Door.Door	
		end
	end
end

function HouseProximityPromptModule:SetupPromptInRoom(room)
	local Exit = room:WaitForChild("Exit", 1)
	
	local Prompt = Instance.new("ProximityPrompt")
	Prompt.Name = "ExitPrompt"
	Prompt.ActionText = "나가기"
	Prompt.RequiresLineOfSight = false
	Prompt.Parent = Exit
end

return HouseProximityPromptModule
