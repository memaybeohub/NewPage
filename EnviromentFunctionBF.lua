local lasttis = 0 
local JoinedGame = tick() 
_G.MeleeWait = ''
getgenv().SetContent = function(v1,delayticks)
    if not v1 then v1 = '' end 
    if tick()-lasttis > 0 then
        if not _G.CurrentTask then 
            _G.CurrentTask = ''
        end 
        if not _G.MeleeWait then 
            _G.MeleeWait = '' 
        end 
        local aSet1 = _G.CurrentTask
        if _G.MeleeTask and _G.MeleeTask ~= '' and _G.MeleeTask ~='None' then 
            aSet1 = _G.MeleeTask
        end
        if ContentSet then ContentSet(v1,tostring(aSet1),tostring(_G.MeleeWait)) else print('Not content set') end
    end 
    if delayticks then 
        lasttis = tick()+delayticks
    end
end  
getgenv().SetMeleeWait = function(v1Name,v1Value)
    _G.MeleeWait = " | Waiting "..tostring(v1Name).." hit "..tostring(v1Value).." mastery." 
end
_G.ServerData = {} 
function Join(v2) 
    v2 = tostring(v2) or "Pirates"
    v2 = string.find(v2,"Marine") and "Marines" or "Pirates"
    for i, v in pairs(
        getconnections(
            game:GetService("Players").LocalPlayer.PlayerGui.Main.ChooseTeam.Container[v2].Frame.TextButton.Activated
        )
    ) do
        v.Function()
    end
end
if not game.Players.LocalPlayer.Team then 
    repeat
        pcall(
            function()
                task.wait()
                if game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Main"):FindFirstChild("ChooseTeam") then 
                    Join(_G.Team)
                end
            end
        )
    until game.Players.LocalPlayer.Team ~= nil 
end
print('Loaded Team')
local RunService= game:GetService("RunService")
function RemoveLevelTitle(v)
    return tostring(tostring(v):gsub(" %pLv. %d+%p", ""):gsub(" %pRaid Boss%p", ""):gsub(" %pBoss%p", ""))
end 
if game.Workspace:FindFirstChild("MobSpawns") then
    for i, v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "MobSpawns" then
            v:Destroy()
        end
    end
end
_G.SavedConfig = type(_G.SavedConfig) == 'table' and _G.SavedConfig or {}
--loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/FastAttackLoading.lua'))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/HopLoader.lua'))()
function GetDistance(target1, taget2)
    if not taget2 then
        pcall(function()
            taget2 = game.Players.LocalPlayer.Character.HumanoidRootPart
        end)
    end
    local bbos, bbos2 =
        pcall(
        function()
            a = target1.Position
            a2 = taget2.Position
        end
    )
    if bbos then
        return (a - a2).Magnitude
    end
end 

local MobSpawnsFolder = Instance.new("Folder")
MobSpawnsFolder.Parent = game.Workspace
MobSpawnsFolder.Name = "MobSpawns"
MobSpawnsFolder.ChildAdded:Connect(function(v)
    wait(1)
    v.Name = RemoveLevelTitle(v.Name)
end)
function getBlueGear()
    if game.workspace.Map:FindFirstChild("MysticIsland") then
        for i, v in pairs(game.workspace.Map.MysticIsland:GetChildren()) do
            if v:IsA("MeshPart") and v.MeshId == "rbxassetid://10153114969" then --and not v.CanCollide then
                return v
            end
        end
    end
end 
function getHighestPoint()
    if not game.workspace.Map:FindFirstChild("MysticIsland") then
        return nil
    end
    for i, v in pairs(game:GetService("Workspace").Map.MysticIsland:GetDescendants()) do
        if v:IsA("MeshPart") then
            if v.MeshId == "rbxassetid://6745037796" then
                return v
            end
        end
    end
end
local AllMobInGame = {}
for i, v in next, require(game:GetService("ReplicatedStorage").Quests) do
    for i1, v1 in next, v do
        for i2, v2 in next, v1.Task do
            if v2 > 1 then
                table.insert(AllMobInGame, i2)
            end
        end
    end
end
local MobOutFolder = {}
for i, v in pairs(game:GetService("Workspace")["_WorldOrigin"].EnemySpawns:GetChildren()) do
    v.Name = RemoveLevelTitle(v.Name)
    table.insert(MobOutFolder, v)
end
for i, v in pairs(getnilinstances()) do
    if table.find(AllMobInGame, RemoveLevelTitle(v.Name)) then
        table.insert(MobOutFolder, v)
    end
end
local l1 = {}
function ReCreateMobFolder()
    local MobNew
    l1 = {}
    for i,v in pairs(MobOutFolder) do 
        if v then
            pcall(function()
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                    MobNew = Instance.new("Part")
                    MobNew.CFrame = v.PrimaryPart.CFrame
                    MobNew.Name = v.Name
                    MobNew.Parent = game.Workspace.MobSpawns
                elseif v:IsA("Part") then
                    MobNew = v:Clone()
                    MobNew.Parent = game.Workspace.MobSpawns
                    MobNew.Transparency = 1
                end
                if not table.find(l1,v.Name) then 
                    table.insert(l1,tostring(v.Name))
                end 
            end)
        end
    end
end
task.spawn(ReCreateMobFolder)
local MobSpawnClone = {}
local function getMid(vName,gg)
    local total = 0
    local allplus 
    for i,v in pairs(gg) do
        if v.Name == vName then 
            if not allplus then 
                allplus = v.Position
            else
                allplus = allplus+v.Position 
            end
            total = total+1
        end
    end
    if allplus then return allplus/total end 
end
local lss = 0
for i,v in pairs(game.Workspace.MobSpawns:GetChildren()) do 
    if not MobSpawnClone[v.Name] then 
        MobSpawnClone[v.Name] = CFrame.new(getMid(v.Name,game.Workspace.MobSpawns:GetChildren()))
        lss = lss +1
    end 
end
_G.MobSpawnClone = MobSpawnClone
function GetMobSpawnList(a)
    local a = RemoveLevelTitle(a)
    k = {}
    for i, v in pairs(game.Workspace.MobSpawns:GetChildren()) do
        if v.Name == a then
            table.insert(k, v)
        end
    end
    return k
end

local BlackListLocation = {}
function CheckNearestTeleporter(vcs)
    vcspos = vcs.Position
    min = math.huge
    min2 = math.huge
    local placeId = game.PlaceId
    if placeId == 2753915549 then
        OldWorld = true
    elseif placeId == 4442272183 then
        NewWorld = true
    elseif placeId == 7449423635 then
        ThreeWorld = true
    end
    local chooseis
    if ThreeWorld then
        TableLocations = {
            ["Caslte On The Sea"] = Vector3.new(-5058.77490234375, 314.5155029296875, -3155.88330078125),
            ["Hydra"] = Vector3.new(5756.83740234375, 610.4240112304688, -253.9253692626953),
            ["Mansion"] = Vector3.new(-12463.8740234375, 374.9144592285156, -7523.77392578125),
            ["Great Tree"] = Vector3.new(28282.5703125, 14896.8505859375, 105.1042709350586),
            ["Ngu1"] = Vector3.new(-11993.580078125, 334.7812805175781, -8844.1826171875),
            ["ngu2"] = Vector3.new(5314.58203125, 25.419387817382812, -125.94227600097656),
            ["Temple Of Time"] = Vector3.new(2957.833740234375, 2286.495361328125, -7217.05078125)
        }
    elseif NewWorld then
        TableLocations = {
            ["Mansion"] = Vector3.new(-288.46246337890625, 306.130615234375, 597.9988403320312),
            ["Flamingo"] = Vector3.new(2284.912109375, 15.152046203613281, 905.48291015625),
            ["122"] = Vector3.new(923.21252441406, 126.9760055542, 32852.83203125),
            ["3032"] = Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422)
        }
    elseif OldWorld then
        TableLocations = {
            ["1"] = Vector3.new(-7894.6201171875, 5545.49169921875, -380.2467346191406),
            ["2"] = Vector3.new(-4607.82275390625, 872.5422973632812, -1667.556884765625),
            ["3"] = Vector3.new(61163.8515625, 11.759522438049316, 1819.7841796875),
            ["4"] = Vector3.new(3876.280517578125, 35.10614013671875, -1939.3201904296875)
        }
    end
    local mmbb = {}
    for i2, v2 in pairs(TableLocations) do
        if not table.find(BlackListLocation, i2) then
            mmbb[i2] = v2
        end
    end
    local TableLocations = mmbb
    local TableLocations2 = {}
    for i, v in pairs(TableLocations) do
        if typeof(v) ~= "table" then
            TableLocations2[i] = (v - vcspos).Magnitude
        else
            TableLocations2[i] = (v["POS"] - vcspos).Magnitude
        end
    end
    for i, v in pairs(TableLocations2) do
        if v < min then
            min = v
            min2 = v
            choose = TableLocations[i]
            chooseis = i
        end
    end
    min3 = (vcspos - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if min2 + 100 <= min3 then
        return choose, chooseis
    end
end
function requestEntrance(vector3, fr)
    if not fr or fr ~= "Temple Of Time" and fr ~= "Dismension" then
        args = {
            "requestEntrance",
            vector3
        }
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
        oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        char = game.Players.LocalPlayer.Character.HumanoidRootPart
        char.CFrame = CFrame.new(oldcframe.X, oldcframe.Y + 50, oldcframe.Z)
        task.wait(0.5)
    else
        pcall(
            function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                    "requestEntrance",
                    Vector3.new(28282.5703125, 14896.8505859375, 105.1042709350586)
                )
                if GetDistance(CFrame.new(28282.5703125, 14896.8505859375, 105.1042709350586)) > 10 then
                    return
                end
                game.Players.LocalPlayer.Character:MoveTo(
                    CFrame.new(
                        28390.7812,
                        14895.8574,
                        106.534714,
                        0.0683786646,
                        1.44424162e-08,
                        -0.997659445,
                        7.52342522e-10,
                        1,
                        1.45278642e-08,
                        0.997659445,
                        -1.74397752e-09,
                        0.0683786646
                    ).Position
                )
                AllNPCS = getnilinstances()
                for i, v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
                    table.insert(AllNPCS, v)
                end
                for i, v in pairs(AllNPCS) do
                    if v.Name == "Mysterious Force" then
                        TempleMysteriousNPC1 = v
                    end
                    if v.Name == "Mysterious Force3" then
                        TempleMysteriousNPC2 = v
                    end
                end
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                    TempleMysteriousNPC2.HumanoidRootPart.CFrame
                wait(0.3)
                if
                    (TempleMysteriousNPC2.HumanoidRootPart.Position -
                        game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 15
                 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack")
                end
                wait(0.75)
            end
        )
    end
end
function AntiLowHealth(NewY)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
        CFrame.new(
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
        NewY,
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
    )
    wait()
end
function GetMidPoint(MobName, b2)
    if MobName == "Ship Officer [Lv. 1325]" then
        return b2.CFrame
    end
    if 1 > 1 then
        return b2.CFrame
    end
    local totalpos
    allid = 0
    for i, v in pairs(game.workspace.Enemies:GetChildren()) do
        if
            v.Name == MobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and
                (b2 and GetDistance(v.HumanoidRootPart, b2) <= 475)
         then
            if not totalpos then
                totalpos = v.HumanoidRootPart.Position
            elseif totalpos then
                totalpos = totalpos + v.HumanoidRootPart.Position
            end
            allid = allid + 1
        end
    end
    if totalpos then
        return totalpos / allid
    end
end 
function TweenObject(TweenCFrame,obj,ts)
    if not ts then ts = 350 end
    local tween_s = game:service "TweenService"
    local info =
        TweenInfo.new(
        (TweenCFrame.Position -
            obj.Position).Magnitude /
            ts,
        Enum.EasingStyle.Linear
    )
    _G.TweenObject =
        tween_s:Create(
            obj,
        info,
        {CFrame = TweenCFrame}
    )
    _G.TweenObject:Play() 
end
function IsPlayerAlive(player)
    if not player then
        player = game.Players.LocalPlayer
    end

    -- Kiểm tra xem đối tượng player có tồn tại và là một người chơi hợp lệ không
    if not player or not player:IsA("Player") then
        return false -- Trả về false nếu không phải là người chơi
    end

    -- Kiểm tra trạng thái nhân vật của người chơi
    local character = player.Character or player:FindFirstChild('Character')
    if not character then
        return false -- Trả về false nếu không có nhân vật
    end

    -- Kiểm tra thanh máu của nhân vật (Humanoid)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        return false -- Trả về false nếu không có Humanoid hoặc máu bằng 0
    end

    -- Nếu tất cả các điều kiện trên đều thỏa mãn, người chơi còn sống
    return true 
end
function CheckPlayerAlive()
    local a2,b2 = pcall(function() return game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 end)
    task.wait()
    if a2 then return b2 end 
end   
local FruitStocks = {}
for i,v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
    "GetFruits",
    game:GetService("Players").LocalPlayer.PlayerGui.Main.FruitShop:GetAttribute("Shop2")
)) do 
    if v.OnSale then 
        table.insert(FruitStocks,v.Name)
    end
