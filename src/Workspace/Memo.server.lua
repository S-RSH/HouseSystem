--[[
HouseModule에 집 모델 교체/추가할 때 주의사항:
다음 이름의 개체들은 모델 안에 반드시 들어있어야 함(괄호 안에는 개체 Class)
 - Claimed (StringValue)
 - HouseNumber (IntValue) -- 집 번호, 따로 지정하지 않은 경우 가장 뒷번호부터 무작위로 지정
 - Door (Model)
    ㄴ Door (Part) -- ProximityPrompt가 위치할 파트(집 들어갈 때 사용)
 - FrontDoorTp (Part) -- 집 나올때 텔레포트 위치

RoomTemplate 교체할 때 주의사항:
다음 이름의 개체들은 모델 안에 반드시 들어있어야 함
 - Exit - ProximityPrompt 들어갈 파트
 - Floor + Texture - 바닥 타일 적용 + 가구 바운더리 기준. RoomTemplate의 PrimaryPart로 설정해두기
 - Ceiling + Texture - 벽지 적용 + 가구 높이 제한
 - Spawn - 집 안으로 이동할 때 기준 
 - Wall + Texture - 벽지 적용




벽지Wallpaper, 바닥Floor, 가구Furniture는 모두 ReplicatedStorage의 HouseMoudule 폴더에서 추가 가능
Wallpaper와 Floor 추가 방법
	1. 각각 Wallpaper 또는 Floor 폴더 안에 Texture 개체를 추가
	2. 해당 개체 TextureID 설정
	3. 해당 개체 Name 수정 (이름은 모두 구별되어야 함)
	4. (선택)해당 개체 안에 IntValue 개체 추가, Price라고 이름을 수정하여 가격 설정해줄 수 있음
	4 - 1. Price개체를 넣지 않는 경우HouseMoudule 폴더의 PriceOfWallpaper 혹은 PriceOfFloor에 설정된 값으로 가격이 정해짐

Furniture추가 방법
	1. Furniture 폴더 안에 MeshPart 개체 추가하여 추가함
	1 - 1. 벽시계나 그림 등 벽에 설치하는 가구의 경우 정면이 하늘을 보도록 모델링 필요
	2. 해당 개체 Name 수정 (이름은 모두 구별되어야 함)
	4. 해당 개체 안에 StringValue 개체 추가, Description이라고 이름을 수정하여 가구 설명 작성할 수 있음
	5. 해당 개체 안에 IntValue 개체 추가, Price라고 이름을 수정하여 가구 가격 설정할 수 있음
	6. 벽시계나 그림 등 벽에 설치하는 가구의 경우 TopView라는 이름의 개체(Class상관없음)를 추가해두면, 미리보기에서 정면이 아닌 탑뷰 형식으로 보이게 됨
	
*RepliactedStorage.HouseModule.Texture/Wallpaper 폴더 안 Texture/Decal 개체들 이름 수정바람(임시로 무작위 이름 배정한 상태)
]]