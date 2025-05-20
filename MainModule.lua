local MainModule = {}

repeat task.wait(2) until game:IsLoaded()
task.wait(15)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local UIModule = require(script.Parent.UIModule)
local ConfigModule = require(script.Parent.ConfigModule)
local ScriptsModule = require(script.Parent.ScriptsModule)
local UtilitiesModule = require(script.Parent.UtilitiesModule)

if _G.AutoScriptsRunning then
    if playerGui:FindFirstChild("AutoScriptsUI") then
        playerGui.AutoScriptsUI:Destroy()
    end
end
_G.AutoScriptsRunning = true

local scriptStates = {
    AutoUpgrade = { enabled = false, coroutine = nil, connection = nil },
    RetryMap = { enabled = false, coroutine = nil, connection = nil },
    AutoPlay = { enabled = false, coroutine = nil, connection = nil },
    VotePass = { enabled = false, coroutine = nil, connection = nil },
    InspectFinished = { enabled = false, coroutine = nil, connection = nil },
    StandardSummon = { enabled = false, coroutine = nil, connection = nil },
    ChallengeAndEasterEvent = { enabled = false, coroutine = nil, connection = nil, challengeConnection = nil, easterEventCoroutine = nil },
    VoteNext = { enabled = false, coroutine = nil, connection = nil },
    RangerAndEasterEvent = { enabled = false, coroutine = nil, connection = nil, easterEventCoroutine = nil },
    GogetaMadaraAndZ10 = { enabled = false, coroutine = nil, connection = nil, z10Coroutine = nil },
    GogetaAndZ10 = { enabled = false, coroutine = nil, connection = nil, z10Coroutine = nil },
    MadaraAndZ10 = { enabled = false, coroutine = nil, connection = nil, z10Coroutine = nil },
    AllRangerAndAllChallenge = { enabled = false, coroutine = nil, connection = nil, challengeCoroutine = nil },
    GhoulRangerAndGhoulStory = { enabled = false, coroutine = nil, connection = nil, storyCoroutine = nil },
    AutoLeave = { enabled = false, coroutine = nil, connection = nil }
}

local priorityScript = nil

function MainModule:StopScript(scriptName)
    local state = scriptStates[scriptName]
    if state.coroutine then
        if state.connection then
            state.connection:Disconnect()
            state.connection = nil
        end
        if state.challengeConnection then
            state.challengeConnection:Disconnect()
            state.challengeConnection = nil
        end
        state.coroutine = nil
    end
    if state.easterEventCoroutine then
        state.easterEventCoroutine = nil
    end
    if state.z10Coroutine then
        state.z10Coroutine = nil
    end
    if state.challengeCoroutine then
        state.challengeCoroutine = nil
    end
    if state.storyCoroutine then
        state.storyCoroutine = nil
    end
    state.enabled = false
    UIModule:UpdateButtonState(self.buttons[scriptName], false)

    if scriptName == "GogetaMadaraAndZ10" or scriptName == "AllRangerAndAllChallenge" then
        priorityScript = nil
        for name, state in pairs(scriptStates) do
            if name ~= "GogetaMadaraAndZ10" and name ~= "AllRangerAndAllChallenge" and state.enabled then
                local scriptFunc = self.scriptFunctions[name]
                if scriptFunc then
                    self:StartScript(name, scriptFunc)
                end
            end
        end
    end
end

