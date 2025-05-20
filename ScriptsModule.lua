local ScriptsModule = {}

local Players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ตัวแปร UtilitiesModule จะถูกส่งมาจาก loader.lua
local UtilitiesModule

-- ฟังก์ชันสำหรับตั้งค่า UtilitiesModule
function ScriptsModule:SetUtilitiesModule(module)
    UtilitiesModule = module
end

local SUMMON_COSTS = { Standard = 500 }
local TARGET_GEMS = 24000
local DEBUG = false

local function DebugPrint(...)
    if DEBUG then
        print(...)
    end
end

-- ต่อจากนี้โค้ดเหมือนเดิม แต่ใช้ UtilitiesModule ที่ส่งมา
local rangerStages = {
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

local gogetaMadaraStages = {
    { world = "Namek", chapter = "Namek_RangerStage1" },
    { world = "Namek", chapter = "Namek_RangerStage2" },
    { world = "Namek", chapter = "Namek_RangerStage3" },
    { world = "Naruto", chapter = "Naruto_RangerStage1" },
    { world = "Naruto", chapter = "Naruto_RangerStage2" },
    { world = "Naruto", chapter = "Naruto_RangerStage3" }
}

local gogetaStages = {
    { world = "Namek", chapter = "Namek_RangerStage1" },
    { world = "Namek", chapter = "Namek_RangerStage2" },
    { world = "Namek", chapter = "Namek_RangerStage3" }
}

local madaraStages = {
    { world = "Naruto", chapter = "Naruto_RangerStage1" },
    { world = "Naruto", chapter = "Naruto_RangerStage2" },
    { world = "Naruto", chapter = "Naruto_RangerStage3" }
}

local ghoulStages = {
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage1" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage2" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage3" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage4" },
    { world = "TokyoGhoul", chapter = "TokyoGhoul_RangerStage5" }
}

function ScriptsModule:AutoUpgradeScript(state)
    local upgradeEvent = replicatedStorage:WaitForChild("Remote")
        :WaitForChild("Server")
        :WaitForChild("Units")
        :WaitForChild("Upgrade")
    local unitsFolder = player:WaitForChild("UnitsFolder")
    local unitFrame = playerGui:WaitForChild("HUD")
        :WaitForChild("InGame")
        :WaitForChild("UnitsManager")
        :WaitForChild("Main")
        :WaitForChild("Main")
        :WaitForChild("ScrollingFrame")

    while state.enabled do
        for _, unit in ipairs(unitsFolder:GetChildren()) do
            if not state.enabled then break end
            if unit:IsA("Folder") then
                local uiUnit = unitFrame:FindFirstChild(unit.Name)
                if uiUnit and uiUnit:FindFirstChild("CostText") then
                    local costText = uiUnit.CostText.Text or uiUnit.CostText.ContentText
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

function ScriptsModule:RetryMapScript(state)
    local voteRetry = replicatedStorage:WaitForChild("Remote")
        :WaitForChild("Server")
        :WaitForChild("OnGame")
        :WaitForChild("Voting")
        :WaitForChild("VoteRetry")

    while state.enabled do
        local rewardsUI = playerGui:FindFirstChild("RewardsUI")
        if rewardsUI and rewardsUI.Enabled then
            if voteRetry and voteRetry:IsA("RemoteEvent") then
                voteRetry:FireServer()
            end
            repeat
                task.wait(1)
            until not rewardsUI.Enabled or not state.enabled
        end
        task.wait(5)
    end
end

function ScriptsModule:AutoPlayScript(state)
    local autoPlay = replicatedStorage:WaitForChild("Remote")
        :WaitForChild("Server")
        :WaitForChild("Units")
        :WaitForChild("AutoPlay")

    while state.enabled do
        local autoPlayButton
        pcall(function()
            autoPlayButton = playerGui
                :WaitForChild("HUD")
                :WaitForChild("InGame")
                :WaitForChild("Main")
                :WaitForChild("AutoPlay")
                :WaitForChild("Back")
                :WaitForChild("true")
        end)

        if autoPlayButton and autoPlayButton.Enabled == false then
            if autoPlay and autoPlay:IsA("RemoteEvent") then
                autoPlay:FireServer(true)
            end
            repeat
                task.wait(1)
            until autoPlayButton.Enabled or not state.enabled
        end
        task.wait(60)
    end
end

function ScriptsModule:VotePassScript(state)
    local votePlaying = replicatedStorage:WaitForChild("Remote")
        :WaitForChild("Server")
        :WaitForChild("OnGame")
        :WaitForChild("Voting")
        :WaitForChild("VotePlaying")

    while state.enabled do
        local voteGui
        pcall(function()
            voteGui = playerGui:WaitForChild("HUD")
                :WaitForChild("InGame")
                :FindFirstChild("VotePlaying")
        end)

        if voteGui and voteGui.Visible then
            if votePlaying and votePlaying:IsA("RemoteEvent") then
                votePlaying:FireServer()
            end
            repeat
                task.wait(1)
            until not voteGui.Visible or not state.enabled
        end
        task.wait(5)
    end
end

