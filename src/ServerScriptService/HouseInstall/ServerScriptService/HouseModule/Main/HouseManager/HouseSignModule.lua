local HouseSignModule = {}

local NO_OWNER_TEXT = "No Owner"

local ServerStorageHouseModuleFolder = game.ServerStorage.HouseModule
local SignTemplate = ServerStorageHouseModuleFolder.SignTemplate

function HouseSignModule:UpdateSignOf(houseModel, playerName)
	
	local signModel = houseModel:FindFirstChild("Sign")
	if signModel then
		
		local textPart = signModel:FindFirstChild("Text")
		
		if textPart then
			
			local surfaceGui = textPart:FindFirstChild("SurfaceGui")
			if surfaceGui and surfaceGui:FindFirstChild("TextLabel") then
				
			else
				surfaceGui = SignTemplate:Clone()
				surfaceGui.Parent = textPart
			end
			surfaceGui.TextLabel.Text = playerName or NO_OWNER_TEXT
		end
	end
end

return HouseSignModule
