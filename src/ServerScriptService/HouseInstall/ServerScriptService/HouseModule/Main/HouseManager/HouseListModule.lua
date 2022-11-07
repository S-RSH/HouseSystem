local HouseListModule = {}
HouseListModule.IsHouseListLoaded = false

local workspaceHouseModule = workspace.HouseModule
local function GetHouseModelListInOrder()
	local TempList = workspaceHouseModule.Houses:GetChildren()
	
	local HouseList = {}
	local HousesWithoutNumber = {}
	local HighestNumber = 0
	for i, v in ipairs(TempList)do
		-- excluding non-model objects
		-- Models Without HouseNumbers are also removed
		if v:IsA("Model") and v:FindFirstChild("HouseNumber") then
			-- Adding Models with HouseNumber To List
			if v.HouseNumber.Value then
				local houseNumber = v.HouseNumber.Value
				HouseList[houseNumber] = v
				print(v.HouseNumber.Value, v)
				if houseNumber > HighestNumber then
					HighestNumber = houseNumber
				end
			else
				table.insert(HousesWithoutNumber, v)
			end
		end
	end
	
	-- Adding models without houseNumbers
	for i, v in ipairs(HousesWithoutNumber)do
		HighestNumber += 1
		table.insert(HouseList, HighestNumber, v)
		v.HouseNumber.Value = HighestNumber
	end
	return HouseList
end
local function CreateEmptyHouseOwnerList()
	local HouseOwnerList = {}
	for i=1, #HouseListModule.HouseList do
		HouseOwnerList[i] = "none"
	end
	return HouseOwnerList
end

HouseListModule.HouseList = GetHouseModelListInOrder() -- {house object}
HouseListModule.HouseUnclaimedList = GetHouseModelListInOrder() --HouseListModule.HouseList 그대로 넣었더니 HouseList랑 HouseUnclaimedList랑 일심동체가 되어버리는 문제 발생
HouseListModule.HouseOwnerList = CreateEmptyHouseOwnerList() -- {"none"; "none"; ...}
HouseListModule.IsHouseListLoaded = true

function HouseListModule:AssignEmptyHouseToPlayer(player)
	local randomNumber = math.random(1,#HouseListModule.HouseUnclaimedList)
	local assignedHouse = HouseListModule.HouseUnclaimedList[randomNumber]

	table.remove(HouseListModule.HouseUnclaimedList, randomNumber)
	local assignedHouseNumber = assignedHouse.HouseNumber.Value
	HouseListModule.HouseOwnerList[assignedHouseNumber] = player.Name
	assignedHouse.Claimed.Value = player.Name
	
	return assignedHouse
end

function HouseListModule:GetHouseFromPlayer(player)
	local HouseNumber = table.find(HouseListModule.HouseOwnerList, player.Name) 
	return HouseListModule.HouseList[HouseNumber]
end

function HouseListModule:GetHouseFromNumber(HouseNumber)

	return HouseListModule.HouseList[HouseNumber]	
end


function HouseListModule:EmptyHouse(houseModel)
	houseModel.Claimed.Value = "none"
	HouseListModule.HouseOwnerList[houseModel.HouseNumber.Value] = "none"
	table.insert(HouseListModule.HouseUnclaimedList, houseModel)
end



return HouseListModule
