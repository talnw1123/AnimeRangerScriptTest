local Constants = {}

Constants.COLORS = {
    BACKGROUND = Color3.fromRGB(40, 40, 60), -- สีพื้นหลังของ mainFrame
    SHADOW = Color3.fromRGB(20, 20, 30),    -- สีเงา
    HEADER = Color3.fromRGB(50, 50, 80),    -- สีหัวข้อ
    BORDER = Color3.fromRGB(60, 110, 220),  -- สีขอบ
    SAVE_BUTTON = Color3.fromRGB(70, 120, 200), -- สีปุ่มบันทึก
    TEXT_PRIMARY = Color3.fromRGB(255, 255, 255), -- สีข้อความหลัก
    TEXT_SECONDARY = Color3.fromRGB(200, 200, 200), -- สีข้อความรอง
    BUTTON_OFF = Color3.fromRGB(255, 0, 0), -- สีปุ่มปิด
    BUTTON_ON = Color3.fromRGB(0, 255, 0)   -- สีปุ่มเปิด
}
Constants.SUMMON_COSTS = { single = 50, multi = 500 }
Constants.dropRates = { common = 0.5, rare = 0.3, epic = 0.15, legendary = 0.05 }
Constants.TARGET_GEMS = 24000
Constants.DEBUG = true

return Constants
