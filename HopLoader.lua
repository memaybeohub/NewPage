local Settings2 = {}
local SaveFileName2 = "!Blacklist_Servers.json"

local HopGuiCreation = loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/HopGui.lua'))()
function SaveSettings2()
    local HttpService = game:GetService("HttpService")
    if not isfolder("Tsuo Hub") then
        makefolder("Tsuo Hub")
    end
    writefile(SaveFileName2, HttpService:JSONEncode(Settings2))
end

function ReadSetting2()
    local s, e =
        pcall(
        function()
            local HttpService = game:GetService("HttpService")
            if not isfolder("Tsuo Hub") then
                makefolder("Tsuo Hub")
            end
            return HttpService:JSONDecode(readfile(SaveFileName2))
        end
    )
    if s then
        return e
    else
        SaveSettings2()
        return ReadSetting2()
    end
end
function CheckX2Exp()
    a2, b2 =
        pcall(
        function()
            if LocalPlayerLevelValue < 2450 then
                if string.find(game.Players.LocalPlayer.PlayerGui.Main.Level.Exp.Text, "ends in") then
                    return true
                end
            end
        end
    )
    if a2 then
        return b2
    end
end
local lessfoundAnything = ""
getgenv().HopLow = function()
    if lessfoundAnything == "" then
        SiteHopServerLess =
            game.HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            )
        )
    else
        SiteHopServerLess =
            game.HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/" ..
                    game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. lessfoundAnything
            )
        )
    end
    if
        SiteHopServerLess.nextPageCursor and SiteHopServerLess.nextPageCursor ~= "null" and
            SiteHopServerLess.nextPageCursor ~= nil
     then
        lessfoundAnything = SiteHopServerLess.nextPageCursor
    end
    for i, v in pairs(SiteHopServerLess.data) do
        if v.playing and tonumber(v.playing) <= 4 and v.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(
                game.PlaceId,
                tostring(v.id),
                game.Players.LocalPlayer
            )
        end
    end
end
local Settings2 = ReadSetting2()
_G.TimeTryHopLow = 0
_G.LastHopTick = 0
getgenv().HopServer = function(CountTarget, hoplowallow,reasontohop)
    SetContent('Start hopping...') 
    delay = 3 
    if not reasontohop then 
        reasontohop = 'None'
    end
    HopGuiCreation(reasontohop,delay) 
    local timeplased = tick()+delay
    if hoplowallow and _G.TimeTryHopLow < 3 then
        for i = 1, 3 - _G.TimeTryHopLow do
            if _G.TimeTryHopLow < 3 then
                local a2,b2 = pcall(function()
                    local FoundId
                    repeat 
                        task.wait()
                        FoundId = game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(math.random(1, 100))[math.random(1, 100)] 
                        task.wait(1)
                    until FoundId and game.JobId ~= FoundId and not Settings2[FoundId] or tick()-Settings2[FoundId] >= 60*60 
                    Settings2[FoundId] = tick() 
                    SaveSettings2()
                    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer, FoundId)
                end)
                _G.TimeTryHopLow = _G.TimeTryHopLow + 1
                warn('Hop low times: ',_G.TimeTryHopLow)
                SetContent('Low Server hopping times: '..tostring(_G.TimeTryHopLow))
                wait(delay/2)
            end
        end
    end
    if not CountTarget then
        CountTarget = 10
    end
    wait(delay)
    local function Hop()
        for i = 1, 100 do
            if ChooseRegion == nil or ChooseRegion == "" then
                ChooseRegion = "Singapore"
            else
                game:GetService("Players").LocalPlayer.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox.Text =
                    ChooseRegion
            end
            local huhu = game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(i)
            for k, v in pairs(huhu) do
                if k ~= game.JobId and v["Count"] <= 10 then
                    if not Settings2[k] or tick() - Settings2[k].Time > 60 * 10 then
                        if tick()-_G.LastHopTick >= 10 then 
                            print('Found Sv:',k)
                            SetContent('Hopping normal server...')
                            Settings2[k] = {
                                Time = tick()
                            }
                            SaveSettings2()
                            _G.SwitchingServer = true
                            game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", k)
                            task.wait(10)
                        else
                            wait(10)
                            return Hop()
                        end
                        return true
                    elseif tick() - Settings2[k].Time > 60 * 60 then
                        Settings2[k] = nil
                    end
                end
            end
        end
        return false
    end 
    if not _G.Loaded then
        local function child(v)
            if v.Name == "ErrorPrompt" then
                if v.Visible then
                    if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                        HopServer()
                        v.Visible = false
                    end
                end
                v:GetPropertyChangedSignal("Visible"):Connect(
                    function()
                        if v.Visible then
                            if v.TitleFrame.ErrorTitle.Text == "Teleport Failed" then
                                HopServer()
                                v.Visible = false
                            end
                        end
                    end
                )
            end
        end
        for k, v in pairs(game.CoreGui.RobloxPromptGui.promptOverlay:GetChildren()) do
            child(v)
        end
        game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(child)
    end
    SaveSettings2()
    return Hop()
end
print('Hub: Loaded Hop.')