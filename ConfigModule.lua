local ConfigModule = {}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

function ConfigModule:SaveConfig(scriptStates, mainFrame, showButton)
    -- ใช้ชื่อผู้เล่นในการสร้างชื่อไฟล์
    local fileName = "AutoScriptsConfig_" .. player.Name .. ".json"
    
    local configData = {
        LastMode = nil,
        LastWorld = nil,
        LastChapter = nil,
        UIPosition = {
            X = mainFrame.Position.X.Scale,
            Y = mainFrame.Position.Y.Scale,
            OffsetX = mainFrame.Position.X.Offset,
            OffsetY = mainFrame.Position.Y.Offset
        },
        UIHidden = not mainFrame.Visible
    }
    for scriptName, state in pairs(scriptStates) do
        configData[scriptName] = state.enabled
    end

    local room = replicatedStorage.PlayRoom:FindFirstChild(player.Name, true)
    if room then
        configData.LastMode = room.Mode.Value
        configData.LastWorld = room.World.Value
        configData.LastChapter = room.Chapter.Value
    end

    local success, err = pcall(function()
        writefile(fileName, HttpService:JSONEncode(configData))
    end)
    if not success then
        warn("Failed to save config for " .. player.Name .. ": " .. err)
    end
end

function ConfigModule:LoadConfig(scriptStates, mainFrame, showButton)
    -- ใช้ชื่อผู้เล่นในการอ่านไฟล์
    local fileName = "AutoScriptsConfig_" .. player.Name .. ".json"
    
    if not isfile(fileName) then
        return false
    end

    local success, configData = pcall(function()
        return HttpService:JSONDecode(readfile(fileName))
    end)

    if not success then
        warn("Failed to load config for " .. player.Name .. ": " .. configData)
        return false
    end

    for scriptName, enabled in pairs(configData) do
        if scriptStates[scriptName] then
            scriptStates[scriptName].enabled = enabled
        end
    end

    if configData.UIPosition then
        mainFrame.Position = UDim2.new(
            configData.UIPosition.X,
            configData.UIPosition.OffsetX,
            configData.UIPosition.Y,
            configData.UIPosition.OffsetY
        )
        showButton.Position = UDim2.new(
            configData.UIPosition.X,
            configData.UIPosition.OffsetX,
            configData.UIPosition.Y,
            configData.UIPosition.OffsetY
        )
    end

    if configData.UIHidden ~= nil then
        mainFrame.Visible = not configData.UIHidden
        showButton.Visible = configData.UIHidden
    end

    return true
end

return ConfigModule
