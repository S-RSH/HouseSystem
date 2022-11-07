local DISTANCE_BETWEEN_ROOMS = 80
local FIRST_ROOM_CFRAME = CFrame.new(67, -48, -538) -- 이 위치 기준으로 z축으로 이동

local FurnitureModule = require(script.FurnitureModule)
local WallModule = require(script.WallModule)
local FloorModule = require(script.FloorModule)
local HouseListModule = require(script.Parent.HouseListModule)
local HouseDataModule = require(script.Parent.HouseDataModule)
local PreloadAssets = require(script.PreloadAssets)

local ServerStorageHouseModuleFolder = game.ServerStorage.HouseModule
local ReplicatedStorageHouseModuleFolder = game.ReplicatedStorage.HouseModule
local workspaceHouseModuleFolder = workspace.HouseModule

local ToggleRoomLockEvent = ReplicatedStorageHouseModuleFolder.ToggleRoomLock

local function OnToggleRoomLock(player, toggle)
	local IsRoomOpenedValue = player.HouseInfo.IsRoomOpened
	IsRoomOpenedValue.Value = toggle
	
end
ToggleRoomLockEvent.OnServerEvent:Connect(OnToggleRoomLock)

local function UpdateInventoryRoomFolder(player, typeOf, Name)
	local InventoryRoomFolder = player.HouseInfo.Inventory.Room
	if typeOf == "Furniture" then
		local furnitureIntValue = InventoryRoomFolder.Furniture:FindFirstChild(Name)
		if not furnitureIntValue then
			furnitureIntValue = Instance.new("IntValue")
			furnitureIntValue.Name = Name
			furnitureIntValue.Parent = InventoryRoomFolder.Furniture
		end
		furnitureIntValue.Value += 1
	elseif typeOf == "FurnitureRemove" then
		local furnitureIntValue = InventoryRoomFolder.Furniture[Name]
		furnitureIntValue.Value -= 1
		if furnitureIntValue.Value == 0 then
			furnitureIntValue:Destroy()
		end
	else
		InventoryRoomFolder[typeOf].Value = Name
	end
end


local RoomModule = {}

local ChangeFloorEvent = ReplicatedStorageHouseModuleFolder.ChangeFloor
ChangeFloorEvent.OnServerEvent:Connect(function(player, FloorName)
	local room = RoomModule:GetRoomFromPlayer(player)
	local TextureId =ReplicatedStorageHouseModuleFolder.Floor[FloorName].Texture
	FloorModule:Change(room, TextureId)
	
	UpdateInventoryRoomFolder(player, "Floor", FloorName)
	HouseDataModule:UpdateData(player,{ typeOf = "Floor", data = FloorName})
end)

local ChangeWallpaperEvent = ReplicatedStorageHouseModuleFolder.ChangeWallpaper
ChangeWallpaperEvent.OnServerEvent:Connect(function(player, WallpaperName)
	local room = RoomModule:GetRoomFromPlayer(player)
	local TextureId =ReplicatedStorageHouseModuleFolder.Wallpaper[WallpaperName].Texture
	WallModule:Change(room, TextureId)
	
	UpdateInventoryRoomFolder(player, "Wallpaper", WallpaperName)
	HouseDataModule:UpdateData(player,{ typeOf = "Wallpaper", data = WallpaperName})
end)

local PlaceFurnitureEvent = ReplicatedStorageHouseModuleFolder.PlaceFurniture
PlaceFurnitureEvent.OnServerEvent:Connect(function(player, furnitureName, furnitureCFrame)
	local room = RoomModule:GetRoomFromPlayer(player)
	local FurnitureInventory = player.HouseInfo.Inventory.Furniture
	local RoomFurnitureFolder = player.HouseInfo.Inventory.Room.Furniture
	
	local function GetAmountOfInventoryFurniture(name)
		return FurnitureInventory[name].Value
	end
	local function GetAmountOfRoomFurniture(name)
		local RoomFurniture = RoomFurnitureFolder:FindFirstChild(name)
		return RoomFurniture and RoomFurniture.Value or 0
	end

	local function GetAmountOfInventoryOnlyFurniture(name)
		local AmountOfInventoryFurniture = GetAmountOfInventoryFurniture(name) 
		local AmountOfInventoryOnlyFurniture = AmountOfInventoryFurniture - GetAmountOfRoomFurniture(name)
		return AmountOfInventoryOnlyFurniture
	end
	if GetAmountOfInventoryOnlyFurniture(furnitureName) <= 0 then
		return --check if player has enough amount in inventory
	end
	
	
	local furnitureMeshPart = ReplicatedStorageHouseModuleFolder.Furniture[furnitureName]
	local success = FurnitureModule:PlaceFurniture(room, furnitureMeshPart, furnitureCFrame)
	
	if success then
		UpdateInventoryRoomFolder(player, "Furniture", furnitureName)
		local relativeFurnitureCFrame = furnitureCFrame - room.Floor.Position
		HouseDataModule:UpdateData(player,{ typeOf = "Furniture", data = {furnitureName = furnitureName, furnitureCFrame = relativeFurnitureCFrame}})
	end
end)
local DeleteFurnitureEvent = ReplicatedStorageHouseModuleFolder.DeleteFurniture
DeleteFurnitureEvent.OnServerEvent:Connect(function(player, furnitureMeshPart)
	if RoomModule:GetRoomFromPlayer(player) ~= furnitureMeshPart.Parent.Parent then
		-- check if deleting own room's furniture
		return
	end
	
	local room = RoomModule:GetRoomFromPlayer(player)
	local furnitureName = furnitureMeshPart.Name
	local furnitureCFrame = furnitureMeshPart.CFrame
	FurnitureModule:RemoveFurniture(room, furnitureMeshPart)
	
	UpdateInventoryRoomFolder(player, "FurnitureRemove", furnitureMeshPart.Name)
	local relativeFurnitureCFrame = furnitureCFrame - room.Floor.Position
	HouseDataModule:UpdateData(player,{ typeOf = "FurnitureRemove", data = {furnitureName = furnitureName, furnitureCFrame = relativeFurnitureCFrame}})
end)

