local UIModule = {}

local COLORS = {
    BACKGROUND = Color3.fromRGB(35, 35, 45),
    HEADER = Color3.fromRGB(45, 45, 65),
    BUTTON_OFF = Color3.fromRGB(60, 60, 80),
    BUTTON_ON = Color3.fromRGB(70, 200, 120),
    BUTTON_HOVER = Color3.fromRGB(70, 70, 90),
    SAVE_BUTTON = Color3.fromRGB(70, 130, 255),
    SAVE_BUTTON_HOVER = Color3.fromRGB(90, 150, 255),
    TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
    TEXT_SECONDARY = Color3.fromRGB(200, 200, 220),
    TEXT_DISABLED = Color3.fromRGB(150, 150, 170),
    BORDER = Color3.fromRGB(80, 80, 100),
    SHADOW = Color3.fromRGB(20, 20, 30)
}

local TweenService = game:GetService("TweenService")

function UIModule:CreateUI(screenGui)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -140, 0.5, -225)
    mainFrame.BackgroundColor3 = COLORS.BACKGROUND
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local shadowFrame = Instance.new("Frame")
    shadowFrame.Size = UDim2.new(1, 10, 1, 10)
    shadowFrame.Position = UDim2.new(0, -5, 0, -5)
    shadowFrame.BackgroundColor3 = COLORS.SHADOW
    shadowFrame.BorderSizePixel = 0
    shadowFrame.ZIndex = 0
    shadowFrame.Parent = mainFrame

    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 14)
    shadowCorner.Parent = shadowFrame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = mainFrame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = COLORS.BORDER
    uiStroke.Thickness = 1.5
    uiStroke.Parent = mainFrame

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 50)
    headerFrame.BackgroundColor3 = COLORS.HEADER
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = headerFrame

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0.5, 0)
    headerFix.Position = UDim2.new(0, 0, 0.5, 0)
    headerFix.BackgroundColor3 = COLORS.HEADER
    headerFix.BorderSizePixel = 0
    headerFix.Parent = headerFrame

    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 100)),
        ColorSequenceKeypoint.new(1, COLORS.HEADER)
    })
    headerGradient.Rotation = 45
    headerGradient.Parent = headerFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Auto Scripts"
    titleLabel.TextColor3 = COLORS.TEXT_PRIMARY
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = headerFrame

    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(0, 40, 0, 20)
    versionLabel.Position = UDim2.new(0, 15, 1, -22)
    versionLabel.BackgroundColor3 = COLORS.BUTTON_OFF
    versionLabel.BackgroundTransparency = 0.7
    versionLabel.Text = "v1.0"
    versionLabel.TextColor3 = COLORS.TEXT_SECONDARY
    versionLabel.TextSize = 12
    versionLabel.Font = Enum.Font.GothamSemibold
    versionLabel.Parent = headerFrame

    local versionCorner = Instance.new("UICorner")
    versionCorner.CornerRadius = UDim.new(0, 4)
    versionCorner.Parent = versionLabel

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 34, 0, 34)
    toggleButton.Position = UDim2.new(1, -44, 0.5, -17)
    toggleButton.BackgroundColor3 = COLORS.BUTTON_OFF
    toggleButton.Text = "-"
    toggleButton.TextColor3 = COLORS.TEXT_PRIMARY
    toggleButton.TextSize = 24
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = headerFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleButton

    local contentContainer = Instance.new("ScrollingFrame")
    contentContainer.Size = UDim2.new(1, -20, 1, -60)
    contentContainer.Position = UDim2.new(0, 10, 0, 55)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ScrollBarThickness = 4
    contentContainer.ScrollBarImageColor3 = COLORS.BORDER
    contentContainer.CanvasSize = UDim2.new(0, 0, 0, 800)
    contentContainer.Parent = mainFrame

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 10)
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.Parent = contentContainer

    local showButton = Instance.new("TextButton")
    showButton.Size = UDim2.new(0, 45, 0, 45)
    showButton.Position = mainFrame.Position
    showButton.BackgroundColor3 = COLORS.HEADER
    showButton.Text = "+"
    showButton.TextColor3 = COLORS.TEXT_PRIMARY
    showButton.TextSize = 28
    showButton.Font = Enum.Font.GothamBold
    showButton.Visible = false
    showButton.Parent = screenGui

    local showButtonCorner = Instance.new("UICorner")
    showButtonCorner.CornerRadius = UDim.new(0, 10)
    showButtonCorner.Parent = showButton

    local showButtonStroke = Instance.new("UIStroke")
    showButtonStroke.Color = COLORS.BORDER
    showButtonStroke.Thickness = 2
    showButtonStroke.Parent = showButton

    local showButtonGradient = Instance.new("UIGradient")
    showButtonGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 100)),
        ColorSequenceKeypoint.new(1, COLORS.HEADER)
    })
    showButtonGradient.Rotation = 45
    showButtonGradient.Parent = showButton

    return {
        mainFrame = mainFrame,
        shadowFrame = shadowFrame,
        headerFrame = headerFrame,
        toggleButton = toggleButton,
        contentContainer = contentContainer,
        uiListLayout = uiListLayout,
        showButton = showButton
    }
