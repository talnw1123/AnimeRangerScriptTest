local UtilitiesModule = {}

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local replicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function UtilitiesModule:SimulateClick()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local cx, cy = viewportSize.X / 2, viewportSize.Y / 2
    local success, err = pcall(function()
        VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, true, game, 0)
        task.wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(cx, cy, 0, false, game, 0)
    end)
end

function UtilitiesModule:SimulateClickAtPosition(x, y)
    local success, err = pcall(function()
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.1)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end)
    if not success then
        warn("Failed to simulate click at position: " .. tostring(err))
    end
end

function UtilitiesModule:GetCurrentGems()
    local playerData = replicatedStorage:FindFirstChild("Player_Data")
    local playerFolder = playerData and playerData:FindFirstChild(player.Name)
    local dataFolder = playerFolder and playerFolder:FindFirstChild("Data")
    local gemValue = dataFolder and dataFolder:FindFirstChild("Gem")
    return gemValue and gemValue.Value or nil
end

function UtilitiesModule:SafeRequire(modulePath)
    local success, module = pcall(require, modulePath)
    if success then
        return true, module
    else
        return false, nil
    end
end

function UtilitiesModule:ClearRewardScreen()
    task.wait(4)
    for i = 1, 12 do
        self:SimulateClick()
        task.wait(2)
    end
    return true
end

function UtilitiesModule:CheckStorageFullMessage()
    local systemMessageGui = playerGui:FindFirstChild("SystemMessage")
    if not systemMessageGui then return false end

    local messageFrame = systemMessageGui:FindFirstChild("Message")
    if not messageFrame then return false end

    local frame = messageFrame:FindFirstChild("Frame")
    if not frame then return false end

    local messageLabel = frame:FindFirstChild("Message")
    if not messageLabel or not messageLabel:IsA("TextLabel") then return false end

    if messageLabel.ContentText == "Your unit storage bag is not enough for 10" then
        local closeButton = frame:FindFirstChild("Close", true)
        if closeButton and closeButton:IsA("TextButton") then
            local success, err = pcall(function()
                closeButton:Fire()
            end)
            if not success then
                systemMessageGui:Destroy()
            end
        else
            systemMessageGui:Destroy()
        end
        return true
    end
    return false
end

function UtilitiesModule:SummonUnits(bannerType)
    if bannerType ~= "Standard" then return false, false end

    local unitsGachaRemote = replicatedStorage:FindFirstChild("Remote")
        and replicatedStorage.Remote:FindFirstChild("Server")
        and replicatedStorage.Remote.Server:FindFirstChild("Gambling")
        and replicatedStorage.Remote.Server.Gambling:FindFirstChild("UnitsGacha")
    if not unitsGachaRemote or not unitsGachaRemote:IsA("RemoteEvent") then return false, false end

    local autoSellSettings = { ["Legendary"] = true }
    local getDataAvailable, GetData = self:SafeRequire(replicatedStorage.Shared.GetData)
    if getDataAvailable then
        local playerDataSuccess, playerData = pcall(function()
            return GetData.GetData(player)
        end)
        if playerDataSuccess and playerData then
            for _, rarity in pairs({"Secret", "Mythic", "Epic", "Rare"}) do
                local setting = playerData.Setting:FindFirstChild("Sell Auto " .. rarity)
                if setting and setting.Value == true then
                    autoSellSettings[rarity] = true
                end
            end
        end
    end

    local success, err = pcall(function()
        unitsGachaRemote:FireServer("x10", "Standard", autoSellSettings)
    end)
    if not success then return false, false end

    task.wait(0.3)
    local isStorageFull = self:CheckStorageFullMessage()
    if isStorageFull then return true, true end
    return true, false
end

function UtilitiesModule:CalculateMaxSummons(currentGems, summonCost, targetGems)
    if not currentGems or not summonCost then return 0 end
    return math.max(0, math.floor((currentGems - targetGems) / summonCost))
end

function UtilitiesModule:WaitForGuiElement(path, timeout)
    timeout = timeout or 5
    local startTime = tick()
    local element = playerGui
    for _, part in ipairs(path) do
        element = element:WaitForChild(part, timeout - (tick() - startTime))
        if not element then return nil end
    end
    return element
end

function UtilitiesModule:VerifyWorldAndChapter(world, chapter)
    local success, Levels = pcall(function()
        return require(replicatedStorage.Shared.Info.GameWorld.Levels)
    end)
    if not success then return false end
    if not Levels[world] then return false end
    if not Levels[world][chapter] then return false end
    return true
end

function UtilitiesModule:SendEvent(action, data)
    local PlayRoomEvent = replicatedStorage:WaitForChild("Remote"):WaitForChild("Server"):WaitForChild("PlayRoom"):WaitForChild("Event")
    local success, err = pcall(function()
        if data then
            PlayRoomEvent:FireServer(action, data)
        else
            PlayRoomEvent:FireServer(action)
        end
    end)
    if not success then return false end
    return true
end

function UtilitiesModule:IsPlayerInSpecificRoom(mode, world, chapter)
    local gameValues = replicatedStorage:FindFirstChild("Values") and replicatedStorage.Values:FindFirstChild("Game")
    if not gameValues then return false end

    local currentMode = gameValues:FindFirstChild("Gamemode") and gameValues.Gamemode.Value
    local currentWorld = gameValues:FindFirstChild("World") and gameValues.World.Value
    local currentChapter = gameValues:FindFirstChild("Level") and gameValues.Level.Value

    if not currentMode or currentMode ~= mode then return false end
    if world and chapter then
        if currentWorld ~= world or currentChapter ~= chapter then return false end
    end
    return true
end

function UtilitiesModule:IsPlayerInSomeMode(mode)
    local gameValues = replicatedStorage:FindFirstChild("Values") and replicatedStorage.Values:FindFirstChild("Game")
    if not gameValues then return false end

    local currentMode = gameValues:FindFirstChild("Gamemode") and gameValues.Gamemode.Value
    if not currentMode or currentMode ~= mode then return false end
    return true
end

function UtilitiesModule:CheckForRangerCrystal()
    local gameplay = replicatedStorage:WaitForChild("Gameplay", 10)
    if not gameplay then return false end

    local gameFolder = gameplay:WaitForChild("Game", 10)
    if not gameFolder then return false end

    local challenge = gameFolder:WaitForChild("Challenge", 10)
    if not challenge then return false end

    local items = challenge:WaitForChild("Items", 10)
    if not items then return false end

    local rangerCrystal = items:FindFirstChild("Ranger Crystal")
    return rangerCrystal ~= nil
end

function UtilitiesModule:IsRangerStageCleared(chapter)
    local playerData = replicatedStorage:WaitForChild("Player_Data"):WaitForChild(player.Name)
    local rangerStageFolder = playerData:FindFirstChild("RangerStage")
    if rangerStageFolder then
        return rangerStageFolder:FindFirstChild(chapter) ~= nil
    end
    return false
end

function UtilitiesModule:FindObject(name, class, parent)
    parent = parent or game
    for _, v in ipairs(parent:GetDescendants()) do
        if v.ClassName == class and v.Name == name then
            return v
        end
    end
    return nil
end

function UtilitiesModule:WaitForRemote(path)
    local remote = replicatedStorage
    for _, part in ipairs(path) do
        remote = remote:WaitForChild(part, 10)
        if not remote then
            warn("Failed to find " .. part)
            return nil
        end
    end
    return remote
end

return UtilitiesModule