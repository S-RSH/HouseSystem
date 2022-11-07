local HouseWallModule = {}

function HouseWallModule:Clear(room)
	HouseWallModule:Change(room, "")
end

function HouseWallModule:Change(room, TextureId)
	for i, v in ipairs(room:GetChildren())do
		if v.Name == "Wall" or v.Name == "Ceiling" then
			v.Texture.Texture = TextureId
		end
	end
end

function HouseWallModule:GetCurrentTextureId(room)
	return room.Wall.Texture.Texture
end

return HouseWallModule