end

function UIModule:CreateToggleButton(name, layoutOrder, description, contentContainer)
    description = description or ""

    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 50)
    buttonFrame.BackgroundColor3 = COLORS.BUTTON_OFF
    buttonFrame.BorderSizePixel = 0
    buttonFrame.LayoutOrder = layoutOrder
    buttonFrame.Parent = contentContainer

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = buttonFrame

    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = COLORS.BORDER
    buttonStroke.Thickness = 1
    buttonStroke.Parent = buttonFrame

    local iconContainer = Instance.new("Frame")
    iconContainer.Size = UDim2.new(0, 30, 0, 30)
    iconContainer.Position = UDim2.new(0, 10, 0.5, -15)
    iconContainer.BackgroundColor3 = COLORS.HEADER
    iconContainer.BackgroundTransparency = 0.5
    iconContainer.BorderSizePixel = 0
    iconContainer.Parent = buttonFrame

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 6)
    iconCorner.Parent = iconContainer

    local iconText = Instance.new("TextLabel")
    iconText.Size = UDim2.new(1, 0, 1, 0)
    iconText.BackgroundTransparency = 1
    iconText.TextColor3 = COLORS.TEXT_PRIMARY
    iconText.TextSize = 14
    iconText.Font = Enum.Font.GothamBold
    iconText.Parent = iconContainer

    if name:find("Upgrade") then
        iconText.Text = "⬆️"
    elseif name:find("Retry") then
        iconText.Text = "🔄"
    elseif name:find("Play") then
        iconText.Text = "▶️"
    elseif name:find("Vote") then
        iconText.Text = "👍"
    elseif name:find("Inspect") then
        iconText.Text = "🔍"
    elseif name:find("Summon") then
        iconText.Text = "🎮"
    elseif name:find("Challenge") then
        iconText.Text = "🏆"
    elseif name:find("Ranger") then
        iconText.Text = "⚔️"
    elseif name:find("Gogeta") or name:find("Madara") then
        iconText.Text = "🔥"
    else
        iconText.Text = "✅"
    end

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.TextColor3 = COLORS.TEXT_PRIMARY
    button.Text = ""
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    button.Parent = buttonFrame

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -120, 0, 20)
    titleText.Position = UDim2.new(0, 50, 0, 8)
    titleText.BackgroundTransparency = 1
    titleText.Text = name
    titleText.TextColor3 = COLORS.TEXT_PRIMARY
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamSemibold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = buttonFrame

    local descText = Instance.new("TextLabel")
    descText.Size = UDim2.new(1, -120, 0, 16)
    descText.Position = UDim2.new(0, 50, 0, 28)
    descText.BackgroundTransparency = 1
    descText.Text = description
    descText.TextColor3 = COLORS.TEXT_SECONDARY
    descText.TextSize = 12
    descText.Font = Enum.Font.Gotham
    descText.TextXAlignment = Enum.TextXAlignment.Left
    descText.Parent = buttonFrame

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 44, 0, 24)
    toggleBg.Position = UDim2.new(1, -54, 0.5, -12)
    toggleBg.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = buttonFrame

    local toggleBgCorner = Instance.new("UICorner")
    toggleBgCorner.CornerRadius = UDim.new(0, 12)
    toggleBgCorner.Parent = toggleBg

    local toggleKnob = Instance.new("Frame")
    toggleKnob.Size = UDim2.new(0, 18, 0, 18)
    toggleKnob.Position = UDim2.new(0, 3, 0.5, -9)
    toggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
    toggleKnob.BorderSizePixel = 0
    toggleKnob.Name = "Knob"
    toggleKnob.Parent = toggleBg

    local toggleKnobCorner = Instance.new("UICorner")
    toggleKnobCorner.CornerRadius = UDim.new(0, 9)
    toggleKnobCorner.Parent = toggleKnob

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 60, 0, 20)
    statusLabel.Position = UDim2.new(1, -120, 0.5, -10)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "OFF"
    statusLabel.TextColor3 = COLORS.TEXT_DISABLED
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.TextSize = 14
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    statusLabel.Parent = buttonFrame

    button.MouseEnter:Connect(function()
        TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.BUTTON_HOVER}):Play()
    end)

    button.MouseLeave:Connect(function()
        if toggleBg.BackgroundColor3 == COLORS.BUTTON_ON then
            TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.BUTTON_ON}):Play()
        else
            TweenService:Create(buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.BUTTON_OFF}):Play()
        end
    end)

    return {
        button = button,
        statusLabel = statusLabel,
        toggleKnob = toggleKnob,
        toggleBg = toggleBg,
        buttonFrame = buttonFrame
    }
