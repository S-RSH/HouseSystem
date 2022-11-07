local HouseFloorModule = {}

function HouseFloorModule:Clear(room)
	room.Floor.Texture.Texture = ""
end

function HouseFloorModule:Change(room, TextureId)
	room.Floor.Texture.Texture = TextureId
end

function HouseFloorModule:GetCurrentTextureId(room)
	return room.Floor.Texture.Texture
end

return HouseFloorModule