end
function SnipeFruit(fruitsSnipes)
    if _G.ServerData['PlayerData'].DevilFruit == '' then 
        for i = #fruitsSnipes,1,1 do 
            local f = fruitsSnipes[i]
            if FruitStocks[f] then 
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PurchaseRawFruit", f, game:GetService("Players").LocalPlayer.PlayerGui.Main.FruitShop:GetAttribute("Shop2"))
                return 
            end
        end  
    end
end   
function sortSwordsByRarity(swords)
    table.sort(swords, function(a, b)
        return a.Rarity > b.Rarity
    end) 
    return swords[1]
end

function getNextSwordToFarm()
    local Swords = {}
    for _, itemData in pairs(_G.ServerData["Inventory Items"]) do 
        if itemData.Type == 'Sword' and itemData.Mastery < itemData.MasteryRequirements.X then 
            table.insert(Swords, itemData)  -- Chèn đúng vào bảng Swords
        end 
    end
    if #Swords > 0 then 
        local NNN = sortSwordsByRarity(Swords) 
        return NNN,NNN.MasteryRequirements.X
    end
    Swords = {}
    for _, itemData in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventory")) do 
        if itemData.Type == 'Sword' and itemData.Mastery < 600 then 
            table.insert(Swords, itemData)  -- Chèn đúng vào bảng Swords
        end 
    end
    if #Swords > 0 then 
        local NNN = sortSwordsByRarity(Swords) 
        return NNN,600
    end
    return nil,0
end  

function checkFruit1MWS()
    for i,v in pairs(game.workspace:GetChildren()) do 
        if v.Name:find('Fruit') and getPriceFruit(ReturnFruitNameWithId(v)) >= 1000000 and getPriceFruit(ReturnFruitNameWithId(v)) < 2500000 then 
            return v 
        end 
    end
end
function checkFruit1M(in5)
    local function fruitsea3bp()
        local n3
        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do 
            if v.Name:find('Fruit') and getPriceFruit(ReturnFruitNameWithId(v)) >= 1000000 and getPriceFruit(ReturnFruitNameWithId(v)) < 2500000 then 
                n3 = v 
            end 
        end 
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do 
            if v.Name:find('Fruit') and getPriceFruit(ReturnFruitNameWithId(v)) >= 1000000 and getPriceFruit(ReturnFruitNameWithId(v)) < 2500000 then 
                n3 = v 
            end 
        end 
        return n3 
    end 
    if fruitsea3bp() then return fruitsea3bp() end
    if in5 then  
        local FOUNDDF 
        local MaxValue = math.huge 
        for i,v in pairs(_G.ServerData["Inventory Items"]) do 
            if v.Value and (v.Value >= 1000000 and v.Value < 2500000 ) and v.Value < MaxValue then   
                MaxValue = v.Value 
                FOUNDDF = v.Name
            end
        end 
        if FOUNDDF then 
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadFruit", FOUNDDF) 
            wait(.5)
            if fruitsea3bp() then return fruitsea3bp() end
        end
    end 
end
function checkFruittoEat(fruitsSnipes,includedInventory)
    for i,v in pairs(fruitsSnipes) do 
        for index,Inst in _G.ServerData['PlayerBackpack'] do 
            if index:find('Fruit') and Inst then 
                if Inst:GetAttribute("OriginalName") and tostring(Inst:GetAttribute("OriginalName")) == v then 
                    return Inst 
                end
            end
        end
    end 
    if includedInventory then 
        for i,v in pairs(fruitsSnipes) do 
            if _G.ServerData["Inventory Items"][v] then 
                return true
            end
        end
    end
end 
function eatFruit(fruitsSnipes,includedInventory) 
    function l4432()
        for i,v in pairs(fruitsSnipes) do
            for Ind,Inst in _G.ServerData['PlayerBackpack'] do 
                if Ind:find('Fruit') and Inst then 
                    if Inst:GetAttribute("OriginalName") and tostring(Inst:GetAttribute("OriginalName")) == v then 
                        task.spawn(function()
                            Tweento(CFrame.new(game.Players.LocalPlayer.Character.PrimaryPart.CFrame.X,game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Y +2000,game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Z))
                        end)
                        repeat 
                            task.wait()
                            EquipWeaponName(Ind)
                        until game.Players.LocalPlayer.Character:FindFirstChild("EatRemote")
                        print('Eating Fruit')
                        game.Players.LocalPlayer.Character:FindFirstChild("EatRemote", true):InvokeServer()
                        _G.CurrentTask = ''
                        print('Changed Task.')
                    end
                end
            end
        end 
    end
    l4432()
    if includedInventory then 
        for i,v in pairs(fruitsSnipes) do 
            if _G.ServerData["Inventory Items"][v] then 
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadFruit", v) 
                l4432()
            end
        end
    end
end 
function Storef(v) 
    if _G.CurrentTask ~= 'Eat Fruit' and _G.CurrentTask ~= 'Auto Sea 3' then 
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
            "StoreFruit",
            tostring(v:GetAttribute("OriginalName")),
            v
        )
    end