function MainModule:StartScript(scriptName, scriptFunc)
    local state = scriptStates[scriptName]
    if state.coroutine then
        if state.connection then
            state.connection:Disconnect()
            state.connection = nil
        end
        if state.challengeConnection then
            state.challengeConnection:Disconnect()
            state.challengeConnection = nil
        end
        state.coroutine = nil
    end
    if state.easterEventCoroutine then
        state.easterEventCoroutine = nil
    end
    if state.z10Coroutine then
        state.z10Coroutine = nil
    end
    if state.challengeCoroutine then
        state.challengeCoroutine = nil
    end
    if state.storyCoroutine then
        state.storyCoroutine = nil
    end
    state.enabled = true
    state.coroutine = coroutine.create(function()
        if scriptName == "AutoLeave" then
            scriptFunc(state.scriptStates)
        else
            scriptFunc(state)
        end
    end)
    UIModule:UpdateButtonState(self.buttons[scriptName], true)

    if scriptName == "GogetaMadaraAndZ10" then
        priorityScript = scriptName
        for name, state in pairs(scriptStates) do
            if name ~= "GogetaMadaraAndZ10" and (name == "RangerAndEasterEvent" or name == "ChallengeAndEasterEvent" or name == "AllRangerAndAllChallenge" or name == "GhoulRangerAndGhoulStory") and state.enabled then
                self:StopScript(name)
            end
        end
    elseif scriptName == "AllRangerAndAllChallenge" then
        priorityScript = scriptName
        for name, state in pairs(scriptStates) do
            if name ~= "AllRangerAndAllChallenge" and (name == "RangerAndEasterEvent" or name == "ChallengeAndEasterEvent" or name == "GhoulRangerAndGhoulStory") and state.enabled then
                self:StopScript(name)
            end
        end
    end

    coroutine.resume(state.coroutine)
end

