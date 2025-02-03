plugin:Activate(false)
local m = plugin:GetMouse()
local target
for _, vs in ipairs(game:GetService("CoreGui"):GetChildren()) do
	if vs.Name == "Sun Animator" then
		vs:Destroy()
	end
end

local function generateKeyframe(model)
	local partsAdded = {}
	local function addPoses(part, parentPose)
		
		-- get all of the joints attached to the part
		for _, joint in pairs(part.Parent:GetDescendants()) do
			-- we're only interested in Motor6Ds
			if joint:IsA("Motor6D") then
				-- find the connected part
				local connectedPart = nil
				if joint.Part0 == part then
					connectedPart = joint.Part1
				elseif joint.Part1 == part then
					connectedPart = joint.Part0
				end
				if connectedPart then
					-- make sure we haven't already added this part
					if not partsAdded[connectedPart] then
						partsAdded[connectedPart] = true
						-- create a pose
						local pose = Instance.new("Pose")
						pose.CFrame = connectedPart.CFrame
						pose.Name = connectedPart.Name
						parentPose:AddSubPose(pose)
						-- recurse
						addPoses(connectedPart, pose)
					end
				end
			end
		end
	end

	local keyframe = Instance.new("Keyframe")

	-- populate the keyframe
	local rootPose = Instance.new("Pose")

	addPoses(model, rootPose)
	keyframe:AddPose(rootPose)

	return keyframe
end

local selected_keyframe = 1
local current_keyframes = 1
local rot = false
local uis = game.UserInputService
local isVisible = false
local inited = false
local Keyframe_data = {}
local Keyframe_data2 = {}
local function mkfs(parent)
	local keyframe = Instance.new('KeyframeSequence')
	for i,v in ipairs(Keyframe_data) do
		for i,v in ipairs(v) do
			
			keyframe:AddKeyframe(v)
			v.Parent = keyframe
			keyframe.Parent = workspace
		end
	end
end
local toolbar = plugin:CreateToolbar("Sun Animator Suite")
local button = toolbar:CreateButton("Sun Animator", "Opens the Sun Animator", "rbxassetid://123268727494993","Sun Animator")
local callback = {}

local goodt = false
local current_aa
local synced = false
local move = false
local is_move_stopped = false
local ui = Instance.new("ScreenGui",game.CoreGui)
local mainui = script["Sun Anim"]:Clone()
function sele(frame:Frame)
	task.spawn(function()
		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				selected_keyframe = tonumber(frame.Name)
				

			end
		end)
	end)
end