local RoomTemplate = ServerStorageHouseModuleFolder.RoomTemplate
local roomsFolder = workspaceHouseModuleFolder.Rooms
function RoomModule:GetRoomFromNumber(houseNumber)
	local room = roomsFolder:FindFirstChild(tostring(houseNumber))
	return room
end
function RoomModule:GetRoomFromPlayer(player)
	local houseNumber = table.find(HouseListModule.HouseOwnerList, player.Name) 
	local room = roomsFolder:FindFirstChild(tostring(houseNumber))
	return room
end

local function createNewRoom(houseNumber)
	local newRoom = RoomTemplate:Clone()
	newRoom.Name = tostring(houseNumber)
	
	local newRoomCFrame = FIRST_ROOM_CFRAME + Vector3.new(0,0,DISTANCE_BETWEEN_ROOMS) * (houseNumber - 1)
	newRoom:PivotTo(newRoomCFrame)
	
	newRoom.Parent = roomsFolder
	return newRoom
end


function RoomModule:AddRoom(playerHouse)
	local houseNumber = playerHouse.HouseNumber.Value
	local room = RoomModule:GetRoomFromNumber(houseNumber)
	if not room then
		room = createNewRoom(houseNumber)
	end
	
	return room
end

function RoomModule:ApplyRoomData(player, room, data)
	local Wallpaper = ReplicatedStorageHouseModuleFolder.Wallpaper:FindFirstChild(data.Wallpaper)
	local Floor = ReplicatedStorageHouseModuleFolder.Floor:FindFirstChild(data.Floor)
	
	if Wallpaper then
		WallModule:Change(room, Wallpaper.Texture) 
		UpdateInventoryRoomFolder(player, "Wallpaper", Wallpaper.Name)
	end
	if Floor then
		FloorModule:Change(room, Floor.Texture) 
		UpdateInventoryRoomFolder(player, "Floor", Floor.Name)
	end
	
	for furnitureName, list in pairs(data.Furniture)do
		local furnitureMeshPart = ReplicatedStorageHouseModuleFolder.Furniture[furnitureName]
		for i, v in ipairs(list)do
			local pos = v.Position
			local rot = v.Rotation
			local relativeFurnitureCFrame= CFrame.new(pos[1], pos[2], pos[3]) 
				* CFrame.Angles(math.rad(rot[1]),math.rad(rot[2]),math.rad(rot[3]))
			local furnitureCFrame = relativeFurnitureCFrame + room.Floor.Position
			FurnitureModule:PlaceFurniture(room, furnitureMeshPart, furnitureCFrame)
			UpdateInventoryRoomFolder(player, "Furniture", furnitureName)
		end
	end
	
	
	
end



function RoomModule:EmptyRoom(playerHouse)
	local houseNumber = playerHouse.HouseNumber.Value
	local room = RoomModule:GetRoomFromNumber(houseNumber)
	
	FurnitureModule:Clear(room)
	WallModule:Clear(room)
	FloorModule:Clear(room)
	
	return room
end

coroutine.wrap(function()
	PreloadAssets:Load(ReplicatedStorageHouseModuleFolder.Floor)
	PreloadAssets:Load(ReplicatedStorageHouseModuleFolder.Furniture)
	PreloadAssets:Load(ReplicatedStorageHouseModuleFolder.Wallpaper)
end)()

return RoomModule