end 
function NearestMob(distanc)
    for i,v in game.workspace.Enemies:GetChildren() do 
        local vhum = v:FindFirstChildOfClass('Humanoid') or v:WaitForChild('Humanoid')
        if vhum and vhum.Parent and vhum.ClassName == 'Humanoid' and vhum.Health >= 0 and vhum.Parent.PrimaryPart and (vhum.Parent.PrimaryPart.Position-game.Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude <= distanc then 
            return v 
        end
    end
end
function CheckMessage(v1)
    local v1 = tostring(v1)
    local RaidCheck = "Island #%d cleared!" 
    if v1:find('Earned') or v1:find('LEVEL') then 
        return false
    end
    if v1:find('Island') and v1:find('cleared') then 
        print("Found next island:",tonumber(string.match(v1,'%d'))+1)
        _G.NextRaidIslandId = tonumber(string.match(v1,'%d'))+1
        return false
    end 

    if v1:find('spotted') then  
        print('Pirate raid FOUND!')
        _G.PirateRaidTick = tick()
        return v1
    elseif v1:find('factory') then 
        return v1
    elseif v1 == "Loading..." then 
        print('Dimension Loading ⚠️⚠️⚠️|',v1,v1 == "Loading...")
        _G.DimensionLoading = true
    elseif v1:find('Good job') then 
        print('Pirate raid Cancelled!')
        _G.PirateRaidTick = 0 
    elseif v1:find('attack') then 
        _G.AttackedSafe = true 
    elseif v1:find('rare item') then 
        _G.Config.FireEssencePassed = typeof(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDragonTalon", true))~= 'string'  
    elseif v1:find('unleashed') then 
        _G.RaidBossEvent = true  
    elseif v1:find('barrier') then 
        _G.RaidBossEvent = true 
    elseif v1:find('dimension') then 
        _G.CakePrince = true 
    elseif v1:find('disappeared') then 
        _G.CakePrince = false
    elseif v1:find('legendary item') then  
        _G.HallowEssence = true
    elseif v1:find("entered this world") then 
        _G.SoulReaper = true
    else
        return false;
    end 
end
function LoadMessage(v)
    if v and not v:FindFirstChild('InstanceUsed') then 
        local InstanceUsed = Instance.new("IntValue",v)
        InstanceUsed.Name = 'InstanceUsed'
        v:GetPropertyChangedSignal('Value'):Connect(function()
            local mmb = CheckMessage(v.Value)
            if _G.CheckM5 and mmb and typeof(mmb) == 'string' then 
                _G.CheckM5(mmb)
            end 
        end) 
    end
end
local function LoadPlayer() 
    if not IsPlayerAlive() then repeat task.wait(.1) until IsPlayerAlive() end
    if IsPlayerAlive() then
        _G.ServerData["PlayerBackpackFruits"] = {}
        _G.ServerData["PlayerBackpack"] = {} 
        task.spawn(function()
            repeat task.wait() until loadSkills
            loadSkills()
        end)
        for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do  
            if v.ClassName =='StringValue' then 
                LoadMessage(v)
            end
            if not _G.ServerData["PlayerBackpack"][v.Name] then 
                _G.ServerData["PlayerBackpack"][v.Name] = v  
                if v.Name:find('Fruit') then  
                    if v.Name:find('Fruit') then  
                        if not Storef(v) then 
                            local nextid = #_G.ServerData["PlayerBackpackFruits"]
                            _G.ServerData["PlayerBackpackFruits"][nextid] = v 
                            v:GetPropertyChangedSignal('Parent'):Connect(function() 
                                if not v.Parent then _G.ServerData["PlayerBackpackFruits"][nextid]=nil end
                            end) 
                        end
                    end 
                end 
                task.spawn(function()
                    if v:IsA('Tool') and v.ToolTip == 'Melee' then 
                        repeat task.wait() until _G.Config and _G.Config['Melee Level Values'] _G.Config["Melee Level Values"][v.Name] = v:WaitForChild('Level').Value 
                    end
                end)
            end
        end 
        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do 
            if not _G.ServerData["PlayerBackpack"][v.Name] then 
                _G.ServerData["PlayerBackpack"][v.Name] = v  
                if v.Name:find('Fruit') then  
                    if not Storef(v) then 
                        local nextid = #_G.ServerData["PlayerBackpackFruits"]
                        _G.ServerData["PlayerBackpackFruits"][nextid] = v 
                        v:GetPropertyChangedSignal('Parent'):Connect(function() 
                            if not v.Parent then _G.ServerData["PlayerBackpackFruits"][nextid]=nil end
                        end) 
                    end
                end 
                task.spawn(function()
                    if v:IsA('Tool') and v.ToolTip == 'Melee' then 
                        repeat task.wait() until _G.Config and _G.Config['Melee Level Values'] _G.Config["Melee Level Values"][v.Name] = v:WaitForChild('Level').Value 
                    end
                end)
            end
        end  
        if not _G.ServerData['PlayerData'] then _G.ServerData['PlayerData'] = {} end
        for i,v in pairs(game.Players.LocalPlayer.Data:GetChildren()) do 
            if tostring(v.ClassName):find('Value') then 
                if not _G.ServerData['PlayerData'][v.Name] then 
                    _G.ServerData['PlayerData'][v.Name] = v.Value 
                    v:GetPropertyChangedSignal('Value'):Connect(function() 
                        _G.ServerData['PlayerData'][v.Name] = v.Value 
                    end)
                end
            end
        end  
        if not game.Players.LocalPlayer.Character:FindFirstChild("Teleport Access") then 
            if not game.Players.LocalPlayer.Character:FindFirstChild("Teleport Access") then
                local TweenAccess = Instance.new("IntValue")
                TweenAccess.Name = "Teleport Access"
                TweenAccess.Parent = game.Players.LocalPlayer.Character 
                game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(v)
                    _G.ServerData["PlayerBackpack"][v.Name] = v 
                    if v.Name == 'Holy Torch' then 
                        for i,v in game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress").Torches do 
                            if not v then 
                                task.spawn(function()
                                    game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress", "Torch", i)
                                end)
                            end
                        end
                    end
                    task.delay(3,function()
                        if v.Name == 'Red Key' then 
                            print('DOugh chip unlocked: ',game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CakeScientist", "Check"))
                        end
                        if v.Name:find('Fruit') then  
                            if not Storef(v) then 
                                local nextid = #_G.ServerData["PlayerBackpackFruits"]
                                _G.ServerData["PlayerBackpackFruits"][nextid] = v 
                                v:GetPropertyChangedSignal('Parent'):Connect(function() 
                                    if not v.Parent then _G.ServerData["PlayerBackpackFruits"][nextid]=nil end
                                end) 
                            end
                        end
                    end) 
                    task.spawn(function()
                        if v:IsA('Tool') and v.ToolTip == 'Melee' then 
                            repeat task.wait() until _G.Config and _G.Config['Melee Level Values'] _G.Config["Melee Level Values"][v.Name] = v:WaitForChild('Level').Value 
                        end
                    end)
                    for newids,v2 in pairs(_G.ServerData["PlayerBackpack"]) do 
                        
                        if not game.Players.LocalPlayer.Character:FindFirstChild(newids) and not game.Players.LocalPlayer.Backpack:FindFirstChild(newids) then 
                            _G.ServerData["PlayerBackpack"][newids] = nil 
         
                        end
                    end 

                end)
                game.Players.LocalPlayer.Character.ChildAdded:Connect(function(newchild) 
                    if newchild.ClassName =='StringValue' then 
                        LoadMessage(newchild)
                    end
                    if newchild.Name:find('Fruit') then  
                        if not Storef(newchild) then 
                            local nextid = #_G.ServerData["PlayerBackpackFruits"]
                            _G.ServerData["PlayerBackpackFruits"][nextid] = newchild 
                            newchild:GetPropertyChangedSignal('Parent'):Connect(function() 
                                if not newchild.Parent then _G.ServerData["PlayerBackpackFruits"][nextid]=nil end
                            end) 
                        end
                    end 
                end)
                game.Players.LocalPlayer.Character.PrimaryPart:GetPropertyChangedSignal("Position"):Connect(function()
                    _G.PlayerLastMoveTick = tick()
                end)
            end
            task.spawn(function()
                if EquipAllWeapon then 
                    EquipAllWeapon() 
                end
            end)
        end
        
    end
end
function AddNoknockback(enemy)
    local humanoid = enemy.PrimaryPart or enemy:WaitForChild('HumanoidRootPart',3)
    if not humanoid then return end  -- Nếu enemy không có Humanoid, thoát hàm

    humanoid.ChildAdded:Connect(function(child)
        if child.ClassName == 'BodyVelocity' then 
            child.Velocity = Vector3.new(0, 0, 0)
            return
        end
        if child.ClassName == 'BodyVelocity' or child.ClassName == "BodyPosition" then
            child.MaxForce = Vector3.new(0, 0, 0)
            child.P = 0 
        elseif child.ClassName == "BodyGyro" then 
            child.P = 0 
            child.MaxTorque = Vector3.new(0, 0, 0) -- Sửa thành MaxTorque
        end
    end)
end 
task.spawn(function()
    _G.Ticktp = tick() 
    getgenv().TushitaQuest = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress")
    wait(5)
    if TushitaQuest and not TushitaQuest.OpenDoor and _G.ServerData['PlayerData'].Level >= 2000 then 
        task.spawn(function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/FinderServerLoading.lua'))()
            if AutoRipIndraHop then  
                for i = 1,120 do 
                    if game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress") and game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress").OpenDoor then
                        break;
                    end
                    if _G.Config.OwnedItems['Tushita'] then 
                        break;
                    end
                    AutoRipIndraHop()
                    task.wait(1)
                end
                print('Didint found any rip indra server in 100s')
            else
                loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/FinderServerLoading.lua'))()
            end
        end)
    end
end)
game.workspace.Characters.ChildAdded:Connect(LoadPlayer)
local tween_s = game:service "TweenService"
function Tweento(targetCFrame)
    if CheckPlayerAlive() then
        if not game.Players.LocalPlayer.Character:FindFirstChild("Teleport Access") then
            return warn('I cant tween right now: Teleport Perm Missing')
        end
        if not TweenSpeed or type(TweenSpeed) ~= "number" then
            TweenSpeed = 325
        end
        if _G.SavedConfig and _G.SavedConfig["Tween Speed"] and typeof(_G.SavedConfig["Tween Speed"]) == 'number' then 
            TweenSpeed = _G.SavedConfig["Tween Speed"]
        end
        local targetPos = targetCFrame.Position
        local Distance =
            (targetPos -
            game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
        if Distance <= 300 and tick() - _G.Ticktp >= 0.01 then
            game.Players.LocalPlayer.Character:MoveTo(targetCFrame.Position)
            _G.Ticktp = tick()
            return
        end
        local bmg, bmg2 = CheckNearestTeleporter(targetCFrame)
        if bmg then
            local timetry = 0
            repeat
                pcall(
                    function()
                        _G.tween:Cancel()
                    end
                )
                wait()
                requestEntrance(bmg, bmg2)
                timetry = timetry + 1
            until not CheckNearestTeleporter(targetCFrame) or timetry >= 10
            if timetry >= 10 and CheckNearestTeleporter(targetCFrame) then
                if bmg2 == "Temple Of Time" then
                    table.insert(BlackListLocation, bmg2)
                end
                game.Players.LocalPlayer.Character.Humanoid.Health = 0
            end
        end
        task.spawn(function()
            if not _G.SavedConfig['Same Y Tween'] then return end
            if (game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Y < targetCFrame.Y-5 or game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Y > targetCFrame.Y+5) 
            and (not bmg)  then 
                if _G.tween then 
                    _G.tween:Cancel()
                    _G.tween = nil 
                end
                game.Players.LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.PrimaryPart.CFrame.X,(targetCFrame.Y > 20 and targetCFrame.Y or targetCFrame.Y+30),game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Z)
            end
        end)
        local tweenfunc = {}
        local info =
            TweenInfo.new(
                (targetPos -
                game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude /
                TweenSpeed,
            Enum.EasingStyle.Linear
        )
        _G.tween =
            tween_s:Create(
            game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
            info,
            {CFrame = targetCFrame}
        )
        _G.tween:Play()
        function tweenfunc:Stop()
            _G.tween:Cancel()
        end
        _G.TweenStats = _G.tween.PlaybackState
        _G.tween.Completed:Wait()
        _G.TweenStats = _G.tween.PlaybackState
        return tweenfunc 
    end
end  
function GetCFrameADD(v2)
    task.wait()
    if game.Players.LocalPlayer.Character.Humanoid.Sit then 
        SendKey('Space',.5) 
    end
    return CFrame.new(0,30,0)
end 
local TweenK
local function TweenKill(v)
    if not CheckPlayerAlive() then return end
    if v and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then  
        local DISCC = GetDistance(v.HumanoidRootPart)
        if DISCC > 1000 then 
            Tweento(v.HumanoidRootPart.CFrame * GetCFrameADD())
        elseif DISCC > 3 then
            local tweenfunc = {}
            local tween_s = game:service "TweenService"
            local info =
                TweenInfo.new(
                GetDistance(v.HumanoidRootPart) /
                    300,
                Enum.EasingStyle.Linear
            )
            if GetDistance(v.HumanoidRootPart) < 200 then 
                if _G.tween then 
                    _G.tween:Cancel()
                    _G.tween = nil 
                end
                game.Players.LocalPlayer.Character:MoveTo((v.HumanoidRootPart.CFrame * GetCFrameADD()).Position)
            else 
                _G.tween =
                    tween_s:Create(
                    game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
                    info,
                    {CFrame = v.HumanoidRootPart.CFrame * GetCFrameADD()}
                )
                _G.tween:Play() 
            end
        end
    end
    task.wait()
end
function IsBoss(nv,raidb)
    if typeof(nv) == "string" then 
        nv = CheckBoss(nv).Name
        if nv:find("Friend") then 
            return true 
        end
    end
    if nv then 
        local Bossb = raidb and "Raid Boss" or not raidb and "Boss"
        local a,b = pcall(function()
            if nv.Humanoid.DisplayName and string.find(nv.Humanoid.DisplayName,Bossb)  then 
                return true 
            end 
            return false
        end)
        if a then return b end
    end
end
function GetMidPointPart(tbpart)
    local pascal
    local allpas = 0
    for i, v in pairs(tbpart) do
        pcall(
            function()
                if not pascal then
                    pascal = v.Position
                else
                    pascal = pascal + v.Position
                end
                allpas = allpas + 1
            end
        )
    end
    return pascal / allpas
end
function EnableBuso()
    if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
        local args = {
            [1] = "Buso"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
end  
function GetWeapon(wptype)
    local s 
    for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == wptype then
            s=v
        end
    end
    for i, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == wptype then
            s = v
        end
    end
    return s
end 
function LoadItem(d)
    if _G.ServerData["PlayerBackpack"][d] then
        return
    end
    print('Loaditem',d)
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", d)
end 
function EquipWeapon(ToolSe)
    if _G.WeaponType == "" or _G.WeaponType == nil then
        _G.WeaponType = "Melee"
    end
    if not ToolSe then 
        if _G.CurrentTask ~='Getting Cursed Dual Katana' or _G.CDKQuest == 'Soul Reaper' then 
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(GetWeapon(_G.WeaponType))
        else
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(GetWeapon('Sword'))
        end
    else
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        wait(.4)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end 
function AddBodyVelocity(enable)
    if not enable then  
        if game.Players.LocalPlayer.Character.Head:FindFirstChildOfClass("BodyVelocity") then 
            game.Players.LocalPlayer.Character.Head:FindFirstChildOfClass("BodyVelocity"):Destroy()
        end
        return
    end
    for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do 
        if v:IsA("BasePart") or v:IsA("Part") then 
            v.CanCollide = false 
        end
    end
    if not game.Players.LocalPlayer.Character.Head:FindFirstChild("NEWQL") then 
        local OV = Instance.new("BodyVelocity",game.Players.LocalPlayer.Character.Head)
        OV.Velocity = Vector3.new(0, 0, 0)
        OV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        OV.P = 15000
        OV.Name = "NEWQL"
    end
end
local Elites = {
    "Deandre",
    "Urban",
    "Diablo"
}
local KillingBoss
local KillingMobTick = tick()-10
local MobUsingSkill = false 
function CanMasteryFarm(v)
    if v and v.Humanoid and v.Humanoid.Health < (v.Humanoid.MaxHealth * 40/100) then 
        return true 
    end
end 
function CheckSkill(skillstable,blacklistedskills)
    if not blacklistedskills then 
        blacklistedskills = {}
    end 
    if skillstable['Z'] then 
        return "Z"
    elseif skillstable['X'] then 
        return "X"
    elseif skillstable["C"] then 
        return "C"
    end
end 
function addCheckSkill(v)
    if v:FindFirstChildOfClass('Humanoid') and v:FindFirstChildOfClass('Humanoid').MaxHealth < 500000 and GetDistance(v.PrimaryPart,CFrame.new(-5543.5327148438, 313.80062866211, -2964.2585449219)) > 1500 then
        local animator = v:FindFirstChildOfClass('Humanoid'):FindFirstChildOfClass('Animator')
        if animator then
            animator.AnimationPlayed:Connect(function(anitrack) 
                if anitrack.Animation.AnimationId ~= 'rbxassetid://9802959564' and anitrack.Animation.AnimationId ~= 'rbxassetid://507766388' and anitrack.Animation.AnimationId ~='http://www.roblox.com/asset/?id=9884584522' then  
                    local realTimePos = anitrack.TimePosition
                    if realTimePos <= 0 then 
                        realTimePos = 1.5
                    end
                    if _G.DogdeUntil and tick() < _G.DogdeUntil then  
                        _G.DogdeUntil = _G.DogdeUntil+math.floor(realTimePos)
                    else 
                        _G.DogdeUntil = tick()+math.floor(realTimePos)
                    end
                    if _G.tween then 
                        _G.tween:Cancel()
                        _G.tween = nil 
                    end
                    --game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame * CFrame.new(0,300,0)
                    warn('Dogde Skill Please sirrrr',anitrack.TimePosition,math.floor(realTimePos)+1,anitrack.Animation.AnimationId)
                end
            end)
        end
    end
end
getgenv().GetPing = function()
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    ping = ping:gsub("CV", "")
    ping = ping:gsub("%%d", "")
    ping = ping:gsub(" ", "")
    ping = ping:gsub("(%d%)", "")
    ping = ping:split("(")[1]
    return tonumber(ping)
end
function KillNigga(MobInstance) 
    local LS,LS2 = pcall(function()
        if IsPlayerAlive() and
        MobInstance and MobInstance:FindFirstChild("Humanoid") and
        MobInstance.Humanoid.Health > 0
        then
            local mmas = GetMidPoint(MobInstance.Name, MobInstance.HumanoidRootPart)
            local LockCFrame
            local KillingBoss
            if mmas and not string.find(MobInstance:FindFirstChildOfClass('Humanoid').DisplayName, "Boss") and MobInstance.Humanoid.MaxHealth < 130000 then
                LockCFrame = CFrame.new(mmas)
            else
                LockCFrame = MobInstance.HumanoidRootPart.CFrame
                KillingBoss = true
            end 
            local N_Name = MobInstance.Name
            SetContent('Killing '..tostring(N_Name))
            
            task.spawn(function()
                if not KillingBoss and CheckEnabling and (CheckEnabling('High Ping Hop') or CheckEnabling("Player Nearing Hop")) then 
                    if MobInstance.Humanoid.MaxHealth < 100000 and not (_G.ServerData["PlayerBackpack"]['Sweet Chalice'] or _G.ServerData["PlayerBackpack"]["God's Chalice"]) and not _G.PirateRaidTick or tick()-_G.PirateRaidTick >= 90 then 
                        if GetPing and GetPing() >= 1000 then 
                            print('High Ping')
                            wait(10)
                            if GetPing and GetPing() >= 650 then 
                                HopServer(10,true,'Ping is too high.')
                            end
                        end 
                        local bbxz 
                        if Exploiters then 
                            for name__,v in Exploiters  do 
                                bbxz = workspace.Characters:FindFirstChild(name__)  
                                if bbxz then 
                                    if GetDistance(bbxz.PrimaryPart) < 500 then 
                                        HopServer(10,true,'Cheater nearing:'..tostring(bbxz.Name).." "..tostring(math.floor(GetDistance(bbxz.PrimaryPart))))
                                    end
                                end
                            end
                        else 
                            print(' not ',Exploiters)
                        end
                    end
                end
            end)
            local BringMobSuccess
            task.delay(7.5,function() 
                BringMobSuccess = true
            end)
            task.delay(.01 ,function()
                repeat task.wait() until MobInstance.PrimaryPart and GetDistance(MobInstance.PrimaryPart) < 150 
                addCheckSkill(MobInstance)
                wait()
                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 3000+300)
                if BringMob(MobInstance, LockCFrame) then 
                    task.wait(.275)
                    BringMobSuccess = true 
                else    
                    BringMobSuccess =true 
                end 
                if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("KenTalk", "Start") == 0 then 
                    if not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:FindFirstChildOfClass("ImageLabel") then 
                        SendKey('E',.5)
                    end
                end
            end)             
            if _G.KillAuraConnection then 
                _G.KillAuraConnection:Disconnect()
                _G.KillAuraConnection = nil 
            end 
            local CurrentPlrHum = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
            repeat
                if CurrentPlrHum and CurrentPlrHum.Health > 0 then 
                    if not (_G.ServerData["PlayerBackpack"]['Sweet Chalice'] or _G.ServerData["PlayerBackpack"]["God's Chalice"]) or ((_G.ServerData["PlayerBackpack"]['Sweet Chalice'] or _G.ServerData["PlayerBackpack"]["God's Chalice"]) and CurrentPlrHum.Health >(CurrentPlrHum.MaxHealth*31)/100) then
                        KillingMob = true
                        EquipWeapon()
                        TweenKill(MobInstance)  
                        if BringMobSuccess then 
                            MobInstance.Humanoid.AutoRotate = false
                            _G.UseFAttack = true 
                        end  
                    elseif (_G.ServerData["PlayerBackpack"]['Sweet Chalice'] or _G.ServerData["PlayerBackpack"]["God's Chalice"]) and CurrentPlrHum.Health <= (CurrentPlrHum.MaxHealth*30)/100 then 
                        local OldCFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame
                        repeat 
                            task.wait()
                            _G.UseFAttack = false 
                            game.Players.LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.PrimaryPart.CFrame.X,math.random(1000,10000),game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Z+30)
                        until not CurrentPlrHum or not CurrentPlrHum.Parent or CurrentPlrHum.Health >=(CurrentPlrHum.MaxHealth*70)/100 or not MobInstance or not MobInstance:FindFirstChildOfClass("Humanoid") or not MobInstance:FindFirstChild("HumanoidRootPart") or
                        MobInstance.Humanoid.Health <= 0 or not IsPlayerAlive()
                        Tweento(OldCFrame)
                    end
                else 
                    _G.UseFAttack = false
                    wait(1)
                    pcall(function()
                        CurrentPlrHum = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                    end)
                end 
                task.wait()
            until not MobInstance or not MobInstance:FindFirstChildOfClass("Humanoid") or not MobInstance:FindFirstChild("HumanoidRootPart") or
            MobInstance.Humanoid.Health <= 0 or _G.SwitchingServer
            SetContent('...')
            KillingMob = false
            _G.UseFAttack = false  
            return true
        end
    end)
    if not LS then print('ls',LS2) end
end  
function CheckMob(mobormoblist,rep)
    if typeof(mobormoblist) == 'table' then 
        for i,v in pairs(mobormoblist) do 
            for __,v2 in pairs(game.workspace.Enemies:GetChildren()) do 
                if RemoveLevelTitle(v) == RemoveLevelTitle(v2.Name) and v2:FindFirstChild('Humanoid') and v2.Humanoid.Health > 0 then 
                    return v2
                end
            end
        end
        if rep then 
            for i,v in pairs(mobormoblist) do 
                for __,v2 in pairs(game.ReplicatedStorage:GetChildren()) do 
                    if RemoveLevelTitle(v) == RemoveLevelTitle(v2.Name) and v2:FindFirstChild('Humanoid') and v2.Humanoid.Health > 0 then 
                        return v2
                    end
                end
            end
        end
    else
        for i,v in pairs(game.workspace.Enemies:GetChildren()) do 
            if RemoveLevelTitle(v.Name) == RemoveLevelTitle(mobormoblist) and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 then 
                return v
            end
        end
        if rep then 
            for i,v in pairs(game.ReplicatedStorage:GetChildren()) do 
                if RemoveLevelTitle(v.Name) == RemoveLevelTitle(mobormoblist) and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 then 
                    return v
                end
            end
        end
    end
end
_G.MobFarest = {}
function getMobSpawnExtra()
    for i2,v2 in pairs(game.Workspace.MobSpawns:GetChildren()) do 
        if GetDistance(v2,MobSpawnClone[v2]) > 350 then 
            local indexg = 0
            if not _G.MobFarest[v2.Name] then 
                _G.MobFarest[v2.Name] = {} 
            else
                indexg = #_G.MobFarest[v2.Name]
            end
            local dist = GetDistance(_G.MobFarest[v2.Name][indexg],v2.CFrame)
            if indexg == 0 or (dist and dist > 350) then 
                table.insert(_G.MobFarest[v2.Name],v2.CFrame)
            end
        end 
    end
end 
task.spawn(getMobSpawnExtra)
function getMobSpawnbyList(MobList)
    local Returner = {}
    for i,v in pairs(MobList) do 
        if MobSpawnClone[v] then 
            table.insert(Returner,MobSpawnClone[v]) 
            if _G.MobFarest[v] and #_G.MobFarest[v] > 0 then 
                for i2,v2 in _G.MobFarest[v] do 
                    table.insert(Returner,v2) 
                end
            end
        end
    end
    return Returner  
end
function KillMobList(MobList)
    for i,v in pairs(MobList) do 
        MobList[i] = RemoveLevelTitle(v)
    end
    local NM = CheckMob(MobList)
    if NM then 
        KillNigga(NM)
    else
        local MS = getMobSpawnbyList(MobList) 
        if MS then 
            for i,v in pairs(MS) do 
                local isV = CheckMob(MobList)
                if not isV and v then 
                    SetContent('Waiting mobs...')
                    Tweento(v * CFrame.new(0,50,0))
                    wait(1)
                elseif isV then 
                    break;
                end
            end
        end
    end
end
function KillBoss(BossInstance)
    if not BossInstance or not BossInstance:FindFirstChildOfClass('Humanoid') or BossInstance:FindFirstChildOfClass('Humanoid').Health <= 0 then
        task.wait(.1)
        return 
    end 
    warn('Killing boss:',BossInstance.Name)
    if not game.Workspace.Enemies:FindFirstChild(BossInstance.Name) then  
        SetContent('Moving to '..BossInstance.Name)
        Tweento(BossInstance.PrimaryPart.CFrame * CFrame.new(0,50,0))
    end
    KillNigga(BossInstance)
end
function BringMob(TAR,V5)
    if not TAR then 
        return
    end
    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 3000+300)
    if not TAR:FindFirstChild("Bringed") then 
        local Bringed = Instance.new("IntValue",TAR)
        Bringed.Name = "Bringed" 
    else
        return
    end
    V6 = V5 or TAR.HumanoidRootPart.CFrame
    for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v.Name == TAR.Name and v.PrimaryPart and
                (V6.Position - v.HumanoidRootPart.Position).Magnitude < 340 and
                (isnetworkowner(v.HumanoidRootPart)) and
                v:FindFirstChildOfClass('Humanoid').MaxHealth < 100000
        then
            v.PrimaryPart.CanCollide = false
            v.Head.CanCollide = false
            v.Humanoid.WalkSpeed = 0
            v.Humanoid.JumpPower = 0 
            v.Humanoid.AutoRotate = false 
            v:MoveTo(V6.Position)
        end
    end 
    return true
