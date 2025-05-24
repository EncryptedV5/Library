local Library = {}
Library.__index = Library

function Library:AddWindow(name)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = name
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game:GetService("CoreGui")

	local Main = Instance.new("Frame")
	Main.Name = "Main"
	Main.Size = UDim2.new(0, 500, 0, 400)
	Main.Position = UDim2.new(0.5, -250, 0.5, -200)
	Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Main.BorderSizePixel = 0
	Main.Parent = ScreenGui

	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.Size = UDim2.new(1, 0, 0, 40)
	Topbar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	Topbar.BorderSizePixel = 0
	Topbar.Parent = Main

	local Title = Instance.new("TextLabel")
	Title.Name = "Title"
	Title.Text = name
	Title.Size = UDim2.new(1, -80, 1, 0)
	Title.Position = UDim2.new(0, 10, 0, 0)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Font = Enum.Font.SourceSansBold
	Title.TextSize = 20
	Title.Parent = Topbar

	local TabHolder = Instance.new("Frame")
	TabHolder.Name = "TabHolder"
	TabHolder.Size = UDim2.new(0, 100, 1, -40)
	TabHolder.Position = UDim2.new(0, 0, 0, 40)
	TabHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	TabHolder.BorderSizePixel = 0
	TabHolder.Parent = Main

	local FeaturesHolder = Instance.new("Frame")
	FeaturesHolder.Name = "FeaturesHolder"
	FeaturesHolder.Size = UDim2.new(1, -100, 1, -40)
	FeaturesHolder.Position = UDim2.new(0, 100, 0, 40)
	FeaturesHolder.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	FeaturesHolder.BorderSizePixel = 0
	FeaturesHolder.Parent = Main

	local Window = {
		Main = Main,
		Topbar = Topbar,
		TabHolder = TabHolder,
		FeaturesHolder = FeaturesHolder,
		ScreenGui = ScreenGui,
		Name = name,
	}
	
	setmetatable(Window, Library)

	local SelectedTabLabel = Instance.new("TextLabel")
	SelectedTabLabel.Name = "SelectTabNameLabel"
	SelectedTabLabel.Size = UDim2.new(0, 200, 1, 0)
	SelectedTabLabel.Position = UDim2.new(1, -210, 0, 0)
	SelectedTabLabel.BackgroundTransparency = 1
	SelectedTabLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
	SelectedTabLabel.Font = Enum.Font.SourceSansBold
	SelectedTabLabel.TextSize = 18
	SelectedTabLabel.TextXAlignment = Enum.TextXAlignment.Right
	SelectedTabLabel.Text = "Select a Tab"
	SelectedTabLabel.Parent = Topbar

	return Window
end

