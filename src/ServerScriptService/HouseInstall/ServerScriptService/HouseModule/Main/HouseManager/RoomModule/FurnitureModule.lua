local HouseFurnitureModule = {}

function HouseFurnitureModule:Clear(room)
	local PlacedFurnitureFolder = room.PlacedFurniture
	for i, v in ipairs(PlacedFurnitureFolder:GetChildren()) do
		v:Destroy()
	end
end

local function IsPositionWithinRoomBoundary(room, pos)
	local MaxHeight = room.Ceiling.Position.Y
	local floor = room.Floor
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

function HouseFurnitureModule:PlaceFurniture(room, meshPart, cFrame)
	meshPart = meshPart:Clone()
	if IsPositionWithinRoomBoundary(room, cFrame.Position) then
		meshPart.CFrame = cFrame
		meshPart.Parent = room.PlacedFurniture
		return true
	else
		warn("furniture position is beyond room boundary", meshPart, cFrame, room)
		return false
	end
end

function HouseFurnitureModule:RemoveFurniture(room, furnitureMeshPart)
	furnitureMeshPart:Destroy()
end



return HouseFurnitureModule