end  
function GetNearestPlayer(pos)
    local ner = math.huge
    local ner2
    for i, v in pairs(game.Players:GetChildren()) do
        if
            v.Character and v.Character.PrimaryPart and
                (v.Character.PrimaryPart.Position - pos).Magnitude < ner
         then
            ner = (v.Character.PrimaryPart.Position - pos).Magnitude 
            ner2 = v.Name
        end
    end
    if game.Players.LocalPlayer.Name == ner2 then
        return true
    end
end
if not isnetworkowner or identifyexecutor() == 'Delta' then 
    function isnetworkowner2(p1)
        local A = gethiddenproperty(game.Players.LocalPlayer, "SimulationRadius")
        local B = game.Players.LocalPlayer.Character or Wait(game.Players.LocalPlayer.CharacterAdded)
        local C = game.WaitForChild(B, "HumanoidRootPart", 300)
        if C then
            if p1.Anchored then
                return false
            end
            if game.IsDescendantOf(p1, B) or (C.Position - p1.Position).Magnitude <= A and GetNearestPlayer(p1.Position) then
                return true
            end
        end
    end  
    isnetworkowner = function(part)
        if isnetworkowner2(part) then
            return isnetworkowner2(part)
        end
        return part.ReceiveAge == 0 and GetNearestPlayer(part.Position)
    end
else
    isnetworkowner2 = isnetworkowner
    warn("already isnetworkowner 😎😎😎") -- bruh
end
function Click()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
end
local cancelKill = false  
_G.AttackedSafe = false 
function CancelKillPlayer()
    cancelKill = true 
end 
function CheckSafeZone(p)
    for i, v in pairs(game:GetService("Workspace")["_WorldOrigin"].SafeZones:GetChildren()) do
        if v:IsA("Part") then
            if
                GetDistance(v,p.PrimaryPart) <= 200 and
                    p.Humanoid.Health / p.Humanoid.MaxHealth >= 90 / 100
             then
                return true
            end
        end
    end
    if _G.AttackedSafe then 
        _G.AttackedSafe = false 
        return true 
    end
end
function KillPlayer(PlayerName)
    warn('KillPlayer',PlayerName) 
    SetContent('Start killing '..tostring(PlayerName))
    local t = game:GetService("Workspace").Characters:FindFirstChild(PlayerName)
    local tRoot = t.PrimaryPart or t:FindFirstChild('HumanoidRootPart')
    local tHumanoid = t:FindFirstChild('Humanoid')
    local getNeartick = tick()-5555
    local totRoot = GetDistance(tRoot)
    local StartKillTick = tick()
    local IsSafeZone = false
    repeat 
        task.wait()
        if IsPlayerAlive() then
            EquipWeapon() 
            IsSafeZone = CheckSafeZone(t)
            if game.Players.LocalPlayer.PlayerGui.Main.PvpDisabled.Visible then 
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
            end
            totRoot = GetDistance(tRoot)
            game.Players.LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.PrimaryPart.CFrame.X,tRoot.CFrame.Y,game.Players.LocalPlayer.Character.PrimaryPart.CFrame.Z)
            if totRoot < 50 then 
                if tick()-getNeartick > 100 then 
                    getNeartick = tick()
                    repeat  
                        SetContent('Bypassing Anti-Killing')
                        task.wait()
                        game.Players.LocalPlayer.Character.PrimaryPart.CFrame = tRoot.CFrame * CFrame.new(0,100,10)
                        _G.UseFAttack = false
                    until tick()-getNeartick > 3 and tick()-getNeartick < 100
                    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = tRoot.CFrame * CFrame.new(0,0,10)
                elseif tick()-getNeartick > 3 and tick()-getNeartick < 100 then 
                    KillingMob = true
                    EquipWeapon() 
                    FastMob = false
                    if t:FindFirstChildOfClass('Tool') and t:FindFirstChildOfClass('Tool'):FindFirstChild('Holding') and t:FindFirstChildOfClass('Tool'):FindFirstChild('Holding').Value then 
                        SetContent(PlayerName..' holding skill...')
                        game.Players.LocalPlayer.Character.PrimaryPart.CFrame = tRoot.CFrame * CFrame.new(0,50,15)
                        SendKey('Z')
                        SendKey('X')
                        
                    else
                        task.spawn(function()
                            game.Players.LocalPlayer.Character.PrimaryPart.CFrame = tRoot.CFrame * CFrame.new(0,2,2.5)
                        end)
                        task.spawn(function()
                            for i,v in game.workspace.Enemies:GetChildren() do v.Humanoid.Health = 0 end
                        end)
                        Click()
                        _G.UseFAttack = true
                        SendKey('Z')
                        SendKey("Q")
                        SendKey('X')
                        SendKey("Q")
                    end
                end
            else
                Tweento(tRoot.CFrame * CFrame.new(0,30,0))
            end 
        else
            getNeartick = tick()-5555
        end
    until cancelKill or IsSafeZone or tick()-StartKillTick > 80 or not t or not t.Parent or not game:GetService("Workspace").Characters:FindFirstChild(PlayerName) or not tRoot or not tRoot.Parent or not tHumanoid or tHumanoid.Health <= 0 
    cancelKill = false 
    KillingMob = false
    StartKillTick = tick()
    _G.UseFAttack = false
    if IsSafeZone or tick()-StartKillTick > 80 then 
        warn('Kill Failed:',PlayerName) 
        SetContent('Kill Failed: '..tostring(PlayerName))
        return false 
    else 
        warn('Kill Success:',PlayerName) 
        SetContent('Kill Success: '..tostring(PlayerName))
        return true 
    end
end 
function getNearestRaidIsland()
    local function GetI(vId)  
        local Nears = math.huge 
        local ChildSet 
        for i,v in pairs(game:GetService("Workspace")["_WorldOrigin"].Locations:GetChildren()) do
            if v.Name == 'Island '..vId and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.Position).Magnitude <= 4500 then 
                ChildSet = v 
                Nears = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.Position).Magnitude 
            end 
        end 
        return ChildSet
    end 
    if _G.NextRaidIslandId then
        return GetI(_G.NextRaidIslandId)
    end 
    local nextg
    for i = 5,1,-1 do   
        nextg = GetI(i)          
        if nextg then
            return nextg 
        end 
    end
