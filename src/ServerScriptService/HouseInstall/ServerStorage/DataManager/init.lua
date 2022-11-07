local Players = game:GetService("Players")
local ProfileService = require(script.ProfileService)
local SaveInStudioValue = script.SaveInStudio

local DATA_TEMPLATE = { -- 데이터 템플릿
	Cash = 999999;
	Furniture = {}; --[[
	{
		Table0 = {
			{Position = {1,2,3}; Rotation = {45,30,60}};
			{Position = {3,4,1}; Rotation = {60,50,40}};
		};
	} 
	식으로 4중테이블에 저장   
	#Table0 becomes the amount of furniture placed in room
	]] 
	Floor = ""; -- name
	Wallpaper = ""; -- name
	Inventory = {["Furniture"] = {}; ["Floor"] ={}; ["Wallpaper"] = {}};
	FurnitureAmount = {}; -- {FurnitureName = 1;} -- including placed furnitures 
}

local ProfileStore = ProfileService.GetProfileStore("HouseStore", DATA_TEMPLATE)	

local Profiles = {}

local function HandleLockedUpdate(globalUpdates, update)
	local id = update[1] --update[1]은 데이터 Id
	local data = update[2] --update[2]가 데이터 정보		
	
	globalUpdates:ClearLockedUpdate(id)
end

-- 플레이어 접속 이벤트 발생 시 호출되는 함수
local function OnPlayerAdded(player)
	
	-- 플레이어 프로필 데이터를 불러옴
	local profile = ProfileStore:LoadProfileAsync(
		-- 키 값
		"Player_"..player.UserId,
		
		-- 프로필이 다른 서버에서 사용 중으로 인해 잠긴 경우 어떻게 할지에 대한 인자 부분
		-- 잠겨있는 상태에서 그냥 바로 가져와버리는 속성이 "ForceLoad" (사용 중이었던 다른 서버에서에서는 강제로 release됨)
		"ForceLoad"
	)
	
	-- 프로필 데이터가 있으면
	if profile then
		
		-- release 이벤트 발생 시 실행될 코드 등록
		profile:ListenToRelease(function() -- 아래 profile:Release()에서 이어지는 부분
			Profiles[player] = nil --Profiles 테이블도 정리
			player:Kick() -- 확실한 플레이어 종료 보장
		end)
		
		-- 플레이어가 game.Players의 자식이면(플레이어가 게임에 접속 되었으면) true 반환, 데이터 캐싱.
		-- 로딩 도중 플레이어가 종료한 경우 대비
		if player:IsDescendantOf(Players) then 
			Profiles[player] = profile
			
			local globalUpdates = profile.GlobalUpdates
			
			for index, update in pairs(globalUpdates:GetActiveUpdates())do
				globalUpdates:LockActiveUpdate(update[1])
			end
			
			for index, update in pairs(globalUpdates:GetLockedUpdates())do
				HandleLockedUpdate(globalUpdates, update)
			end
			
			globalUpdates:ListenToNewActiveUpdate(function(id, data)
				globalUpdates:LockActiveUpdate(id)
			end)
			
			globalUpdates:ListenToNewLockedUpdate(function(id, data)
				HandleLockedUpdate(globalUpdates, {id, data})
			end)

		else
			profile:Release() 
			-- 플레이어 나간 경우 데이터 테이블 정리를 위해 release호출
			-- 위의 profile:ListenToRelease로 이어짐
		end
	else
		player:Kick("Data loading failed, Please try again 데이터 로딩 실패")
	end
end
Players.PlayerAdded:Connect(OnPlayerAdded)


local function OnPlayerRemoving(player)
	local profile = Profiles[player]
	if profile then
		if SaveInStudioValue.Value then
			profile:Save()		
		end
		profile:Release()-- 플레이어 나간 경우 데이터 테이블 정리를 위해 release호출
	end
end
Players.PlayerRemoving:Connect(OnPlayerRemoving)


-----------------------모듈-------------------------

local DataManager = {} 

-- 플레이어 데이터 반환하는 함수
function DataManager:GetData(player)
	local profile = Profiles[player]
	
	if profile then
		return profile.Data
	else
		return nil
	end
end

function DataManager:GetProfileStore()
	return ProfileStore
end

--데이터 업데이트, 현재 세션에만 저장되며 데이터스토어 저장을 위해선 SaveData()를 불러야 함
function DataManager:UpdateData(player, key, data)
	local profile = Profiles[player]
	
	if key == "Inventory" then
		--print(data.typeOf)
		--for i, v in pairs(profile.Data[key])do
		--	print(i, v)
		--end
		table.insert(profile.Data[key][data.typeOf], data.data)
	elseif key == "Furniture" then
		-- data = {furnitureName, posInArray, rotInArray}
		local furnitureName = data[1]
		if not profile.Data[key][furnitureName] then
			profile.Data[key][furnitureName] = {}
		end
		for i, v in pairs(data[2])do
			print(v)
		end
		for i, v in pairs(data[3])do
			print(v)
		end
		table.insert(profile.Data[key][data[1]], 
			{Position = data[2], Rotation = data[3]}
		)
	elseif key == "FurnitureRemove" then
		-- data = {furnitureName, posInArray, rotInArray}
		key = "Furniture"
		
		for i, v in ipairs(profile.Data[key][data[1]]) do
			local p =  v.Position
			local dp = data[2]
			local r = v.Rotation
			local dr = data[3]
			local sub = {p[1] - dp[1];
				p[2] - dp[2];
				p[3] - dp[3];
				r[1] - dr[1];
				r[2] - dr[2];
				r[3] - dr[3];
			}
			print(p[1],p[2],p[3],r[1],r[2],r[3], ":", dp[1], dp[2],dp[3],dr[1],dr[2],dr[3])
			if math.max(sub[1],sub[2],sub[3],sub[4],sub[5],sub[6]) < 0.1 --오차 확인(0.1미만은 같은 걸로 간주)
				and math.min(sub[1],sub[2],sub[3],sub[4],sub[5],sub[6]) > -0.1 then
				table.remove(profile.Data[key][data[1]], i) 
				return true
			end
		end
		return false
	else
		profile.Data[key] = data
	end
	
	
	
	print("UpdateData:" ,player, key, data)
end

-- 데이터스토어 저장, 안전을 위해선 UpdateData 부른 직후에 호출
-- 최적화를 위해선 5분에 한번씩만 호출(나갈때는 자동으로 저장됨)
function DataManager:SaveData(player)
	if SaveInStudioValue.Value then
		Profiles[player]:Save()		
	end
end


---------------- 특정 플레이어 데이터 초기화 ------------------
local RunService = game:GetService("RunService")
function DataManager:ClearData(player) 
	if RunService:IsStudio() and RunService:IsServer() then -- 스튜디오에서만 작동함, 서버 시점으로만 작동됨
		local profile = Profiles[player] or ProfileStore:LoadProfileAsync(
			"Player_"..player.UserId,
			"ForceLoad"
		)
		profile["Data"] = DATA_TEMPLATE -- 기본값 템플릿으로 설정
		player:Kick("Data Cleared")
	end
end


return DataManager


