  local ServerStorage = game.ServerStorage

local DataManager = require(ServerStorage.DataManager)

local HouseDataModule = {}

function HouseDataModule:GetDataAsync(player)
	local data = DataManager:GetData(player)
	local timeOut = 15
	local timePassed = 0
	repeat 
		if timePassed > timeOut then
			player:Kick("HouseData loading failed. Please reconnect.")
			break
		end
		timePassed += task.wait()
		data = DataManager:GetData(player)
	until data 
	return data
end

function HouseDataModule:SaveData(player)
	DataManager:SaveData(player)
end

function CFrameToOrientation(cf)
	local x, y, z = cf:ToOrientation()
	return Vector3.new(math.deg(x), math.deg(y), math.deg(z))
end
local function ConvertCFrameToPosAndRotArray(cframe)
	local decimalPoint = "%.2f" -- only save upto second decimal
	local pos =  cframe.Position
	local posInArray = {
		string.format(decimalPoint, pos.X),
		string.format(decimalPoint, pos.Y), 
		string.format(decimalPoint, pos.Z)
	}
	local rot = CFrameToOrientation(cframe)
	local rotInArray = {
		string.format(decimalPoint, rot.X),
		string.format(decimalPoint, rot.Y), 
		string.format(decimalPoint, rot.Z)
	}
	return posInArray, rotInArray
end

function HouseDataModule:UpdateData(player, updateData)
	
	local dataType = updateData.typeOf 
	if dataType  == "Furniture" then
		-- {furnitureName, furnitureCFrame}
		local furnitureName = updateData.data.furnitureName
		local posInArray, rotInArray = ConvertCFrameToPosAndRotArray(updateData.data.furnitureCFrame)
		DataManager:UpdateData(player, "Furniture", {furnitureName, posInArray, rotInArray})
		
	elseif dataType  == "FurnitureRemove" then
		-- {furnitureName, furnitureCFrame}
		local furnitureName = updateData.data.furnitureName
		local posInArray, rotInArray = ConvertCFrameToPosAndRotArray(updateData.data.furnitureCFrame)
		local success = DataManager:UpdateData(player, "FurnitureRemove", {furnitureName, posInArray, rotInArray})
		print("FurnitureRemove Success? ", success)	
	elseif dataType  == "Floor" then
		DataManager:UpdateData(player, "Floor", updateData.data)
		
	elseif dataType  == "Wallpaper" then
		DataManager:UpdateData(player, "Wallpaper", updateData.data)
		
	elseif dataType  == "Inventory" then
		-- Shop Buy
		DataManager:UpdateData(player, "Inventory", {typeOf = updateData.inventoryType, data = updateData.data})
	else
		warn(script:GetFullName()..":UpdateData, UnknownDataType ", dataType)
	end
end


coroutine.wrap(function()
	while task.wait(300) do
		for i, player in ipairs(game.Players:GetPlayers())do
			DataManager:SaveData(player)
		end
	end
end)()

return HouseDataModule