end 
function CheckIsRaiding() 
    return _G.ServerData['Nearest Raid Island'] and _G.ServerData['Nearest Raid Island'].Parent
end
local lplr = game.Players.LocalPlayer
function FlyBoat(e,b,h)
    if not b then return end 
    if not h then h = 200 end 
    local fakevh = b.Engine
    local vh = b:FindFirstChildOfClass('VehicleSeat')
    if e then 
        vh.Name = 'L'
        local bodyV = vh:WaitForChild('BodyVelocity',.1)
        if bodyV then 
            bodyV.Parent = fakevh 
        end
        local bodyP = vh:WaitForChild('BodyPosition')
        bodyP.Position = Vector3.new(0,h,0)
        vh:GetPropertyChangedSignal('Position'):Connect(function()
            bodyP.Position = Vector3.new(0,h,0)
        end)
    else 
        local bodyV = fakevh:WaitForChild('BodyVelocity',.1)
        if bodyV then 
            bodyV.Parent = vh 
        end
        vh.Name = 'VehicleSeat'
        local bodyP = vh:WaitForChild('BodyPosition')
        bodyP.Position = Vector3.new(0,b.WaterOrigin.Value ,0)
    end
end

function EquipWeaponName(fff)
    if not fff then
        return
    end
    NoClip = true
    local ToolSe = fff
    if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
        local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
        wait(.4)
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
    end
end
function IsWpSKillLoaded(ki)
    if game:GetService("Players")["LocalPlayer"].PlayerGui.Main.Skills:FindFirstChild(ki) then
        return true
    end
end
function EquipAllWeapon()
    local u3 = {
        "Melee",
        "Blox Fruit",
        "Sword",
        "Gun"
    }
    local u3_2 = {}
    for i, v in pairs(u3) do
        u3_3 = GetWeapon(v)
        if u3_3 and u3_3 ~= "" then table.insert(u3_2, u3_3) end
    end
    for i, v in pairs(u3_2) do
        if not IsWpSKillLoaded(v) then
            EquipWeaponName(v)
        end
    end
end
wait()
local GuideModule = require(game:GetService("ReplicatedStorage").GuideModule)
local Quest = require(game:GetService("ReplicatedStorage").Quests) 
local v17 = require(game.ReplicatedStorage:WaitForChild("GuideModule"))
local CFrameByLevelQuest = {} 
local UselessQuest = {
    "BartiloQuest",
    "Trainees",
    "MarineQuest",
    "CitizenQuest"
}
for i,v in pairs(GuideModule["Data"].NPCList) do
	for i1,v1 in pairs(v["Levels"]) do
		CFrameByLevelQuest[v1] = i.CFrame
        if v1 == 0 then 
            CFrameByLevelQuest[v1] = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, -0, -0.341998369, 0, 1, -0, 0.341998369, 0, 0.939700544)
        end 
	end
end
function IsHavingQuest()
    for i, v in next, v17.Data do
        if i == "QuestData" then
            return true
        end
    end
    return false
end 
function CheckCurrentQuestMob()
    local a
    if IsHavingQuest() then
        for i, v in next, v17.Data.QuestData.Task do
            a = i
        end
    end
    return a
end
function CheckQuestByLevel(cq)
    local cq = cq or {} 
    local lvlPl = cq.Level or game.Players.LocalPlayer.Data.Level.Value 
    local LevelMaxReq = 99999
    local DoubleQuest = cq.DoubleQuest or false 
    local Returner = {
        ["LevelReq"] = 0,
        ["Mob"] = "",
        ["QuestName"] = "",
        ["QuestId"] = 0,
    }
    if game.PlaceId == 2753915549 then 
        LevelMaxReq = 699
    elseif game.PlaceId ==4442272183 then 
        LevelMaxReq = 1475
    end
    for i, v in pairs(Quest) do
        for i1, v1 in pairs(v) do
            local lvlreq = v1.LevelReq
            for i2, v2 in pairs(v1.Task) do
                if
                    lvlPl >= lvlreq and lvlreq >= Returner["LevelReq"] and lvlreq <= LevelMaxReq and v1.Task[i2] > 1 and
                        not table.find(UselessQuest, tostring(i))
                then
                    Returner["LevelReq"] = lvlreq 
                    Returner["Mob"] = tostring(i2) 
                    Returner["QuestName"] = i 
                    Returner["QuestId"] = i1
                end
            end
        end
    end
    if DoubleQuest and IsHavingQuest() then 
        local CurrentMob = Returner["Mob"]
        if
        lvlPl >= 10 and IsHavingQuest() and
            CheckCurrentQuestMob() == Returner["Mob"]
        then
            for i, v in pairs(Quest) do
                for i1, v1 in pairs(v) do
                    for i2, v2 in pairs(v1.Task) do
                        if tostring(i2) == tostring(CurrentMob) then
                            for quest1, quest2 in next, v do
                                for quest3, quest4 in next, quest2.Task do
                                    if tostring(quest3) ~= tostring(CurrentMob) and quest4 > 1 then
                                        if quest2.LevelReq <= lvlPl then
                                            Returner["Mob"]  = tostring(quest3)
                                            Returner["QuestName"]  = i
                                            Returner["QuestId"] = quest1 
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    Returner["QuestCFrame"] = CFrameByLevelQuest[Returner["LevelReq"]]
    return Returner
end
local function TweenKillInstant(POS) 
    local tweenfunc = {}
    local tween_s = game:service "TweenService"
    local info =
        TweenInfo.new(
        GetDistance(POS) /
            300,
        Enum.EasingStyle.Linear
    )
    if GetDistance(POS) < 200 then 
        if _G.tween then 
            _G.tween:Cancel()
            _G.tween = nil 
        end
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = POS 
    else 
        _G.tween =
            tween_s:Create(
            game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
            info,
            {CFrame = POS}
        )
        _G.tween:Play() 
    end
end
function GetQuest(QuestTables) 
    if game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then
        return
    end 
    SetContent('Getting quest...')
    if not QuestTables or not QuestTables["Mob"] or not QuestTables["QuestName"] or not QuestTables["LevelReq"] or not QuestTables["QuestId"] or not QuestTables["QuestCFrame"] then 
        QuestTables = CheckQuestByLevel()
    end
    if QuestTables.QuestCFrame and GetDistance(QuestTables.QuestCFrame) <= 8 then  
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", tostring(QuestTables["QuestName"]), QuestTables["QuestId"])
        task.wait(.75)
    else
        if GetDistance(QuestTables["QuestCFrame"] * CFrame.new(0,0,-2)) < 1000 then 
            TweenKillInstant(QuestTables["QuestCFrame"] * CFrame.new(0,0,-2))
        else 
            Tweento(QuestTables["QuestCFrame"] * CFrame.new(0,0,-2))
        end
        task.wait(1) 
        GetQuest(QuestTables)
    end
end    
local AllNPCS = getnilinstances()
for i, v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
    table.insert(AllNPCS, v)
end
function GetNPC(npc)
    for i, v in pairs(AllNPCS) do
        if v.Name == npc then
            return v
        end
    end
end  
local function FireAddPoint(PointName,num) 
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint",PointName,num)
end
function autoStats() 
    if IsPlayerAlive() and game:GetService("Players").LocalPlayer.Data.Points.Value > 0 then
        local MaxLevel = 2550 
        local Stats_Melee = game:GetService("Players").LocalPlayer.Data.Stats.Melee.Level.Value  
        local Stats_Def = game:GetService("Players").LocalPlayer.Data.Stats['Defense'].Level.Value
        local Stats_DF = game:GetService("Players").LocalPlayer.Data.Stats["Demon Fruit"].Level.Value 
        local Stats_Gun = game:GetService("Players").LocalPlayer.Data.Stats.Gun.Level.Value 
        local Stats_Sword = game:GetService("Players").LocalPlayer.Data.Stats.Sword.Level.Value   
        if Stats_Melee < MaxLevel then 
            FireAddPoint('Melee',MaxLevel-Stats_Melee)
            autoStats()
        elseif Stats_Def < 2550 then 
            FireAddPoint('Defense',MaxLevel-Stats_Def)
            autoStats()
        else 
            FireAddPoint('Sword',MaxLevel-Stats_Sword)
            autoStats()
        end
    end
end
function PushData(tab,newdata)
    for i = 1, #tab - 1 do
        tab[i] = tab[i + 1]  -- Gán giá trị ở vị trí i + 1 vào vị trí i
    end

    tab[#tab] = newdata -- Xóa phần tử cuối cùng (hoặc gán giá trị mới nếu cần)
    return tab
end
function FarmMobByLevel(level)
    if not level then  
        level = game.Players.LocalPlayer.Data.Level.Value 
    end 
    if Sea1 and level >= 700 then  
        level = 650 
        if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Dressrosa") == 0 then 
            TeleportWorld(2)
        end
    elseif Sea2 and level >= 1500 then  
        level = 1450
        if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Zou") == 0 then 
            TeleportWorld(3)
        end
         
    end
    if _G.KillAuraConnection then 
        _G.KillAuraConnection:Disconnect()
        _G.KillAuraConnection = nil 
    end
    local CurrentQuestMob = CheckCurrentQuestMob()
    if level <= game.Players.LocalPlayer.Data.Level.Value and not game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then 
        local NewQuest = CheckQuestByLevel({
            Level = level,
            DoubleQuest = true 
        }) 
        GetQuest(NewQuest)
    elseif CheckMob(CurrentQuestMob) then 
        KillNigga(CheckMob(CurrentQuestMob))
    elseif _G.MobSpawnClone and _G.MobSpawnClone[CurrentQuestMob] then 
        SetContent('Waiting mob... | '..tostring(CurrentQuestMob))
        Tweento(_G.MobSpawnClone[CurrentQuestMob] * CFrame.new(0,60,0))
        for i,v in pairs(game.workspace.MobSpawns:GetChildren()) do 
            if v.Name == CurrentQuestMob and GetDistance(v,_G.MobSpawnClone[CurrentQuestMob]) > 350 and not CheckMob(CurrentQuestMob) then  
                Tweento(v.CFrame* CFrame.new(0,30,0))
            end
        end
    end
end
task.spawn(function()
    getgenv().FruitsID = loadstring(game:HttpGet("https://raw.githubusercontent.com/memaybeohub/NewPage/main/Magnetism.lua"))()
end)
function ReturnFruitNameWithId(v) 
    if not v then return end 
    local SH = v:WaitForChild("Fruit",15):WaitForChild("Fruit",1)
    if not SH then 
        SH = v:WaitForChild("Fruit",15):WaitForChild("Retopo_Cube.001",1) 
    end
    for i,v in pairs(FruitsID) do 
        if v == SH.MeshId then 
            return i 
        end
    end   
    return v.Name
end
local function mmb(v)  
    local OC = tostring(v):split('-')
    if #OC >= 3 then 
        local OC2 = {} 
        for i,v in pairs(OC) do 
            table.insert(OC2,v)
            if #OC2 >= #OC/2 then break end 
        end
        return unpack(OC2)
    else
        return OC[1]
    end
end
function ReturnToShowFruit(v)
    local OC = ReturnFruitNameWithId(v):split('-')
    if #OC >= 3 then 
        local OC2 = {} 
        for i,v in pairs(OC) do 
            table.insert(OC2,v)
            if #OC2 >= #OC/2 then break end 
        end
        return unpack(OC2)
    else
        return OC[1]
    end
end
function CheckNatural(v)
    return v and not v:GetAttribute("OriginalName")
end
function getPriceFruit(z5)
    for i,v in pairs(game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
        "GetFruits",
        game:GetService("Players").LocalPlayer.PlayerGui.Main.FruitShop:GetAttribute("Shop2")
    )) do 
        if v.Name == z5 then 
            return v.Price 
        end
    end
    return 0 
end
function getRealFruit(v)
    local kf = CheckNatural(v) and " (Spawned)" or ""
    return ReturnFruitNameWithId(v) .. " ("..tostring(getPriceFruit(ReturnFruitNameWithId(v))).."$) ".. tostring(kf)
end 
function SendKey(key, holdtime,mmb)
    if key and (not mmb or (mmb)) then
        if not holdtime then
            game:service("VirtualInputManager"):SendKeyEvent(true, key, false, game)
            task.wait()
            game:service("VirtualInputManager"):SendKeyEvent(false, key, false, game)
        elseif holdtime then
            game:service("VirtualInputManager"):SendKeyEvent(true, key, false, game)
            task.wait(holdtime)
            game:service("VirtualInputManager"):SendKeyEvent(false, key, false, game)
        end
    end
end
function collectAllFruit_Store()
    if _G.ServerData['Workspace Fruits'] then 
        for i,v in pairs(_G.ServerData['Workspace Fruits']) do 
            if v and not _G.ServerData['Inventory Items'][ReturnFruitNameWithId(v)] then 
                SetContent('Picking up '..getRealFruit(v))
                Tweento(v.Handle.CFrame)
                task.wait(.1) 
                task.delay(3,function()
                    if _G.CurrentTask == 'Collect Fruit' then 
                        _G.CurrentTask = ''
                    end
                end)
            elseif _G.ServerData['Inventory Items'][ReturnFruitNameWithId(v)] then 
                _G.ServerData['Workspace Fruits'][i] = nil
            end
        end
    end
