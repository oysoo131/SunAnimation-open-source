local mst = {}
function mst.Makeui(Parent)
	local ui = Instance.new("ScreenGui")
	ui.Parent =workspace
	ui.Name = "Sun Animator"
end
function mst.Makeint(Parent,ui)
	local a2222222222222222222222222222cd
	for i,v in ipairs(Parent.Parent:GetDescendants()) do
		if v:IsA("Motor6D") and v.Part1 == Parent then
			a2222222222222222222222222222cd = v
		end
	end
	
	local interactor = Instance.new("Part")
	local Handle = Instance.new("BoxHandleAdornment")
	local selecta = Instance.new("BoxHandleAdornment")
	local be = Instance.new("BindableEvent")
	local sb = Instance.new("SelectionBox")
	sb.Parent = interactor
	interactor.Parent = ui
	Parent.Locked = true
	Handle.Parent = interactor
	selecta.Parent = interactor
	
	be.Parent = interactor
	be.Name = "Clicked"
	selecta.Name = "Select"
	Handle.Name = "Handle"
	interactor.Size = Parent.Size/3
	Handle.Size = interactor.Size
	selecta.Size = interactor.Size
	Handle.AlwaysOnTop = true
	selecta.AlwaysOnTop = true
	interactor.CFrame = Parent.CFrame

	sb.Adornee = interactor
	sb.LineThickness = 0
	Handle.Color3 = Color3.new(0.568627, 0.435294, 0.129412)
	selecta.Color3 = Color3.new(1, 0.756863, 0.227451)
	Handle.ZIndex = 1
	Handle.Adornee = interactor
	selecta.ZIndex = -1
	selecta.Adornee = interactor
	selecta.Visible = false
	interactor.Anchored = true
	interactor.Name = Parent.Name.."SUNANIMATOR"
	interactor.Transparency = 1
	return interactor
end
function mst.Makeinta(Parent,ui)
	local a2222222222222222222222222222cd
	for i,v in ipairs(Parent.Parent:GetDescendants()) do
		if v:IsA("Motor6D") and v.Part1 == Parent then
			a2222222222222222222222222222cd = v
		end
	end
	local at = Instance.new("Attachment")

	local interactor = Instance.new("Part")
	local Handle = Instance.new("BoxHandleAdornment")
	local selecta = Instance.new("BoxHandleAdornment")
	local be = Instance.new("BindableEvent")
	local sb = Instance.new("SelectionBox")
	sb.Parent = interactor
	interactor.Parent = ui
	Parent.Locked = true
	Handle.Parent = interactor
	selecta.Parent = interactor
	local x,y,z = a2222222222222222222222222222cd.C1:ToOrientation()
	interactor.CFrame = CFrame.fromOrientation(x,y,z)  + a2222222222222222222222222222cd.Part1.CFrame.Position
	
	at:Destroy()
	be.Parent = interactor
	be.Name = "Clicked"
	selecta.Name = "Select"
	Handle.Name = "Handle"
	interactor.Size = Vector3.new(0.01,0.01,0.01)
	Handle.Size = interactor.Size
	selecta.Size = interactor.Size
	Handle.AlwaysOnTop = false
	selecta.AlwaysOnTop = false
	 
	sb.Adornee = interactor
	sb.LineThickness = 0
	Handle.Color3 = Color3.new(0.568627, 0.435294, 0.129412)
	selecta.Color3 = Color3.new(1, 0.756863, 0.227451)
	Handle.ZIndex = -1
	Handle.Adornee = interactor
	selecta.ZIndex = -1
	selecta.Adornee = interactor
	selecta.Visible = false
	interactor.Anchored = true
	interactor.Name = Parent.Name
	interactor.Transparency = .9
	return interactor
end
function mst.callback(part:Part)
	local te = part.Name:gsub("SUNANIMATOR","")
	local aaaaaaaaaaaaaaaaaa = part.Parent:WaitForChild(te).Clicked
	task.spawn(function()
		local pa = part

			pa.Handle.MouseEnter:Connect(function()
			if pa.Parent.Value.Value == false then

				pa.Handle.ZIndex = -1
				pa.Select.ZIndex = 1

				pa.Select.Visible = true
			end
			end)
			pa.Handle.MouseLeave:Connect(function()
			if pa.Parent.Value.Value == false then
				pa.Handle.ZIndex = 1
				pa.Select.ZIndex = -1
				pa.Select.Visible = false
				end
			end)
		pa.Select.MouseButton1Down:Connect(function()
			if pa.Parent.Value.Value == false then

				aaaaaaaaaaaaaaaaaa:Fire()
				pa.Parent.Value.Value = true
				end
		end)
		
	end)
	return aaaaaaaaaaaaaaaaaa
end
return mst