function clear()
	mkfs(workspace)
	for i,v in ipairs(callback) do
		v:Destroy()
	end
	for i,v in ipairs(mainui:WaitForChild("Main UI").Editor.Parts.Parts:GetChildren()) do
		v:Destroy()
	end
	for i,v in ipairs(mainui:WaitForChild("Main UI").Editor.Keyframe.ScrollingFrame.Key:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
	for i,v in ipairs(mainui:WaitForChild("Main UI").Editor.Keyframe.ScrollingFrame.time:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
	task.spawn(function()
		for i=1,73 do
			local temp = mainui:WaitForChild("Main UI").Editor.Keyframe.ScrollingFrame.time.LocalScript.TextLabel:Clone()

			if i >= 61 then
				temp.Text = "1:"..tostring(i-60).."		"
			elseif i == 60 then
				temp.Text = "1:".."00".."		"
			elseif i >= 10 and i ~= 60 then
				temp.Text = "0:"..tostring(i).."		"
			elseif i<10 then
				temp.Text = "0:0"..tostring(i).."		"


			end
			temp.Parent = mainui:WaitForChild("Main UI").Editor.Keyframe.ScrollingFrame.time.LocalScript.Parent
			temp.Visible = true
		end
	end)
	task.spawn(function()
		for i=1,73 do
			local temp = mainui:WaitForChild("Main UI").Editor.Keyframe.ScrollingFrame.Key.LocalScript.Frame:Clone()
			temp.Parent = mainui:WaitForChild("Main UI").Editor.Keyframe.ScrollingFrame.Key.LocalScript.Parent
			temp.Name =tostring(i)
			sele(temp)
		end
	end)
	target= nil
	inited =false
end
task.spawn(function()
	for i=1,73 do
		local temp = mainui:WaitForChild("Main UI").Editor.Keyframe.ScrollingFrame.time.LocalScript.TextLabel:Clone()

		if i >= 61 then
			temp.Text = "1:"..tostring(i-60).."		"
		elseif i == 60 then
			temp.Text = "1:".."00".."		"
		elseif i >= 10 and i ~= 60 then
			temp.Text = "0:"..tostring(i).."		"
		elseif i<10 then
			temp.Text = "0:0"..tostring(i).."		"


		end
		temp.Parent = mainui:WaitForChild("Main UI").Editor.Keyframe.ScrollingFrame.time.LocalScript.Parent
		temp.Visible = true
	end
end)
task.spawn(function()
	for i=1,73 do
		local temp = mainui:WaitForChild("Main UI").Editor.Keyframe.ScrollingFrame.Key.LocalScript.Frame:Clone()
		temp.Parent = mainui:WaitForChild("Main UI").Editor.Keyframe.ScrollingFrame.Key.LocalScript.Parent
		temp.Name =tostring(i)
		sele(temp)
	end
end)
task.spawn(function()
	mainui:WaitForChild("Main UI").TextButton.Activated:Connect(function()
		isVisible = false
		mainui.Enabled = isVisible
		clear()
	end)
end)
resizer = require(mainui.guiResizer.handler)
plugin:Activate(false)
frameToResize = mainui["Main UI"]

-- you can add a minimum size (optional)

minimumSize = Vector2.new(240, 160)


resizer.makeDraggable(frameToResize)

mainui.Parent = ui
ui.Name = "Sun Animator"
local is_clicked = Instance.new("BoolValue",ui)
is_clicked.Value =false
function call(a:BindableEvent)
	task.spawn(function()
		local be:BindableEvent = a
		be.Event:Connect(function()
			local selects = game:GetService("Selection")
			selects:Set({be.Parent})
			plugin:SelectRibbonTool(Enum.RibbonTool.Rotate,UDim2.new())
		end)
	end)
end
function addkeyframe(obj:Part)
	if Keyframe_data2[selected_keyframe] then
		if table.find(Keyframe_data2[selected_keyframe],obj) then
			local keyf:Keyframe = generateKeyframe(obj)
			keyf.Time = selected_keyframe
			Keyframe_data[selected_keyframe][table.find(Keyframe_data2[selected_keyframe],obj)] = keyf
		else

			local keyf:Keyframe = generateKeyframe(obj)
			keyf.Time = selected_keyframe
			table.insert(Keyframe_data[selected_keyframe],keyf)
			table.insert(Keyframe_data2[selected_keyframe],obj)

			local s = mainui:WaitForChild('Templ').Keyf:Clone()
			s.Visible = true
			s.Parent = mainui:WaitForChild("Main UI").Editor.Keyframe.ScrollingFrame.Key[selected_keyframe]

		end
	else

			Keyframe_data[selected_keyframe] = {}
			Keyframe_data2[selected_keyframe] = {}
			local keyf:Keyframe = generateKeyframe(obj)
			keyf.Time = selected_keyframe
			table.insert(Keyframe_data[selected_keyframe],keyf)
			table.insert(Keyframe_data2[selected_keyframe],obj)

		local s = mainui:WaitForChild('Templ').Keyf:Clone()
			s.Visible = true
		s.Parent = mainui:WaitForChild("Main UI").Editor.Keyframe.ScrollingFrame.Key[selected_keyframe]

	end
	
	rot = false
end
function a(part:Part)
	task.spawn(function()
		local be:Part = part



		be.Changed:Connect(function(att)
				
			if att == "Rotation" and not is_move_stopped and plugin:GetSelectedRibbonTool() == Enum.RibbonTool.Rotate then

					local types
					rot = true
					for i,v in ipairs(target:GetDescendants()) do
						for i,vs in ipairs(target:GetChildren()) do
							if vs.Name == be.Name then
								types = vs
							end
						end
						if v:IsA("Motor6D") and types then
							if v.Part1 == types then
								local x,y,z = be.CFrame:ToOrientation()
								local A = v.C1.Position
								v.C1 = CFrame.fromOrientation(x,y,z) + A
								is_clicked.Value =true
								addkeyframe(types)
								
							end
						end

					end

					
				end
			if att == "Position" and not is_move_stopped and not rot and plugin:GetSelectedRibbonTool() == Enum.RibbonTool.Move then
					local types
					for i,v in ipairs(target:GetDescendants()) do
						for i,vs in ipairs(target:GetChildren()) do
							if vs.Name == be.Name then
								types = vs
							end
						end
						if v:IsA("Motor6D") and types then
							if v.Part1 == types then
								local a = v.Part1.CFrame:ToObjectSpace(be.CFrame)
								local x,y,z = v.C1:ToOrientation()
								v.C1 = CFrame.fromOrientation(x,y,z) + a.Position
								addkeyframe(types)
							end
						end

				end
				end


		end)

		

		
	end)
end
function resetpos(part:Part)
	task.spawn(function()
		while wait() do
			
			if target then
				toolchange2()
				for i,v in ipairs(target:GetChildren()) do
					local te = part.Name:gsub("SUNANIMATOR","")

					if te == v.Name then
						part.CFrame = v.CFrame
					end
				end
			end

		end

	end)
end
function toolchange()
	local passed = false
	for i,v in ipairs(game.Selection:Get()) do
		if v:IsA("BasePart") then
			if v.Parent == game.CoreGui["Sun Animator"] then
				passed = true
				
			end
		end
	end
	if passed == false and is_clicked.Value ==false then

		is_clicked.Value =false
		setupInteractorsa()
	end
end
function toolchange2()
	local passed = false
	for i,v in ipairs(game.Selection:Get()) do
		if v:IsA("BasePart") then
			if v.Parent == game.CoreGui["Sun Animator"] then
				passed = true
				if Keyframe_data2[selected_keyframe] and selected_keyframe > current_keyframes then
					current_keyframes = selected_keyframe
				end
			end
		end
	end
	if passed == false then
		plugin:SelectRibbonTool(Enum.RibbonTool.None, UDim2.new(0,0,0,0))
		is_clicked.Value =false

	end
end
function resetposa(part:Part)
	task.spawn(function()
		local pa = part
		local wanted_part
		while wait() do
			if plugin:GetSelectedRibbonTool() == Enum.RibbonTool.None and resizer.isfoucs ~= true then
				wait(5)
				
				break
			else

				is_move_stopped = false
			end

		end

	end)
end
function callbackthecollapse(collapse:TextButton)
	task.spawn(function()
		local open = false
		local cp:TextButton = collapse
		local origin = UDim2.new(0,2)
		cp.Activated:Connect(function()
			if open then
				open = false

				local ts = game:GetService("TweenService"):Create(collapse,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Rotation = 0})
				ts:Play()
				ts.Completed:Wait()
				collapse.Parent.Frame.Visible = false

				collapse.Parent.Parent.UIListLayout.Padding = UDim.new(origin)
			else
				open = true

				local ts = game:GetService("TweenService"):Create(collapse,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.In),{Rotation = -90})
				ts:Play()
				ts.Completed:Wait()
 				collapse.Parent.Frame.Visible = true
				local count = 0
				for i,v in ipairs(collapse.Parent.Frame:GetChildren()) do
					count +=1
				end

				collapse.Parent.Parent.UIListLayout.Padding = UDim.new(0,count*35)
			end
		end)
	end)