end 
_G.CurrentElite = false
function LoadBoss(v)  
    local CastleCFrame = CFrame.new(-5543.5327148438, 313.80062866211, -2964.2585449219)
    local Root = v.PrimaryPart or v:WaitForChild('HumanoidRootPart',3)
    local Hum = v:WaitForChild('Humanoid',3)
    task.spawn(function()
        local IsElite = table.find(Elites,RemoveLevelTitle(v.Name))
        if Hum and Root and v:FindFirstChildOfClass('Humanoid') and v.Humanoid.Health > 0 and (v.Humanoid.DisplayName:find('Boss') or RemoveLevelTitle(v.Name) == 'Core' or IsElite) and not _G.ServerData['Server Bosses'][v.Name] then 
            if not IsElite then 
                SetContent('Loaded boss '..tostring(v.Name))
                _G.ServerData['Server Bosses'][v.Name] = v  
            end
        else
            return
        end 
    end)
    task.spawn(function()
        AddNoknockback(v)
        if Sea3 and Hum and Root and v:FindFirstChildOfClass('Humanoid') and v:FindFirstChildOfClass('Humanoid').Health > 0 and GetDistance(v.PrimaryPart,CastleCFrame) <= 1500 and (RemoveLevelTitle(v.Name) ~='rip_indra True Form' and not v.Name:find('Friend')) then  
            _G.PirateRaidTick = tick() 
        end
    end)
    task.spawn(function()
        if RemoveLevelTitle(v.Name) == 'rip_indra True Form' then 
            getgenv().TushitaQuest = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress");
            repeat task.wait() until _G.ServerData['PlayerData'] and _G.ServerData['PlayerData'].Level
            if TushitaQuest and not TushitaQuest.OpenedDoor then 
                repeat 
                    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game:GetService("Workspace").Map.Waterfall.SecretRoom.Room.Door.Door.Hitbox.CFrame
                    task.wait()
                until game.Players.LocalPlayer.Backpack:FindFirstChild('Holy Torch') or not v or not v.Parent or not v.Humanoid or v.Humanoid.Health <= 0
                game.Players.LocalPlayer.Character.PrimaryPart.Anchored= false
                task.spawn(function()
                    for i,v in game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress").Torches do 
                        if not v then 
                            task.spawn(function()
                                game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress", "Torch", i)
                            end)
                        end
                    end
                end)
            end
            if _G.ServerData['PlayerData'].Level >= 2000 and not _G.ServerData["Inventory Items"]["Tushita"] then 
                _G.CurrentTask = 'Getting Tushita'
            end
        end
    end)
    if table.find(Elites,RemoveLevelTitle(v.Name)) then 
        print("Found elite:",tostring(v.Name))
        _G.CurrentElite = v 
    end 
    v.Humanoid:GetPropertyChangedSignal('Health'):Connect(function()
        if v.Humanoid.Health <= 0 then  
            if table.find(Elites,RemoveLevelTitle(v.Name)) then 
                _G.CurrentElite = nil
            end
            local index = _G.ServerData['Server Bosses'][v.Name]
            if index then
                _G.ServerData['Server Bosses'][v.Name] = nil
            end            
            return
        end
    end)
