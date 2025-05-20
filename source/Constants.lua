-- Constants.lua: Defines constants for the AutoScripts system
local Constants = {}

Constants.COLORS = {
    BACKGROUND = Color3.fromRGB(35, 35, 45),
    HEADER = Color3.fromRGB(45, 45, 65),
    BUTTON_OFF = Color3.fromRGB(60, 60, 80),
    BUTTON_ON = Color3.fromRGB(70, 200, 120),
    BUTTON_HOVER = Color3.fromRGB(70, 70, 90),
    SAVE_BUTTON = Color3.fromRGB(70, 130, 255),
    SAVE_BUTTON_HOVER = Color3.fromRGB(90, 150, 255),
    TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
    TEXT_SECONDARY = Color3.fromRGB(200, 200, 220),
    TEXT_DISABLED = Color3.fromRGB(150, 150, 170),
    BORDER = Color3.fromRGB(80, 80, 100),
    SHADOW = Color3.fromRGB(20, 20, 30)
}

Constants.SUMMON_COSTS = {
    Standard = 500
}

Constants.dropRates = {
    Secret = 0.001,
    Mythic = 1,
    Legendary = 5,
    Epic = 28,
    Rare = 66
}

Constants.TARGET_GEMS = 24000

Constants.DEBUG = false

return Constants