function Window:AddTab(tabName)
	local tab = Instance.new("TextButton")
	tab.Name = tabName
	tab.Text = tabName
	tab.Size = UDim2.new(0, 150, 0, 30)
	tab.BackgroundTransparency = 1
	tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tab.TextColor3 = Color3.fromRGB(212, 212, 212)
	tab.Font = Enum.Font.Fantasy
	tab.TextSize = 18
	tab.Parent = self.TabHolder

	local tabContent = Instance.new("ScrollingFrame")
	tabContent.Size = self.FeaturesHolder.Size
	tabContent.BackgroundTransparency = 1
	tabContent.BorderSizePixel = 0
	tabContent.ScrollBarThickness = 0
	tabContent.Visible = false
	tabContent.Name = tabName .. "_Content"
	tabContent.Parent = self.FeaturesHolder.Parent

	local layout = Instance.new("UIListLayout")
	layout.Parent = tabContent
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 4)
	padding.Parent = tabContent

	if not self._tabs then
		self._tabs = {}
	end

	self._tabs[tab] = tabContent

	tab.MouseButton1Click:Connect(function()
		for otherTab, content in pairs(self._tabs) do
			otherTab.BackgroundTransparency = 1
			otherTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			content.Visible = false
		end

		tab.BackgroundTransparency = 0
		tab.BackgroundColor3 = Color3.fromRGB(66, 66, 66)
		tabContent.Visible = true

		self.FeaturesHolder.Visible = false

		local label = self.Topbar:FindFirstChild("SelectTabNameLabel")
		if label then
			label.Text = tabName
		end
	end)


	local TabObject = {}
	TabObject.Content = tabContent

	function TabObject:AddLabel(labelConfig)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0, 314, 0, 30)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.SourceSans
		label.Text = labelConfig.Name or "Label"
		label.TextColor3 = Color3.fromRGB(212, 212, 212)
		label.TextSize = 20
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = tabContent
		return label
	end
	
	function TabObject:AddTextbox(config)
		local container = Instance.new("Frame")
		container.Size = UDim2.new(0, 314, 0, 35)
		container.BackgroundTransparency = 1
		container.Parent = tabContent

		local box = Instance.new("TextBox")
		box.Size = UDim2.new(1, 0, 1, 0)
		box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		box.BorderSizePixel = 0
		box.Text = config.Default or ""
		box.Font = Enum.Font.SourceSans
		box.TextColor3 = Color3.fromRGB(212, 212, 212)
		box.TextSize = 20
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.ClearTextOnFocus = false
		box.Parent = container

		box.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				local value = box.Text
				if config.TextDisappear then
					box.Text = ""
				end
				if config.Callback then
					pcall(config.Callback, value)
				end
			end
		end)

		return box
	end
	
	function TabObject:AddToggle(config)
		local state = config.Default or false

		local container = Instance.new("Frame")
		container.Size = UDim2.new(0, 314, 0, 35)
		container.BackgroundTransparency = 1
		container.Parent = tabContent

		local text = Instance.new("TextLabel")
		text.Size = UDim2.new(1, -35, 1, 0)
		text.BackgroundTransparency = 1
		text.Text = config.Name or "Toggle"
		text.Font = Enum.Font.SourceSans
		text.TextColor3 = Color3.fromRGB(212, 212, 212)
		text.TextSize = 20
		text.TextXAlignment = Enum.TextXAlignment.Left
		text.Parent = container

		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0, 30, 0, 30)
		button.Position = UDim2.new(1, -30, 0.5, -15)
		button.BackgroundColor3 = state and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(40, 40, 40)
		button.Text = ""
		button.BorderSizePixel = 0
		button.Parent = container

		button.MouseButton1Click:Connect(function()
			state = not state
			button.BackgroundColor3 = state and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(40, 40, 40)
			if config.Callback then
				pcall(config.Callback, state)
			end
		end)

		return button
	end
	
	function TabObject:AddButton(config)
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0, 314, 0, 35)
		button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		button.Text = config.Name or "Button"
		button.Font = Enum.Font.SourceSans
		button.TextColor3 = Color3.fromRGB(212, 212, 212)
		button.TextSize = 20
		button.BorderSizePixel = 0
		button.Parent = tabContent

		button.MouseButton1Click:Connect(function()
			if config.Callback then
				pcall(config.Callback)
			end
		end)

		return button
	end
	
	function TabObject:AddDropdown(config)
		local dropdownFrame = Instance.new("Frame")
		dropdownFrame.Size = UDim2.new(0, 314, 0, 35)
		dropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		dropdownFrame.BorderSizePixel = 0
		dropdownFrame.Parent = tabContent

		local selectedValue = Instance.new("TextButton")
		selectedValue.Size = UDim2.new(1, 0, 1, 0)
		selectedValue.BackgroundTransparency = 1
		selectedValue.Text = config.Default or ""
		selectedValue.Font = Enum.Font.SourceSans
		selectedValue.TextSize = 20
		selectedValue.TextColor3 = Color3.fromRGB(212, 212, 212)
		selectedValue.TextXAlignment = Enum.TextXAlignment.Left
		selectedValue.Parent = dropdownFrame

		local caret = Instance.new("ImageLabel")
		caret.Size = UDim2.new(0, 20, 0, 20)
		caret.Position = UDim2.new(1, -25, 0.5, -10)
		caret.BackgroundTransparency = 1
		caret.Image = "rbxassetid://132286269376660"
		caret.Rotation = 0
		caret.Parent = dropdownFrame

		local optionsHolder = Instance.new("Frame")
		optionsHolder.Position = UDim2.new(0, 0, 1, 0)
		optionsHolder.Size = UDim2.new(1, 0, 0, 0)
		optionsHolder.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		optionsHolder.BorderSizePixel = 0
		optionsHolder.Visible = false
		optionsHolder.ClipsDescendants = true
		optionsHolder.Parent = dropdownFrame

		local layout = Instance.new("UIListLayout")
		layout.Parent = optionsHolder

		local function toggleDropdown()
			local open = not optionsHolder.Visible
			optionsHolder.Visible = open
			caret.Rotation = open and 90 or 0
			optionsHolder.Size = open and UDim2.new(1, 0, 0, #config.Options * 30) or UDim2.new(1, 0, 0, 0)
		end

		selectedValue.MouseButton1Click:Connect(toggleDropdown)

		for _, option in ipairs(config.Options or {}) do
			local optionButton = Instance.new("TextButton")
			optionButton.Size = UDim2.new(1, 0, 0, 30)
			optionButton.BackgroundTransparency = 1
			optionButton.Text = option
			optionButton.Font = Enum.Font.SourceSans
			optionButton.TextSize = 18
			optionButton.TextColor3 = Color3.fromRGB(212, 212, 212)
			optionButton.Parent = optionsHolder

			optionButton.MouseButton1Click:Connect(function()
				selectedValue.Text = option
				toggleDropdown()
				if config.Callback then
					pcall(config.Callback, option)
				end
			end)
		end
	end


	return TabObject

return Library
