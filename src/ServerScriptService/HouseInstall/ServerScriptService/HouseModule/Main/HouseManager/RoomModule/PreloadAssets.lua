local PreloadAssets = {}

local ContentProvider = game:GetService("ContentProvider")

function PreloadAssets:Load(folder)
	ContentProvider:PreloadAsync(folder:GetChildren())
end
	
return PreloadAssets