end
function setupInteractors()

	for _, v in ipairs(target:GetChildren()) do
		if v:IsA("BasePart") then
			v.Locked = true
		end
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			local mst = require(script.Parent.Util.Make_Selector)
			local ignorelist = {v.Parent:FindFirstChild("HumanoidRootPart")}
			for i,vs in ipairs(ui:GetChildren()) do
				if vs.Name == v.Name.."SUNANIMATOR" then
					vs:Destroy()
					callback[table.find(callback,vs)] = nil
				end
			end


			local interactor = mst.Makeint(v,ui)
			local ss =mst.callback(interactor)
			table.insert(callback,interactor)
			resetpos(interactor)
			call(ss)
			
		end
	end
end
function addpro(frame)
		
		for i=1,4 do
			if i ==1 then
			local t = mainui:WaitForChild('Templ').Color:Clone()
				t.Parent = frame.Frame
				t.Visible = true
			elseif i ==2 then
			local t = mainui:WaitForChild('Templ').Position:Clone()
				t.Parent = frame.Frame
				t.Visible = true
			elseif i ==3 then
			local t = mainui:WaitForChild('Templ').Rotation:Clone()
				t.Parent = frame.Frame
				t.Visible = true
			elseif i ==4 then
			local t = mainui:WaitForChild('Templ').Size:Clone()
				t.Parent = frame.Frame
				t.Visible = true



			end
		end
		