function ScriptsModule:VoteNextScript(state)
    local voteNext = replicatedStorage:WaitForChild("Remote")
        :WaitForChild("Server")
        :WaitForChild("OnGame")
        :WaitForChild("Voting")
        :WaitForChild("VoteNext")

    while state.enabled do
        local rewardsUI = playerGui:FindFirstChild("RewardsUI")
        if rewardsUI and rewardsUI.Enabled then
            if UtilitiesModule:IsPlayerInSomeMode("Story") then
                DebugPrint("VoteNext: Skipping in TokyoGhoul_Chapter10")
                task.wait(5)
            else
                local nextButton = rewardsUI:FindFirstChild("Main")
                    and rewardsUI.Main:FindFirstChild("LeftSide")
                    and rewardsUI.Main.LeftSide:FindFirstChild("Button")
                    and rewardsUI.Main.LeftSide.Button:FindFirstChild("Next")

                if nextButton and nextButton.Visible then
                    if voteNext and voteNext:IsA("RemoteEvent") then
                        task.wait(1)
                        if state.enabled then
                            voteNext:FireServer()
                        end
                    end
                    repeat
                        task.wait(1)
                    until not nextButton.Visible or not rewardsUI.Enabled or not state.enabled
                end
            end
        end
        task.wait(5)
    end
end

function ScriptsModule:InspectFinishedScript(state)
    while state.enabled do
        local inspectFinished = UtilitiesModule:FindObject("Inspect_Finished", "StringValue", player)
            or UtilitiesModule:FindObject("Inspect_Finished", "StringValue", playerGui)
            or UtilitiesModule:FindObject("Inspect_Finished", "StringValue", replicatedStorage)

        if inspectFinished then
            while inspectFinished and inspectFinished.Parent and state.enabled do
                UtilitiesModule:SimulateClick()
                task.wait(1)
                inspectFinished = UtilitiesModule:FindObject("Inspect_Finished", "StringValue", player)
                    or UtilitiesModule:FindObject("Inspect_Finished", "StringValue", playerGui)
                    or UtilitiesModule:FindObject("Inspect_Finished", "StringValue", replicatedStorage)
            end
        end
        task.wait(10)
    end
end

function ScriptsModule:StandardSummonScript(state)
    while state.enabled do
        local currentGems = UtilitiesModule:GetCurrentGems()
        if not currentGems then
            task.wait(10)
            continue
        end

        local maxSummons = UtilitiesModule:CalculateMaxSummons(currentGems, SUMMON_COSTS.Standard, TARGET_GEMS)
        if maxSummons == 0 then
            task.wait(10)
            continue
        end

        local summonsPerformed = 0
        for i = 1, maxSummons do
            if not state.enabled then break end
            if (currentGems - SUMMON_COSTS.Standard) < TARGET_GEMS then break end

            local success, isStorageFull = UtilitiesModule:SummonUnits("Standard")
            if not success then break end
            if isStorageFull then break end

            summonsPerformed = summonsPerformed + 1
            local cleared = UtilitiesModule:ClearRewardScreen()
            if not cleared then break end

            task.wait(0.3)
            local newGems = UtilitiesModule:GetCurrentGems()
            if newGems then
                currentGems = newGems
            else
                currentGems = currentGems - SUMMON_COSTS.Standard
            end
        end
        task.wait(10)
    end
end

