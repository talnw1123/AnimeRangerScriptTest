local Constants = {}

Constants.COLORS = {
    TEXT_PRIMARY = Color3.fromRGB(255, 255, 255),
    TEXT_DISABLED = Color3.fromRGB(150, 150, 150),
    BUTTON_ON = Color3.fromRGB(0, 255, 0),
    BUTTON_OFF = Color3.fromRGB(255, 0, 0)
}
Constants.SUMMON_COSTS = { single = 50, multi = 500 }
Constants.dropRates = { common = 0.5, rare = 0.3, epic = 0.15, legendary = 0.05 }
Constants.TARGET_GEMS = 24000
Constants.DEBUG = true

return Constants