end
function setupInteractorsa()
	local a2
	if not inited then
		local t = mainui:WaitForChild('Templ').Model:Clone()
		t.Parent = mainui:WaitForChild("Main UI").Editor.Parts.Parts
		t.TextLabel.Text = target.Name
		t.Visible = true
		callbackthecollapse(t.TextButton)
	else
		mainui:WaitForChild("Main UI").Editor.Parts.Parts.Model:Destroy()
		local t = mainui:WaitForChild('Templ').Model:Clone()
		t.Parent = mainui:WaitForChild("Main UI").Editor.Parts.Parts
		t.TextLabel.Text = target.Name
		t.Visible = true
		callbackthecollapse(t.TextButton)
		inited = false
	end
	for _, v in ipairs(target:GetChildren()) do
		if v:IsA("BasePart") then
			v.Locked = true
		end
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			local mst = require(script.Parent.Util.Make_Selector)
			local ignorelist = {v.Parent:FindFirstChild("HumanoidRootPart")}
			for i,vs in ipairs(ui:GetChildren()) do
				if vs.Name == v.Name then
					vs:Destroy()
					if callback[table.find(callback,v)] then
						callback[table.find(callback,v)] = nil
					end
					
				end
			end
			

				local t = mainui:WaitForChild('Templ').Part:Clone()
			t.Parent = mainui:WaitForChild("Main UI").Editor.Parts.Parts.Model.Frame
				t.TextLabel.Text = v.Name
				t.Visible = true
				addpro(t)
				callbackthecollapse(t.TextButton)
				
			
			local interactor = mst.Makeinta(v,ui)
			table.insert(callback,interactor)
			a2 = interactor
			a(a2)
			if not inited then
				inited = true
				resetposa(interactor)
			end
		end
	end
	setupInteractors()

end
uis.InputBegan:Connect(function(kety)
	if kety.UserInputType == Enum.UserInputType.MouseButton1 then
		
		if goodt then
			goodt = false
			target = m.Target.Parent
			setupInteractorsa()
			
			
		end
	end
end)

function findt()
	task.spawn(function()

			while not target do
				wait()
				if m.Target then
					if m.Target.Parent:IsA("Model") then
					if m.Target.Parent:FindFirstChildOfClass("Humanoid")  then
						if not target then
							goodt = true
						end
						
						else
							goodt = false
												
						end
					else
					goodt = false
	
					end
				else
					goodt = false
	
				end
			end

	end)
end
button.Click:Connect(function()
	isVisible = not isVisible
	mainui.Enabled = isVisible
	if isVisible == false then
		
		clear()
		target = nil

	elseif isVisible == true and target then
		setupInteractorsa()
		
	elseif isVisible == true and not target then
		findt()
		
	end
end)
