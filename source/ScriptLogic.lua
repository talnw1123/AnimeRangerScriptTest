-- ScriptLogic.lua: Contains core script logic
local ScriptLogic = {}

function ScriptLogic.startScript(scriptName, scriptFunc, scriptStates, buttons, TweenService, COLORS, priorityScript)
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
    state.coroutine = coroutine.create(scriptFunc)
    buttons[scriptName].status.Text = "ON"
    buttons[scriptName].status.TextColor3 = COLORS.TEXT_PRIMARY
    
    TweenService:Create(buttons[scriptName].knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 23, 0.5, -9)}):Play()
    TweenService:Create(buttons[scriptName].bg, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.BUTTON_ON}):Play()
    TweenService:Create(buttons[scriptName].frame, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.BUTTON_ON}):Play()
    
    if scriptName == "GogetaMadaraAndZ10" then
        _G.priorityScript = scriptName
        for name, state in pairs(scriptStates) do
            if name ~= "GogetaMadaraAndZ10" and (name == "RangerAndEasterEvent" or name == "ChallengeAndEasterEvent" or name == "AllRangerAndAllChallenge" or name == "GhoulRangerAndGhoulStory") and state.enabled then
                ScriptLogic.stopScript(name, scriptStates, buttons, TweenService, COLORS, _G.priorityScript)
            end
        end
    elseif scriptName == "AllRangerAndAllChallenge" then
        _G.priorityScript = scriptName
        for name, state in pairs(scriptStates) do
            if name ~= "AllRangerAndAllChallenge" and (name == "RangerAndEasterEvent" or name == "ChallengeAndEasterEvent" or name == "GhoulRangerAndGhoulStory") and state.enabled then
                ScriptLogic.stopScript(name, scriptStates, buttons, TweenService, COLORS, _G.priorityScript)
            end
        end
    end
    
    coroutine.resume(state.coroutine)
end

