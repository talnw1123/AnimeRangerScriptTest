-- ConfigSystem.lua: Manages configuration saving and loading
local ConfigSystem = {}

function ConfigSystem.new(player, HttpService, replicatedStorage, mainFrame, showButton)
    local self = {}
    self.player = player
    self.HttpService = HttpService
    self.replicatedStorage = replicatedStorage
    self.mainFrame = mainFrame
    self.showButton = showButton

    function self:getFileName()
        return "AutoScriptsConfig_" .. self.player.Name .. ".json"
    end

    function self:saveConfig()
        local configData = {
            LastMode = nil,
            LastWorld = nil,
            LastChapter = nil,
            UIPosition = {
                X = self.mainFrame.Position.X.Scale,
                Y = self.mainFrame.Position.Y.Scale,
                OffsetX = self.mainFrame.Position.X.Offset,
                OffsetY = self.mainFrame.Position.Y.Offset
            },
            UIHidden = not self.mainFrame.Visible
        }
        for scriptName, state in pairs(_G.scriptStates or {}) do
            configData[scriptName] = state.enabled
        end

        local room = self.replicatedStorage.PlayRoom:FindFirstChild(self.player.Name, true)
        if room then
            configData.LastMode = room.Mode.Value
            configData.LastWorld = room.World.Value
            configData.LastChapter = room.Chapter.Value
        end

        local success, err = pcall(function()
            writefile(self:getFileName(), self.HttpService:JSONEncode(configData))
        end)
        if not success then
            warn("Failed to save config for " .. self.player.Name .. ": " .. tostring(err))
        end
    end

    function self:loadConfig()
        local fileName = self:getFileName()
        if not isfile(fileName) then
            return false
        end

        local success, configData = pcall(function()
            return self.HttpService:JSONDecode(readfile(fileName))
        end)

        if not success then
            warn("Failed to load config for " .. self.player.Name)
            return false
        end

        for scriptName, enabled in pairs(configData) do
            if _G.scriptStates and _G.scriptStates[scriptName] then
                _G.scriptStates[scriptName].enabled = enabled
            end
        end

        if configData.UIPosition then
            self.mainFrame.Position = UDim2.new(
                configData.UIPosition.X, 
                configData.UIPosition.OffsetX, 
                configData.UIPosition.Y, 
                configData.UIPosition.OffsetY
            )
            self.showButton.Position = UDim2.new(
                configData.UIPosition.X, 
                configData.UIPosition.OffsetX, 
                configData.UIPosition.Y, 
                configData.UIPosition.OffsetY
            )
        end

        if configData.UIHidden ~= nil then
            self.mainFrame.Visible = not configData.UIHidden
            self.showButton.Visible = configData.UIHidden
        end

        return true
    end

    return self
end

return ConfigSystem