end

function UIModule:CreateSaveButton(contentContainer)
    local saveConfigFrame = Instance.new("Frame")
    saveConfigFrame.Size = UDim2.new(1, 0, 0, 40)
    saveConfigFrame.BackgroundColor3 = COLORS.SAVE_BUTTON
    saveConfigFrame.BorderSizePixel = 0
    saveConfigFrame.LayoutOrder = 15
    saveConfigFrame.Parent = contentContainer

    local saveCorner = Instance.new("UICorner")
    saveCorner.CornerRadius = UDim.new(0, 10)
    saveCorner.Parent = saveConfigFrame

    local saveStroke = Instance.new("UIStroke")
    saveStroke.Color = Color3.fromRGB(60, 110, 220)
    saveStroke.Thickness = 1
    saveStroke.Parent = saveConfigFrame

    local saveGradient = Instance.new("UIGradient")
    saveGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 150, 255)),
        ColorSequenceKeypoint.new(1, COLORS.SAVE_BUTTON)
    })
    saveGradient.Rotation = 45
    saveGradient.Parent = saveConfigFrame

    local saveConfigButton = Instance.new("TextButton")
    saveConfigButton.Size = UDim2.new(1, 0, 1, 0)
    saveConfigButton.BackgroundTransparency = 1
    saveConfigButton.TextColor3 = COLORS.TEXT_PRIMARY
    saveConfigButton.Text = "Save Configuration"
    saveConfigButton.Font = Enum.Font.GothamBold
    saveConfigButton.TextSize = 16
    saveConfigButton.Parent = saveConfigFrame

    local saveIcon = Instance.new("TextLabel")
    saveIcon.Size = UDim2.new(0, 20, 0, 20)
    saveIcon.Position = UDim2.new(0, 15, 0.5, -10)
    saveIcon.BackgroundTransparency = 1
    saveIcon.Text = "💾"
    saveIcon.TextColor3 = COLORS.TEXT_PRIMARY
    saveIcon.TextSize = 16
    saveIcon.Font = Enum.Font.GothamBold
    saveIcon.Parent = saveConfigFrame

    saveConfigButton.MouseEnter:Connect(function()
        TweenService:Create(saveConfigFrame, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.SAVE_BUTTON_HOVER}):Play()
    end)

    saveConfigButton.MouseLeave:Connect(function()
        TweenService:Create(saveConfigFrame, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.SAVE_BUTTON}):Play()
    end)

    return saveConfigButton, saveConfigFrame
end

function UIModule:UpdateButtonState(buttonData, enabled)
    if enabled then
        buttonData.statusLabel.Text = "ON"
        buttonData.statusLabel.TextColor3 = COLORS.TEXT_PRIMARY
        TweenService:Create(buttonData.toggleKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 23, 0.5, -9)}):Play()
        TweenService:Create(buttonData.toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.BUTTON_ON}):Play()
        TweenService:Create(buttonData.buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.BUTTON_ON}):Play()
    else
        buttonData.statusLabel.Text = "OFF"
        buttonData.statusLabel.TextColor3 = COLORS.TEXT_DISABLED
        TweenService:Create(buttonData.toggleKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
        TweenService:Create(buttonData.toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
        TweenService:Create(buttonData.buttonFrame, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.BUTTON_OFF}):Play()
    end
end

return UIModule