local function createGui(ReasonT,TimeT)
    if not ReasonT then ReasonT = 'None' end 
    if not TimeT then TimeT = 5 end 
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local screenGui = Instance.new("ScreenGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui

    local blur = Instance.new("BlurEffect")
    blur.Size = 1
    blur.Parent = game.Lighting
    blur.Enabled = true
    local hopText = Instance.new("TextLabel")
    hopText.Name = "hoptext"
    hopText.Text = (_G.HubNameFr or "Starlight Hub") .." - Hop Server"
    hopText.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json")
    hopText.TextColor3 = Color3.fromRGB(230, 36, 237)
    hopText.TextSize = 45
    hopText.BackgroundTransparency = 1
    hopText.Size = UDim2.new(0, 200, 0, 50)
    hopText.Position = UDim2.new(0.5, 0, 0.1, 0)  -- Start above screen
    hopText.AnchorPoint = Vector2.new(0.5, 0.5)
    hopText.Parent = screenGui

    local hopTextStroke = Instance.new("UIStroke")
    hopTextStroke.Thickness = 1.5
    hopTextStroke.Parent = hopText

    local secondText = Instance.new("TextLabel")
    secondText.Name = "secondtext"
    secondText.Text = "Hopping to new Server in: 5s"
    secondText.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json")
    secondText.TextColor3 = Color3.fromRGB(255, 255, 255)
    secondText.TextSize = 32
    secondText.BackgroundTransparency = 1
    secondText.Size = UDim2.new(0, 200, 0, 50)
    secondText.Position = UDim2.new(0.5, 0, 0.46154, 0)
    secondText.AnchorPoint = Vector2.new(0.5, 0.5)
    secondText.TextTransparency = 1  -- Start invisible
    secondText.Parent = screenGui

    local secondTextStroke = Instance.new("UIStroke")
    secondTextStroke.Thickness = 1.5
    secondTextStroke.Parent = secondText

    local reason = Instance.new("TextLabel")
    reason.Name = "reason"
    reason.Text = "Reason: None"
    reason.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json")
    reason.TextColor3 = Color3.fromRGB(255, 255, 255)
    reason.TextSize = 32
    reason.BackgroundTransparency = 1
    reason.Size = UDim2.new(0, 200, 0, 50)
    reason.Position = UDim2.new(-0.5, 0, 0.58502, 0) -- Start off-screen
    reason.AnchorPoint = Vector2.new(0.5, 0.5)
    reason.Parent = screenGui

    local reasonStroke = Instance.new("UIStroke")
    reasonStroke.Thickness = 1.5
    reasonStroke.Parent = reason

    local dbclick = Instance.new("TextLabel")
    dbclick.Name = "dbclick"
    dbclick.Text = "Double click for increase speed"
    dbclick.FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json")
    dbclick.TextColor3 = Color3.fromRGB(255, 255, 255)
    dbclick.TextSize = 24
    dbclick.BackgroundTransparency = 1
    dbclick.Size = UDim2.new(0, 200, 0, 50)
    dbclick.Position = UDim2.new(-0.5, 0, 0.72672, 0) -- Start off-screen
    dbclick.AnchorPoint = Vector2.new(0.5, 0.5)
    dbclick.Parent = screenGui

    local dbclickStroke = Instance.new("UIStroke")
    dbclickStroke.Thickness = 1.5
    dbclickStroke.Parent = dbclick

    local TweenService = game:GetService("TweenService")
    local IncreaseClick = false 
    local UserInputService = game:GetService("UserInputService")
    local doubleClickEnabled = true  -- Flag to prevent multiple clicks

    local function handleDoubleClick()
        if doubleClickEnabled then 
            IncreaseClick = true
            doubleClickEnabled = false  -- Disable further clicks  
            game:GetService("TweenService"):Create(secondText, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextColor3 = Color3.fromRGB(255, 255, 255),
            }):Play() 
            secondText.Text = 'Hopping to new Server in: '..tostring(0)..'s' 
            TweenService:Create(blur, TweenInfo.new(3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Size = 1}):Play()
            task.wait(1.5)
            screenGui:Destroy()  -- Destroy the entire GUI 
            blur:Destroy() 

        end
    end
    dbclick.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then  -- Check for left mouse button click
            handleDoubleClick()
        end
    end)

    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            handleDoubleClick()
        end
    end)
    task.spawn(function()
        TweenService:Create(blur, TweenInfo.new(TimeT/2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Size = 100}):Play()
        TweenService:Create(hopText, TweenInfo.new(TimeT/5, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.34615, 0)}):Play()
        TweenService:Create(secondText, TweenInfo.new(TimeT/2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        TweenService:Create(reason, TweenInfo.new(TimeT/5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.58502, 0)}):Play()
        wait(.3)
        TweenService:Create(dbclick, TweenInfo.new(TimeT/5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0.72672, 0)}):Play()
    end)

    reason.Text = 'Reason: '..tostring(ReasonT)
    for TimeT = TimeT,0,-1 do   
        if IncreaseClick then break; end
        game:GetService("TweenService"):Create(secondText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 0, 0)}):Play() 
        TweenService:Create(blur, TweenInfo.new(TimeT/2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Size = 0}):Play()
        secondText.Text = 'Hopping to new Server in: '..tostring(TimeT)..'s' 
        wait(.5) 
        if IncreaseClick then break; end 
        game:GetService("TweenService"):Create(secondText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() 
        TweenService:Create(blur, TweenInfo.new(TimeT/2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Size = 100}):Play()
        wait(.5)
    end 
    handleDoubleClick()
    return screenGui
end
return createGui