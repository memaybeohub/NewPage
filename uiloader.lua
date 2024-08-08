-- we sPeak music 😈
print('loading Ui Loader');
local UiLoader = {}
UiLoader.Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))() 
local CheckMobile = function()
    if
        game:GetService("UserInputService").TouchEnabled
     then
        return true 
    end
end 
local IsMobile = CheckMobile()
local Size11,Size22 = 600,460 
pcall(function()
    if IsMobile then 
        Size11,Size22 = 500,290
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer

        -- Create the UI elements directly, avoiding the G2L table
        local screenGui = Instance.new("ScreenGui", localPlayer:WaitForChild("PlayerGui"))
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local imageButton = Instance.new("ImageButton", screenGui)
        imageButton.BorderSizePixel = 0
        imageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        imageButton.AnchorPoint = Vector2.new(0.5, 0.5)
        imageButton.Image = "http://www.roblox.com/asset/?id=17140528880"
        imageButton.Size = UDim2.new(0, 63, 0, 63)
        imageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        imageButton.Position = UDim2.new(0.5, 0, 0.10324, 0)

        Instance.new("UICorner", imageButton)  -- No need to store this reference

        local uiStroke = Instance.new("UIStroke", imageButton)
        uiStroke.Thickness = 2
        uiStroke.Color = Color3.fromRGB(133, 21, 124)

        imageButton.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true,"LeftControl",false,game)
            game:GetService("VirtualInputManager"):SendKeyEvent(false,"LeftControl",false,game)
        end)
    end 
end) 
UiLoader.Window = UiLoader.Fluent:CreateWindow(
    {
        Title = "Tsuo Hub",
        SubTitle = "Develope by vMh~ (discord.gg/tsuoscripts)",
        TabWidth = 160,
        Size = UDim2.fromOffset(500, 290),
        Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
        Theme = "Amethyst",
        MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
    }
) 
print('loaded ui loader')
return UiLoader
