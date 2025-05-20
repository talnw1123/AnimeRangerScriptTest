-- UISetup.lua: Handles UI creation and management
local UISetup = {}

function UISetup.createToggleButton(name, layoutOrder, description, COLORS, contentContainer)
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
    if COLORS.TEXT_DISABLED then
        statusLabel.TextColor3 = COLORS.TEXT_DISABLED
    else
        warn("COLORS.TEXT_DISABLED is nil")
        statusLabel.TextColor3 = Color3.fromRGB(150, 150, 170) -- ค่าเริ่มต้นชั่วคราว
    end
        statusLabel.Font = Enum.Font.GothamMedium
        statusLabel.TextSize = 14
        statusLabel.TextXAlignment = Enum.TextXAlignment.Right
        statusLabel.Parent = buttonFrame

    return button, statusLabel, toggleKnob, toggleBg, buttonFrame
end

function UISetup.setupUI(playerGui, COLORS)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoScriptsUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 280, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -140, 0.5, -225)
    mainFrame.BackgroundColor3 = COLORS and COLORS.BACKGROUND or Color3.fromRGB(40, 40, 60)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local shadowFrame = Instance.new("Frame")
    shadowFrame.Size = UDim2.new(1, 10, 1, 10)
    shadowFrame.Position = UDim2.new(0, -5, 0, -5)
    shadowFrame.BackgroundColor3 = COLORS and COLORS.SHADOW or Color3.fromRGB(20, 20, 30)
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
    uiStroke.Color = COLORS and COLORS.BORDER or Color3.fromRGB(60, 110, 220)
    uiStroke.Thickness = 1.5
    uiStroke.Parent = mainFrame

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 50)
    headerFrame.BackgroundColor3 = COLORS and COLORS.HEADER or Color3.fromRGB(50, 50, 80)
    headerFrame.BorderSizePixel = 0
    headerFrame.Parent = mainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = headerFrame

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0.5, 0)
    headerFix.Position = UDim2.new(0, 0, 0.5, 0)
    headerFix.BackgroundColor3 = COLORS and COLORS.HEADER or Color3.fromRGB(50, 50, 80)
    headerFix.BorderSizePixel = 0
    headerFix.Parent = headerFrame

    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 100)),
        ColorSequenceKeypoint.new(1, COLORS and COLORS.HEADER or Color3.fromRGB(50, 50, 80))
    })
    headerGradient.Rotation = 45
    headerGradient.Parent = headerFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Auto Scripts"
    titleLabel.TextColor3 = COLORS and COLORS.TEXT_PRIMARY or Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = headerFrame

    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(0, 40, 0, 20)
    versionLabel.Position = UDim2.new(0, 15, 1, -22)
    versionLabel.BackgroundColor3 = COLORS and COLORS.BUTTON_OFF or Color3.fromRGB(255, 0, 0)
    versionLabel.BackgroundTransparency = 0.7
    versionLabel.Text = "v1.0"
    versionLabel.TextColor3 = COLORS and COLORS.TEXT_SECONDARY or Color3.fromRGB(200, 200, 200)
    versionLabel.TextSize = 12
    versionLabel.Font = Enum.Font.GothamSemibold
    versionLabel.Parent = headerFrame

    local versionCorner = Instance.new("UICorner")
    versionCorner.CornerRadius = UDim.new(0, 4)
    versionCorner.Parent = versionLabel

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 34, 0, 34)
    toggleButton.Position = UDim2.new(1, -44, 0.5, -17)
    toggleButton.BackgroundColor3 = COLORS and COLORS.BUTTON_OFF or Color3.fromRGB(255, 0, 0)
    toggleButton.Text = "-"
    toggleButton.TextColor3 = COLORS and COLORS.TEXT_PRIMARY or Color3.fromRGB(255, 255, 255)
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
    contentContainer.ScrollBarImageColor3 = COLORS and COLORS.BORDER or Color3.fromRGB(60, 110, 220)
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
    showButton.BackgroundColor3 = COLORS and COLORS.HEADER or Color3.fromRGB(50, 50, 80)
    showButton.Text = "+"
    showButton.TextColor3 = COLORS and COLORS.TEXT_PRIMARY or Color3.fromRGB(255, 255, 255)
    showButton.TextSize = 28
    showButton.Font = Enum.Font.GothamBold
    showButton.Visible = false
    showButton.Parent = screenGui

    local showButtonCorner = Instance.new("UICorner")
    showButtonCorner.CornerRadius = UDim.new(0, 10)
    showButtonCorner.Parent = showButton

    local showButtonStroke = Instance.new("UIStroke")
    showButtonStroke.Color = COLORS and COLORS.BORDER or Color3.fromRGB(60, 110, 220)
    showButtonStroke.Thickness = 2
    showButtonStroke.Parent = showButton

    local showButtonGradient = Instance.new("UIGradient")
    showButtonGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 100)),
        ColorSequenceKeypoint.new(1, COLORS and COLORS.HEADER or Color3.fromRGB(50, 50, 80))
    })
    showButtonGradient.Rotation = 45
    showButtonGradient.Parent = showButton

    local buttons = {
        AutoUpgrade = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        RetryMap = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        AutoPlay = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        VotePass = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        InspectFinished = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        StandardSummon = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        ChallengeAndEasterEvent = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        VoteNext = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        RangerAndEasterEvent = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        GogetaMadaraAndZ10 = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        GogetaAndZ10 = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        MadaraAndZ10 = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        AllRangerAndAllChallenge = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        GhoulRangerAndGhoulStory = { button = nil, status = nil, knob = nil, bg = nil, frame = nil },
        AutoLeave = { button = nil, status = nil, knob = nil, bg = nil, frame = nil }
    }

    buttons.AutoUpgrade.button, buttons.AutoUpgrade.status, buttons.AutoUpgrade.knob, buttons.AutoUpgrade.bg, buttons.AutoUpgrade.frame = 
        UISetup.createToggleButton("AutoUpgrade", 1, "Automatically upgrades units", COLORS, contentContainer)
    buttons.RetryMap.button, buttons.RetryMap.status, buttons.RetryMap.knob, buttons.RetryMap.bg, buttons.RetryMap.frame = 
        UISetup.createToggleButton("RetryMap", 2, "Automatically votes to retry maps", COLORS, contentContainer)
    buttons.AutoPlay.button, buttons.AutoPlay.status, buttons.AutoPlay.knob, buttons.AutoPlay.bg, buttons.AutoPlay.frame = 
        UISetup.createToggleButton("AutoPlay", 3, "Toggles auto-play functionality", COLORS, contentContainer)
    buttons.VotePass.button, buttons.VotePass.status, buttons.VotePass.knob, buttons.VotePass.bg, buttons.VotePass.frame = 
        UISetup.createToggleButton("VotePass", 4, "Automatically votes to pass", COLORS, contentContainer)
    buttons.InspectFinished.button, buttons.InspectFinished.status, buttons.InspectFinished.knob, buttons.InspectFinished.bg, buttons.InspectFinished.frame = 
        UISetup.createToggleButton("InspectFinished", 5, "Handles inspection completion", COLORS, contentContainer)
    buttons.StandardSummon.button, buttons.StandardSummon.status, buttons.StandardSummon.knob, buttons.StandardSummon.bg, buttons.StandardSummon.frame = 
        UISetup.createToggleButton("StandardSummon", 6, "Auto summons with gem management", COLORS, contentContainer)
    buttons.ChallengeAndEasterEvent.button, buttons.ChallengeAndEasterEvent.status, buttons.ChallengeAndEasterEvent.knob, buttons.ChallengeAndEasterEvent.bg, buttons.ChallengeAndEasterEvent.frame = 
        UISetup.createToggleButton("Challenge & Easter", 7, "Farms Challenge and Easter events", COLORS, contentContainer)
    buttons.VoteNext.button, buttons.VoteNext.status, buttons.VoteNext.knob, buttons.VoteNext.bg, buttons.VoteNext.frame = 
        UISetup.createToggleButton("VoteNext", 8, "Automatically votes for next map", COLORS, contentContainer)
    buttons.RangerAndEasterEvent.button, buttons.RangerAndEasterEvent.status, buttons.RangerAndEasterEvent.knob, buttons.RangerAndEasterEvent.bg, buttons.RangerAndEasterEvent.frame = 
        UISetup.createToggleButton("Ranger & Easter", 9, "Farms Ranger stages and Easter events", COLORS, contentContainer)
    buttons.GogetaMadaraAndZ10.button, buttons.GogetaMadaraAndZ10.status, buttons.GogetaMadaraAndZ10.knob, buttons.GogetaMadaraAndZ10.bg, buttons.GogetaMadaraAndZ10.frame = 
        UISetup.createToggleButton("Gogeta-Madara & Z10", 10, "Farms Namek/Naruto Ranger stages and Z10", COLORS, contentContainer)
    buttons.GogetaAndZ10.button, buttons.GogetaAndZ10.status, buttons.GogetaAndZ10.knob, buttons.GogetaAndZ10.bg, buttons.GogetaAndZ10.frame = 
        UISetup.createToggleButton("Gogeta & Z10", 11, "Farms Namek Ranger stages and Z10", COLORS, contentContainer)
    buttons.MadaraAndZ10.button, buttons.MadaraAndZ10.status, buttons.MadaraAndZ10.knob, buttons.MadaraAndZ10.bg, buttons.MadaraAndZ10.frame = 
        UISetup.createToggleButton("Madara & Z10", 12, "Farms Naruto Ranger stages and Z10", COLORS, contentContainer)
    buttons.AllRangerAndAllChallenge.button, buttons.AllRangerAndAllChallenge.status, buttons.AllRangerAndAllChallenge.knob, buttons.AllRangerAndAllChallenge.bg, buttons.AllRangerAndAllChallenge.frame = 
        UISetup.createToggleButton("AllRangerAndAllChallenge", 13, "Farms all Ranger Stages then Challenge Mode", COLORS, contentContainer)
    buttons.GhoulRangerAndGhoulStory.button, buttons.GhoulRangerAndGhoulStory.status, buttons.GhoulRangerAndGhoulStory.knob, buttons.GhoulRangerAndGhoulStory.bg, buttons.GhoulRangerAndGhoulStory.frame = 
        UISetup.createToggleButton("GhoulRanger & GhoulStory", 14, "Farms Tokyo Ghoul Ranger stages and Chapter 10", COLORS, contentContainer)
    buttons.AutoLeave.button, buttons.AutoLeave.status, buttons.AutoLeave.knob, buttons.AutoLeave.bg, buttons.AutoLeave.frame = 
        UISetup.createToggleButton("AutoLeave", 15, "Automatically leaves after game ends", COLORS, contentContainer)

    local saveConfigFrame = Instance.new("Frame")
    saveConfigFrame.Size = UDim2.new(1, 0, 0, 40)
    saveConfigFrame.BackgroundColor3 = COLORS and COLORS.SAVE_BUTTON or Color3.fromRGB(70, 120, 200)
    saveConfigFrame.BorderSizePixel = 0
    saveConfigFrame.LayoutOrder = 16
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
        ColorSequenceKeypoint.new(1, COLORS and COLORS.SAVE_BUTTON or Color3.fromRGB(70, 120, 200))
    })
    saveGradient.Rotation = 45
    saveGradient.Parent = saveConfigFrame

    local saveConfigButton = Instance.new("TextButton")
    saveConfigButton.Size = UDim2.new(1, 0, 1, 0)
    saveConfigButton.BackgroundTransparency = 1
    saveConfigButton.TextColor3 = COLORS and COLORS.TEXT_PRIMARY or Color3.fromRGB(255, 255, 255)
    saveConfigButton.Text = "Save Configuration"
    saveConfigButton.Font = Enum.Font.GothamBold
    saveConfigButton.TextSize = 16
    saveConfigButton.Parent = saveConfigFrame

    local saveIcon = Instance.new("TextLabel")
    saveIcon.Size = UDim2.new(0, 20, 0, 20)
    saveIcon.Position = UDim2.new(0, 15, 0.5, -10)
    saveIcon.BackgroundTransparency = 1
    saveIcon.Text = "💾"
    saveIcon.TextColor3 = COLORS and COLORS.TEXT_PRIMARY or Color3.fromRGB(255, 255, 255)
    saveIcon.TextSize = 16
    saveIcon.Font = Enum.Font.GothamBold
    saveIcon.Parent = saveConfigFrame

    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentContainer.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
    end)

    return screenGui, mainFrame, showButton, buttons, toggleButton, saveConfigButton, saveConfigFrame
