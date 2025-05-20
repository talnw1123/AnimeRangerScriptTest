-- Main.lua: Entry point for the AutoScripts system
repeat wait(2) until game:IsLoaded()
task.wait(15)

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
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to load module " .. moduleName .. ": " .. tostring(result))
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
local UISetup = require("UISetup")
local ConfigSystem = require("ConfigSystem")
local Utility = require("Utility")
local ScriptLogic = require("ScriptLogic")

-- Initialize UI
local screenGui, mainFrame, showButton, buttons, toggleButton = UISetup.setupUI(playerGui, Constants.COLORS)

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
    AllRangerAndAllChallenge = { enabled = false, coroutine = nil, connection = nil, challengeCoroutine = nil },
    GhoulRangerAndGhoulStory = { enabled = false, coroutine = nil, connection = nil, storyCoroutine = nil },
    AutoLeave = { enabled = false, coroutine = nil, connection = nil }
}

-- Initialize priority script
local priorityScript = nil

-- Setup button connections
UISetup.connectButtons(buttons, scriptStates, ScriptLogic, configSystem, TweenService, Constants.COLORS, priorityScript)

-- Setup auto-execute
ScriptLogic.setupAutoExecute(player, scriptStates, configSystem)

-- Load configuration and initialize scripts
if configSystem:loadConfig() then
    UISetup.updateButtonStates(buttons, scriptStates, TweenService, Constants.COLORS)
end

for scriptName, state in pairs(scriptStates) do
    if state.enabled then
        local scriptFunc = ScriptLogic[scriptName]
        if scriptFunc then
            ScriptLogic.startScript(scriptName, scriptFunc, scriptStates, buttons, TweenService, Constants.COLORS, priorityScript)
        end
    end
end