function ScriptLogic.stopScript(scriptName, scriptStates, buttons, TweenService, COLORS, priorityScript)
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
    buttons[scriptName].status.Text = "OFF"
    buttons[scriptName].status.TextColor3 = COLORS.TEXT_DISABLED
    
    TweenService:Create(buttons[scriptName].knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
    TweenService:Create(buttons[scriptName].bg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
    TweenService:Create(buttons[scriptName].frame, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.BUTTON_OFF}):Play()
    
    if scriptName == "GogetaMadaraAndZ10" or scriptName == "AllRangerAndAllChallenge" then
        _G.priorityScript = nil
        for name, state in pairs(scriptStates) do
            if name ~= "GogetaMadaraAndZ10" and name ~= "AllRangerAndAllChallenge" and state.enabled then
                local scriptFunc = ScriptLogic[name]
                if scriptFunc then
                    ScriptLogic.startScript(name, scriptFunc, scriptStates, buttons, TweenService, COLORS, _G.priorityScript)
                end
            end
        end
    end
end

function ScriptLogic.createAndStartChallengeRoom(Utility, replicatedStorage, player, scriptStates)
    if Utility.isPlayerInSomeMode(replicatedStorage, "Challenge") then
        return true
    end

    if replicatedStorage.PlayRoom:FindFirstChild(player.Name, true) then
        Utility.sendEvent(replicatedStorage, "Remove")
        task.wait(1)
    end

    local world, chapter, difficulty = "World1", "Challenge1", "Hard"
    if not Utility.sendEvent(replicatedStorage, "Change-World", { World = world }) then
        return false
    end
    task.wait(1)
    if not Utility.sendEvent(replicatedStorage, "Change-Chapter", { Chapter = chapter }) then
        return false
    end
    task.wait(1)
    if not Utility.sendEvent(replicatedStorage, "Change-Difficulty", { Difficulty = difficulty }) then
        return false
    end
    task.wait(1)

    if not Utility.sendEvent(replicatedStorage, "Create", { CreateChallengeRoom = true }) then
        return false
    end

    local roomCreated = false
    local startTime = tick()
    while tick() - startTime < 40 do
        if not scriptStates.ChallengeAndEasterEvent.enabled and not scriptStates.AllRangerAndAllChallenge.enabled then
            return false
        end
        local room = replicatedStorage.PlayRoom:FindFirstChild(player.Name, true)
        if room and room.Mode.Value == "Challenge" then
            roomCreated = true
            break
        end
        task.wait(1)
    end

    if roomCreated then
        Utility.sendEvent(replicatedStorage, "Start")
        return true
    end
    return false
end

function ScriptLogic.startEasterEvent(Utility, replicatedStorage, player, DebugPrint, DEBUG)
    if Utility.isPlayerInSomeMode(replicatedStorage, "Event") then return true end

    if replicatedStorage.PlayRoom:FindFirstChild(player.Name, true) then
        Utility.sendEvent(replicatedStorage, "Remove")
        task.wait(2)
    end

    if not Utility.sendEvent(replicatedStorage, "Easter-Event") then return false end
    task.wait(0.5)

    local submitSuccess = false
    local connection
    connection = replicatedStorage.Remote.Server.PlayRoom.Event.OnClientEvent:Connect(function(arg1)
        if arg1 == "Room-Submit/Success" then
            submitSuccess = true
        end
    end)

    if not Utility.sendEvent(replicatedStorage, "Submit") then
        if connection then connection:Disconnect() end
        return false
    end

    local startTime = tick()
    while tick() - startTime < 10 do
        if submitSuccess then break end
        task.wait(0.5)
    end
    if connection then connection:Disconnect() end

    if not submitSuccess then return false end

    if not Utility.sendEvent(replicatedStorage, "Start") then return false end

    startTime = tick()
    while tick() - startTime < 30 do
        if Utility.isPlayerInSomeMode(replicatedStorage, "Event") then return true end
        task.wait(1)
    end
    return false
end

function ScriptLogic.autoJoinStage(Utility, playerGui, replicatedStorage, player, world, chapter, DebugPrint, DEBUG)
    if Utility.isPlayerInSomeMode(replicatedStorage, "Ranger Stage") then
        DebugPrint(DEBUG, "Player already in Ranger Stage mode")
        return false
    end

    DebugPrint(DEBUG, "Starting auto join for stage: " .. chapter)

    Utility.enableGui(playerGui, "PlayRoomSelection", "PlayRoomSelection", DebugPrint, DEBUG)
    task.wait(2)
    Utility.fireServerEvent(replicatedStorage.Remote.Server.PlayRoom.Event, {"Create"}, DebugPrint, DEBUG)
    task.wait(2)

    Utility.enableGui(playerGui, "PlayRoom", "PlayRoom", DebugPrint, DEBUG)
    local gameStage = Utility.waitForGuiElement(playerGui, {"PlayRoom", "Main", "GameStage"})
    if gameStage then
        gameStage.Visible = true
        DebugPrint(DEBUG, "Opened GameStage")
    end
    task.wait(0.5)

    Utility.fireServerEvent(replicatedStorage.Remote.Server.PlayRoom.Event, {"Change-Mode", {Mode = "Ranger Stage"}}, DebugPrint, DEBUG)
    task.wait(0.5)

    Utility.fireServerEvent(replicatedStorage.Remote.Server.PlayRoom.Event, {"Change-World", {World = world}}, DebugPrint, DEBUG)
    task.wait(0.5)

    Utility.fireServerEvent(replicatedStorage.Remote.Server.PlayRoom.Event, {"Change-Chapter", {Chapter = chapter}}, DebugPrint, DEBUG)
    task.wait(0.5)

    local gameSubmit = Utility.waitForGuiElement(playerGui, {"PlayRoom", "Main", "Game_Submit"})
    if gameSubmit then
        gameSubmit.Visible = true
        DebugPrint(DEBUG, "Opened Game_Submit")
    end
    task.wait(0.5)

    Utility.fireServerEvent(replicatedStorage.Remote.Server.PlayRoom.Event, {"Submit"}, DebugPrint, DEBUG)
    task.wait(0.5)

    Utility.fireServerEvent(replicatedStorage.Remote.Server.PlayRoom.Event, {"Start"}, DebugPrint, DEBUG)
    DebugPrint(DEBUG, "Game started for stage " .. chapter)
    return true
end

function ScriptLogic.startZ10Mode(Utility, replicatedStorage, playerGui, player, DebugPrint, DEBUG)
    if Utility.isPlayerInSomeMode(replicatedStorage, "Story") then
        DebugPrint(DEBUG, "Player already in Story mode")
        return false
    end

    DebugPrint(DEBUG, "Starting auto join for Z10")

    local world, chapter = "OPM", "OPM_Chapter10"
    if not Utility.verifyWorldAndChapter(replicatedStorage, world, chapter) then
        warn("Invalid world or chapter for Z10")
        return false
    end

    local playRoomGui = Utility.waitForGuiElement(playerGui, {"PlayRoom"})
    if not playRoomGui then
        warn("PlayRoom GUI not found")
        return false
    end
    playRoomGui.Enabled = true
    DebugPrint(DEBUG, "PlayRoom GUI enabled")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Create") then
        warn("Failed to create room")
        return false
    end
    DebugPrint(DEBUG, "Room created")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Change-Mode", { Mode = "Story" }) then
        warn("Failed to set Story mode")
        return false
    end
    DebugPrint(DEBUG, "Set mode to Story")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Change-World", { World = world }) then
        warn("Failed to select OPM world")
        return false
    end
    DebugPrint(DEBUG, "Selected OPM world")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Change-Chapter", { Chapter = chapter }) then
        warn("Failed to select OPM_Chapter10 chapter")
        return false
    end
    DebugPrint(DEBUG, "Selected OPM_Chapter10 chapter")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Change-Difficulty", { Difficulty = "Nightmare" }) then
        warn("Failed to set Nightmare difficulty")
        return false
    end
    DebugPrint(DEBUG, "Set difficulty to Nightmare")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Submit") then
        warn("Failed to submit room settings")
        return false
    end
    DebugPrint(DEBUG, "Room settings submitted")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Start") then
        warn("Failed to start game")
        return false
    end
    DebugPrint(DEBUG, "Game started")

    local submitSuccess = false
    local connection
    connection = replicatedStorage.Remote.Server.PlayRoom.Event.OnClientEvent:Connect(function(arg1)
        if arg1 == "Room-Submit/Success" or arg1 == "Room-Submit/Teleport" then
            DebugPrint(DEBUG, "Room submission successful")
            submitSuccess = true
        end
    end)

    local startTime = tick()
    while tick() - startTime < 10 do
        if submitSuccess then break end
        task.wait(0.5)
    end
    if connection then connection:Disconnect() end
    return submitSuccess
end

function ScriptLogic.startGhoulStoryMode(Utility, replicatedStorage, playerGui, player, DebugPrint, DEBUG)
    if Utility.isPlayerInSomeMode(replicatedStorage, "Story") then
        DebugPrint(DEBUG, "Player already in Story mode")
        return false
    end

    DebugPrint(DEBUG, "Starting auto join for TokyoGhoul_Chapter10")

    local world, chapter = "TokyoGhoul", "TokyoGhoul_Chapter10"
    if not Utility.verifyWorldAndChapter(replicatedStorage, world, chapter) then
        warn("Invalid world or chapter for TokyoGhoul_Chapter10")
        return false
    end

    local playRoomGui = Utility.waitForGuiElement(playerGui, {"PlayRoom"})
    if not playRoomGui then
        warn("PlayRoom GUI not found")
        return false
    end
    playRoomGui.Enabled = true
    DebugPrint(DEBUG, "PlayRoom GUI enabled")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Create") then
        warn("Failed to create room")
        return false
    end
    DebugPrint(DEBUG, "Room created")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Change-Mode", { Mode = "Story" }) then
        warn("Failed to set Story mode")
        return false
    end
    DebugPrint(DEBUG, "Set mode to Story")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Change-World", { World = world }) then
        warn("Failed to select TokyoGhoul world")
        return false
    end
    DebugPrint(DEBUG, "Selected TokyoGhoul world")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Change-Chapter", { Chapter = chapter }) then
        warn("Failed to select TokyoGhoul_Chapter10 chapter")
        return false
    end
    DebugPrint(DEBUG, "Selected TokyoGhoul_Chapter10 chapter")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Change-Difficulty", { Difficulty = "Nightmare" }) then
        warn("Failed to set Nightmare difficulty")
        return false
    end
    DebugPrint(DEBUG, "Set difficulty to Nightmare")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Submit") then
        warn("Failed to submit room settings")
        return false
    end
    DebugPrint(DEBUG, "Room settings submitted")
    task.wait(0.5)

    if not Utility.sendEvent(replicatedStorage, "Start") then
        warn("Failed to start game")
        return false
    end
    DebugPrint(DEBUG, "Game started")

    local submitSuccess = false
    local connection
    connection = replicatedStorage.Remote.Server.PlayRoom.Event.OnClientEvent:Connect(function(arg1)
        if arg1 == "Room-Submit/Success" or arg1 == "Room-Submit/Teleport" then
            DebugPrint(DEBUG, "Room submission successful")
            submitSuccess = true
        end
    end)

    local startTime = tick()
    while tick() - startTime < 10 do
        if submitSuccess then break end
        task.wait(0.5)
    end
    if connection then connection:Disconnect() end
    return submitSuccess
end

ScriptLogic.rangerStages = {
    { world = "OnePiece", chapter = "OnePiece_RangerStage1" },
    { world = "OnePiece", chapter = "OnePiece_RangerStage2" },
    { world = "OnePiece", chapter = "OnePiece_RangerStage3" },
    { world = "Namek", chapter = "Namek_RangerStage1" },
    { world = "Namek", chapter = "Namek_RangerStage2" },
    { world = "Namek", chapter = "Namek_RangerStage3" },
    { world = "DemonSlayer", chapter = "DemonSlayer_RangerStage1" },
    { world = "DemonSlayer", chapter = "DemonSlayer_RangerStage2" },
    { world = "DemonSlayer", chapter = "DemonSlayer_RangerStage3" },
    { world = "Naruto", chapter = "Naruto_RangerStage1" },
    { world = "Naruto", chapter = "Naruto_RangerStage2" },
    { world = "Naruto", chapter = "Naruto_RangerStage3" },
    { world = "OPM", chapter = "OPM_RangerStage1" },
    { world = "OPM", chapter = "OPM_RangerStage2" },
    { world = "OPM", chapter = "OPM_RangerStage3" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage1" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage2" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage3" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage4" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage5" }
}

ScriptLogic.gogetaMadaraStages = {
    { world = "Namek", chapter = "Namek_RangerStage1" },
    { world = "Namek", chapter = "Namek_RangerStage2" },
    { world = "Namek", chapter = "Namek_RangerStage3" },
    { world = "Naruto", chapter = "Naruto_RangerStage1" },
    { world = "Naruto", chapter = "Naruto_RangerStage2" },
    { world = "Naruto", chapter = "Naruto_RangerStage3" }
}

ScriptLogic.gogetaStages = {
    { world = "Namek", chapter = "Namek_RangerStage1" },
    { world = "Namek", chapter = "Namek_RangerStage2" },
    { world = "Namek", chapter = "Namek_RangerStage3" }
}

ScriptLogic.madaraStages = {
    { world = "Naruto", chapter = "Naruto_RangerStage1" },
    { world = "Naruto", chapter = "Naruto_RangerStage2" },
    { world = "Naruto", chapter = "Naruto_RangerStage3" }
}

ScriptLogic.ghoulStages = {
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage1" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage2" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage3" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage4" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage5" }
}

function ScriptLogic.AutoUpgrade(replicatedStorage, player, playerGui, scriptStates)
    local upgradeEvent = Utility.waitForRemote(replicatedStorage, {"Remote", "Server", "Units", "Upgrade"})
    local unitsFolder = player:WaitForChild("UnitsFolder")
    local unitFrame = Utility.waitForGuiElement(playerGui, {"HUD", "InGame", "UnitsManager", "Main", "Main", "ScrollingFrame"})

    while scriptStates.AutoUpgrade.enabled do
        for _, unit in ipairs(unitsFolder:GetChildren()) do
            if not scriptStates.AutoUpgrade.enabled then break end
            if unit:IsA("Folder") then
                local uiUnit = unitFrame and unitFrame:FindFirstChild(unit.Name)
                if uiUnit and uiUnit:FindFirstChild("CostText") then
                    local costText = uiUnit.CostText.ContentText or uiUnit.CostText.Text
                    if costText ~= "Cost: 0" then
                        upgradeEvent:FireServer(unit)
                        task.wait(0.2)
                    end
                end
            end
        end
        task.wait(2)
    end
end

function ScriptLogic.RetryMap(replicatedStorage, playerGui, scriptStates)
    local voteRetry = Utility.waitForRemote(replicatedStorage, {"Remote", "Server", "OnGame", "Voting", "VoteRetry"})
    
    while scriptStates.RetryMap.enabled do
        if voteRetry then
            voteRetry:FireServer()
        end
        task.wait(5)
    end
end

function ScriptLogic.AutoPlay(replicatedStorage, playerGui, scriptStates)
    local autoPlayEvent = Utility.waitForRemote(replicatedStorage, {"Remote", "Server", "OnGame", "AutoPlay"})
    
    while scriptStates.AutoPlay.enabled do
        if autoPlayEvent then
            autoPlayEvent:FireServer(true)
        end
        task.wait(10)
    end
end

function ScriptLogic.VotePass(replicatedStorage, playerGui, scriptStates)
    local votePass = Utility.waitForRemote(replicatedStorage, {"Remote", "Server", "OnGame", "Voting", "VotePass"})
    
    while scriptStates.VotePass.enabled do
        if votePass then
            votePass:FireServer()
        end
        task.wait(5)
    end
end

function ScriptLogic.InspectFinished(replicatedStorage, playerGui, scriptStates)
    local inspectEvent = Utility.waitForRemote(replicatedStorage, {"Remote", "Server", "OnGame", "InspectFinished"})
    
    while scriptStates.InspectFinished.enabled do
        if inspectEvent then
            inspectEvent:FireServer()
        end
        task.wait(5)
    end
end

function ScriptLogic.StandardSummon(replicatedStorage, player, playerGui, VirtualInputManager, scriptStates, SUMMON_COSTS, TARGET_GEMS, DebugPrint, DEBUG)
    while scriptStates.StandardSummon.enabled do
        local currentGems = Utility.GetCurrentGems(replicatedStorage, player)
        if not currentGems then
            DebugPrint(DEBUG, "Could not retrieve gem count")
            task.wait(5)
            continue
        end

        local maxSummons = Utility.CalculateMaxSummons(currentGems, SUMMON_COSTS, TARGET_GEMS)
        if maxSummons <= 0 then
            DebugPrint(DEBUG, "Not enough gems to summon")
            task.wait(10)
            continue
        end

        DebugPrint(DEBUG, "Attempting to summon " .. maxSummons .. " times")
        for i = 1, maxSummons do
            if not scriptStates.StandardSummon.enabled then break end
            local success, isStorageFull = Utility.SummonUnits(replicatedStorage, player, SUMMON_COSTS)
            if not success then
                DebugPrint(DEBUG, "Summon failed")
                task.wait(5)
                continue
            end
            if isStorageFull then
                DebugPrint(DEBUG, "Storage full, stopping summon")
                break
            end
            if not Utility.ClearRewardScreen(VirtualInputManager, scriptStates) then
                DebugPrint(DEBUG, "Failed to clear reward screen or script disabled")
                break
            end
            task.wait(1)
        end
        task.wait(5)
    end
end

function ScriptLogic.ChallengeAndEasterEvent(Utility, replicatedStorage, playerGui, player, scriptStates, DebugPrint, DEBUG)
    while scriptStates.ChallengeAndEasterEvent.enabled do
        if Utility.checkForRangerCrystal(replicatedStorage) then
            DebugPrint(DEBUG, "Ranger Crystal detected, starting Easter Event")
            if not ScriptLogic.startEasterEvent(Utility, replicatedStorage, player, DebugPrint, DEBUG) then
                DebugPrint(DEBUG, "Failed to start Easter Event")
            end
        else
            DebugPrint(DEBUG, "No Ranger Crystal, starting Challenge Mode")
            if not ScriptLogic.createAndStartChallengeRoom(Utility, replicatedStorage, player, scriptStates) then
                DebugPrint(DEBUG, "Failed to start Challenge Mode")
            end
        end
        task.wait(30)
    end
end

function ScriptLogic.VoteNext(replicatedStorage, playerGui, scriptStates)
    local voteNext = Utility.waitForRemote(replicatedStorage, {"Remote", "Server", "OnGame", "Voting", "VoteNext"})
    
    while scriptStates.VoteNext.enabled do
        if voteNext then
            voteNext:FireServer()
        end
        task.wait(5)
    end
end

function ScriptLogic.RangerAndEasterEvent(Utility, replicatedStorage, playerGui, player, scriptStates, DebugPrint, DEBUG)
    while scriptStates.RangerAndEasterEvent.enabled do
        if Utility.checkForRangerCrystal(replicatedStorage) then
            DebugPrint(DEBUG, "Ranger Crystal detected, starting Easter Event")
            if not ScriptLogic.startEasterEvent(Utility, replicatedStorage, player, DebugPrint, DEBUG) then
                DebugPrint(DEBUG, "Failed to start Easter Event")
            end
        else
            DebugPrint(DEBUG, "No Ranger Crystal, cycling through Ranger Stages")
            for _, stage in ipairs(ScriptLogic.rangerStages) do
                if not scriptStates.RangerAndEasterEvent.enabled then break end
                if not Utility.isRangerStageCleared(replicatedStorage, player, stage.chapter) then
                    DebugPrint(DEBUG, "Joining Ranger Stage: " .. stage.chapter)
                    ScriptLogic.autoJoinStage(Utility, playerGui, replicatedStorage, player, stage.world, stage.chapter, DebugPrint, DEBUG)
                    task.wait(60)
                end
            end
        end
        task.wait(30)
    end
end

function ScriptLogic.GogetaMadaraAndZ10(Utility, replicatedStorage, playerGui, player, scriptStates, DebugPrint, DEBUG)
    while scriptStates.GogetaMadaraAndZ10.enabled do
        for _, stage in ipairs(ScriptLogic.gogetaMadaraStages) do
            if not scriptStates.GogetaMadaraAndZ10.enabled then break end
            if not Utility.isRangerStageCleared(replicatedStorage, player, stage.chapter) then
                DebugPrint(DEBUG, "Joining Ranger Stage: " .. stage.chapter)
                ScriptLogic.autoJoinStage(Utility, playerGui, replicatedStorage, player, stage.world, stage.chapter, DebugPrint, DEBUG)
                task.wait(60)
            end
        end
        if scriptStates.GogetaMadaraAndZ10.enabled then
            DebugPrint(DEBUG, "Starting Z10 Mode")
            ScriptLogic.startZ10Mode(Utility, replicatedStorage, playerGui, player, DebugPrint, DEBUG)
            task.wait(60)
        end
    end
end

function ScriptLogic.GogetaAndZ10(Utility, replicatedStorage, playerGui, player, scriptStates, DebugPrint, DEBUG)
    while scriptStates.GogetaAndZ10.enabled do
        for _, stage in ipairs(ScriptLogic.gogetaStages) do
            if not scriptStates.GogetaAndZ10.enabled then break end
            if not Utility.isRangerStageCleared(replicatedStorage, player, stage.chapter) then
                DebugPrint(DEBUG, "Joining Ranger Stage: " .. stage.chapter)
                ScriptLogic.autoJoinStage(Utility, playerGui, replicatedStorage, player, stage.world, stage.chapter, DebugPrint, DEBUG)
                task.wait(60)
            end
        end
        if scriptStates.GogetaAndZ10.enabled then
            DebugPrint(DEBUG, "Starting Z10 Mode")
            ScriptLogic.startZ10Mode(Utility, replicatedStorage, playerGui, player, DebugPrint, DEBUG)
            task.wait(60)
        end
    end
end

function ScriptLogic.MadaraAndZ10(Utility, replicatedStorage, playerGui, player, scriptStates, DebugPrint, DEBUG)
    while scriptStates.MadaraAndZ10.enabled do
        for _, stage in ipairs(ScriptLogic.madaraStages) do
            if not scriptStates.MadaraAndZ10.enabled then break end
            if not Utility.isRangerStageCleared(replicatedStorage, player, stage.chapter) then
                DebugPrint(DEBUG, "Joining Ranger Stage: " .. stage.chapter)
                ScriptLogic.autoJoinStage(Utility, playerGui, replicatedStorage, player, stage.world, stage.chapter, DebugPrint, DEBUG)
                task.wait(60)
            end
        end
        if scriptStates.MadaraAndZ10.enabled then
            DebugPrint(DEBUG, "Starting Z10 Mode")
            ScriptLogic.startZ10Mode(Utility, replicatedStorage, playerGui, player, DebugPrint, DEBUG)
            task.wait(60)
        end
    end
end

function ScriptLogic.AllRangerAndAllChallenge(Utility, replicatedStorage, playerGui, player, scriptStates, DebugPrint, DEBUG)
    while scriptStates.AllRangerAndAllChallenge.enabled do
        local allStagesCleared = true
        for _, stage in ipairs(ScriptLogic.rangerStages) do
            if not scriptStates.AllRangerAndAllChallenge.enabled then break end
            if not Utility.isRangerStageCleared(replicatedStorage, player, stage.chapter) then
                allStagesCleared = false
                DebugPrint(DEBUG, "Joining Ranger Stage: " .. stage.chapter)
                ScriptLogic.autoJoinStage(Utility, playerGui, replicatedStorage, player, stage.world, stage.chapter, DebugPrint, DEBUG)
                task.wait(60)
            end
        end
        if allStagesCleared and scriptStates.AllRangerAndAllChallenge.enabled then
            DebugPrint(DEBUG, "All Ranger Stages cleared, starting Challenge Mode")
            ScriptLogic.createAndStartChallengeRoom(Utility, replicatedStorage, player, scriptStates)
            task.wait(60)
        end
        task.wait(30)
    end
end

function ScriptLogic.GhoulRangerAndGhoulStory(Utility, replicatedStorage, playerGui, player, scriptStates, DebugPrint, DEBUG)
    while scriptStates.GhoulRangerAndGhoulStory.enabled do
        for _, stage in ipairs(ScriptLogic.ghoulStages) do
            if not scriptStates.GhoulRangerAndGhoulStory.enabled then break end
            if not Utility.isRangerStageCleared(replicatedStorage, player, stage.chapter) then
                DebugPrint(DEBUG, "Joining Ranger Stage: " .. stage.chapter)
                ScriptLogic.autoJoinStage(Utility, playerGui, replicatedStorage, player, stage.world, stage.chapter, DebugPrint, DEBUG)
                task.wait(60)
            end
        end
        if scriptStates.GhoulRangerAndGhoulStory.enabled then
            DebugPrint(DEBUG, "Starting TokyoGhoul Story Mode")
            ScriptLogic.startGhoulStoryMode(Utility, replicatedStorage, playerGui, player, DebugPrint, DEBUG)
            task.wait(60)
        end
    end
end

function ScriptLogic.AutoLeave(replicatedStorage, TeleportService, scriptStates, DebugPrint, DEBUG)
    local gameEndedSignal = replicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("OnGame"):WaitForChild("GameEnded")
    
    while scriptStates.AutoLeave.enabled do
        local connection
        connection = gameEndedSignal.OnClientEvent:Connect(function()
            DebugPrint(DEBUG, "Game ended, leaving...")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
        end)
        scriptStates.AutoLeave.connection = connection
        while scriptStates.AutoLeave.enabled do
            task.wait(10)
        end
        if connection then
            connection:Disconnect()
            scriptStates.AutoLeave.connection = nil
        end
    end
end

function ScriptLogic.setupAutoExecute(player, scriptStates, configSystem)
    local autoExecuteScripts = {
        "AutoUpgrade",
        "RetryMap",
        "AutoPlay",
        "VotePass",
        "InspectFinished",
        "StandardSummon",
        "ChallengeAndEasterEvent",
        "VoteNext",
        "RangerAndEasterEvent",
        "GogetaMadaraAndZ10",
        "GogetaAndZ10",
        "MadaraAndZ10",
        "AllRangerAndAllChallenge",
        "GhoulRangerAndGhoulStory",
        "AutoLeave"
    }
    
    for _, scriptName in ipairs(autoExecuteScripts) do
        if scriptStates[scriptName].enabled then
            local scriptFunc = ScriptLogic[scriptName]
            if scriptFunc then
                ScriptLogic.startScript(scriptName, scriptFunc, scriptStates, {}, nil, {}, nil)
            end
        end
    end
end

return ScriptLogic