end

function UISetup.setupDragging(mainFrame, showButton, UserInputService, configSystem)
    local isDragging = false
    local dragStart = nil
    local startPos = nil

    mainFrame.Parent:GetDescendant("headerFrame").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            showButton.Position = mainFrame.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            configSystem:saveConfig()
        end
    end)

    local isShowButtonDragging = false
    local showButtonDragStart = nil
    local showButtonStartPos = nil

    showButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isShowButtonDragging = true
            showButtonDragStart = input.Position
            showButtonStartPos = showButton.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isShowButtonDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - showButtonDragStart
            showButton.Position = UDim2.new(
                showButtonStartPos.X.Scale,
                showButtonStartPos.X.Offset + delta.X,
                showButtonStartPos.Y.Scale,
                showButtonStartPos.Y.Offset + delta.Y
            )
            mainFrame.Position = showButton.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isShowButtonDragging = false
            configSystem:saveConfig()
        end
    end)
end

function UISetup.connectButtons(buttons, scriptStates, ScriptLogic, configSystem, TweenService, COLORS, priorityScript)
    for scriptName, buttonData in pairs(buttons) do
        buttonData.button.MouseButton1Click:Connect(function()
            if scriptStates[scriptName].enabled then
                ScriptLogic.stopScript(scriptName, scriptStates, buttons, TweenService, COLORS, priorityScript)
            else
                local scriptFunc = ScriptLogic[scriptName]
                if scriptFunc then
                    ScriptLogic.startScript(scriptName, scriptFunc, scriptStates, buttons, TweenService, COLORS, priorityScript)
                end
            end
            configSystem:saveConfig()
        end)

        buttonData.button.MouseEnter:Connect(function()
            TweenService:Create(buttonData.frame, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.BUTTON_HOVER}):Play()
        end)

        buttonData.button.MouseLeave:Connect(function()
            if scriptStates[scriptName].enabled then
                TweenService:Create(buttonData.frame, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.BUTTON_ON}):Play()
            else
                TweenService:Create(buttonData.frame, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.BUTTON_OFF}):Play()
            end
        end)
    end
