local function loadModule(url)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)
    if success then
        return result
    else
        warn("Failed to load module from " .. url .. ": " .. tostring(result))
        return nil
    end
end

local baseUrl = "https://raw.githubusercontent.com/talnw1123/AnimeRangerScriptTest/refs/heads/main/"
local UIModule = loadModule(baseUrl .. "UIModule.lua")
local ConfigModule = loadModule(baseUrl .. "ConfigModule.lua")
local UtilitiesModule = loadModule(baseUrl .. "UtilitiesModule.lua")
local ScriptsModule = loadModule(baseUrl .. "ScriptsModule.lua")
local MainModule = loadModule(baseUrl .. "MainModule.lua")

-- แทนที่ require ใน MainModule ด้วยตัวแปรที่โหลดมา
getfenv(MainModule.Init).script.Parent.UIModule = UIModule
getfenv(MainModule.Init).script.Parent.ConfigModule = ConfigModule
getfenv(MainModule.Init).script.Parent.UtilitiesModule = UtilitiesModule
getfenv(MainModule.Init).script.Parent.ScriptsModule = ScriptsModule

MainModule:Init()
return MainModule