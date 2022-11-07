local lua_plus = require(script:WaitForChild("lua_plus"))
local ScrollingFrame = script.Parent 
local UIListLayout = script.Parent:WaitForChild("UIListLayout") 
local UpdateDirection = Enum.ScrollingDirection.Y 
 
lua_plus.update_canvas_based_on_children(ScrollingFrame, UIListLayout, UpdateDirection)
ScrollingFrame.DescendantAdded:Connect(function()
	wait(0.1)
	lua_plus.update_canvas_based_on_children(ScrollingFrame, UIListLayout, UpdateDirection)
end)

ScrollingFrame.DescendantRemoving:Connect(function()
	wait(0.1)
	lua_plus.update_canvas_based_on_children(ScrollingFrame, UIListLayout, UpdateDirection)
end)