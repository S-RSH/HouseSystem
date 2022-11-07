-- 게임 플레이어의 화면 크기에 따라 상점 버튼 크기 조절해줌
-- 상점 버튼 개수가 한 줄을 꽉 채우면 게임 시작할 때 자동으로 가운데 정렬해줌
-- ScrollingFrame 스크롤 크기도 자동으로 맞춰줌
-- 버튼이랑 스크롤바랑 겹침도 방지

if script.Parent:IsA("Script") then script.Enabled = false return end

local cooldown = true
function adaptsize()
	if cooldown then
		cooldown = false
	else
		return
	end
	local pixel = script.Parent.Parent.Parent.Parent.AbsoluteSize.X
	local size = script.Parent.CellSize.X.Scale
	local padding = script.Parent.CellPadding.X.Scale
	if pixel < 800 then -- 폰(600~700 * 0.8*0.9) -- 전체 화면 크기*그 화면에서 Gui가 차지하는 비율 고려
		size = 90
		padding = 15
	elseif pixel > 1200 then -- 컴터
		size = 150
		padding = 25
	else -- 테블릿
		size = 150
		padding = 25
	end
	
	local UIGridLayout = script.Parent
	local ScrollingFrame = script.Parent.Parent
	local main = script.Parent.Parent.Parent
	
	UIGridLayout.CellSize = UDim2.new(0,size,0,size)
	UIGridLayout.CellPadding = UDim2.new(0,padding,0,padding)
	-- 크기 조절
	
	ScrollingFrame.Size = UDim2.new(UDim.new(ScrollingFrame.Size.X.Scale, 0), ScrollingFrame.Size.Y)
	--아래쪽 스크롤바랑 버튼 겹침 방지때 한거 초기화
	
	local scrollbarSize = 0
	if ScrollingFrame:IsA("ScrollingFrame") then
		
		scrollbarSize = ScrollingFrame.ScrollBarThickness
		
		local nophi = UIGridLayout.AbsoluteCellCount.Y*size +  (UIGridLayout.AbsoluteCellCount.Y-1)*padding
		if nophi <= ScrollingFrame.AbsoluteSize.Y then	
			ScrollingFrame.CanvasSize = UDim2.new(UDim.new(0,0),ScrollingFrame.Size.Y)
			--캔버스 사이즈도 그냥 사이즈와 마찬가지로 scrollingFrame의 parent 기준으로 정해짐
		else
			local canvasYScale = nophi/main.AbsoluteSize.Y 
			ScrollingFrame.CanvasSize = UDim2.new(0,0,canvasYScale,0)
		end
		
	end 
	
	if (UIGridLayout.AbsoluteCellCount.X + 1)*size + UIGridLayout.AbsoluteCellCount.X * padding > ScrollingFrame.AbsoluteSize.X then
		-- 한 줄 꽉 차면

		UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		-- 가운데 정렬
	end 
	local cellArea = UIGridLayout.AbsoluteCellCount.X*size + (UIGridLayout.AbsoluteCellCount.X-1)*padding
	if cellArea <= ScrollingFrame.AbsoluteSize.X
		and cellArea > ScrollingFrame.AbsoluteSize.X - scrollbarSize*2 then
		-- 스크롤바랑 버튼이 겹칠 시 버튼이 짤림. 그거 방지용. 
		-- 참고로 스크롤바 크기가 0(스크롤바가 없는 경우)일때는, 계산식 보면 애초에 수학적으로 조건문 통과 불가능이니 안심하시길
		local offset = ScrollingFrame.AbsoluteSize.X - cellArea - 1
		ScrollingFrame.Size -= UDim2.new(0,offset,0,0)
		-- 크기 줄여서 버튼을 다음 줄로 보낸다
	end
	
	task.wait()
	cooldown = true
end


script.Parent.Parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(adaptsize)
script.Parent:GetPropertyChangedSignal("AbsoluteCellCount"):Connect(adaptsize)
adaptsize()