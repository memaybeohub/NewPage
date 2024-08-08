return function(TextBoxGradientColorTable)
    if game.CoreGui:FindFirstChild('JoinTextBox') then 
        for i,v in game.CoreGui:GetChildren() do 
            if v.Name == 'JoinTextBox' then 
                v:Destroy()
            end
        end
    end
    
    local JoinTextBox = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame")
    local TextBox = Instance.new("TextBox")
     
    JoinTextBox.Name = "JoinTextBox"
    JoinTextBox.Parent = game.CoreGui
    JoinTextBox.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Parent = JoinTextBox
    Frame.BackgroundColor3 = Color3.new(255, 255, 255)
    Frame.BackgroundTransparency = 0.4
    Frame.BorderMode = 'Middle'
    Frame.BorderColor3 = Color3.new(250, 250, 250)
    Frame.BorderSizePixel = 5
    Frame.Position = UDim2.new(0.5, 0, 0.7, 0)
    Frame.Size = UDim2.new(0, 400, 0, 50)
    local UIStroke = Instance.new("UIStroke");
    
    
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 2.5
    UIStroke.Parent = Frame
    
    
    local TextLabel = Instance.new("TextLabel")
     
    TextLabel.Parent = Frame
    TextLabel.BackgroundColor3 = Color3.new(0.623529, 0.623529, 0.623529)
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderColor3 = Color3.new(0, 0, 0)
    TextLabel.BorderSizePixel = 0
    TextLabel.AnchorPoint = Vector2.new(0, 0)
    TextLabel.Size = UDim2.new(0, 400, 0, 50)
    TextLabel.Font = Enum.Font.Highway
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextSize = 20
    TextLabel.Text = 'Enter a Job Id or join Job Id script right here.'
    TextLabel.TextWrapped = true
    --TextLabel.TextScaled = true
    TextLabel.ZIndex = 0
    local gadient = Instance.new("UIGradient");
    gadient.Parent = UIStroke
    gadient.Color = ColorSequence.new(TextBoxGradientColorTable)
    
    local gadient = Instance.new("UIGradient");
    gadient.Parent = TextLabel
    gadient.Color = ColorSequence.new(TextBoxGradientColorTable)
    
    gadient = Instance.new("UIGradient");
    gadient.Parent = Frame
    gadient.Color = ColorSequence.new(TextBoxGradientColorTable)
    
    
    
    TextBox.Parent = Frame
    TextBox.BackgroundColor3 = Color3.new(255, 255, 255)
    TextBox.BackgroundTransparency = 1
    TextBox.BorderColor3 = Color3.new(0, 0, 0)
    TextBox.BorderSizePixel = 0
    TextBox.Size = UDim2.new(0, 400, 0, 50)
    TextBox.Font = Enum.Font.Highway
    TextBox.Text = ""
    TextBox.TextColor3 = Color3.new(1, 1, 1)
    TextBox.TextSize = 14
    TextBox.ZIndex = 1
    
    -- Sự kiện khi ô nhập liệu được click vào
    TextBox.Focused:Connect(function()
        TextLabel.Visible = false
    end)
    
    -- Sự kiện khi ô nhập liệu bị bỏ chọn hoặc người dùng nhấn Enter
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            if TextBoxJoinCallback then 
                TextBoxJoinCallback(TextBox.Text)
            end
            TextLabel.Text = TextBox.Text
        else
            TextLabel.Text = "Press Enter Please."
        end
        TextBox.Visible = false
        TextLabel.Visible = true
        task.delay(5,function()
            TextBox.Visible = true 
            TextLabel.Visible = false
        end)
    end)
end