function ScriptsModule:CreateAndStartChallengeRoom(state)
    if UtilitiesModule:IsPlayerInSomeMode("Challenge") then
        print("Player is already in Challenge mode")
        return true
    end

    if replicatedStorage.PlayRoom:FindFirstChild(player.Name, true) then
        warn("Player is already in a room! Removing from current room...")
        UtilitiesModule:SendEvent("Remove")
        task.wait(1)
    end

    local world = "World1"
    local chapter = "Challenge1"
    local difficulty = "Hard"

    print("Setting up room parameters...")
    if not UtilitiesModule:SendEvent("Change-World", { World = world }) then
        warn("Failed to set World")
        return false
    end
    task.wait(1)
    if not UtilitiesModule:SendEvent("Change-Chapter", { Chapter = chapter }) then
        warn("Failed to set Chapter")
        return false
    end
    task.wait(1)
    if not UtilitiesModule:SendEvent("Change-Difficulty", { Difficulty = difficulty }) then
        warn("Failed to set Difficulty")
        return false
    end
    task.wait(1)

    print("Creating Challenge room...")
    if not UtilitiesModule:SendEvent("Create", { CreateChallengeRoom = true }) then
        warn("Failed to create Challenge room")
        return false
    end

    local roomCreated = false
    local startTime = tick()
    while tick() - startTime < 40 do
        if not state.enabled then
            warn("Script disabled, stopping room creation")
            return false
        end
        local room = replicatedStorage.PlayRoom:FindFirstChild(player.Name, true)
        if room then
            print("Room found:", room.Name, "Mode:", room.Mode.Value, "Players:", #room.Players:GetChildren())
            if room.Mode.Value == "Challenge" then
                roomCreated = true
                break
            end
        end
        task.wait(1)
    end

    if roomCreated then
        print("Room created successfully! Starting game...")
        UtilitiesModule:SendEvent("Start")
        return true
    else
        warn("Timeout: Room not created within 40 seconds")
        return false
    end
end

function ScriptsModule:StartEasterEvent(state)
    if UtilitiesModule:IsPlayerInSomeMode("Event") then return true end

    if replicatedStorage.PlayRoom:FindFirstChild(player.Name, true) then
        UtilitiesModule:SendEvent("Remove")
        task.wait(2)
    end

    if not UtilitiesModule:SendEvent("Easter-Event") then return false end
    task.wait(0.5)

    local submitSuccess = false
    local connection
    connection = replicatedStorage.Remote.Server.PlayRoom.Event.OnClientEvent:Connect(function(arg1)
        if arg1 == "Room-Submit/Success" then
            submitSuccess = true
        end
    end)

    if not UtilitiesModule:SendEvent("Submit") then
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

    if not UtilitiesModule:SendEvent("Start") then return false end

    startTime = tick()
    while tick() - startTime < 30 do
        if UtilitiesModule:IsPlayerInSomeMode("Event") then return true end
        task.wait(1)
    end
    return false
end

function ScriptsModule:AutoJoinStage(state, world, chapter)
    if UtilitiesModule:IsPlayerInSomeMode("Ranger Stage") then
        DebugPrint("Player already in Ranger Stage mode, skipping room creation")
        return false
    end

    DebugPrint("Starting auto join for stage: " .. chapter)

    local playRoomGui = playerGui:WaitForChild("PlayRoomSelection")
    if playRoomGui then
        playRoomGui.Enabled = true
        DebugPrint("Enabled GUI: PlayRoomSelection")
    end
    task.wait(2)
    UtilitiesModule:SendEvent("Create")
    task.wait(2)

    local playRoom = playerGui:WaitForChild("PlayRoom")
    if playRoom then
        playRoom.Enabled = true
        local gameStage = playRoom:FindFirstChild("Main") and playRoom.Main:FindFirstChild("GameStage")
        if gameStage then
            gameStage.Visible = true
            DebugPrint("Opened GameStage")
        end
    end
    task.wait(0.5)

    UtilitiesModule:SendEvent("Change-Mode", { ["Mode"] = "Ranger Stage" })
    task.wait(0.5)

    DebugPrint("Setting world " .. world .. "...")
    UtilitiesModule:SendEvent("Change-World", { ["World"] = world })
    task.wait(0.5)

    DebugPrint("Setting chapter " .. chapter .. "...")
    UtilitiesModule:SendEvent("Change-Chapter", { ["Chapter"] = chapter })
    task.wait(0.5)

    local gameSubmit = playRoom and playRoom:FindFirstChild("Main") and playRoom.Main:FindFirstChild("Game_Submit")
    if gameSubmit then
        gameSubmit.Visible = true
        DebugPrint("Opened Game_Submit")
    end
    task.wait(0.5)

    UtilitiesModule:SendEvent("Submit")
    task.wait(0.5)

    DebugPrint("Starting game...")
    UtilitiesModule:SendEvent("Start")
    DebugPrint("Game started for stage " .. chapter)
    return true
end

function ScriptsModule:StartZ10Mode(state)
    if UtilitiesModule:IsPlayerInSomeMode("Story") then
        DebugPrint("Player already in Story mode, skipping room creation")
        return false
    end

    DebugPrint("Starting auto join for Z10")

    local world, chapter = "OPM", "OPM_Chapter10"
    if not UtilitiesModule:VerifyWorldAndChapter(world, chapter) then
        warn("Invalid world or chapter for Z10")
        return false
    end

    local playRoomGui = UtilitiesModule:WaitForGuiElement({"PlayRoom"})
    if not playRoomGui then
        warn("PlayRoom GUI not found")
        return false
    end
    playRoomGui.Enabled = true
    DebugPrint("PlayRoom GUI enabled")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Create") then
        warn("Failed to create room")
        return false
    end
    DebugPrint("Room created")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Change-Mode", { Mode = "Story" }) then
        warn("Failed to set Story mode")
        return false
    end
    DebugPrint("Set mode to Story")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Change-World", { World = world }) then
        warn("Failed to select OPM world")
        return false
    end
    DebugPrint("Selected OPM world")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Change-Chapter", { Chapter = chapter }) then
        warn("Failed to select OPM_Chapter10 chapter")
        return false
    end
    DebugPrint("Selected OPM_Chapter10 chapter")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Change-Difficulty", { Difficulty = "Nightmare" }) then
        warn("Failed to set Nightmare difficulty")
        return false
    end
    DebugPrint("Set difficulty to Nightmare")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Submit") then
        warn("Failed to submit room settings")
        return false
    end
    DebugPrint("Room settings submitted")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Start") then
        warn("Failed to start game")
        return false
    end
    DebugPrint("Game started")

    local submitSuccess = false
    local connection
    connection = replicatedStorage.Remote.Server.PlayRoom.Event.OnClientEvent:Connect(function(arg1)
        if arg1 == "Room-Submit/Success" then
            DebugPrint("Room submission successful")
            submitSuccess = true
            connection:Disconnect()
        elseif arg1 == "Room-Submit/Teleport" then
            DebugPrint("Teleporting to game...")
            submitSuccess = true
            connection:Disconnect()
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

function ScriptsModule:StartGhoulStoryMode(state)
    if UtilitiesModule:IsPlayerInSomeMode("Story") then
        DebugPrint("Player already in Story mode, skipping room creation")
        return false
    end

    DebugPrint("Starting auto join for TokyoGhoul_Chapter10")

    local world, chapter = "TokyoGhoul", "TokyoGhoul_Chapter10"
    if not UtilitiesModule:VerifyWorldAndChapter(world, chapter) then
        warn("Invalid world or chapter for TokyoGhoul_Chapter10")
        return false
    end

    local playRoomGui = UtilitiesModule:WaitForGuiElement({"PlayRoom"})
    if not playRoomGui then
        warn("PlayRoom GUI not found")
        return false
    end
    playRoomGui.Enabled = true
    DebugPrint("PlayRoom GUI enabled")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Create") then
        warn("Failed to create room")
        return false
    end
    DebugPrint("Room created")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Change-Mode", { Mode = "Story" }) then
        warn("Failed to set Story mode")
        return false
    end
    DebugPrint("Set mode to Story")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Change-World", { World = world }) then
        warn("Failed to select TokyoGhoul world")
        return false
    end
    DebugPrint("Selected TokyoGhoul world")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Change-Chapter", { Chapter = chapter }) then
        warn("Failed to select TokyoGhoul_Chapter10 chapter")
        return false
    end
    DebugPrint("Selected TokyoGhoul_Chapter10 chapter")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Change-Difficulty", { Difficulty = "Nightmare" }) then
        warn("Failed to set Nightmare difficulty")
        return false
    end
    DebugPrint("Set difficulty to Nightmare")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Submit") then
        warn("Failed to submit room settings")
        return false
    end
    DebugPrint("Room settings submitted")
    task.wait(0.5)

    if not UtilitiesModule:SendEvent("Start") then
        warn("Failed to start game")
        return false
    end
    DebugPrint("Game started")

    local submitSuccess = false
    local connection
    connection = replicatedStorage.Remote.Server.PlayRoom.Event.OnClientEvent:Connect(function(arg1)
        if arg1 == "Room-Submit/Success" then
            DebugPrint("Room submission successful")
            submitSuccess = true
            connection:Disconnect()
        elseif arg1 == "Room-Submit/Teleport" then
            DebugPrint("Teleporting to game...")
            submitSuccess = true
            connection:Disconnect()
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

function ScriptsModule:ChallengeAndEasterEventScript(state)
    local PlayRoomEvent = replicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event")
    local connection
    connection = PlayRoomEvent.OnClientEvent:Connect(function(arg1, ...) end)
    state.connection = connection

    if replicatedStorage.Remote.Client.UI:FindFirstChild("Challenge_Updated") then
        local challengeConnection
        challengeConnection = replicatedStorage.Remote.Client.UI.Challenge_Updated.OnClientEvent:Connect(function(...) end)
        state.challengeConnection = challengeConnection
    end

    while state.enabled do
        if state.priorityScript == "GogetaMadaraAndZ10" or state.priorityScript == "AllRangerAndAllChallenge" then
            task.wait(5)
            continue
        end

        if UtilitiesModule:IsPlayerInSomeMode("Challenge") then
            task.wait(60)
        elseif UtilitiesModule:IsPlayerInSomeMode("Event") then
            task.wait(60)
        end

        local hasRangerCrystal = UtilitiesModule:CheckForRangerCrystal()
        if hasRangerCrystal then
            if state.easterEventCoroutine then
                state.easterEventCoroutine = nil
            end
            local success = self:CreateAndStartChallengeRoom(state)
            if not success then
                task.wait(5)
            end
        else
            if not state.easterEventCoroutine then
                state.easterEventCoroutine = coroutine.create(function()
                    while state.enabled do
                        local success = self:StartEasterEvent(state)
                        if not success then
                            task.wait(5)
                        end
                        task.wait(1)
                    end
                end)
                coroutine.resume(state.easterEventCoroutine)
            end
        end

        task.wait(2)
    end

    if state.connection then
        state.connection:Disconnect()
        state.connection = nil
    end
    if state.challengeConnection then
        state.challengeConnection:Disconnect()
        state.challengeConnection = nil
    end
    if state.easterEventCoroutine then
        state.easterEventCoroutine = nil
    end
end

function ScriptsModule:RangerAndEasterEventScript(state)
    local PlayRoomEvent = replicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event")
    local connection
    connection = PlayRoomEvent.OnClientEvent:Connect(function(arg1, ...) end)
    state.connection = connection

    while state.enabled do
        if state.priorityScript == "GogetaMadaraAndZ10" or state.priorityScript == "AllRangerAndAllChallenge" then
            task.wait(5)
            continue
        end

        local allCleared = true
        for _, stage in ipairs(rangerStages) do
            if not UtilitiesModule:IsRangerStageCleared(stage.chapter) then
                allCleared = false
                DebugPrint("Found uncleared stage: " .. stage.chapter)
                local success = self:AutoJoinStage(state, stage.world, stage.chapter)
                if success then
                    while UtilitiesModule:IsPlayerInSomeMode("Ranger Stage") and state.enabled do
                        task.wait(5)
                        DebugPrint("Waiting for stage " .. stage.chapter .. " to complete...")
                    end
                    task.wait(5)
                else
                    DebugPrint("Skipping stage " .. stage.chapter .. " as already in mode")
                    task.wait(5)
                end
                break
            else
                DebugPrint("Stage " .. stage.chapter .. " already cleared")
            end
        end

        if allCleared then
            DebugPrint("All Ranger Stages cleared! Starting Easter Event")
            if not state.easterEventCoroutine then
                state.easterEventCoroutine = coroutine.create(function()
                    while state.enabled do
                        local success = self:StartEasterEvent(state)
                        if not success then
                            task.wait(5)
                        end
                        task.wait(1)
                    end
                end)
                coroutine.resume(state.easterEventCoroutine)
            end
        end

        task.wait(2)
    end

    if state.connection then
        state.connection:Disconnect()
        state.connection = nil
    end
    if state.easterEventCoroutine then
        state.easterEventCoroutine = nil
    end
end

function ScriptsModule:GogetaMadaraAndZ10Script(state)
    local PlayRoomEvent = replicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event")
    local connection
    connection = PlayRoomEvent.OnClientEvent:Connect(function(arg1, ...)
        DebugPrint("PlayRoomEvent received: " .. tostring(arg1))
    end)
    state.connection = connection

    DebugPrint("Starting GogetaMadaraAndZ10 script")
    while state.enabled do
        DebugPrint("GogetaMadaraAndZ10 loop iteration, enabled: " .. tostring(state.enabled))
        local allCleared = true
        for i, stage in ipairs(gogetaMadaraStages) do
            DebugPrint("Checking stage " .. i .. ": " .. stage.chapter)
            if not UtilitiesModule:IsRangerStageCleared(stage.chapter) then
                allCleared = false
                DebugPrint("Found uncleared stage: " .. stage.chapter)
                print("Attempting to join stage: " .. stage.chapter)
                local success = self:AutoJoinStage(state, stage.world, stage.chapter)
                DebugPrint("autoJoinStage result for " .. stage.chapter .. ": " .. tostring(success))
                if success then
                    DebugPrint("Successfully joined stage: " .. stage.chapter)
                    local startTime = tick()
                    while UtilitiesModule:IsPlayerInSomeMode("Ranger Stage") and state.enabled do
                        DebugPrint("Waiting for stage " .. stage.chapter .. " to complete, elapsed: " .. math.floor(tick() - startTime) .. "s")
                        task.wait(5)
                    end
                    DebugPrint("Exited stage loop for " .. stage.chapter .. ", in Ranger Stage: " .. tostring(UtilitiesModule:IsPlayerInSomeMode("Ranger Stage")))
                    task.wait(5)
                else
                    DebugPrint("Failed to join stage " .. stage.chapter .. " or already in mode")
                    print("Skipped stage: " .. stage.chapter)
                    task.wait(5)
                end
                break
            else
                DebugPrint("Stage " .. stage.chapter .. " already cleared")
            end
        end

        DebugPrint("All stages cleared: " .. tostring(allCleared))
        if allCleared then
            DebugPrint("All Gogeta-Madara stages cleared! Starting Z10")
            print("Switching to Z10 mode")
            if not state.z10Coroutine then
                DebugPrint("Creating new Z10 coroutine")
                state.z10Coroutine = coroutine.create(function()
                    DebugPrint("Z10 coroutine started")
                    while state.enabled do
                        DebugPrint("Attempting to start Z10 mode")
                        local success = self:StartZ10Mode(state)
                        DebugPrint("startZ10Mode result: " .. tostring(success))
                        if not success then
                            DebugPrint("Z10 mode failed, retrying after 5 seconds")
                            print("Z10 failed to start")
                            task.wait(5)
                        end
                        task.wait(1)
                        for i, stage in ipairs(gogetaMadaraStages) do
                            if not UtilitiesModule:IsRangerStageCleared(stage.chapter) then
                                DebugPrint("Found uncleared Gogeta-Madara stage: " .. stage.chapter)
                                print("Exiting Z10 due to uncleared stage: " .. stage.chapter)
                                state.z10Coroutine = nil
                                return
                            end
                        end
                        DebugPrint("Z10 loop iteration, all stages still cleared")
                    end
                    DebugPrint("Z10 coroutine ended")
                end)
                DebugPrint("Resuming Z10 coroutine")
                coroutine.resume(state.z10Coroutine)
            else
                DebugPrint("Z10 coroutine already running")
            end
        else
            DebugPrint("Not all stages cleared, continuing to check stages")
        end

        task.wait(2)
    end

    DebugPrint("GogetaMadaraAndZ10 script stopped, enabled: " .. tostring(state.enabled))
    print("GogetaMadaraAndZ10 script terminated")
    if state.connection then
        DebugPrint("Disconnecting PlayRoomEvent connection")
        state.connection:Disconnect()
        state.connection = nil
    end
    if state.z10Coroutine then
        DebugPrint("Clearing Z10 coroutine")
        state.z10Coroutine = nil
    end
end

function ScriptsModule:GogetaAndZ10Script(state)
    local PlayRoomEvent = replicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event")
    local connection
    connection = PlayRoomEvent.OnClientEvent:Connect(function(arg1, ...)
        DebugPrint("PlayRoomEvent received: " .. tostring(arg1))
    end)
    state.connection = connection

    DebugPrint("Starting GogetaAndZ10 script")
    while state.enabled do
        DebugPrint("GogetaAndZ10 loop iteration, enabled: " .. tostring(state.enabled))
        local allCleared = true
        for i, stage in ipairs(gogetaStages) do
            DebugPrint("Checking stage " .. i .. ": " .. stage.chapter)
            if not UtilitiesModule:IsRangerStageCleared(stage.chapter) then
                allCleared = false
                DebugPrint("Found uncleared stage: " .. stage.chapter)
                print("Attempting to join stage: " .. stage.chapter)
                local success = self:AutoJoinStage(state, stage.world, stage.chapter)
                DebugPrint("autoJoinStage result for " .. stage.chapter .. ": " .. tostring(success))
                if success then
                    DebugPrint("Successfully joined stage: " .. stage.chapter)
                    local startTime = tick()
                    while UtilitiesModule:IsPlayerInSomeMode("Ranger Stage") and state.enabled do
                        DebugPrint("Waiting for stage " .. stage.chapter .. " to complete, elapsed: " .. math.floor(tick() - startTime) .. "s")
                        task.wait(5)
                    end
                    DebugPrint("Exited stage loop for " .. stage.chapter .. ", in Ranger Stage: " .. tostring(UtilitiesModule:IsPlayerInSomeMode("Ranger Stage")))
                    task.wait(5)
                else
                    DebugPrint("Failed to join stage " .. stage.chapter .. " or already in mode")
                    print("Skipped stage: " .. stage.chapter)
                    task.wait(5)
                end
                break
            else
                DebugPrint("Stage " .. stage.chapter .. " already cleared")
            end
        end

        DebugPrint("All stages cleared: " .. tostring(allCleared))
        if allCleared then
            DebugPrint("All Gogeta stages cleared! Starting Z10")
            print("Switching to Z10 mode")
            if not state.z10Coroutine then
                DebugPrint("Creating new Z10 coroutine")
                state.z10Coroutine = coroutine.create(function()
                    DebugPrint("Z10 coroutine started")
                    while state.enabled do
                        DebugPrint("Attempting to start Z10 mode")
                        local success = self:StartZ10Mode(state)
                        DebugPrint("startZ10Mode result: " .. tostring(success))
                        if not success then
                            DebugPrint("Z10 mode failed, retrying after 5 seconds")
                            print("Z10 failed to start")
                            task.wait(5)
                        end
                        task.wait(1)
                        for i, stage in ipairs(gogetaStages) do
                            if not UtilitiesModule:IsRangerStageCleared(stage.chapter) then
                                DebugPrint("Found uncleared Gogeta stage: " .. stage.chapter)
                                print("Exiting Z10 due to uncleared stage: " .. stage.chapter)
                                state.z10Coroutine = nil
                                return
                            end
                        end
                        DebugPrint("Z10 loop iteration, all stages still cleared")
                    end
                    DebugPrint("Z10 coroutine ended")
                end)
                DebugPrint("Resuming Z10 coroutine")
                coroutine.resume(state.z10Coroutine)
            else
                DebugPrint("Z10 coroutine already running")
            end
        else
            DebugPrint("Not all stages cleared, continuing to check stages")
        end

        task.wait(2)
    end

    DebugPrint("GogetaAndZ10 script stopped, enabled: " .. tostring(state.enabled))
    print("GogetaAndZ10 script terminated")
    if state.connection then
        DebugPrint("Disconnecting PlayRoomEvent connection")
        state.connection:Disconnect()
        state.connection = nil
    end
    if state.z10Coroutine then
        DebugPrint("Clearing Z10 coroutine")
        state.z10Coroutine = nil
    end
end

function ScriptsModule:MadaraAndZ10Script(state)
    local PlayRoomEvent = replicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event")
    local connection
    connection = PlayRoomEvent.OnClientEvent:Connect(function(arg1, ...)
        DebugPrint("PlayRoomEvent received: " .. tostring(arg1))
    end)
    state.connection = connection

    DebugPrint("Starting MadaraAndZ10 script")
    while state.enabled do
        DebugPrint("MadaraAndZ10 loop iteration, enabled: " .. tostring(state.enabled))
        local allCleared = true
        for i, stage in ipairs(madaraStages) do
            DebugPrint("Checking stage " .. i .. ": " .. stage.chapter)
            if not UtilitiesModule:IsRangerStageCleared(stage.chapter) then
                allCleared = false
                DebugPrint("Found uncleared stage: " .. stage.chapter)
                print("Attempting to join stage: " .. stage.chapter)
                local success = self:AutoJoinStage(state, stage.world, stage.chapter)
                DebugPrint("autoJoinStage result for " .. stage.chapter .. ": " .. tostring(success))
                if success then
                    DebugPrint("Successfully joined stage: " .. stage.chapter)
                    local startTime = tick()
                    while UtilitiesModule:IsPlayerInSomeMode("Ranger Stage") and state.enabled do
                        DebugPrint("Waiting for stage " .. stage.chapter .. " to complete, elapsed: " .. math.floor(tick() - startTime) .. "s")
                        task.wait(5)
                    end
                    DebugPrint("Exited stage loop for " .. stage.chapter .. ", in Ranger Stage: " .. tostring(UtilitiesModule:IsPlayerInSomeMode("Ranger Stage")))
                    task.wait(5)
                else
                    DebugPrint("Failed to join stage " .. stage.chapter .. " or already in mode")
                    print("Skipped stage: " .. stage.chapter)
                    task.wait(5)
                end
                break
            else
                DebugPrint("Stage " .. stage.chapter .. " already cleared")
            end
        end

        DebugPrint("All stages cleared: " .. tostring(allCleared))
        if allCleared then
            DebugPrint("All Madara stages cleared! Starting Z10")
            print("Switching to Z10 mode")
            if not state.z10Coroutine then
                DebugPrint("Creating new Z10 coroutine")
                state.z10Coroutine = coroutine.create(function()
                    DebugPrint("Z10 coroutine started")
                    while state.enabled do
                        DebugPrint("Attempting to start Z10 mode")
                        local success = self:StartZ10Mode(state)
                        DebugPrint("startZ10Mode result: " .. tostring(success))
                        if not success then
                            DebugPrint("Z10 mode failed, retrying after 5 seconds")
                            print("Z10 failed to start")
                            task.wait(5)
                        end
                        task.wait(1)
                        for i, stage in ipairs(madaraStages) do
                            if not UtilitiesModule:IsRangerStageCleared(stage.chapter) then
                                DebugPrint("Found uncleared Madara stage: " .. stage.chapter)
                                print("Exiting Z10 due to uncleared stage: " .. stage.chapter)
                                state.z10Coroutine = nil
                                return
                            end
                        end
                        DebugPrint("Z10 loop iteration, all stages still cleared")
                    end
                    DebugPrint("Z10 coroutine ended")
                end)
                DebugPrint("Resuming Z10 coroutine")
                coroutine.resume(state.z10Coroutine)
            else
                DebugPrint("Z10 coroutine already running")
            end
        else
            DebugPrint("Not all stages cleared, continuing to check stages")
        end

        task.wait(2)
    end

    DebugPrint("MadaraAndZ10 script stopped, enabled: " .. tostring(state.enabled))
    print("MadaraAndZ10 script terminated")
    if state.connection then
        DebugPrint("Disconnecting PlayRoomEvent connection")
        state.connection:Disconnect()
        state.connection = nil
    end
    if state.z10Coroutine then
        DebugPrint("Clearing Z10 coroutine")
        state.z10Coroutine = nil
    end
end

function ScriptsModule:AllRangerAndAllChallengeScript(state)
    local PlayRoomEvent = replicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event")
    local connection
    connection = PlayRoomEvent.OnClientEvent:Connect(function(arg1, ...) end)
    state.connection = connection

    while state.enabled do
        local allCleared = true
        for _, stage in ipairs(rangerStages) do
            if not UtilitiesModule:IsRangerStageCleared(stage.chapter) then
                allCleared = false
                DebugPrint("Found uncleared Ranger Stage: " .. stage.chapter)
                local success = self:AutoJoinStage(state, stage.world, stage.chapter)
                if success then
                    while UtilitiesModule:IsPlayerInSomeMode("Ranger Stage") and state.enabled do
                        task.wait(5)
                        DebugPrint("Waiting for Ranger Stage " .. stage.chapter .. " to complete...")
                    end
                    task.wait(5)
                else
                    DebugPrint("Skipping Ranger Stage " .. stage.chapter .. " as already in mode")
                    task.wait(5)
                end
                break
            else
                DebugPrint("Ranger Stage " .. stage.chapter .. " already cleared")
            end
        end

        if allCleared then
            DebugPrint("All Ranger Stages cleared! Starting Challenge Mode")
            if not state.challengeCoroutine then
                state.challengeCoroutine = coroutine.create(function()
                    while state.enabled do
                        local success = self:CreateAndStartChallengeRoom(state)
                        if not success then
                            task.wait(5)
                        end
                        task.wait(1)
                        for _, stage in ipairs(rangerStages) do
                            if not UtilitiesModule:IsRangerStageCleared(stage.chapter) then
                                DebugPrint("Found uncleared Ranger Stage: " .. stage.chapter)
                                state.challengeCoroutine = nil
                                return
                            end
                        end
                    end
                end)
                coroutine.resume(state.challengeCoroutine)
            end
        end

        task.wait(2)
    end

    if state.connection then
        state.connection:Disconnect()
        state.connection = nil
    end
    if state.challengeCoroutine then
        state.challengeCoroutine = nil
    end
end

function ScriptsModule:GhoulRangerAndGhoulStoryScript(state)
    local PlayRoomEvent = replicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event")
    local connection
    connection = PlayRoomEvent.OnClientEvent:Connect(function(arg1, ...)
        DebugPrint("PlayRoomEvent received: " .. tostring(arg1))
    end)
    state.connection = connection

    DebugPrint("Starting GhoulRangerAndGhoulStory script")
    while state.enabled do
        DebugPrint("GhoulRangerAndGhoulStory loop iteration, enabled: " .. tostring(state.enabled))
        local allCleared = true
        for i, stage in ipairs(ghoulStages) do
            DebugPrint("Checking stage " .. i .. ": " .. stage.chapter)
            if not UtilitiesModule:IsRangerStageCleared(stage.chapter) then
                allCleared = false
                DebugPrint("Found uncleared stage: " .. stage.chapter)
                print("Attempting to join stage: " .. stage.chapter)
                local success = self:AutoJoinStage(state, stage.world, stage.chapter)
                DebugPrint("autoJoinStage result for " .. stage.chapter .. ": " .. tostring(success))
                if success then
                    DebugPrint("Successfully joined stage: " .. stage.chapter)
                    local startTime = tick()
                    while UtilitiesModule:IsPlayerInSomeMode("Ranger Stage") and state.enabled do
                        DebugPrint("Waiting for stage " .. stage.chapter .. " to complete, elapsed: " .. math.floor(tick() - startTime) .. "s")
                        task.wait(5)
                    end
                    DebugPrint("Exited stage loop for " .. stage.chapter .. ", in Ranger Stage: " .. tostring(UtilitiesModule:IsPlayerInSomeMode("Ranger Stage")))
                    task.wait(5)
                else
                    DebugPrint("Failed to join stage " .. stage.chapter .. " or already in mode")
                    print("Skipped stage: " .. stage.chapter)
                    task.wait(5)
                end
                break
            else
                DebugPrint("Stage " .. stage.chapter .. " already cleared")
            end
        end

        DebugPrint("All stages cleared: " .. tostring(allCleared))
        if allCleared then
            DebugPrint("All Tokyo Ghoul Ranger stages cleared! Starting TokyoGhoul_Chapter10")
            print("Switching to TokyoGhoul_Chapter10 mode")
            if not state.storyCoroutine then
                DebugPrint("Creating new Story coroutine")
                state.storyCoroutine = coroutine.create(function()
                    DebugPrint("Story coroutine started")
                    while state.enabled do
                        DebugPrint("Attempting to start TokyoGhoul_Chapter10 mode")
                        local success = self:StartGhoulStoryMode(state)
                        DebugPrint("startGhoulStoryMode result: " .. tostring(success))
                        if not success then
                            DebugPrint("TokyoGhoul_Chapter10 mode failed, retrying after 5 seconds")
                            print("TokyoGhoul_Chapter10 failed to start")
                            task.wait(5)
                        end
                        task.wait(1)
                        for i, stage in ipairs(ghoulStages) do
                            if not UtilitiesModule:IsRangerStageCleared(stage.chapter) then
                                DebugPrint("Found uncleared Tokyo Ghoul Ranger stage: " .. stage.chapter)
                                print("Exiting TokyoGhoul_Chapter10 due to uncleared stage: " .. stage.chapter)
                                state.storyCoroutine = nil
                                return
                            end
                        end
                        DebugPrint("Story loop iteration, all stages still cleared")
                    end
                    DebugPrint("Story coroutine ended")
                end)
                DebugPrint("Resuming Story coroutine")
                coroutine.resume(state.storyCoroutine)
            else
                DebugPrint("Story coroutine already running")
            end
        else
            DebugPrint("Not all stages cleared, continuing to check stages")
        end

        task.wait(2)
    end

    DebugPrint("GhoulRangerAndGhoulStory script stopped, enabled: " .. tostring(state.enabled))
    print("GhoulRangerAndGhoulStory script terminated")
    if state.connection then
        DebugPrint("Disconnecting PlayRoomEvent connection")
        state.connection:Disconnect()
        state.connection = nil
    end
    if state.storyCoroutine then
        DebugPrint("Clearing Story coroutine")
        state.storyCoroutine = nil
    end
end

function ScriptsModule:AutoLeaveScript(state)
    local rewardsUI = playerGui:WaitForChild("RewardsUI")
    local leaveButton = rewardsUI:WaitForChild("Main"):WaitForChild("LeftSide"):WaitForChild("Button"):WaitForChild("Leave")

    DebugPrint("AutoLeave: Initialized - RewardsUI Enabled: " .. tostring(rewardsUI.Enabled))

    while state.enabled do
        DebugPrint("AutoLeave: Loop running - RewardsUI Enabled: " .. tostring(rewardsUI.Enabled) .. ", Leave Visible: " .. tostring(leaveButton.Visible))
        if rewardsUI.Enabled and leaveButton.Visible then
            DebugPrint("AutoLeave: Rewards UI detected, checking VoteNext/RetryMap status...")
            local voteWaitTime = 0
            if state.scriptStates.VoteNext.enabled or state.scriptStates.RetryMap.enabled then
                voteWaitTime = 10
                DebugPrint("AutoLeave: VoteNext or RetryMap enabled, waiting up to 10 seconds...")
                local elapsed = 0
                while elapsed < voteWaitTime and state.enabled and rewardsUI.Enabled do
                    task.wait(1)
                    elapsed = elapsed + 1
                    if not rewardsUI.Enabled then
                        DebugPrint("AutoLeave: RewardsUI closed during wait, skipping leave action")
                        break
                    end
                end
            else
                voteWaitTime = 2
                DebugPrint("AutoLeave: No VoteNext or RetryMap enabled, waiting 2 seconds before leaving...")
                task.wait(voteWaitTime)
            end

            if state.enabled and rewardsUI.Enabled then
                DebugPrint("AutoLeave: Executing leave action using VirtualInputManager...")
                local buttonPos = leaveButton.AbsolutePosition
                local buttonSize = leaveButton.AbsoluteSize
                local clickX = buttonPos.X + buttonSize.X / 2
                local clickY = buttonPos.Y + buttonSize.Y / 2
                UtilitiesModule:SimulateClickAtPosition(clickX, clickY)
                DebugPrint("AutoLeave: Waiting for RewardsUI to close...")
                repeat
                    task.wait(1)
                until not rewardsUI.Enabled or not state.enabled
                DebugPrint("AutoLeave: RewardsUI closed or AutoLeave disabled")
            end
        end
        task.wait(2)
    end
end

return ScriptsModule
