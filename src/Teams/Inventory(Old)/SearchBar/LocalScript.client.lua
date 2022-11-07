local SearchBar  =script.Parent
local ScrollingFrame = script.Parent.Parent.ScrollingFrame
function UpdateSearchBar()
	local search = string.lower(SearchBar.Text) or string.upper(SearchBar.Text)
	for i ,v in pairs(ScrollingFrame:GetChildren()) do
		if v:IsA("Frame") then
			if search~="" then
				local Result = string.lower(v.ItemName.Text) or string.upper(v.ItemName.Text)
				if string.find(Result,search) then
				 
			 v.Visible = true
				else
					v.Visible = false
			 
				end
			 else
				v.Visible = true
			end
		end
	end
end
 
SearchBar.Changed:Connect(UpdateSearchBar)