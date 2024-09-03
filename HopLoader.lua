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


local function fetchServerData()
    local HttpService = game:GetService("HttpService")
    local data = {} 
    local success, response = pcall(function()
        return request({
            Url = 'http://103.77.172.226:10000/get_server/' .. game.PlaceId,
            Method = "POST",
            Body = HttpService:JSONEncode(data),
            Headers = {
                ["Content-Type"] = "application/json"
            }
        })
    end)
    table.foreach(response,print)
    if success and response.StatusCode == 200 then
        local result = HttpService:JSONDecode(response.Body)
        return result
    end
end
function HopLowV2()
    local placeId = tostring(game.PlaceId)
    local serverData = fetchServerData()
    if serverData then
        game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport",
            serverData.id)
    end
end

function getRandomIndex(tab)
    local keys = {}
    local keysc = 0 
    for k, v in pairs(tab) do
            keysc +=1
            table.insert(keys, k)
    end
    -- Chọn ngẫu nhiên một index từ bảng keys
    return keysc > 0 and keys[math.random(1,keysc)] or nil
end
local Settings2 = ReadSetting2()
_G.TimeTryHopLow = 0
_G.LastHopTick = 0 
local Ids = {}
local function SaveIds()
    writefile('HopSave.json',game:GetService("HttpService"):JSONEncode(Ids))
    return Ids
end
local function LoadIds()
    local a,b = pcall(function()
        return game:GetService("HttpService"):JSONDecode('HopSave.json')
    end)
    if not a then return SaveIds() end 
    return b 
end
local function CanJoin(S)
    getgenv().HopMin = 4
    getgenv().HopMax = 11
    if S.Count < getgenv().HopMin or S.Count > getgenv().HopMax then 
        return false 
    end
    if Ids[S.JobId] then
        if tick()-Ids[S.JobId].tick > 60*60 then 
            return true 
        end  
    else
        S.tick = tick()
        Ids[S.JobId] = S 
        SaveIds()
        return true 
    end
    return false 
end
local function Hop()
    HopLowV2()
    for i = 1,100,1 do 
        getgenv().HopDelay = 3
        local ServersDT = game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer(i)
        local Currsv
        for k,Currsv in pairs(ServersDT) do 
            Currsv.JobId = k
            if CanJoin(Currsv) then 
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,math.random(4000,15000),game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z)
                game:GetService("ReplicatedStorage").__ServerBrowser:InvokeServer("teleport", k)
                task.wait(getgenv().HopDelay)
            end 
        end
    end
end
getgenv().HopServer = function(CountTarget, hoplowallow,reasontohop)
    delay = 3 
    if not reasontohop then 
        reasontohop = 'None'
    end
    SetContent(reasontohop)
    HopGuiCreation(reasontohop,delay) 
    local timeplased = tick()+delay
    if not CountTarget then
        CountTarget = 10
    end
    return Hop()
end
print('Hub: Loaded Hop.')