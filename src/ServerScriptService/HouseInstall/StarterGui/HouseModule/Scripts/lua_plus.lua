--[[
	Made by Jermartynojm (https://www.roblox.com/users/479838273/profile).
	
	Documentation: (https://devforum.roblox.com/t/lua-plus-turn-long-functions-into-one-line-of-code/1101547)
	
	You can use in your games.
	It is illegal to claim that the Module was made by you.
	
	Notes: it is mostly your job to handle pcalls.
]]

local lua_plus = {}

function lua_plus.test()
	local c = true

	return c
end

function lua_plus.version()
	return script:WaitForChild("Version").Value
end

function lua_plus.insert(id, parent)
	local m = game:GetService("InsertService"):LoadAsset(id)
	local nm = m:GetChildren()[1]
	nm.Parent = parent
	m:Destroy()
end

function lua_plus.check_version()
	local u, nt = nil, ""
	for _, v in pairs(script:WaitForChild("Downloads"):WaitForChild("check_version"):GetChildren()) do
		v:Destroy()
	end
	local s, e = pcall(function()
		lua_plus.insert(6503999156, script:WaitForChild("Downloads"):WaitForChild("check_version"))
	end)
	if s then
		local n = nil
		for _, v in pairs(script:WaitForChild("Downloads"):WaitForChild("check_version"):GetChildren()) do
			n = v:WaitForChild("Version").Value
		end
		if n > lua_plus.version() then
			u = false
			nt = "You are using old version of lua_plus ("..lua_plus.version().."). Please insert a new lua_plus Module to the game (v: "..n..")."
		else
			u = true
			nt = "You are using the newest version of lua_plus ("..lua_plus.version()..")."
		end
	else
		nt = "lua_plus.check_version() failed:\n"..e
	end
	for _, v in pairs(script:WaitForChild("Downloads"):WaitForChild("check_version"):GetChildren()) do
		v:Destroy()
	end
	return u, nt
end

function lua_plus.ungroup_model(model)
	for _, v in pairs(model:GetChildren()) do
		v.Parent = model.Parent
	end
	model:Destroy()
end

function lua_plus.return_xNumber(number, percentage)
	return number * (percentage / 100)
end

function lua_plus.pick_by_percenatage(namesT, percentageT)
	local t = {}
	for i = 1, #namesT do
		for i2 = 1, percentageT[i] do
			table.insert(t, namesT[i])
		end
	end
	return t[math.random(1, #t)]
end

function lua_plus.player_from_disorted_string(str)
	local p, d = nil, string.lower(str)
	for _, v in pairs(game:GetService("Players"):GetPlayers()) do
		if string.lower(v.Name) == d then
			p = v
		end
	end
	return p
end

function lua_plus.game_instance_from_string(str)
	local i, t = game, nil
	if not str then
		return nil
	end
	pcall(function()
		t = str:split(".")
	end)
	if #t == 1 then
		local s = pcall(function() i = i:GetService(t[1]) end)
		if not s then return nil else return i end
	elseif #t > 1 then
		local s = pcall(function() i = i:GetService(t[1]) end)
		if not s then return nil end
		table.remove(t, 1)
		for _, v in ipairs(t) do
			i = i:FindFirstChild(v)
		end
		return i
	end
	return nil
end

function lua_plus.load(id, parent)
	for _, v in pairs(game:GetObjects("rbxassetid://"..id)) do
		v.Parent = parent
	end
end

function lua_plus.update_canvas_based_on_children(scrollingFrame, uiAContentSizeElement, scrollingDirection)
	if scrollingDirection == Enum.ScrollingDirection.XY then
		scrollingFrame.CanvasSize = UDim2.new(0, uiAContentSizeElement.AbsoluteContentSize.X, 0, uiAContentSizeElement.AbsoluteContentSize.Y)
	elseif scrollingDirection == Enum.ScrollingDirection.X then
		scrollingFrame.CanvasSize = UDim2.new(0, uiAContentSizeElement.AbsoluteContentSize.X, 0, 0)
	elseif scrollingDirection == Enum.ScrollingDirection.Y then
		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, uiAContentSizeElement.AbsoluteContentSize.Y)
	else
		error("scrollingDirection parameter was provided incorrectly.")
	end
end

function lua_plus.get_touching_parts(part)
	local c = part.Touched:Connect(function() end)
	local t = part:GetTouchingParts()
	c:Disconnect()
	return t
end

return lua_plus