end

local function updateButtonStates()
    for scriptName, state in pairs(scriptStates) do
        if buttons[scriptName] and buttons[scriptName].status then
            if state.enabled then
                buttons[scriptName].status.Text = "ON"
                if COLORS.TEXT_PRIMARY then
                    buttons[scriptName].status.TextColor3 = COLORS.TEXT_PRIMARY
                else
                    warn("COLORS.TEXT_PRIMARY is nil for " .. scriptName)
                end
            else
                buttons[scriptName].status.Text = "OFF"
                if COLORS.TEXT_DISABLED then
                    buttons[scriptName].status.TextColor3 = COLORS.TEXT_DISABLED
                else
                    warn("COLORS.TEXT_DISABLED is nil for " .. scriptName)
                end
            end
            -- ทำการ Tween...
            TweenService:Create(buttons[scriptName].knob, TweenInfo.new(0.2), {Position = UDim2.new(0, state.enabled and 23 or 3, 0.5, -9)}):Play()
            TweenService:Create(buttons[scriptName].bg, TweenInfo.new(0.2), {BackgroundColor3 = state.enabled and COLORS.BUTTON_ON or Color3.fromRGB(50, 50, 60)}):Play()
            TweenService:Create(buttons[scriptName].button.Parent, TweenInfo.new(0.2), {BackgroundColor3 = state.enabled and COLORS.BUTTON_ON or COLORS.BUTTON_OFF}):Play()
        else
            warn("buttons[" .. scriptName .. "].status is nil")
        end
    end
end
return UISetup