end  
function TeleportWorld(world)
    if typeof(world) == "string" then
        world = world:gsub(" ", ""):gsub("Sea", "")
        world = tonumber(world)
    end
    if world == 1 then
        local args = {
            [1] = "TravelMain"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    elseif world == 2 then
        local args = {
            [1] = "TravelDressrosa"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    elseif world == 3 then
        local args = {
            [1] = "TravelZou"
        }
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end
end
_G.ServerData["Inventory Items"] = {}
_G.ServerData['Skill Loaded'] = {}
_G.ServerData['Workspace Fruits'] = {}
_G.ServerData['Server Bosses'] = {}
_G.ServerData["PlayerBackpack"] = {}
for i,v in pairs(game.workspace.Enemies:GetChildren()) do 
    task.spawn(LoadBoss,v)
end
for i,v in pairs(game.ReplicatedStorage:GetChildren()) do 
    task.spawn(LoadBoss,v)
end 
function CheckRaceVer()
    local v113 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
    local v111 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")
    if game.Players.LocalPlayer.Character:FindFirstChild("RaceTransformed") then
        return "V4"
    end
    if v113 == -2 then
        return "V3"
    end
    if v111 == -2 then
        return "V2"
    end
    return "V1"
end 
workspace.Enemies.ChildAdded:Connect(LoadBoss)
game.ReplicatedStorage.ChildAdded:Connect(LoadBoss) 
local FreeFallTime = {}
getgenv().Exploiters = {}
function checkExploiting(playerInstance)
    if not playerInstance or playerInstance.Name == game.Players.LocalPlayer.Character.Name then return end 
    local humanoid = playerInstance.Character and playerInstance.Character:WaitForChild("Humanoid")
    if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall then            
        if not FreeFallTime[playerInstance.Name] then 
            FreeFallTime[playerInstance.Name] = tick()
            repeat
                task.wait()
            until humanoid:GetState() ~= Enum.HumanoidStateType.Freefall or tick()-FreeFallTime[playerInstance.Name] >= 20 
            if tick()-FreeFallTime[playerInstance.Name] >= 20 then 
                Exploiters[playerInstance.Name] = true 
            end
        end 
    elseif FreeFallTime[playerInstance.Name] then 
        if tick()-FreeFallTime[playerInstance.Name] > 20 then 
            Exploiters[playerInstance.Name] = true 
        end
    end
    if humanoid then 
        humanoid.StateChanged:Connect(function(_oldState, newState)
            if humanoid:GetState() == Enum.HumanoidStateType.Freefall then            
                if not FreeFallTime[playerInstance.Name] then 
                    FreeFallTime[playerInstance.Name] = tick()
                end 
            elseif FreeFallTime[playerInstance.Name] then 
                if tick()-FreeFallTime[playerInstance.Name] > 20 then 
                    Exploiters[playerInstance.Name] = true 
                    FreeFallTime[playerInstance.Name] = nil
                else
                    FreeFallTime[playerInstance.Name] = tick()
                end
            end
        end)  
    end  
end
for i,v in game.Players:GetChildren() do 
    task.spawn(checkExploiting,v)
end
game.Players.ChildAdded:Connect(checkExploiting)
local Melee_and_Price = {
    ["Black Leg"] = {Beli = 150000, Fragment = 0},
    ["Fishman Karate"] = {Beli = 750000, Fragment = 0},
    ["Electro"] = {Beli = 500000, Fragment = 0},
    ["Dragon Claw"] = {Beli = 0, Fragment = 1500},
    ["Superhuman"] = {Beli = 3000000, Fragment = 0},
    ["Sharkman Karate"] = {Beli = 2500000, Fragment = 5000},
    ["Death Step"] = {Beli = 2500000, Fragment = 5000},
    ["Dragon Talon"] = {Beli = 3000000, Fragment = 5000},
    ["Godhuman"] = {Beli = 5000000, Fragment = 5000},
    ["Electric Claw"] = {Beli = 3000000, Fragment = 5000},
    ["Sanguine Art"] = {Beli = 5000000, Fragment = 5000},
}
local Melee_and_RemoteBuy = {
    ["Black Leg"] = "BuyBlackLeg",
    ["Fishman Karate"] = "BuyFishmanKarate",
    ["Electro"] = "BuyElectro",
    ["Dragon Claw"] = function()
        local OwnDragonClaw = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1") == 1
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
        return OwnDragonClaw
    end,
    ["Superhuman"] = "BuySuperhuman",
    ["Sharkman Karate"] = "BuySharkmanKarate",
    ["Death Step"] = "BuyDeathStep",
    ["Dragon Talon"] = "BuyDragonTalon",
    ["Godhuman"] = "BuyGodhuman",
    ["Electric Claw"] = "BuyElectricClaw",
    ["Sanguine Art"] = "BuySanguineArt"
} 
local Melee_in_game = {}
for i,v in pairs(Melee_and_RemoteBuy) do 
    table.insert(Melee_in_game,i)
end
table.sort(Melee_in_game)
function BuyMelee(MeleeN)
    if IsPlayerAlive() and not KillingMob then 
        if _G.ServerData["PlayerBackpack"][MeleeN] then 
            task.spawn(function()
                _G.Config["Melee Level Values"][MeleeN] = _G.ServerData["PlayerBackpack"][MeleeN].Level.Value 
            end) 
            return
        end
        local RemoteArg = Melee_and_RemoteBuy[MeleeN]
        if type(RemoteArg) == "string" then
            local Loser = game.ReplicatedStorage.Remotes.CommF_:InvokeServer(RemoteArg, true) 
            local BeliPassed = _G.ServerData['PlayerData'].Beli >= Melee_and_Price[MeleeN].Beli 
            local FragmentPassed = _G.ServerData['PlayerData'].Fragments >= Melee_and_Price[MeleeN].Fragment   
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer(RemoteArg) 
            --if Loser then
                --[[

                and (Loser ~= 3 and (Loser ~= 0 or (Loser == 0 and FragmentPassed and BeliPassed ))) 
and (MeleeN == 'Godhuman' or (MeleeN == 'Godhuman' and CheckMaterialCount('Fish Tail') >= 20 and CheckMaterialCount('Magma Ore') >= 20 and CheckMaterialCount('Mystic Droplet') >= 10 and  CheckMaterialCount('Dragon Scale') >= 10)) then  
                ]]

            --end
        else
            pcall(
                function()
                    game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
                    RemoteArg()
                end
            )
        end 
    end
end
function getMeleeLevelValues()
    SetContent('Checking all melee')
    task.spawn(function()
        if not _G.Config then repeat task.wait() until _G.Config end
        repeat 
            if identifyexecutor() == 'Wave' or not _G.Config["Melee Level Values"] then _G.Config["Melee Level Values"] = {} end
            task.wait()
        until _G.Config["Melee Level Values"]
        for i,v in pairs(Melee_and_RemoteBuy) do 
            if not _G.Config["Melee Level Values"][i] then 
                _G.Config["Melee Level Values"][i] = 0 
            end
            if _G.Config["Melee Level Values"][i] == 0 then 
                BuyMelee(i)
            end
            if _G.ServerData["PlayerBackpack"][i] then 
                _G.Config["Melee Level Values"][i] = _G.ServerData["PlayerBackpack"][i].Level.Value 
            end 
        end
    end) 
end 
function getFruitBelow1M()
    local minValue = 1000000
    local fruitName 
    for i,v in pairs(_G.ServerData["Inventory Items"]) do 
        if v.Value and v.Value < minValue then 
            fruitName = v.Name 
            minValue = v.Value  
        end 
    end
    return fruitName 
end
getMeleeLevelValues() 
_G.CheckAllMelee = true
function ReloadFrutis()    
    SetContent('Checking Server Fruits...')
    task.spawn(function()
        for i,v in pairs(game.workspace:GetChildren()) do 
            if v.Name:find('Fruit') and not table.find(_G.ServerData['Workspace Fruits'],v) then 
                pcall(function()
                    local vN = ReturnFruitNameWithId(v)
                    if not _G.ServerData['Inventory Items'][vN] then
                        print(vN,'new fruit')
                        table.insert(_G.ServerData['Workspace Fruits'],v)  
                        local selfs 
                        selfs = v:GetPropertyChangedSignal('Parent'):Connect(function()
                            if v.Parent ~= game.workspace then 
                                _G.ServerData['Workspace Fruits'] = {}
                                selfs:Disconnect()
                                ReloadFrutis()
                            end
                        end)
                    else
                        print("Skipped "..tostring(vN).." because already stored.")
                    end
                end)
            end 
        end
    end)
end  
function CheckAnyPlayersInCFrame(CFrameCheck, MinDistance)
    local CurrentFound
    for i, v in pairs(game.Players:GetChildren()) do
        pcall(
            function()
                if
                    v.Name ~= game.Players.LocalPlayer.Name and
                        GetDistance(v.Character.HumanoidRootPart, CFrameCheck) < MinDistance
                 then
                    CurrentFound = GetDistance(v.Character.HumanoidRootPart, gggggggggggggg)
                end
            end
        )
    end
    return CurrentFound
end 
ReloadFrutis() 
game:GetService("Workspace")["_WorldOrigin"].Locations.ChildAdded:Connect(function(v)
    local AddedTick = tick() 
    if not _G.ServerData then _G.ServerData = {} end
    if v.Name == 'Island 1' then 
        repeat 
            task.wait()
        until tick()-AddedTick > 60 or (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.Position).Magnitude <= 1000 
        if tick()-AddedTick > 60 then 
            return  
        end
    end 
    if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position-v.Position).Magnitude <= 4500 then  
        if v.Name:find('Island') then 
            v:GetPropertyChangedSignal('Parent'):Connect(function()
                if not v.Parent or v.Parent ~= game:GetService("Workspace")["_WorldOrigin"].Locations then  
                    if _G.CurrentTask == 'Auto Raid' and _G.ServerData['Nearest Raid Island'] then 
                        repeat task.wait(1) until not game.Players.LocalPlayer.PlayerGui.Main.Timer.Visible
                        _G.CurrentTask = '' 
                        print('Clearing',_G.ServerData['Nearest Raid Island'])   
                        if not _G.ServerData['Nearest Raid Island'] then 
                            _G.CurrentTask = ''
                        end
                        if _G.DimensionLoading then 
                            _G.DimensionLoading = false 
                        end
                        _G.NextRaidIslandId = 1 
                        _G.ServerData['Nearest Raid Island'] = nil
                        _G.tween:Cancel()   
                        if _G.KillAuraConnection then 
                            _G.KillAuraConnection:Disconnect()
                            _G.KillAuraConnection = nil 
                        end
                        local v302 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Awakener", "Check")
                        if not v302 or v302 == 0 or v302 == 1 then
                            wait()
                        else
                            if v302.Cost <= _G.ServerData['PlayerData'].Fragments and _G.Config.OwnedItems["Soul Guitar"] then
                                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Awakener", "Awaken")
                            end
                        end
                        
                    end
                end
            end)  
        end 
        _G.ServerData['Nearest Raid Island'] = getNearestRaidIsland()
    end
end)  
function CheckX2Exp()
    local a2, b2 =
        pcall(
        function()
            if _G.ServerData['PlayerData'].Level < 2450 then
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
function PickChest(Chest)
    if not _G.ChestCollect or typeof(_G.ChestCollect) ~= 'number' then 
        _G.ChestCollect = 0 
    end
    if not Chest then 
        return 
    elseif not _G.ChestConnection then 
        SetContent('Picking up chest | '..tostring(_G.ChestCollect))
        _G.ChestConnection = Chest:GetPropertyChangedSignal('Parent'):Connect(function()
            _G.ChestCollect +=1 
            _G.ChestConnection:Disconnect()
            _G.ChestConnection = nil
            SortChest()
        end) 
        local StartPick = tick()
        local TouchTrans 
        local OldChestCollect = _G.ChestCollect
        repeat 
            local PickChest1,PickChest2 = pcall(function()
                Tweento(Chest.CFrame)
                if GetDistance(Chest) <= 10 then
                    task.spawn(function()
                        firetouchinterest(Chest, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
                        firetouchinterest(Chest, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
                    end)
                    --firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, TouchTrans, 0)
                    --firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, TouchTrans, 1)
                end
            end)
        until not Chest or not Chest.Parent or tick()-StartPick >= 60 
        if Chest and Chest.Parent then 
            Chest:Destroy() 
        elseif _G.ChestCollect == OldChestCollect then 
            _G.ChestCollect+=1
        end
    end
end
local RealRaid = {}
task.spawn(function()
    local Raids = require(game:GetService("ReplicatedStorage").Raids).raids
    local AdvancedRaids = require(game:GetService("ReplicatedStorage").Raids).advancedRaids
    for i, v in pairs(Raids) do 
        if v ~= " " and v ~= "" then 
            table.insert(RealRaid, v) 
        end
    end
    for i, v in pairs(AdvancedRaids) do
        if v ~= " " and v ~= "" then 
            table.insert(RealRaid, v) 
        end
    end 
end)
function CheckMaterialCount(MM) 
    local Count = 0 
    if _G.ServerData['Inventory Items'][MM] and _G.ServerData['Inventory Items'][MM].Count then 
        Count = _G.ServerData['Inventory Items'][MM].Count 
    end 
    return Count
end
_G.SuccessBoughtTick = 0
_G.LastBuyChipTick = 0
function buyRaidingChip() 
    if _G.EnLoaded and (Sea2 or Sea3) and tick()-JoinedGame > 60 and tick()-_G.SuccessBoughtTick > 60 and _G.ServerData['PlayerData'].Level >= 1100 and not _G.ServerData["PlayerBackpack"]['Special Microchip'] and not CheckIsRaiding() then 
        if (((_G.CurrentTask == '' or _G.MeleeTask == 'None') and _G.CurrentTask ~= 'Auto Sea 3') or _G.FragmentNeeded) and not checkFruit1M() and (_G.FragmentNeeded or (not CheckX2Exp() and ((_G.ServerData['PlayerData'].Fragments < 7500 or (_G.ServerData['PlayerData'].Level >= 2550 and _G.ServerData['PlayerData'].Fragments < 25000)) or #_G.ServerData["PlayerBackpackFruits"] > 0))) then 
            wait(1)
            local SelRaid = "Flame"
            if table.find(RealRaid,mmb(_G.ServerData['PlayerData'].DevilFruit)) then  
                SelRaid = mmb(_G.ServerData['PlayerData'].DevilFruit)
            end
            local bought = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc","Select",SelRaid) == 1 
            if bought then 
                _G.SuccessBoughtTick = tick() 
            else
                local below1MFruit = getFruitBelow1M()
                if below1MFruit then 
                    SetContent('Getting '..tostring(below1MFruit)..' from inventory to buy chips...')
                    if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadFruit", below1MFruit) then 
                        buyRaidingChip() 
                        _G.ServerData['Inventory Items'][below1MFruit] = nil 
                    else 
                        SetContent('Removing...')
                        if _G.ServerData['Inventory Items'][below1MFruit] then 
                            _G.ServerData['Inventory Items'][below1MFruit] = nil 
                        end
                    end
                end
            end 
        end
    end 
    _G.LastBuyChipTick = tick()
end 
_G.ServerData['Chest'] = {}
_G.ChestsConnection = {}
function SortChest()
    local LOROOT = game.Players.LocalPlayer.Character.PrimaryPart or game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart')
    if LOROOT then
        table.sort(_G.ServerData['Chest'], function(chestA, chestB)  
            local distanceA
            local distanceB
            if chestA:IsA('Model') then 
                distanceA = (Vector3.new(chestA:GetModelCFrame()) - LOROOT.Position).Magnitude
            end 
            if chestB:IsA('Model') then 
                distanceB = (Vector3.new(chestB:GetModelCFrame()) - LOROOT.Position).Magnitude 
            end
            if not distanceA then  distanceA = (chestA.Position - LOROOT.Position).Magnitude end
            if not distanceB then  distanceB = (chestB.Position - LOROOT.Position).Magnitude end
            return distanceA < distanceB -- Sắp xếp giảm dần
        end)
    end
end
function AddChest(chest)
    wait()
    if table.find(_G.ServerData['Chest'], chest) or not chest.Parent then return end 
    if not string.find(chest.Name,'Chest') and not (chest:IsA('Part') or chest:IsA('BasePart')) then return end
    local CallSuccess,Returned = pcall(function()
        return GetDistance(chest)
    end)
    if not CallSuccess or not Returned then return end
    table.insert(_G.ServerData['Chest'], chest)  
    local parentChangedConnection
    parentChangedConnection = chest:GetPropertyChangedSignal('Parent'):Connect(function()
        local index = table.find(_G.ServerData['Chest'], chest)
        table.remove(_G.ServerData['Chest'], index)
        parentChangedConnection:Disconnect()
        SortChest()
    end)
end

function LoadChest()
    for _, v in pairs(workspace:GetDescendants()) do
        if string.find(v.Name, 'Chest') and v.Parent then
            task.spawn(function()
                AddChest(v)
                local parentFullName = tostring(v.Parent:GetFullName())
                if not _G.ChestsConnection[parentFullName] then
                    _G.ChestsConnection[parentFullName] = v.Parent.ChildAdded:Connect(AddChest)
                end
            end)
        end
    end 
    task.delay(3,function()
        print('Loaded total',#_G.ServerData['Chest'],'chests')
        SortChest()
    end)
end

task.spawn(LoadChest) 
function getNearestChest()
    for i,v in pairs(_G.ServerData['Chest']) do
        return v 
    end
end 
function advancedSkills(v2) 
    if v2:IsA("Frame") then 
        if v2.Name ~= 'Template' then 
            v2.Cooldown:GetPropertyChangedSignal('Size'):Connect(function()
                if v2.Name ~= "Template" and v2.Title.TextColor3 == Color3.new(1, 1, 1) and (v2.Cooldown.Size == UDim2.new(0, 0, 1, -1) or v2.Cooldown.Size == UDim2.new(1, 0, 1, -1))then
                    _G.ServerData['Skill Loaded'][v2.Parent.Name][v2.Name] = true  
                elseif v2.Name ~= 'Template' then 
                    _G.ServerData['Skill Loaded'][v2.Parent.Name][v2.Name] = false  
                end 
            end) 
        end
        if v2.Name ~= "Template" and v2.Title.TextColor3 == Color3.new(1, 1, 1) and (v2.Cooldown.Size == UDim2.new(0, 0, 1, -1) or v2.Cooldown.Size == UDim2.new(1, 0, 1, -1))
         then
            _G.ServerData['Skill Loaded'][v2.Parent.Name][v2.Name] = true 
        end 
    end
end
function addSkills(v) 
    if not table.find({'Title','Container','Level','StarContainer','Rage'},v.Name) then 
        if not _G.ServerData['Skill Loaded'][v.Name] then 
            _G.ServerData['Skill Loaded'][v.Name] = {}
        end 
        v.ChildAdded:Connect(advancedSkills)
    end
end
function loadSkills()
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills:GetChildren()) do 
        addSkills(v)
    end
    game:GetService("Players").LocalPlayer.PlayerGui.Main.Skills.ChildAdded:Connect(addSkills) 
end    
function CheckTorchDimension(DimensionName) 
    DimensionName = DimensionName == "Yama" and "HellDimension" or "HeavenlyDimension" 
    if game.workspace.Map:FindFirstChild(DimensionName) then 
        v3 = game.workspace.Map:FindFirstChild(DimensionName):GetChildren()
        for i, v in pairs(v3) do
            if string.find(v.Name, "Torch") then
                if v.ProximityPrompt.Enabled == true then
                    return v
                end
            end
        end
    end
end  
function CheckQuestCDK() 
    if not Sea3 then return end
    local CDK_LevelQuest = {
        Good = 666,
        Evil = 666
    }
    Check,CheckValue = pcall(function()
        for i,v in pairs(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Good")) do 
            CDK_LevelQuest[i] = v 
        end
    end)
    if CDK_LevelQuest.Good == -2 or CDK_LevelQuest.Good == 4 then 
        _G.CDK_Yama = true 
    end   
    task.spawn(function()
        if CDK_LevelQuest.Good ~= -2 and CDK_LevelQuest.Evil ~= -2 then 
            if not _G.CDK_Yama then 
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Good")
            else
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")
            end
        end
    end) 
    if game.Players.LocalPlayer.PlayerGui.Main.Dialogue.Visible then
        game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
        game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
    end
    if CDK_LevelQuest.Good == 4 and CDK_LevelQuest.Evil == 3 then
        return "Pedestal2"
    elseif CDK_LevelQuest.Good == 3 and CDK_LevelQuest.Evil == 4 then
        return "Pedestal1"
    end
    if CDK_LevelQuest.Evil == 4 and CDK_LevelQuest.Good == 4 then
        return "The Final Boss"
    end  
    if CDK_LevelQuest.Good ~= -2 then 
        if GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Heavenly Dimension"]) < 2000 then 
            return "Tushita Dimension"
        end
        if CDK_LevelQuest.Good == -3 or CDK_LevelQuest.Good == -4 then 
            return "Tushita Quest "..tostring(CDK_LevelQuest.Good)
        end 
        if CDK_LevelQuest.Good == -5 then 
            return "Cake Queen"
        end
    else 
        if GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Hell Dimension"]) <= 2000 then 
            return "Yama Dimension"
        end
        if CDK_LevelQuest.Evil == -3 or CDK_LevelQuest.Evil == -4 then 
            return "Yama Quest "..tostring(CDK_LevelQuest.Evil)
        end  
        return "Soul Reaper"
    end
end  
function CheckHazeMob()
    for i, v in pairs(game.workspace.Enemies:GetChildren()) do
        if
            RemoveLevelTitle(v.Name) == NearestHazeMob() and v:IsA("Model") and
                v:FindFirstChild("HumanoidRootPart") and
                v:FindFirstChild("Humanoid") and
                v.Humanoid.Health > 0
         then
            return v
        end
    end
end 
function CheckMobHaki(mb)
    if mb:FindFirstChild("Humanoid") then
        for i, v in pairs(mb:WaitForChild("Humanoid"):GetChildren()) do
            if string.find(v.Name, "Buso") then
                return v
            end
        end
    end
end
function FindMobHasHaki(IncludedStorage)
    for i, v in pairs(game.workspace.Enemies:GetChildren()) do
        if v:FindFirstChildOfClass('Humanoid') and v:FindFirstChildOfClass('Humanoid').Health > 0 and CheckMobHaki(v) then
            return v
        end
    end
    if IncludedStorage then
        if v:FindFirstChildOfClass('Humanoid') and v:FindFirstChildOfClass('Humanoid').Health > 0 and CheckMobHaki(v) then
            if CheckMobHaki(v) then
                return v
            end
        end
    end
end
function NearestHazeMob()
    local AllHazeMobs = {}
    if not game:GetService("Players").LocalPlayer:FindFirstChild('QuestHaze') then 
        return ""
    end
    for i, v in pairs(game:GetService("Players").LocalPlayer.QuestHaze:GetChildren()) do
        if v.Value > 0 then
            table.insert(AllHazeMobs, RemoveLevelTitle(v.Name))
        end
    end
    local MobF = ""
    local maxDis = math.huge
    for i, v in pairs(AllHazeMobs) do
        if MobSpawnClone[v] then
            if GetDistance(MobSpawnClone[v]) < maxDis then
                maxDis = GetDistance(MobSpawnClone[v]) 
                MobF = v 
            end
        end
    end
    return MobF
end
if not _G.ServerData['PlayerData'] then _G.ServerData['PlayerData'] = {} end

_G.ServerData['PlayerData']['Colors'] = {} 
function UnCompleteColor()
    for i, v in next, game:GetService("Workspace").Map["Boat Castle"].Summoner.Circle:GetChildren() do
        if v:IsA("Part") and v:FindFirstChild("Part") and v.Part.BrickColor.Name == "Dark stone grey" then
            return v
        end
    end
end    
function HasColor(BrickColorName) 
    local BricksWithColors = {
        ["Hot pink"] = "Winter Sky",
        ["Really red"] = "Pure Red",
        ["Oyster"] = "Snow White"
    }
    local RealColorName = BricksWithColors[BrickColorName]
    if not _G.ServerData['PlayerData']['Colors'][RealColorName] then
        return false 
    else
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("activateColor", RealColorName) 
        return true
    end
end     
local Item_Bosses = {
    ["Chief Warden1"] = "Wardens Sword",
    ["Swan2"] = "Pink Coat",
    ["Magma Admiral3"] = "Refined Musket",
    ["Fishman Lord4"] = "Trident",
    ["Wysper5"] = "Bazooka",
    ["Thunder God6"] = " Pole (1st Form)",
    ["Cyborg7"] = "Cool Shades",

    ["Diamond8"] = "Longsword",
    ["Jeremy9"] = "Black Spikey Coat",
    ["Fajita10"] = "Gravity Cane",
    --["Don Swan11"] = "Swan Glasses",
    ["Smoke Admiral12"] = "Jitte",
    ["Tide Keeper13"] = "Dragon Trident",
    
    ["Stone14"] = "Pilot Helmet",
    ["Island Empress15"] = "Serpent Bow",
    ["Kilo Admiral17"] = "Lei",
    ["Captain Elephant18"] = "Twin Hooks",
    ["Beautiful Pirate16"] = "Canvander",
    ["Cake Queen19"] = "Buddy Sword",
}
function getNextBossDropParent()
    if not _G.DropIndex then 
        _G.DropIndex =1
    end
    local function findDrop(DropIndex) 
        local currentindex = 0
        for index,drop in Item_Bosses do 
            currentindex = tonumber(index:match('%d+'))
            if currentindex == DropIndex then 
                return drop,index:gsub(currentindex,'')
            end
        end
    end
    local currentDrop,dropParent = findDrop(_G.DropIndex)
    while not currentDrop or _G.ServerData["Inventory Items"][currentDrop] do 
        _G.DropIndex +=1 
        currentDrop,dropParent = findDrop(_G.DropIndex) 
    end
    return currentDrop,dropParent
end
function UpdateBossDropTable()
    if not _G.BossDropTable then _G.BossDropTable = {} end 
    for i,v in (Item_Bosses) do 
        if not _G.ServerData["Inventory Items"][v] then 
            if not table.find(_G.BossDropTable,i:gsub('%d+','')) then 
                table.insert(_G.BossDropTable,tostring(i:gsub('%d+','')))
            end 
        else
            if table.find(_G.BossDropTable,i:gsub('%d+','')) then 
                table.remove(_G.BossDropTable,table.find(_G.BossDropTable,i:gsub('%d+','')))
            end 
        end
    end 
    return _G.BossDropTable
end
local TOIKHONGBIET = 0
local CheckFruitStockTick = 0
local LastCheckTickFruit = 0
_G.ServerData["Fruits Stock"] = {}
local ThisiSW 
ThisiSW = RunService.Heartbeat:Connect(function()
    if game.PlaceId == 2753915549 then
        Sea1 = true
        Sea2 = false
        Sea3 = false 
        MySea = "Sea 1"
    elseif game.PlaceId == 4442272183 then
        Sea2 = true
        Sea1 = false
        Sea3 = false
        MySea = "Sea 2"
    elseif game.PlaceId == 7449423635 then
        Sea3 = true
        Sea1 = false
        Sea2 = false
        MySea = "Sea 3"
    end
    if IsPlayerAlive() then 
        if Sea3 and not _G.ServerData["Inventory Items"]['Cursed Dual Katana'] and _G.ServerData["Inventory Items"]['Tushita'] and _G.ServerData["Inventory Items"]['Yama'] and _G.ServerData["Inventory Items"]['Tushita'].Mastery >= 350 and _G.ServerData["Inventory Items"]['Yama'].Mastery then 
            _G.CDKQuest = CheckQuestCDK()  
        end  
        if game.Players.LocalPlayer.Character:FindFirstChild("RaceEnergy") and game.Players.LocalPlayer.Character.RaceEnergy.Value >= 1 and not game.Players.LocalPlayer.Character.RaceTransformed.Value then 
            SendKey('Y',.5)
        end
        EnableBuso()
        if tick() - _G.LastBuyChipTick > 5 then 
            _G.LastBuyChipTick = tick() buyRaidingChip() 
        end
        if tick()-_G.Ticktp < 0.5 or KillingMob or (_G.tween and _G.tween.PlaybackState and tostring(string.gsub(tostring(_G.tween.PlaybackState), "Enum.PlaybackState.", "")) == 'Playing') or (_G.TweenStats and tostring(string.gsub(tostring(_G.TweenStats), "Enum.PlaybackState.", "")) == 'Playing') then 
            AddBodyVelocity(true)
            for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do 
                if v:IsA("BasePart") or v:IsA("Part") then 
                    v.CanCollide = false 
                end
            end
        else
            AddBodyVelocity(false)
        end 
        if _G.PlayerLastMoveTick and tick()-_G.PlayerLastMoveTick >= 5*60 then 
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)  
        end
        local SetText = ""
        if _G.LocalPlayerStatusParagraph then 
            SetText = "Level: "..tostring(_G.ServerData['PlayerData'].Level)..
                    "\nBeli: "..tostring(_G.ServerData['PlayerData'].Beli)..
                    "\nFragment: "..tostring(_G.ServerData['PlayerData'].Fragments)..
                    "\nRace: "..tostring(_G.ServerData['PlayerData'].Race).." "..tostring(_G.ServerData['PlayerData'].RaceVer)..
                    "\nElite Hunted: "..tostring(_G.ServerData['PlayerData']["Elite Hunted"])..
                    "\nDevil Fruit: "..tostring((_G.ServerData['PlayerData'].DevilFruit ~= '' and _G.ServerData['PlayerData'].DevilFruit or "None"))
            _G.LocalPlayerStatusParagraph:Set({
                Title = "Local Player Status",
                Content = SetText
            })
        end
        if _G.ServerStatusParagraph then
            local MoonPhase = game:GetService("Lighting"):GetAttribute("MoonPhase") 
            SetText = "Moon: "..tostring((MoonPhase == 5 and "Full Moon" or MoonPhase == 4 and "Gibbous Moon" or "Bad moon"))..
                "\nMirage Island: "..tostring(game:GetService("Workspace").Map:FindFirstChild("MysticIsland") and "✅" or "❌")..
                "\nElite Spawned: "..tostring(_G.CurrentElite and "✅" or "❌")
            _G.ServerStatusParagraph:Set({
                Title = 'Server Status',
                Content = SetText
            })
        end
        if _G.ItemOwnedParagraph then 
            SetText = ""
            local ItemsOwned = {}
            for itemName,itemTab in _G.ServerData["Inventory Items"] do 
                if itemTab and (itemTab.Type ~= "Blox Fruit" and itemTab.Type ~= 'Material') then 
                    table.insert(ItemsOwned,itemTab)
                end
            end
            table.sort(ItemsOwned,function(a,b)
                if a.Type == b.Type then 
                    if a.Rarity == b.Rarity then 
                        return a.Name < b.Name
                    else
                        return a.Rarity > b.Rarity
                    end    
                else
                    return a.Type < b.Type 
                end  
            end)
            for i,v in ItemsOwned do 
                SetText = SetText.."\n"..tostring(v.Name)..": ✅"
            end
            _G.ItemOwnedParagraph:Set({
                Title = 'Item Owned',
                Content = SetText
            })
        end
        if KillingMob or tick()-TOIKHONGBIET < 3 then return end   
        TOIKHONGBIET = tick() 
        for i,v in pairs(game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("getInventory")) do 
            if v and typeof(v) == 'table' and v.Name and v.Name ~= '' then 
                _G.ServerData["Inventory Items"][v.Name] = v  
            end
            if _G.Config and v.Type ~= 'Fruit' and not v.Value then 
                if not _G.Config then 
                    _G.Config = {}
                end
                if not _G.Config.OwnedItems then 
                    _G.Config.OwnedItems = {}
                end
                _G.Config.OwnedItems[v.Name] = true 
            end
        end
        _G.Config.OwnedItems.LoadedFr = true
        _G.HavingX2 =CheckX2Exp()
        UpdateBossDropTable()
        _G.NextDrop,_G.NextDropParent = getNextBossDropParent()
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner")
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
        if _G.FruitSniping and _G.SnipeFruit and _G.ServerData['PlayerData'].DevilFruit == '' and tick()-LastCheckTickFruit >= 3 then 
            LastCheckTickFruit = tick()
            if tick()-CheckFruitStockTick >= 15*60 then 
                CheckFruitStockTick = tick()
                _G.ServerData["Fruits Stock"][1] = (function() 
                    local returnTable = {}
                    for i,v in game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GetFruits", false) do 
                        if v.OnSale then 
                            table.insert(returnTable,v.Name)
                        end
                    end
                    return returnTable
                end)() 
                _G.ServerData["Fruits Stock"][2] = (function() 
                    local returnTable = {}
                    for i,v in game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GetFruits", true) do 
                        if v.OnSale then 
                            table.insert(returnTable,v.Name)
                        end
                    end
                    return returnTable
                end)()
            end
            for i,v in pairs(_G.FruitSniping) do 
                if table.find(_G.ServerData["Fruits Stock"][1],v) then 
                    print("Buying: "..tostring(v))
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("PurchaseRawFruit",v, 1==2)
                    break;
                elseif table.find(_G.ServerData["Fruits Stock"][2],v) then 
                    print("Buying: "..tostring(v))
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("PurchaseRawFruit",v, 2==2)
                    break;
                end
            end
            _G.CanEatFruit = checkFruittoEat(_G.FruitSniping,_G.IncludeStored)
        end
        if _G.ServerData["Inventory Items"]['Cursed Dual Katana'] and _G.CDKQuest then 
            _G.CDKQuest = nil 
        end
        if not _G.RaceV4Progress or (_G.RaceV4Progress ~= 4 and _G.RaceV4Progress ~= 5) then 
            _G.RaceV4Progress = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") 
        end
        if _G.ServerData["PlayerData"].Beli >= 5500000 then 
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
            -- Buy Buso Haki
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Buso")
            -- Buy Soru
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki","Soru")  
            -- Buy Ken 
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("KenTalk", "Buy")
        end
        if not _G.ServerData['PlayerData']["Elite Hunted"] or _G.ServerData['PlayerData']["Elite Hunted"] < 30 then 
            _G.ServerData['PlayerData']["Elite Hunted"] = tonumber(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")) or 0 
        end
        _G.ServerData['PlayerData']["RaceVer"] = CheckRaceVer()  
        for i, v in pairs(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("getColors")) do
            if v["Unlocked"] then
                _G.ServerData['PlayerData']['Colors'][v.HiddenName] = v
            end
        end
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy") 
        local v141, v142 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ColorsDealer", "1")
        if v141 and v142 and v142 > 5000 then 
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ColorsDealer", "2")
        end
        if _G.SwitchingServer and ThisiSW then 
            task.delay(3,function()
                if _G.SwitchingServer then 
                    if ThisiSW then 
                        ThisiSW:Disconnect()
                        ThisiSW = nil 
                    end
                end
            end)
        end
    end
end) 
local GC = getconnections or get_signal_cons
if GC then
    game.Players.LocalPlayer.Idled:Connect(
        function()
            for i, v in pairs(GC(game.Players.LocalPlayer.Idled)) do
                v:Disable()
            end
        end
    )
end 
--[[
local getrawgame = getrawmetatable(game)
local oldraw = getrawgame.__namecall
setreadonly(getrawgame,false)
getrawgame.__namecall = newcclosure(function(...)
	local method = getnamecallmethod()
	local args = {...}
	if tostring(method) == "FireServer" then
		if tostring(args[1]) == "RemoteEvent" then
			if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
				if _G.AimbotToggle and _G.AimbotPosition then
					args[2] = _G.AimbotPosition
					return oldraw(unpack(args))
				end
			end
		end
	end
	return oldraw(...)
end)
]]
LoadPlayer()
task.spawn(SetContent,"😇")
print('Loaded Success Full!')
_G.EnLoaded = true   
