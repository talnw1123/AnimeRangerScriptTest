-- Main.lua: Entry point for the AutoScripts system
repeat wait(2) until game:IsLoaded()
task.wait(2)

-- Services
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local replicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Prevent script from running multiple times
if _G.AutoScriptsRunning then
    if playerGui:FindFirstChild("AutoScriptsUI") then
        playerGui.AutoScriptsUI:Destroy()
    end
end
_G.AutoScriptsRunning = true

-- Custom module loader for GitHub
local function loadModule(moduleName)
    local url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source/" .. moduleName .. ".lua"
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)
    if not success then
        warn("Failed to fetch module " .. moduleName .. ": " .. tostring(content))
        return nil
    end
    if content == "" then
        warn("Empty content for module " .. moduleName)
        return nil
    end
    local func, err = loadstring(content)
    if not func then
        warn("Failed to compile module " .. moduleName .. ": " .. tostring(err))
        return nil
    end
    local success, result = pcall(func)
    if not success then
        warn("Failed to execute module " .. moduleName .. ": " .. tostring(result))
        return nil
    end
    return result
end

-- Override require to load modules from GitHub
local originalRequire = require
require = function(module)
    if type(module) == "string" then
        return loadModule(module)
    end
    return originalRequire(module)
end

-- Load modules
local Constants = require("Constants")
if not Constants then
    warn("Constants module not loaded")
    return
end
local UISetup = require("UISetup")
if not UISetup then
    warn("UISetup module not loaded")
    return
end
local ConfigSystem = require("ConfigSystem")
if not ConfigSystem then
    warn("ConfigSystem module not loaded")
    return
end
local Utility = require("Utility")
if not Utility then
    warn("Utility module not loaded")
    return
end
local ScriptLogic = require("ScriptLogic")
if not ScriptLogic then
    warn("ScriptLogic module not loaded")
    return
end

-- Initialize UI
local screenGui, mainFrame, showButton, buttons, toggleButton = UISetup.setupUI(playerGui, Constants.COLORS)
if not screenGui then
    warn("Failed to initialize UI")
    return
end

-- Initialize config system
local configSystem = ConfigSystem.new(player, HttpService, replicatedStorage, mainFrame, showButton)

-- Initialize script states
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
    AllRangerAndAllChallenge = { enabled = false, coroutine = nil, connection = nil, challengeConnection = nil, easterEventCoroutine = nil },
    GhoulRangerAndGhoulStory = { enabled = false, coroutine = nil, connection = nil, storyCoroutine = nil },
    AutoLeave = { enabled = false, coroutine = nil, connection = nil }
}

-- Setup button interactions
for scriptName, state in pairs(scriptStates) do
    local button = buttons[scriptName]
    if button then
        button.toggleButton.MouseButton1Click:Connect(function()
            if not state.enabled then
                local scriptFunc = ScriptLogic[scriptName]
                if scriptFunc then
                    ScriptLogic.startScript(scriptName, scriptFunc, scriptStates, buttons, TweenService, Constants.COLORS, _G.priorityScript)
                end
            else
                ScriptLogic.stopScript(scriptName, scriptStates, buttons, TweenService, Constants.COLORS, _G.priorityScript)
            end
        end)
    end
end

-- Auto-execute scripts based on config
ScriptLogic.setupAutoExecute(player, scriptStates, configSystem)

-- Handle UI toggle
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    showButton.Visible = not mainFrame.Visible
end)

-- Cleanup on player removal
player.AncestryChanged:Connect(function()
    if not player:IsDescendantOf(game) then
        if playerGui:FindFirstChild("AutoScriptsUI") then
            playerGui.AutoScriptsUI:Destroy()
        end
        _G.AutoScriptsRunning = nil
    end
end)