function MainModule:Init()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoScriptsUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local uiElements = UIModule:CreateUI(screenGui)
    local mainFrame = uiElements.mainFrame
    local headerFrame = uiElements.headerFrame
    local toggleButton = uiElements.toggleButton
    local contentContainer = uiElements.contentContainer
    local uiListLayout = uiElements.uiListLayout
    local showButton = uiElements.showButton

    self.buttons = {
        AutoUpgrade = UIModule:CreateToggleButton("AutoUpgrade", 1, "Automatically upgrades units", contentContainer),
        RetryMap = UIModule:CreateToggleButton("RetryMap", 2, "Automatically votes to retry maps", contentContainer),
        AutoPlay = UIModule:CreateToggleButton("AutoPlay", 3, "Toggles auto-play functionality", contentContainer),
        VotePass = UIModule:CreateToggleButton("VotePass", 4, "Automatically votes to pass", contentContainer),
        InspectFinished = UIModule:CreateToggleButton("InspectFinished", 5, "Handles inspection completion", contentContainer),
        StandardSummon = UIModule:CreateToggleButton("StandardSummon", 6, "Auto summons with gem management", contentContainer),
        ChallengeAndEasterEvent = UIModule:CreateToggleButton("Challenge & Easter", 7, "Farms Challenge and Easter events", contentContainer),
        VoteNext = UIModule:CreateToggleButton("VoteNext", 8, "Automatically votes for next map", contentContainer),
        RangerAndEasterEvent = UIModule:CreateToggleButton("Ranger & Easter", 9, "Farms Ranger stages and Easter events", contentContainer),
        GogetaMadaraAndZ10 = UIModule:CreateToggleButton("Gogeta-Madara & Z10", 10, "Farms Namek/Naruto Ranger stages and Z10", contentContainer),
        GogetaAndZ10 = UIModule:CreateToggleButton("Gogeta & Z10", 11, "Farms Namek Ranger stages and Z10", contentContainer),
        MadaraAndZ10 = UIModule:CreateToggleButton("Madara & Z10", 12, "Farms Naruto Ranger stages and Z10", contentContainer),
        AllRangerAndAllChallenge = UIModule:CreateToggleButton("AllRangerAndAllChallenge", 13, "Farms all Ranger Stages then Challenge Mode", contentContainer),
        GhoulRangerAndGhoulStory = UIModule:CreateToggleButton("GhoulRanger & GhoulStory", 14, "Farms Tokyo Ghoul Ranger stages and Chapter 10", contentContainer),
        AutoLeave = UIModule:CreateToggleButton("AutoLeave", 15, "Automatically leaves after game ends", contentContainer)
    }

    local saveConfigButton, saveConfigFrame = UIModule:CreateSaveButton(contentContainer)

    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentContainer.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20)
    end)

    self.scriptFunctions = {
        AutoUpgrade = ScriptsModule.AutoUpgradeScript,
        RetryMap = ScriptsModule.RetryMapScript,
        AutoPlay = ScriptsModule.AutoPlayScript,
        VotePass = ScriptsModule.VotePassScript,
        InspectFinished = ScriptsModule.InspectFinishedScript,
        StandardSummon = ScriptsModule.StandardSummonScript,
        ChallengeAndEasterEvent = ScriptsModule.ChallengeAndEasterEventScript,
        VoteNext = ScriptsModule.VoteNextScript,
        RangerAndEasterEvent = ScriptsModule.RangerAndEasterEventScript,
        GogetaMadaraAndZ10 = ScriptsModule.GogetaMadaraAndZ10Script,
        GogetaAndZ10 = ScriptsModule.GogetaAndZ10Script,
        MadaraAndZ10 = ScriptsModule.MadaraAndZ10Script,
        AllRangerAndAllChallenge = ScriptsModule.AllRangerAndAllChallengeScript,
        GhoulRangerAndGhoulStory = ScriptsModule.GhoulRangerAndGhoulStoryScript,
        AutoLeave = function() ScriptsModule:AutoLeaveScript({ enabled = true, scriptStates = scriptStates }) end
    }

    for scriptName, state in pairs(scriptStates) do
        state.priorityScript = priorityScript
    end

    local isDragging = false
    local dragStart = nil
    local startPos = nil

    headerFrame.InputBegan:Connect(function(input)
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
            ConfigModule:SaveConfig("AutoScriptsConfig.json", scriptStates, mainFrame, showButton)
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
            ConfigModule:SaveConfig("AutoScriptsConfig.json", scriptStates, mainFrame, showButton)
        end
    end)

    toggleButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        showButton.Visible = true
        showButton.Position = mainFrame.Position
        ConfigModule:SaveConfig("AutoScriptsConfig.json", scriptStates, mainFrame, showButton)
    end)

    showButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        showButton.Visible = false
        ConfigModule:SaveConfig("AutoScriptsConfig.json", scriptStates, mainFrame, showButton)
    end)

    for scriptName, buttonData in pairs(self.buttons) do
        buttonData.button.MouseButton1Click:Connect(function()
            if scriptStates[scriptName].enabled then
                self:StopScript(scriptName)
            else
                local scriptFunc = self.scriptFunctions[scriptName]
                self:StartScript(scriptName, scriptFunc)
            end
            ConfigModule:SaveConfig("AutoScriptsConfig.json", scriptStates, mainFrame, showButton)
        end)
    end

    saveConfigButton.MouseButton1Click:Connect(function()
        ConfigModule:SaveConfig("AutoScriptsConfig.json", scriptStates, mainFrame, showButton)
        local originalColor = saveConfigFrame.BackgroundColor3
        TweenService:Create(saveConfigFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 200, 100)}):Play()
        task.wait(0.5)
        TweenService:Create(saveConfigFrame, TweenInfo.new(0.2), {BackgroundColor3 = originalColor}):Play()
    end)

    Players.PlayerRemoving:Connect(function(playerLeaving)
        if playerLeaving == player then
            ConfigModule:SaveConfig("AutoScriptsConfig.json", scriptStates, mainFrame, showButton)
        end
    end)

    player.CharacterAdded:Connect(function(character)
        if UtilitiesModule:IsPlayerInSomeMode("Challenge") or UtilitiesModule:IsPlayerInSomeMode("Event") or UtilitiesModule:IsPlayerInSomeMode("Ranger Stage") or UtilitiesModule:IsPlayerInSomeMode("Story") then
            return
        end

        for scriptName, state in pairs(scriptStates) do
            if state.enabled then
                local scriptFunc = self.scriptFunctions[scriptName]
                if scriptFunc then
                    self:StartScript(scriptName, scriptFunc)
                end
            end
        end
    end)

    if ConfigModule:LoadConfig("AutoScriptsConfig.json", scriptStates, mainFrame, showButton) then
        for scriptName, state in pairs(scriptStates) do
            UIModule:UpdateButtonState(self.buttons[scriptName], state.enabled)
            if state.enabled then
                local scriptFunc = self.scriptFunctions[scriptName]
                if scriptFunc then
                    self:StartScript(scriptName, scriptFunc)
                end
            end
        end
    end
end

MainModule:Init()

return MainModule