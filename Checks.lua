repeat task.wait() until _G.EnLoaded 
_G.CurrentTask = ""  
_G.TaskUpdateTick = tick()  
_G.PirateRaidTick = 0
getgenv().CheckEnabling = function(taskName)
    return _G.SavedConfig and _G.SavedConfig['Actions Allowed'] and (_G.SavedConfig['Actions Allowed'][taskName] or _G.SavedConfig[taskName])
end
getgenv().refreshTask = function() 
    if tick()-_G.TaskUpdateTick >= 60 then 
        _G.CurrentTask = ''
    end
    if not SaberQuest or not SaberQuest.KilledShanks then 
        getgenv().SaberQuest = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ProQuestProgress")
    end
    if not _G.Config then 
        _G.Config = {}
    end
    if not _G.Config.OwnedItems then 
        _G.Config.OwnedItems = {}
    end
    if _G.CurrentTask == '' and _G.Config.OwnedItems.LoadedFr then  
        if _G.ServerData["PlayerBackpack"]['Special Microchip'] or CheckIsRaiding() then 
            _G.CurrentTask = 'Auto Raid'
        elseif _G.ServerData['PlayerData'].DevilFruit == '' and _G.SnipeFruit and _G.FruitSniping and _G.CanEatFruit then 
            _G.CurrentTask = 'Eat Fruit'
        elseif #_G.ServerData['Workspace Fruits'] > 0 then 
            _G.CurrentTask = 'Collect Fruit' 
        elseif Sea3 and _G.CurrentElite and (not _G.Config.OwnedItems["Yama"] and not _G.ServerData['Server Bosses']['rip_indra True Form'])  then 
            _G.CurrentTask = 'Hunting Elite'  
        elseif Sea3 and CheckEnabling('Cursed Dual Katana') and _G.ServerData['PlayerData'].Level >= 2000 and not _G.Config.OwnedItems["Tushita"] and (_G.ServerData['Server Bosses']['rip_indra True Form'] or (getgenv().TushitaQuest and getgenv().TushitaQuest.OpenedDoor)) then 
            _G.CurrentTask = 'Getting Tushita'
        elseif Sea3 and CheckEnabling('Cursed Dual Katana') and not _G.Config.OwnedItems["Yama"] and (_G.ServerData['PlayerData']["Elite Hunted"] >= 30 or _G.ServerData['PlayerData'].Level >= 2200) then 
            _G.CurrentTask = 'Getting Yama' 
        elseif Sea3 and CheckEnabling('Cursed Dual Katana') and _G.CDKQuest and _G.CDKQuest ~= '' then 
            _G.CurrentTask = 'Getting Cursed Dual Katana' 
        elseif Sea3 and CheckEnabling('Mirage Puzzle') and _G.RaceV4Progress and _G.ServerData['PlayerData'].RaceVer == "V3" and _G.Config.OwnedItems['Mirror Fractal'] and _G.Config.OwnedItems['Valkyrie Helm'] and (_G.RaceV4Progress < 4 or (game:GetService("Workspace").Map:FindFirstChild("MysticIsland") and not game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CheckTempleDoor"))) then 
            _G.CurrentTask = 'Unlocking Mirage Puzzle'
        elseif (Sea2 or Sea3) and CheckEnabling('Upgrading Race') and _G.ServerData['PlayerData'].Beli >= 2000000 and _G.ServerData['PlayerData'].Level >= 2550 and not table.find({'Skypiea',"Fishman","Ghoul"},_G.ServerData['PlayerData'].Race) and (_G.ServerData['PlayerData'].RaceVer == 'V2') then 
            _G.CurrentTask = 'Auto Race V3'
        elseif _G.ServerData['PlayerData'].Level > 200 and CheckEnabling('Saber') and not (_G.Config.OwnedItems["Saber"]) and ((SaberQuest and not SaberQuest.UsedRelic) or _G.ServerData['PlayerData'].Level >= 550) then 
            _G.CurrentTask = 'Saber Quest'
        elseif _G.Config and CheckEnabling('Soul Guitar') and _G.Config["Melee Level Values"] and (_G.Config["Melee Level Values"]['Godhuman'] > 0 or _G.ServerData['PlayerData'].Level >= 2400) and _G.ServerData['PlayerData'].Level >= 2300 and not _G.Config.OwnedItems["Soul Guitar"] then 
            _G.CurrentTask = 'Getting Soul Guitar'
        elseif Sea3 and (_G.ServerData['Server Bosses']['Soul Reaper'] or _G.ServerData["PlayerBackpack"]['Hallow Essence']) and (not _G.ServerData["Inventory Items"]["Alucard Fragment"] or _G.ServerData["Inventory Items"]["Alucard Fragment"].Count ~= 5) then 
            _G.CurrentTask = 'Getting Hallow Scythe'
        elseif Sea3 and CheckEnabling('Mirror Fractal') and ((_G.ServerData['PlayerBackpack']["God's Chalice"] or _G.ServerData['PlayerBackpack']["Sweet Chalice"] ) or _G.ServerData['PlayerData'].Level >= 2550) and not _G.Config.OwnedItems["Mirror Fractal"] then
            _G.CurrentTask = 'Auto Dough King'
        elseif _G.ServerData['PlayerData'].Level > 150 
        and CheckEnabling('Pole (1st Form)') and not _G.Config.OwnedItems["Pole (1st Form)"] 
        and (_G.ServerData['Server Bosses']['Thunder God']) then 
            _G.CurrentTask = 'Pole Quest'
        elseif game.PlaceId == 2753915549 and _G.ServerData['PlayerData'].Level >= 700 and game.ReplicatedStorage.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Dressrosa") ~= 0 then 
            _G.CurrentTask = 'Sea 2 Quest'
            print('Sea 1',Sea1)
            print('Sea2',Sea2)
            print('Sea 3',Sea3)
        elseif Sea3 and (_G.CakePrince or (_G.ServerData['Server Bosses']['Cake Prince'] or _G.ServerData['Server Bosses']['Dough King'] ))  then 
            _G.CurrentTask = 'Cake Prince Raid Boss Event'
        elseif (Sea2 or Sea3) and (_G.ServerData['Server Bosses']['Core'] or (Sea3 and _G.PirateRaidTick and tick()-_G.PirateRaidTick < 60)) then 
            _G.CurrentTask = '3rd Sea Event'
        elseif Sea2 and _G.ServerData['PlayerData'].Level >= 850 and game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") ~= 3 then
            _G.CurrentTask = 'Bartilo Quest'
        elseif Sea2 and _G.ServerData['PlayerData'].Level >= 1500 and game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Zou") ~= 0 then 
            _G.CurrentTask = 'Auto Sea 3' 
        elseif (Sea2 or Sea3) and (_G.RaidBossEvent or _G.ServerData['Server Bosses']['Darkbeard'] or _G.ServerData['Server Bosses']['rip_indra True Form']) then 
            _G.CurrentTask = 'Auto Raid Boss' 
        elseif Sea3 and (_G.ServerData['PlayerBackpack']["God's Chalice"] and (not UnCompleteColor() or HasColor(UnCompleteColor().BrickColor.Name))) then 
            _G.CurrentTask = "Using God's Chalice"
        elseif CheckEnabling('Upgrading Race') and _G.ServerData['PlayerData'].Beli >= 500000 and _G.Config.OwnedItems["Warrior Helmet"] and _G.ServerData['PlayerData'].RaceVer == 'V1' then 
            _G.CurrentTask = 'Race V2 Quest' 
        end  
        _G.TaskUpdateTick = tick()
    end
end 
local rF1,rF2 
task.spawn(function()
    while task.wait(.5) do 
        rF1,rF2  = pcall(function()
            refreshTask() 
        end)
        if not rF1 then 
            warn('Refreshing task error:',rF2)
        end
    end
end)    
if hookfunction then  
    task.spawn(function()
        local gameNgu = {}
        if game.PlaceId == 2753915549 then  
            gameNgu = {
                Workspace.Map.SkyArea1.PathwayTemple.Entrance,
                Workspace.Map.TeleportSpawn.Entrance,
                Workspace.Map.TeleportSpawn.Exit,
                Workspace.Map.SkyArea2.PathwayHouse.Exit,
            }
            
        elseif game.PlaceId == 4442272183 then 
            gameNgu = {
                Workspace.Map.Dressrosa.FlamingoExit,
                Workspace.Map.Dressrosa.FlamingoEntrance,
                Workspace.Map.GhostShip.Teleport,
                Workspace.Map.GhostShipInterior.Teleport,
            }
        else
            gameNgu = {
                Workspace.Map.Turtle.Entrance.Door.BossDoor.Hitbox,
                Workspace.Map.Turtle.MapTeleportB.Hitbox,
                Workspace.Map.Turtle.Cursed.EntranceTouch,
                Workspace.Map.Waterfall.MapTeleportA.Hitbox,
                Workspace.Map.Waterfall.BossRoom.Door.BossDoor.Hitbox,
                Workspace.Map['Boat Castle'].MapTeleportB.Hitbox,
                Workspace.Map['Boat Castle'].MapTeleportA.Hitbox,
                Workspace.Map['Temple of Time'].ClockRoomExit,
            }  
        end
        table.foreach(gameNgu,function(i,v)
            for i2,v2 in getconnections(v.Touched) do 
                v2:Disable()
                print('Disabled:',v)
            end
        end)
    end)
    task.delay(2,function()
        require(game.ReplicatedStorage.Notification).new = function(v1,v2) 
            v1 = tostring(v1):gsub("<Color=[^>]+>", "") 
            local Nof = game.Players.LocalPlayer.Character:FindFirstChild('Notify') or (function() 
                if not game.Players.LocalPlayer.Character:FindFirstChild('Notify') then 
                    local nof = Instance.new('StringValue',game.Players.LocalPlayer.Character)
                    nof.Name = 'Notify'
                    nof.Value = ''
                    return nof
                end 
            end)()
            Nof.Value = v1 
            local FakeLOL = {}
            function FakeLOL.Display(p18)
                return true;
            end; 
            function FakeLOL.Dead()
            end
            return FakeLOL
        end
        task.delay(3,function() 
            warn('Disabling effects') 
            if hookfunction and not islclosure(hookfunction) then 
                for i,v in pairs(require(game.ReplicatedStorage.Effect.Container.Misc.Damage)) do 
                    if typeof(v) == 'function' then 
                        hookfunction(
                            v, 
                            function()
                                return {
                                    Run = function() end,
                                    Stop = function() end,
                                }
                            end
                        )
                    end
                end 
                for i,v in pairs(game.ReplicatedStorage.Assets.GUI:GetChildren()) do 
                    v.Enabled = false 
                end
                hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Death), function()end)
                hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Respawn), function()end)
                hookfunction(require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule")).ChangeDisplayedNPC,function() end) 
                task.delay(0.1,function()
                    for i,v2 in pairs(game.ReplicatedStorage.Effect.Container:GetDescendants()) do 
                        pcall(function()
                            if v2.ClassName =='ModuleScript' and typeof(require(v2)) == 'function' then 
                                hookfunction(require(v2),function()end)     
                                task.wait(1)
                            end
                        end)
                    end
                end)
            end
        end)
    end)
end
_G.rejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(
    child)
    if not _G.SwitchingServer and child.Name == 'ErrorPrompt' and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
        wait()
        print('not _G.SwitchingServer',not _G.SwitchingServer)
        local CurrentErrorTitle = child.TitleFrame.ErrorTitle.Text
        local CurrentErrorMessage = child.MessageArea.ErrorFrame.ErrorMessage.Text 
        if CurrentErrorTitle ~= 'Teleport Failed' and not Hopping then 
            Hopping = true 
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)  
        end
    end
end)
local Tiers = {
    "Soul Guitar",  
    'Cursed Dual Katana',
    'Mirror Fractal',
    'Upgrading Race',
    'Mirage Puzzle',
    --'Rainbown Haki'
}
AutoMiragePuzzle = function()
    if _G.ServerData['PlayerData'].RaceVer == "V3" and _G.Config.OwnedItems['Mirror Fractal'] and _G.Config.OwnedItems['Valkyrie Helm'] then 
        if not Sea3 then 
            TeleportWorld(3)
        else
            _G.RaceV4Progress = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check")
            if _G.RaceV4Progress==1 then 
                SetContent(tostring(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Begin")))
            elseif _G.RaceV4Progress == 2 then 
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "requestEntrance",
                    Vector3.new(28282.5703125, 14896.8505859375, 105.1042709350586)
                )
                local AllNPCS = getnilinstances()
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
                Tweento(TempleMysteriousNPC2.HumanoidRootPart.CFrame)
                wait(0.5)
                if
                    (TempleMysteriousNPC2.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <
                        15
                 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack")
                end
                if
                    (TempleMysteriousNPC1.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <
                        15
                 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Teleport")
                end
            elseif _G.RaceV4Progress == 3 then 
                SetContent(tostring(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Continue")))
            elseif _G.RaceV4Progress == 4 then
                if game.workspace.Map:FindFirstChild("MysticIsland") and not game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CheckTempleDoor") then
                    if IsPlayerAlive() then 
                        local BlueGear = getBlueGear()
                        local HighestPoint = getHighestPoint() and getHighestPoint().CFrame * CFrame.new(0, 211.88, 0)
                        if BlueGear and BlueGear.Transparency ~= 1 then 
                            repeat 
                                task.wait()
                                if IsPlayerAlive() then 
                                    local BlueGearCaller,BlueGearCaller2 = pcall(function()
                                        for i,v in BlueGear:GetDescendants() do 
                                            if v.ClassName == 'TouchTransmitter' then 
                                                firetouchinterest(v.Parent, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
                                                firetouchinterest(v.Parent, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
                                            end
                                        end
                                    end)
                                    SetContent('Getting Blue Gear...')
                                    if not BlueGearCaller then 
                                        print('BlueGearCaller2',BlueGearCaller2)
                                    end
                                    Tweento(BlueGear.CFrame)
                                end
                            until not BlueGear or not BlueGear.Parent or BlueGear.Transparency == 1 
                        elseif BlueGear and BlueGear.Transparency == 1 then 
                            if HighestPoint then 
                                Tweento(HighestPoint)
                                if GetDistance(HighestPoint) < 10 then 
                                    SetContent('Looking at moon...')
                                    workspace.CurrentCamera.CFrame =
                                        CFrame.new(
                                        workspace.CurrentCamera.CFrame.Position,
                                        game:GetService("Lighting"):GetMoonDirection() + workspace.CurrentCamera.CFrame.Position
                                    )
                                    wait()
                                    SendKey("T",.5)
                                end
                            end
                        elseif HighestPoint then 
                            if game.Lighting.ClockTime < 18 and game.Lighting.ClockTime > 5 then
                                TimetoNight = (18 - game.Lighting.ClockTime)*60 
                                TimeInS = math.floor(TimetoNight%60)
                                TimeInM = TimetoNight//60
                                if TimeInM <= 0 then 
                                    SetContent('Waiting '..tostring(TimeInS).."s to night.")
                                else 
                                    SetContent("Waiting "..tostring(TimeInM)..":"..tostring(TimeInS).." to night.")
                                end
                            end
                            Tweento(HighestPoint)
                        end
                    end
                end
            else
                _G.CurrentTask = ''
            end
        end
    end
end
FindNextTaskTier = function()
    if _G.Config["Melee Level Values"]['Godhuman'] then 
        for __,taskK in Tiers do 
            if table.find(_G.GUIConfig["Allowed Actions"],taskK) then 
                if __ < 4 then 
                    if _G.Config.OwnedItems[taskK] then 
                        table.remove(Tiers,__)
                    end
                elseif taskK == 'Upgrading Race' then 
                    if _G.ServerData['PlayerData'].RaceVer ~= "V3" and _G.ServerData['PlayerData'].RaceVer ~= 'V4' then 
                        return taskK 
                    else
                        table.remove(Tiers,__)
                    end
                elseif taskK == 'Mirage Puzzle' then 
                    if not game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CheckTempleDoor") then 
                        return taskK
                    else
                        table.remove(Tiers,__)
                    end
                elseif taskK == 'Rainbown Haki' then 

                end
            end
        end
    end 
end
AutoDoughKing = function()
    local CP = _G.ServerData['Server Bosses']['Dough King'] or _G.ServerData['Server Bosses']['Cake Prince']
    if CP then 
        if _G.SpamSpawnCakePrince then 
            _G.SpamSpawnCakePrince:Disconnect()
            _G.SpamSpawnCakePrince = nil 
        end
        KillBoss(CP)
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
            "RaidsNpc",
            "Select",
            "Dough"
        )
    elseif _G.ServerData["PlayerBackpack"]['Sweet Chalice'] then 
        local MobLeft = tonumber(string.match(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner", true),'%d+')) or 0
        task.spawn(function()
            if MobLeft <= 8 then
                if not _G.SpamSpawnCakePrince then 
                    _G.SpamSpawnCakePrince = game.RunService.Heartbeat:Connect(function()
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CakePrinceSpawner") 
                    end)
                end
            elseif MobLeft >= 400 then 
                if _G.SpamSpawnCakePrince then 
                    _G.SpamSpawnCakePrince:Disconnect()
                    _G.SpamSpawnCakePrince = nil 
                end
            end
        end)
        if MobLeft > 0 then 
            KillMobList({
                "Cookie Crafter",
                "Cake Guard",
                "Head Baker",
                "Baking Staff"
            })
        end
    elseif _G.ServerData["PlayerBackpack"]["God's Chalice"] then 
        if CheckMaterialCount('Conjured Cocoa') >= 10 then 
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("SweetChaliceNpc")
        else
            KillMobList({
                "Cocoa Warrior",
                "Chocolate Bar Battler"
            })
        end
    elseif CheckMaterialCount('Conjured Cocoa') < 10 then 
        KillMobList({
            "Cocoa Warrior",
            "Chocolate Bar Battler"
        })
    else
        if _G.CurrentElite then  
            if
                not string.find(
                    game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,
                    _G.CurrentElite.Name
                ) or
                    not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                then
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "AbandonQuest"
                )
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "EliteHunter"
                )
            end
            KillBoss(_G.CurrentElite)
            task.wait(1)
            return
        else
            HopServer(10,true,'Elite (Auto Dough King)')
        end
    end
end
AutoV3 = function()  
    if _G.ServerData['PlayerData'].RaceVer == "V3" then 
        _G.CurrentTask = ''
        return 
    elseif _G.ServerData['PlayerData'].Beli <2000000 then 
        _G.CurrentTask = ''
        return 
    elseif not Sea2 then 
        TeleportWorld(2)
    else 
        local CurrentR = _G.ServerData['PlayerData'].Race  
        local v113 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
        if v113 == 0 then
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
        end
        if CurrentR == 'Human' then  
            if _G.ServerData['Server Bosses']['Diamond'] and _G.ServerData['Server Bosses']['Jeremy'] and _G.ServerData['Server Bosses']['Fajita'] then 
                repeat 
                    task.wait() 
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
                    if _G.ServerData['Server Bosses']['Diamond'] then 
                        KillBoss(_G.ServerData['Server Bosses']['Diamond'])
                    elseif _G.ServerData['Server Bosses']['Jeremy'] then 
                        KillBoss(_G.ServerData['Server Bosses']['Jeremy'])
                    elseif _G.ServerData['Server Bosses']['Fajita'] then 
                        KillBoss(_G.ServerData['Server Bosses']['Fajita']) 
                    end
                    task.wait()
                until not _G.ServerData['Server Bosses']['Diamond'] and not _G.ServerData['Server Bosses']['Jeremy'] and not _G.ServerData['Server Bosses']['Fajita'] 
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3")
                SetContent('NIGGA ON FIRE 🔥🔥🔥')
                TeleportWorld(3)
            else
                HopServer(10,true,"Find 3 bosses to get Human V3")
            end 
        elseif CurrentR == 'Cyborg' then  
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3") 
            local CheckAgain = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1")
            if CheckAgain and CheckAgain == 1 then 
                local FruitBelow1M = getFruitBelow1M()
                if FruitBelow1M then 
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", FruitBelow1M) 
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3") 
                end 
            end 
        elseif CurrentR == 'Mink' then 
            repeat 
                local NearestChest = getNearestChest()
                if NearestChest then 
                    PickChest(NearestChest) 
                else
                    warn('Not Chest')
                end 
                task.wait(.1)
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3") 
            until game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") ~= 1
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Wenlocktoad", "3") 
        end
    end
end
AutoCDK = function(questTitle) 
    SetContent(questTitle)
    if questTitle ~= 'Soul Reaper' and _G.WeaponType ~= 'Sword' then 
        _G.WeaponType = 'Sword'
    end
    LoadItem('Tushita')
    if questTitle == 'The Final Boss' then  
        repeat 
            task.wait()
            if GetDistance(game:GetService("Workspace").Map.Turtle.Cursed.Pedestal3) > 10 and game:GetService("Workspace").Map.Turtle.Cursed.PlacedGem.Transparency ~= 0 then
                Tweento(game:GetService("Workspace").Map.Turtle.Cursed.Pedestal3.CFrame * CFrame.new(0, 0, -2)) 
            end 
            if game:GetService("Workspace").Map.Turtle.Cursed.PlacedGem.Transparency == 0 then 
                if not _G.ServerData['Server Bosses']['Cursed Skeleton Boss'] then
                    Tweento(CFrame.new(-12341.66796875, 603.3455810546875, -6550.6064453125),true)
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("CDKQuest", "SpawnBoss")
                else
                    KillBoss(_G.ServerData['Server Bosses']['Cursed Skeleton Boss'])
                    _G.CurrentTask = ''
                end
            else 
                if GetDistance(game:GetService("Workspace").Map.Turtle.Cursed.Pedestal3) < 10 and game:GetService("Workspace").Map.Turtle.Cursed.Pedestal3.ProximityPrompt.Enabled then 
                    fireproximityprompt(game:GetService("Workspace").Map.Turtle.Cursed.Pedestal3.ProximityPrompt) 
                    task.wait(1)
                    for i,v in pairs(game.workspace.Enemies:GetChildren()) do 
                        pcall(function()
                            if v and v.PrimaryPart and GetDistance(v.PrimaryPart) <= 1000 and v:FindFirstChildOfClass('Humanoid') and v:FindFirstChildOfClass('Humanoid').Health > 0 then 
                                v:FindFirstChildOfClass('Humanoid').Health = 0 
                            end
                        end)
                    end
                end
            end 
        until _G.Config.OwnedItems["Cursed Dual Katana"]
        _G.CurrentTask = ''
        _G.CDKQuest = ''
    elseif questTitle == 'Pedestal1' then 
        if GetDistance(game:GetService("Workspace").Map.Turtle.Cursed["Pedestal1"]) < 10 then
            fireproximityprompt(game:GetService("Workspace").Map.Turtle.Cursed['Pedestal1'].ProximityPrompt)
        else
            Tweento(game:GetService("Workspace").Map.Turtle.Cursed['Pedestal1'].CFrame * CFrame.new(0, 0, -2))
        end
    elseif questTitle == 'Pedestal2' then  
        if GetDistance(game:GetService("Workspace").Map.Turtle.Cursed["Pedestal2"]) < 10 then
            fireproximityprompt(game:GetService("Workspace").Map.Turtle.Cursed['Pedestal2'].ProximityPrompt)
        else
            Tweento(game:GetService("Workspace").Map.Turtle.Cursed['Pedestal2'].CFrame * CFrame.new(0, 0, -2))
        end
    elseif questTitle == 'Tushita Dimension' then 
        local Torch
        local CurrentCFrame
        local TickTorch
        repeat task.wait()
            if game:GetService("Workspace").Map.HeavenlyDimension.Exit.BrickColor == BrickColor.new("Cloudy grey") then 
                if _G.KillAuraConnection then 
                    _G.KillAuraConnection:Disconnect()
                    _G.KillAuraConnection = nil 
                end
                Tweento(game:GetService("Workspace").Map.HeavenlyDimension.Exit.CFrame)
                wait(2) 
            else
                if CheckTorchDimension("Tushita") then 
                    Torch = CheckTorchDimension("Tushita")
                    Tweento(Torch.CFrame)  
                    wait(.5)
                    fireproximityprompt(Torch.ProximityPrompt)  
                    CurrentCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame 
                    TickTorch = tick()
                    if not _G.KillAuraConnection then 
                        _G.KillAuraConnection = workspace.Enemies.ChildAdded:Connect(function(v)  
                            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 3000+300)   
                            local V5Hum = v:FindFirstChildOfClass('Humanoid') or v:WaitForChild('Humanoid')
                            if V5Hum then 
                                V5Hum.Health = 0 
                                repeat 
                                    V5Hum.Health = 0 
                                    task.wait(1)
                                until not V5Hum or not V5Hum.Parent or not V5Hum.Parent.Parent
                
                            end
                        end) 
                    end
                    repeat task.wait()
                        for i,v in pairs(workspace.Enemies:GetChildren()) do 
                            pcall(function()
                                if v:FindFirstChildOfClass('Humanoid') then 
                                    v:FindFirstChildOfClass('Humanoid').Health = 0 
                                end
                            end) 
                        end
                        Tweento(CurrentCFrame * CFrame.new(0,250,0))
                    until not NearestMob(1500) or tick()-TickTorch >= 5
                    Tweento(CurrentCFrame)
                    if _G.KillAuraConnection then 
                        _G.KillAuraConnection:Disconnect()
                        _G.KillAuraConnection = nil 
                    end
                end
            end
            task.wait()
        until not IsPlayerAlive() or GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Heavenly Dimension"]) > 2000
    elseif questTitle == 'Cake Queen' then 
        if _G.ServerData['Server Bosses']['Cake Queen'] then 
            CDKTICK = tick()
            repeat task.wait()
                KillBoss(_G.ServerData['Server Bosses']['Cake Queen'])  
                wait(1)
                CDKTICK = tick()
            until GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Heavenly Dimension"]) <= 2000 or tick()-CDKTICK >= 30
            if tick()-CDKTICK >= 30 then 
                return 
            end
            wait(1)
        elseif not _G.DimensionLoading then
            wait(1)
            if _G.DimensionLoading then return end
            SetContent('Hopping for Cake Quen',5)
            HopServer(10,true,"Cake Queen")
        end 
    elseif questTitle == 'Tushita Quest -4' then 
        if _G.PirateRaidTick and tick()-_G.PirateRaidTick < 60 then 
            Auto3rdEvent() 
        else
            if FindAndJoinServer then  
                FindAndJoinServer('seaevent','spot',function(v,rt)
                    return rt-v.FoundOn < 20
                end)
            else
                loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/FinderServerLoading.lua'))()
            end
            AutoL()
        end
    elseif questTitle == 'Tushita Quest -3' then 
        for v50, v51 in pairs(getnilinstances()) do
            if v51.Name:match("Luxury Boat Dealer") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v51.HumanoidRootPart.CFrame
                local args = {
                    [1] = "CDKQuest",
                    [2] = "BoatQuest",
                    [3] = workspace.NPCs:FindFirstChild("Luxury Boat Dealer")
                }
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
            end
        end
    elseif questTitle == 'Yama Dimension' then 
        local Torch
        local CurrentCFrame
        local TickTorch
        repeat task.wait()
            if not _G.DoneHell then 
                if game:GetService("Workspace").Map.HellDimension.Exit.BrickColor == BrickColor.new("Olivine") then 
                    repeat 
                        if GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Hell Dimension"]) < 2000 then 
                            Tweento(game:GetService("Workspace").Map.HellDimension.Exit.CFrame)
                        end
                        if _G.KillAuraConnection then 
                            _G.KillAuraConnection:Disconnect()
                            _G.KillAuraConnection = nil 
                        end
                        _G.DoneHell = true
                        wait(2) 
                    until GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Hell Dimension"]) > 2000 
                    _G.CDKQuest = CheckQuestCDK()  
                else 
                    if CheckTorchDimension("Yama") then 
                        Torch = CheckTorchDimension("Yama")
                        task.spawn(SetContent,'Touching torch.')
                        Tweento(Torch.CFrame)  
                        wait(.5)
                        fireproximityprompt(Torch.ProximityPrompt)  
                        CurrentCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame 
                        TickTorch = tick()
                        if not _G.KillAuraConnection then 
                            _G.KillAuraConnection = workspace.Enemies.ChildAdded:Connect(function(v)  
                                sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 3000+300)   
                                local V5Hum = v:FindFirstChildOfClass('Humanoid') or v:WaitForChild('Humanoid')
                                if V5Hum then 
                                    V5Hum.Health = 0 
                                    repeat 
                                        V5Hum.Health = 0 
                                        task.wait(1)
                                    until not V5Hum or not V5Hum.Parent or not V5Hum.Parent.Parent
                    
                                end
                            end) 
                        end
                        repeat task.wait()
                            for i,v in pairs(workspace.Enemies:GetChildren()) do 
                                pcall(function()
                                    if v:FindFirstChildOfClass('Humanoid') then 
                                        v:FindFirstChildOfClass('Humanoid').Health = 0 
                                    end
                                end) 
                            end
                            Tweento(CurrentCFrame * CFrame.new(0,250,0))
                            task.wait()
                        until not NearestMob(1500) or tick()-TickTorch >= 5
                        Tweento(CurrentCFrame)
                    else
                        print('Not Torch Dimension yama')
                    end
                end
            end
        until GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Hell Dimension"]) > 2000 
    elseif questTitle == 'Soul Reaper' then 
        if _G.ServerData['Server Bosses']['Soul Reaper'] then 
            print('Soul Reaper Found')
            repeat 
                task.wait()
                if not _G.DimensionLoading then --and not (game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild('Hell Dimension') or GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Hell Dimension"]) < 1001) then 
                    if GetDistance(_G.ServerData['Server Bosses']['Soul Reaper'].PrimaryPart) > 300 then  
                        Tweento(_G.ServerData['Server Bosses']['Soul Reaper'].PrimaryPart.CFrame * CFrame.new(0,1.5,-1.5)) 
                        wait(3)
                    else
                        game.Players.LocalPlayer.Character.PrimaryPart.CFrame = _G.ServerData['Server Bosses']['Soul Reaper'].PrimaryPart.CFrame * CFrame.new(0,1.5,-1.5) 
                    end  
                end
            until _G.DimensionLoading or (game:GetService("Workspace")["_WorldOrigin"].Locations:FindFirstChild('Hell Dimension') and GetDistance(game:GetService("Workspace")["_WorldOrigin"].Locations["Hell Dimension"]) <= 1001) 
            if _G.DimensionLoading then 
                _G.DimensionLoading = false 
                wait(5)
            end
        elseif _G.ServerData["PlayerBackpack"]['Hallow Essence'] then 
            EquipWeapon("Hallow Essence")
            Tweento(game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection.CFrame)
            task.wait(1)
        else
            local v316, v317, v318, v319 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Check")
            if v318 and v318 > 0 then 
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1) 
                if _G.ServerData['PlayerData'].Level >= 2000 then  
                    if not game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then 
                        FarmMobByLevel(2000)
                    else 
                        KillMobList({
                            "Reborn Skeleton [Lv. 1975]",
                            "Living Zombie [Lv. 2000]",
                            "Demonic Soul [Lv. 2025]",
                            "Posessed Mummy [Lv. 2050]"
                        })
                    end
                else 
                    KillMobList({
                        "Reborn Skeleton [Lv. 1975]",
                        "Living Zombie [Lv. 2000]",
                        "Demonic Soul [Lv. 2025]",
                        "Posessed Mummy [Lv. 2050]"
                    })
                end
            elseif v316 and v316 < 5000 then 
                if _G.ServerData['PlayerData'].Level >= 2000 then  
                    if not game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then 
                        FarmMobByLevel(2000)
                    else 
                        KillMobList({
                            "Reborn Skeleton [Lv. 1975]",
                            "Living Zombie [Lv. 2000]",
                            "Demonic Soul [Lv. 2025]",
                            "Posessed Mummy [Lv. 2050]"
                        })
                    end
                else 
                    KillMobList({
                        "Reborn Skeleton [Lv. 1975]",
                        "Living Zombie [Lv. 2000]",
                        "Demonic Soul [Lv. 2025]",
                        "Posessed Mummy [Lv. 2050]"
                    })
                end
            else
                AutoL()
            end  
        end
    elseif questTitle == 'Yama Quest -4' then 
        local MobSP = NearestHazeMob()
        if MobSP then 
            KillMobList({MobSP})
        end
        repeat 
            MobSP = NearestHazeMob()
            if MobSP then 
                KillMobList({MobSP})
            end
            task.wait()
        until not _G.CDKQuest ~= 'Yama Quest -4'
        print('cc')
    elseif questTitle == 'Yama Quest -3' then 
        if FindMobHasHaki() then 
            repeat 
                pcall(function()
                    task.wait()
                    Tweento(FindMobHasHaki().PrimaryPart.CFrame * CFrame.new(0,0,-2))
                end)
            until not IsPlayerAlive()
        end
    end        
end
AutoUseGodChalice = function()
    local UnCompleteColorr = UnCompleteColor()
    if not UnCompleteColorr then 
        EquipWeapon("God's Chalice") 
        Tweento(game:GetService("Workspace").Map["Boat Castle"].Summoner.Detection.CFrame)
        _G.CurrentTask = ''
    elseif HasColor(UnCompleteColorr.BrickColor.Name) then
        if UnCompleteColorr then 
            Tweento(UnCompleteColorr.CFrame)
        end
    end
end
AutoRaidBoss = function()
    local RaidBoss = _G.ServerData['Server Bosses']['Darkbeard'] or _G.ServerData['Server Bosses']['rip_indra True Form']
    if RaidBoss then 
        KillBoss(RaidBoss)
    else
        _G.RaidBossEvent =false
        _G.CurrentTask = ''
    end
end
AutoCakePrinceEvent = function()
    local CPB = _G.ServerData['Server Bosses']['Cake Prince'] or _G.ServerData['Server Bosses']['Dough King'] 
    if not CPB or not CPB:FindFirstChildOfClass('Humanoid') then 
        _G.CakePrince = false 
        _G.CurrentTask =''  
    else  
        KillBoss(CPB)
        _G.CurrentTask ='' 
    end
end
AutoHallowScythe = function()
    if _G.ServerData['Server Bosses']['Soul Reaper'] then 
        KillBoss(_G.ServerData['Server Bosses']['Soul Reaper'])
        _G.CurrentTask = ''
    elseif _G.ServerData["PlayerBackpack"]['Hallow Essence'] then
        EquipWeapon('Hallow Essence') 
        Tweento(game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection.CFrame)
        wait(1)
    end
end
AutoSoulGuitar = function() 
    if Sea1 then 
        TeleportWorld(3)
        return
    end
    local BlankTablets = {
        "Segment6",
        "Segment2",
        "Segment8",
        "Segment9",
        "Segment5"
    }
    local Trophy = {
        ["Segment1"] = "Trophy1",
        ["Segment3"] = "Trophy2",
        ["Segment4"] = "Trophy3",
        ["Segment7"] = "Trophy4",
        ["Segment10"] = "Trophy5",
    }
    local Pipes = {
        ["Part1"] = "Really black",
        ["Part2"] = "Really black",
        ["Part3"] = "Dusty Rose",
        ["Part4"] = "Storm blue",
        ["Part5"] = "Really black",
        ["Part6"] = "Parsley green",
        ["Part7"] = "Really black",
        ["Part8"] = "Dusty Rose",
        ["Part9"] = "Really black",
        ["Part10"] = "Storm blue",
    }
    local CurrnetPuzzle = game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("GuitarPuzzleProgress", "Check")
    if not _G.SoulGuitarPuzzlePassed then 
        _G.SoulGuitarPuzzlePassed = (function()
            local LLL = CurrnetPuzzle
            return LLL and LLL.Trophies and LLL.Ghost and LLL.Gravestones and LLL.Swamp and LLL.Pipes 
        end)()
    end 
    if not _G.SoulGuitarPuzzlePassed then 
        if not CurrnetPuzzle then  
            moonPhase = game:GetService("Lighting"):GetAttribute("MoonPhase")
            SetContent("Unlocking Soul Guitar's Puzzle (Praying Grave Stone)",5)
            if not Sea3 then 
                TeleportWorld(3)
            elseif (moonPhase == 5 or moonPhase == 4) and (moonPhase == 4 or (moonPhase == 5 and (game.Lighting.ClockTime > 12 or game.Lighting.ClockTime < 5))) then   
                if moonPhase == 5 and (game.Lighting.ClockTime >= 18 or game.Lighting.ClockTime < 5) then
                    Tweento(CFrame.new(-8654.314453125, 140.9499053955078, 6167.5283203125)) 
                    if GetDistance(CFrame.new(-8654.314453125, 140.9499053955078, 6167.5283203125)) < 10 then
                        CheckRemote = game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("gravestoneEvent", 2) 
                        if CheckRemote ~= true then return end 
                        require(game.ReplicatedStorage.Effect).new("BlindCam"):replicate({
                            Color = Color3.new(0.03, 0.03, 0.03), 
                            Duration = 2, 
                            Fade = 0.25, 
                            ZIndex = -10
                        });
                        require(game.ReplicatedStorage.Util.Sound):Play("Thunder", workspace.CurrentCamera.CFrame.p); 
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
                        SetContent('Completed')  
                        return
                    end  
                else
                    AutoL()
                end
            else 
                if not AutoFullMoon then 
                    loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/AutoFullMoon.lua'))()
                else
                    AutoFullMoon()
                end
            end 
        elseif not CurrnetPuzzle.Swamp then  
            SetContent("Unlocking Soul Guitar's Puzzle (Swamp: Kill 6 Zombie at same time)",5)
            if not Sea3 then 
                TeleportWorld(3)
            elseif GetDistance(CFrame.new(-10171.7607421875, 138.62667846679688, 6008.0654296875)) > 300 then
                Tweento(CFrame.new(-10171.7607421875, 138.62667846679688, 6008.0654296875) * CFrame.new(0,25,-20))
            else
                if CheckAnyPlayersInCFrame(CFrame.new(-10171.7607421875, 138.62667846679688, 6008.0654296875), 500) then
                    SetContent('Players In Area | Hopping for peace',5)
                    HopServer(10,true,"Peace Area")
                else
                    if (function() 
                        local Cos = 0   
                        for i ,v in pairs(game.workspace.Enemies:GetChildren()) do 
                            if RemoveLevelTitle(v.Name) == "Living Zombie" and v.Humanoid.Health > 0 then
                                if GetDistance(CFrame.new(-10171.7607421875, 138.62667846679688, 6008.0654296875),v.HumanoidRootPart) <= 20 then 
                                    Cos += 1
                                end
                            end
                        end
                        return Cos
                    end)() == 6 then
                        warn('Zombie Near')
                        for i, v in pairs(game.workspace.Enemies:GetChildren()) do
                            if
                                RemoveLevelTitle(v.Name) == "Living Zombie" and v:FindFirstChild("HumanoidRootPart") and
                                    v:FindFirstChild("Humanoid") and
                                    v.Humanoid.Health > 0
                            then
                                repeat
                                    wait()
                                    KillNigga(v)
                                until v.Humanoid.Health <= 0 or not v.Parent
                            end
                        end
                    else
                        warn('Not 6 Zombie');
                        (function()
                            for i, v in pairs(game.workspace.Enemies:GetChildren()) do
                                if RemoveLevelTitle(v.Name) == "Living Zombie" and v:FindFirstChild("Humanoid") and
                                        v:FindFirstChild("HumanoidRootPart") --and isnetworkowner(v.HumanoidRootPart)
                                    then
                                    v.HumanoidRootPart.CFrame = CFrame.new(-10171.7607421875, 138.62667846679688, 6008.0654296875)
                                    v.Humanoid:ChangeState(14)
                                    v.PrimaryPart.CanCollide = false
                                    v.Head.CanCollide = false
                                    v.Humanoid.WalkSpeed = 0
                                    v.Humanoid.JumpPower = 0
                                    if v.Humanoid:FindFirstChild("Animator") then
                                        v.Humanoid.Animator:Destroy()
                                    end
                                end
                            end
                        end)()
                    end
                end
            end
        elseif not CurrnetPuzzle.Gravestones then 
            print(game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("GuitarPuzzleProgress", "Gravestones"))
            SetContent("Unlocking Soul Guitar's Puzzle (Grave Stones: Clicking Signs)")
            if not Sea3 then 
                TeleportWorld(3)
            elseif GetDistance(CFrame.new(-8761.4765625, 142.10487365722656, 6086.07861328125)) > 50 then
                Tweento(CFrame.new(-8761.4765625, 142.10487365722656, 6086.07861328125))
            else
                local ClickSigns = {
                    game.workspace.Map["Haunted Castle"].Placard1.Right.ClickDetector,
                    game.workspace.Map["Haunted Castle"].Placard2.Right.ClickDetector,
                    game.workspace.Map["Haunted Castle"].Placard3.Left.ClickDetector,
                    game.workspace.Map["Haunted Castle"].Placard4.Right.ClickDetector,
                    game.workspace.Map["Haunted Castle"].Placard5.Left.ClickDetector,
                    game.workspace.Map["Haunted Castle"].Placard6.Left.ClickDetector,
                    game.workspace.Map["Haunted Castle"].Placard7.Left.ClickDetector
                }
                for i, v in pairs(ClickSigns) do
                    fireclickdetector(v)
                end
            end  
        elseif not CurrnetPuzzle.Ghost then 
            print(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost"))
            SetContent("Unlocking Soul Guitar's Puzzle (Ghost: Talking to the ghost)") 
            if not Sea3 then 
                TeleportWorld(3)
            elseif GetDistance(CFrame.new(-9755.6591796875, 271.0661315917969, 6290.61474609375)) > 7 then
                Tweento(CFrame.new(-9755.6591796875, 271.0661315917969, 6290.61474609375))
                game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("GuitarPuzzleProgress", "Ghost") 
                wait(3)
            end 
        elseif not CurrnetPuzzle.Trophies then 
            print(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Trophies"))
            SetContent("Unlocking Soul Guitar's Puzzle (Trophies: Unlock the Trophies's Puzzle)") 
            if not Sea3 then 
                TeleportWorld(3)
            elseif GetDistance(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375)) > 30 then
                Tweento(CFrame.new(-9530.0126953125, 6.104853630065918, 6054.83349609375)) 
            else 
                local DepTraiv4 = game.workspace.Map["Haunted Castle"].Tablet
                for i, v in pairs(BlankTablets) do
                    local x = DepTraiv4[v]
                    if x.Line.Position.X ~= 0 then
                        repeat
                            wait()
                            fireclickdetector(x.ClickDetector)
                        until x.Line.Position.X == 0
                    end
                end
                for i, v in pairs(Trophy) do
                    local x = game.workspace.Map["Haunted Castle"].Trophies.Quest[v].Handle.CFrame
                    x = tostring(x)
                    x = x:split(", ")[4]
                    local c = "180"
                    if x == "1" or x == "-1" then
                        c = "90"
                    end
                    if not string.find(tostring(DepTraiv4[i].Line.Rotation.Z), c) then
                        repeat
                            wait()
                            fireclickdetector(DepTraiv4[i].ClickDetector)
                        until string.find(tostring(DepTraiv4[i].Line.Rotation.Z), c)
                    end
                end
            end 
        elseif not CurrnetPuzzle.Pipes then 
            print(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Pipes"))
            SetContent("Unlocking Soul Guitar's Puzzle (Pipes)") 
            if not Sea3 then 
                TeleportWorld(3)
            else
                for i, v in pairs(Pipes) do
                    pcall(function()
                        local x = game.workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model[i]
                        if x.BrickColor.Name ~= v then
                            repeat
                                wait()
                                fireclickdetector(x.ClickDetector)
                            until x.BrickColor.Name == v
                        end
                    end) 
                end
            end 
        end 
    elseif CheckMaterialCount('Bones') < 500 then  
        SetContent('Farming Bones for soul guitar')
        if not Sea3 then 
            TeleportWorld(3) 
        else
            KillMobList({
                "Reborn Skeleton [Lv. 1975]",
                "Living Zombie [Lv. 2000]",
                "Demonic Soul [Lv. 2025]",
                "Posessed Mummy [Lv. 2050]"
            })
        end
    elseif CheckMaterialCount('Ectoplasm') < 250 then 
        if not Sea2 then 
            TeleportWorld(2)
        else
            KillMobList({
                "Ship Deckhand [Lv. 1250]",
                "Ship Engineer [Lv. 1275]",
                "Ship Steward [Lv. 1300]",
                'Ship Officer'
            }) 
        end
    elseif CheckMaterialCount('Dark Fragment') < 1  then   
        if not _G.ChestCollect then _G.ChestCollect = 0 end
        if not Sea2 then 
            TeleportWorld(2)
        else
            if _G.ServerData['Server Bosses']['Darkbeard'] then
                KillBoss(_G.ServerData['Server Bosses']['Darkbeard'])
                TeleportWorld(3)
            elseif _G.ServerData["PlayerBackpack"]['Fist of Darkness'] then 
                if GetDistance(game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection) <= 5 then 
                    EquipWeaponName("Fist of Darkness")
                    pcall(
                        function()
                            firetouchinterest(
                                game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection,
                                game.Players.LocalPlayer.Character["Fist of Darkness"].Handle,
                                0
                            )
                            firetouchinterest(
                                game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection,
                                game.Players.LocalPlayer.Character["Fist of Darkness"].Handle,
                                1
                            )
                        end
                    )
                else 
                    Tweento(game:GetService("Workspace").Map.DarkbeardArena.Summoner.Detection.CFrame)
                end
            elseif _G.ChestCollect >= 20 then 
                HopServer(9,true,"Find new server for Fist of Darkness")
            else 
                local NearestChest = getNearestChest()
                if not NearestChest then 
                    SetContent('Ngu')
                end 
                if NearestChest then 
                    PickChest(NearestChest) 
                elseif #_G.ServerData['Chest'] <= 0 then 
                    HopServer(9,true,"Find Chest") 
                end
            end
        end
    elseif _G.ServerData['PlayerData'].Fragments < 5000 then  
        print('Frag < 5000')
        repeat 
            if not Sea3 then 
                TeleportWorld(3)
            else
                if _G.ServerData["PlayerBackpack"]['Special Microchip'] or _G.ServerData['Nearest Raid Island'] then
                    AutoRaid() 
                else
                    _G.FragmentNeeded =true 
                    buyRaidingChip()
                    AutoL()
                end
            end
            task.wait() 
        until _G.ServerData['PlayerData'].Fragments >= 5000
        print('req: ',_G.ServerData['PlayerData'].Fragments >= 5000)
        _G.FragmentNeeded =false 
    else
        if not Sea3 then 
            TeleportWorld(3)
        else
            game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("soulGuitarBuy", true)
            SetContent(tostring(game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("soulGuitarBuy")))
            wait(10)
            _G.CurrentTask = ''
        end
    end
end
AutoTushita = function()
    if not _G.Config.OwnedItems["Tushita"] then 
        task.spawn(function()
            getgenv().TushitaQuest = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress");
        end)
        if _G.ServerData['Server Bosses']['rip_indra True Form'] then
            print('Rip India')
            if TushitaQuest.OpenedDoor then 
                if _G.ServerData['Server Bosses']['Longma'] then 
                    KillBoss(_G.ServerData['Server Bosses']['Longma'])
                    _G.CurrentTask = '' 
                else
                    HopServer(9,true,"Find Long Ma")
                end
            elseif not TushitaQuest.OpenedDoor then 
                TushitaStartQuestTick = tick()
                SetContent('Getting Holy Torch...')
                repeat 
                    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game:GetService("Workspace").Map.Waterfall.SecretRoom.Room.Door.Door.Hitbox.CFrame
                    task.wait()
                until _G.ServerData["PlayerBackpack"]['Holy Torch']
                SetContent('Got Holy Torch.')
                game.Players.LocalPlayer.Character.PrimaryPart.Anchored = false 
                task.spawn(function()
                    for i,v in TushitaQuest.Torches do 
                        if not v then 
                            task.spawn(function()
                                game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("TushitaProgress", "Torch", i)
                            end)
                        end
                    end
                end)
                task.wait()
                print('Tushita Door Opened:',TushitaQuest.OpenedDoor)
                if TushitaStartQuestTick then 
                    print('Done tushita in',tick() - (TushitaStartQuestTick or 0))
                end
                task.wait()
                repeat 
                    task.wait()
                    if _G.ServerData['Server Bosses']['rip_indra True Form'] then 
                        KillBoss(_G.ServerData['Server Bosses']['rip_indra True Form'])
                    end
                    task.wait()
                until not _G.ServerData['Server Bosses']['rip_indra True Form']
                wait()
            else
                KillBoss(_G.ServerData['Server Bosses']['rip_indra True Form'])
            end
        elseif TushitaQuest.OpenedDoor then 
            if _G.ServerData['Server Bosses']['Longma'] then 
                KillBoss(_G.ServerData['Server Bosses']['Longma'])
                _G.CurrentTask = '' 
            elseif not _G.Config.OwnedItems["Tushita"] then
                HopServer(9,true,"Find Long Ma")
            end
        end
    else 
        print('Already Tushita')
        _G.CurrentTask = '' 
    end
end
AutoYama = function()
    if Sea3 then 
        if _G.ServerData['PlayerData']["Elite Hunted"] >= 30 then  
            if GetDistance(game.Workspace.Map.Waterfall.SealedKatana.Handle.CFrame) > 50 then 
                SetContent('Tweening to temple to get yama...')
                Tweento(game.Workspace.Map.Waterfall.SealedKatana.Handle.CFrame * CFrame.new(0, 20, 0))
            else
                repeat 
                    task.wait()
                    repeat 
                        task.wait()
                        for i,v in pairs(workspace.Enemies:GetChildren()) do 
                            if v:FindFirstChildOfClass('Humanoid') then 
                                v:FindFirstChildOfClass('Humanoid').Health = 0 
                            end 
                        end  
                    until not game.Workspace.Enemies:FindFirstChild("Ghost [Lv. 1500]")
                    if not game.Workspace.Enemies:FindFirstChild("Ghost [Lv. 1500]") then
                        SetContent('Getting Yama')
                        fireclickdetector(game.Workspace.Map.Waterfall.SealedKatana.Handle.ClickDetector)
                    end
                until _G.Config.OwnedItems["Yama"] 
                _G.CurrentTask = '' 
            end 
        elseif _G.CurrentElite then 
            if
                not string.find(
                    game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,
                    _G.CurrentElite.Name
                ) or
                    not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                then
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "AbandonQuest"
                )
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    "EliteHunter"
                )
            end
            KillBoss(_G.CurrentElite)
        else 
            print(Sea3 and _G.CurrentElite and not (_G.ServerData['PlayerData']["Elite Hunted"] or _G.ServerData['PlayerData']["Elite Hunted"] >= 30 or _G.ServerData['Server Bosses']['rip_indra True Form']))
            HopServer(9,true,'Elite, getting yama | Total Killed Elites: '..tostring(tonumber(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")) or 0))
        end
    end
end
AutoElite = function() 
    if _G.CurrentElite and _G.CurrentElite.Parent then  
        if
            not string.find(
                game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,
                _G.CurrentElite.Name
            ) or
                not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
            then
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                "AbandonQuest"
            )
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                "EliteHunter"
            )
        else
            KillBoss(_G.CurrentElite)
            _G.CurrentTask = ''
        end
    else
        _G.CurrentElite = nil
        _G.CurrentTask = ''
    end
end
AutoSea3 = function()
    if Sea2 and _G.ServerData['PlayerData'].Level >= 1000 then  
        local v135 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1")
        if v135 and v135 ~= 0 then  
            if checkFruit1M() then 
                EquipWeaponName(checkFruit1M().Name)
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "3")  
                return 
            end
            local v136666 = checkFruit1M(true) 
            if v136666 then 
                EquipWeaponName(v136666.Name)
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "1")
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "2")
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TalkTrevor", "3")  
            elseif checkFruit1MWS() then  
                SetContent('Picking up '..getRealFruit(checkFruit1MWS()))
                Tweento(checkFruit1MWS().Handle.CFrame)
                task.wait(.1) 
                _G.CurrentTask = ''
            else 
                SetContent('Dont Have Fruit So We Must Farm')
                if _G.HopFruit1M then 
                    SetContent('Hoping for 1M Fruit',5)
                    HopServer(9,math.random(1,2) == 1)  
                end
                if _G.ServerData['Server Bosses']['Core'] then 
                    KillBoss(_G.ServerData['Server Bosses']['Core']) 
                elseif #_G.ServerData['Workspace Fruits'] > 0 then 
                    collectAllFruit_Store()
                else
                    AutoL()
                end
            end
        elseif v135 == 0 then
            local ZQuestProgress = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check")
            if not ZQuestProgress then 
                if _G.ServerData['Server Bosses']['Don Swan'] then 
                    KillBoss(_G.ServerData['Server Bosses']['Don Swan'])
                else 
                    SetContent('Hopping for Don Swan',5)
                    HopServer(9,true,"Don Swan")
                end
            elseif ZQuestProgress == 0 and GetDistance(game:GetService("Workspace").Map.IndraIsland.Part) > 1000 then
                local RedHeadCFrame =
                    CFrame.new(
                    -1926.78772,
                    12.1678171,
                    1739.80884,
                    0.956294656,
                    -0,
                    -0.292404652,
                    0,
                    1,
                    -0,
                    0.292404652,
                    0,
                    0.956294656
                )
                if GetDistance(RedHeadCFrame) <= 50 then
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ZQuestProgress", "Begin")
                else
                    Tweento(RedHeadCFrame)
                end
            elseif _G.ServerData['Server Bosses']['rip_indra'] then 
                task.spawn(function()
                    while task.wait(0.1) do 
                        local timetry = 0 
                        if timetry > 500 then break; end 
                        timetry+=1 
                        local args = {
                            [1] = "TravelZou"
                        }
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
                    end
                end)
                repeat 
                    KillBoss(_G.ServerData['Server Bosses']['rip_indra'])
                until not _G.ServerData['Server Bosses']['rip_indra']
            end 
        end
    end
end














AutoRaid = function()
    if _G.ServerData['Nearest Raid Island'] then 
        local RaidDis = GetDistance(_G.ServerData['Nearest Raid Island'])
        if RaidDis < 250 then
            game.Players.LocalPlayer.Character.PrimaryPart.CFrame = _G.ServerData['Nearest Raid Island'].CFrame  *CFrame.new(0,60,0) 
            _G.Ticktp = tick()
        elseif RaidDis < 4550 then
            Tweento(_G.ServerData['Nearest Raid Island'].CFrame  *CFrame.new(0,60,0)) 
        end
    elseif _G.ServerData["PlayerBackpack"]['Special Microchip'] then
        SetContent('Firing raid remote...',3)
        _G.NextRaidIslandId = 1
        if Sea2 then 
            --Tweento(CFrame.new(-12463.8740234375, 374.9144592285156, -7523.77392578125))
            fireclickdetector(Workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)  
        elseif Sea3 then 
            --Tweento(CFrame.new(923.21252441406, 126.9760055542, 32852.83203125))
            fireclickdetector(Workspace.Map["Boat Castle"].RaidSummon2.Button.Main.ClickDetector) 
        end
        if _G.ServerData["PlayerBackpack"]['Special Microchip'] then 
            _G.ServerData["PlayerBackpack"]['Special Microchip'] = nil 
        end
        wait(12) 
    end
    SetContent('Doing raid')   
    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 3000+300)     
    if not _G.KillAuraConnection then 
        _G.KillAuraConnection = workspace.Enemies.ChildAdded:Connect(function(v)  
            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", 3000+300)   
            local V5Hum = v:FindFirstChildOfClass('Humanoid') or v:WaitForChild('Humanoid',3)
            if V5Hum then 
                repeat 
                    V5Hum.Health = 0 
                    task.wait(1)
                until not V5Hum or not V5Hum.Parent or not V5Hum.Parent.Parent
            end
        end) 
    end
end
Auto3rdEvent = function() 
    if Sea2 then
        KillBoss(_G.ServerData['Server Bosses']['Core']) 
        _G.CurrentTask = ''
    else  
        if _G.PirateRaidTick <= 0 then 
            _G.CurrentTask = ''
            return 
        end 
        local CastleCFrame = CFrame.new(-5543.5327148438, 313.80062866211, -2964.2585449219)
        if GetDistance(CastleCFrame) > 1500 then 
            Tweento(CastleCFrame * CFrame.new(0,-100,0))
        else
            for i,v in pairs(game.workspace.Enemies:GetChildren()) do 
                if v:FindFirstChildOfClass("Humanoid") and v.Humanoid.Health > 0 and GetDistance(v.PrimaryPart,CastleCFrame) <= 1500 then 
                    KillNigga(v)
                end
            end
        end
    end
end
AutoMeleeFunc = function()
    if _G.MeleeTask == 'Find Library Key' then
        if not Sea2 then TeleportWorld(2) end  
        if _G.ServerData["PlayerBackpack"]['Library Key'] then 
            EquipWeaponName('Library Key')
            Tweento(CFrame.new(
                6375.9126,
                296.634583,
                -6843.14062,
                -0.849467814,
                1.5493983e-08,
                -0.527640462,
                3.70608895e-08,
                1,
                -3.0301031e-08,
                0.527640462,
                -4.5294577e-08,
                -0.849467814
            ))
        elseif _G.ServerData['Server Bosses']['Awakened Ice Admiral'] then 
            KillBoss(_G.ServerData['Server Bosses']['Awakened Ice Admiral'])  
            if not game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLibrary") and _G.ServerData['PlayerData'].Level >= 1450 then
                SetContent('Hopping for Ice Admiral',5)
                HopServer(10,true,"Ice Admiral")
            elseif _G.ServerData['PlayerData'].Level < 1450 then 
                _G.MeleeTask = '' 
            end
        elseif _G.ServerData['PlayerData'].Level >= 1450 and not game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLibrary") then
            SetContent('Hopping for Ice Admiral',5)
            HopServer(10,true,"Ice Admiral")
        end
    elseif _G.MeleeTask == 'Find Waterkey' then  
        if not Sea2 then TeleportWorld(2) end  
        if _G.ServerData["PlayerBackpack"]['Water Key'] then 
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true) 
        elseif _G.ServerData['Server Bosses']['Tide Keeper'] then 
            KillBoss(_G.ServerData['Server Bosses']['Tide Keeper']) 
            if (not _G.ServerData['Server Bosses']['Tide Keeper'] or _G.ServerData['Server Bosses']['Tide Keeper'].Humanoid.Health <= 0) and (type(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)) ~='string' or _G.ServerData['PlayerData'].Level < 1450) then   
                _G.MeleeTask = '' 
            end
        elseif _G.ServerData['PlayerData'].Level >= 1450 then
            SetContent('Hopping for Tide Keeper',5)
            HopServer(10,true,"Tide Keeper")
        else
            _G.MeleeTask= ''
        end 
    elseif _G.MeleeTask == 'Previous Hero Puzzle' then   
        if not Sea3 then TeleportWorld(3) end
        Tweento(GetNPC('Previous Hero').PrimaryPart.CFrame * CFrame.new(0,0,-2.5))
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectricClaw", "Start")
        Tweento(CFrame.new(-12548.8, 332.378, -7617.77)) 
        _G.MeleeTask = '' 
    elseif _G.MeleeTask == 'Find Fire Essence' then  
        if #_G.ServerData['Workspace Fruits'] > 0 then
            collectAllFruit_Store()
        elseif _G.ServerData['Server Bosses']['Soul Reaper'] then
            KillBoss(_G.ServerData['Server Bosses']['Soul Reaper'] )
        elseif _G.ServerData["PlayerBackpack"]['Hallow Essence'] then 
            EquipWeapon('Hallow Essence') 
            Tweento(game:GetService("Workspace").Map["Haunted Castle"].Summoner.Detection.CFrame) 
        elseif _G.ServerData['PlayerData'].Level >= 2000 then  
            if not game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then 
                FarmMobByLevel(2000)
            else 
                KillMobList({
                    "Reborn Skeleton [Lv. 1975]",
                    "Living Zombie [Lv. 2000]",
                    "Demonic Soul [Lv. 2025]",
                    "Posessed Mummy [Lv. 2050]"
                })
            end
        else 
            KillMobList({
                "Reborn Skeleton [Lv. 1975]",
                "Living Zombie [Lv. 2000]",
                "Demonic Soul [Lv. 2025]",
                "Posessed Mummy [Lv. 2050]"
            })
        end
    elseif _G.MeleeTask == 'Farm Godhuman' or _G.Config.FarmmingForGodhuman then 
        local FishTails = CheckMaterialCount('Fish Tail')
        local MagmaOre = CheckMaterialCount('Magma Ore')
        local MysticDroplet = CheckMaterialCount('Mystic Droplet') 
        local DragonScale = CheckMaterialCount('Dragon Scale') 
        if FishTails < 20 then 
            if not Sea1 then 
                TeleportWorld(1)
            else
                KillMobList({"Fishman Warrior","Fishman Commando"})
            end
        elseif MagmaOre < 20 then 
            if not Sea1 then 
                TeleportWorld(1)
            else
                KillMobList({"Military Spy","Military Soldier"})
            end
        elseif MysticDroplet < 10 then 
            if not Sea2 then 
                TeleportWorld(2)
            else
                KillMobList({"Sea Soldier","Water Fighter"})
            end
        elseif DragonScale < 10 then 
            if not Sea3 then 
                TeleportWorld(3)
            else
                KillMobList({"Dragon Crew Archer","Dragon Crew Warrior"})
            end 
        else
            _G.Config.GodhumanMaterialPassed = true
            TeleportWorld(3) 
        end
    end
end    
AutoMeleeMasteryCheck = function() 
    task.spawn(function()
        _G.FragmentNeeded = false
        _G.MeleeTask = 'None' 
        _G.MeleeWait = ''
        repeat task.wait() until _G.CheckAllMelee and _G.Config and _G.Config["Melee Level Values"]
        print('Hub: Loaded Melee') 
        while task.wait(1) do 
            local MLLV = _G.Config["Melee Level Values"]
            pcall(function()
                if MLLV["Superhuman"] == 0 then 
                    BuyMelee('Superhuman')
                    if MLLV["Black Leg"] < 300 then 
                        BuyMelee('Black Leg') 
                        SetMeleeWait('Black Leg',300)  
                    elseif MLLV["Electro"] < 300 then 
                        BuyMelee('Electro')    
                        SetMeleeWait('Electro',300)
                    elseif MLLV["Fishman Karate"] < 300 then 
                        BuyMelee('Fishman Karate')  
                        SetMeleeWait('Fishman Karate',300)
                    elseif MLLV["Dragon Claw"] < 300 then 
                        if MLLV['Dragon Claw'] == 0 then 
                            if _G.ServerData['PlayerData'].Fragments < 1500 then 
                                _G.FragmentNeeded = true 
                            else 
                                BuyMelee('Dragon Claw') 
                                _G.FragmentNeeded = false 
                            end
                        else 
                            BuyMelee('Dragon Claw') 
                            SetMeleeWait('Dragon Claw',300)
                        end 
                    else
                        BuyMelee('Superhuman')
                    end 
                elseif MLLV['Sharkman Karate'] == 0 or MLLV['Death Step'] == 0 or MLLV['Electric Claw'] == 0 or MLLV['Dragon Talon'] == 0 then 
                    if MLLV['Fishman Karate'] < 400 then 
                        BuyMelee('Fishman Karate')   
                        SetMeleeWait('Fishman Karate',400)
                    elseif MLLV['Black Leg'] < 400 then 
                        BuyMelee('Black Leg') 
                        SetMeleeWait('Black Leg',400)
                    elseif MLLV['Electro'] < 400 then 
                        BuyMelee('Electro') 
                        SetMeleeWait('Electro',400)
                    elseif MLLV['Dragon Claw'] < 400 then 
                        BuyMelee('Dragon Claw')  
                        SetMeleeWait('Dragon Claw',400)  
                    elseif MLLV['Superhuman'] < 400 then
                        BuyMelee('Superhuman')
                        SetMeleeWait('Superhuman',400)
                    elseif MLLV['Sharkman Karate'] > 0 and MLLV['Sharkman Karate'] < 400 then 
                        BuyMelee('Sharkman Karate')  
                        SetMeleeWait('Sharkman Karate',400)
                    elseif MLLV['Death Step'] > 0 and MLLV['Death Step'] < 400 then 
                        BuyMelee('Death Step')  
                        SetMeleeWait('Death Step',400)
                    elseif MLLV['Electric Claw'] > 0 and MLLV['Electric Claw'] < 400 then 
                        BuyMelee('Electric Claw')  
                        SetMeleeWait('Electric Claw',400)
                    elseif MLLV['Dragon Talon'] > 0 and MLLV['Dragon Talon'] < 400 then 
                        SetMeleeWait('Dragon Talon',400)
                        BuyMelee('Dragon Talon')
                    end   
                    if MLLV['Sharkman Karate'] == 0 then 
                        BuyMelee('Sharkman Karate')  
                    elseif MLLV['Death Step'] == 0 then 
                        BuyMelee('Death Step')  
                    elseif MLLV['Electric Claw'] == 0 then 
                        BuyMelee('Electric Claw')  
                    elseif MLLV['Dragon Talon'] == 0 then 
                        BuyMelee('Dragon Talon')   
                    end  
                elseif MLLV['Superhuman'] < 400 then
                    BuyMelee('Superhuman')
                    SetMeleeWait('Superhuman',400)
                elseif MLLV['Sharkman Karate'] < 400 then 
                    BuyMelee('Sharkman Karate')  
                    SetMeleeWait('Sharkman Karate',400)
                elseif MLLV['Death Step'] < 400 then 
                    BuyMelee('Death Step')  
                    SetMeleeWait('Death Step',400)
                elseif MLLV['Electric Claw'] < 400 then 
                    BuyMelee('Electric Claw')  
                    SetMeleeWait('Electric Claw',400)
                elseif MLLV['Dragon Talon'] < 400 then 
                    if MLLV['Dragon Talon'] > 0 then
                        SetMeleeWait('Dragon Talon',400)
                        BuyMelee('Dragon Talon') 
                    else
                        if (_G.ServerData["Inventory Items"]['Yama'] and _G.ServerData["Inventory Items"]['Yama'].Mastery < 350) or (_G.ServerData["Inventory Items"]['Tushita'] and _G.ServerData["Inventory Items"]['Tushita'].Mastery < 350) then 
                            _G.WeaponType = 'Sword'
                            if _G.ServerData["Inventory Items"]['Yama'] and _G.ServerData["Inventory Items"]['Yama'].Mastery < 350 then 
                                LoadItem('Yama')
                            elseif _G.ServerData["Inventory Items"]['Tushita'] and _G.ServerData["Inventory Items"]['Tushita'].Mastery < 350 then 
                                LoadItem('Tushita')
                            end
                        end
                    end
                elseif MLLV['Godhuman'] == 0 then 
                    if not _G.Config.AllV2MeleeStyles400Mastery then 
                        _G.Config.AllV2MeleeStyles400Mastery = true 
                    end 
                    if (_G.ServerData["Inventory Items"]['Yama'] and _G.ServerData["Inventory Items"]['Yama'].Mastery < 350) or (_G.ServerData["Inventory Items"]['Tushita'] and _G.ServerData["Inventory Items"]['Tushita'].Mastery < 350) then 
                        _G.WeaponType = 'Sword'
                        if _G.ServerData["Inventory Items"]['Yama'] and _G.ServerData["Inventory Items"]['Yama'].Mastery < 350 then 
                            LoadItem('Yama')
                        elseif _G.ServerData["Inventory Items"]['Tushita'] and _G.ServerData["Inventory Items"]['Tushita'].Mastery < 350 then 
                            LoadItem('Tushita')
                        end
                    end
                    if _G.Config.GodhumanMaterialPassed and _G.ServerData['PlayerData'].Fragments >= 5000 and _G.ServerData['PlayerData'].Beli >= 5000000 then 
                        BuyMelee('Godhuman')
                    end 
                else
                    if _G.ServerData["Inventory Items"]['Yama'] and _G.ServerData["Inventory Items"]['Yama'].Mastery < 350 then 
                        _G.WeaponType = 'Sword'
                        LoadItem('Yama')
                        SetMeleeWait('Yama',350)
                    elseif _G.ServerData["Inventory Items"]['Tushita'] and _G.ServerData["Inventory Items"]['Tushita'].Mastery < 350 then  
                        LoadItem('Tushita')
                        SetMeleeWait('Tushita',350)
                        _G.WeaponType = 'Sword'
                    elseif CheckEnabling('Auto Switch Melee') and MLLV['Godhuman'] < 600 then 
                        BuyMelee('Godhuman') 
                        _G.WeaponType = "Melee"
                        SetMeleeWait('Godhuman',600)
                    elseif CheckEnabling('Auto Switch Melee') and MLLV['Sharkman Karate'] < 450 then 
                        BuyMelee('Sharkman Karate')
                        _G.WeaponType = "Melee"
                        SetMeleeWait('Sharkman Karate',450)
                    elseif CheckEnabling('Auto Switch Melee') and MLLV['Death Step'] < 450 then 
                        BuyMelee('Death Step')
                        _G.WeaponType = "Melee"
                        SetMeleeWait('Death Step',450)
                    elseif CheckEnabling('Auto Switch Melee') and MLLV['Electric Claw'] < 450 then 
                        BuyMelee('Electric Claw')
                        _G.WeaponType = "Melee"
                        SetMeleeWait('Electric Claw',450)
                    elseif CheckEnabling('Auto Switch Melee') and MLLV['Dragon Talon'] < 450 then 
                        BuyMelee('Dragon Talon')
                        _G.WeaponType = "Melee"
                        SetMeleeWait('Dragon Talon',450)
                    elseif CheckEnabling('Auto Switch Melee') and    MLLV['Superhuman'] < 450 then 
                        BuyMelee('Superhuman')
                        _G.WeaponType = "Melee"
                        SetMeleeWait('Superhuman',450)
                    elseif _G.CurrentTask ~='Getting Cursed Dual Katana' then
                        _G.MasteryFarm = false
                        local SwordMasteryFarm,SwordMasteryFarm2 = getNextSwordToFarm()
                        if SwordMasteryFarm and not SwordMasteryFarm.Equipped then 
                            LoadItem(SwordMasteryFarm.Name) 
                        elseif SwordMasteryFarm and SwordMasteryFarm.Equipped then 
                            _G.WeaponType = 'Sword'   
                            SetMeleeWait(SwordMasteryFarm.Name,tonumber(SwordMasteryFarm2))
                        else
                            _G.WeaponType = 'Melee'
                        end
                    end
                end  
            end)
        end
    end)
end 
AutoMeleeMasteryCheck()
AutoMeleeCheck = function()
    task.spawn(function()
        _G.FragmentNeeded = false
        _G.MeleeTask = 'None'
        repeat task.wait() until _G.CheckAllMelee and _G.Config and _G.Config["Melee Level Values"]  
        local PreviousHeroRemoteFired = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectricClaw", true)  
        local MonkRemote = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman", true)

        _G.Config.PreviousHeroPassed = typeof(PreviousHeroRemoteFired) ~= 'string' 
        _G.Config.PreviousHeroPassed2 =  PreviousHeroRemoteFired ~= 4  
        _G.Config.WaterkeyPassed = typeof(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)) ~= 'string';   
        _G.Config.FireEssencePassed = typeof(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDragonTalon", true))~= 'string'   
        _G.Config.IceCastleDoorPassed = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLibrary")
        _G.Config.GodhumanMaterialPassed = typeof(MonkRemote) ~= 'string' and MonkRemote ~= 3        
        while task.wait() do 
            local MLLV = _G.Config["Melee Level Values"] 
            local v316, v317, v318, v319 = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Check")  
            if MLLV['Sharkman Karate'] == 0 or MLLV['Death Step'] == 0 or MLLV['Electric Claw'] == 0 or MLLV['Dragon Talon'] == 0  then 
                pcall(function()   
                    if not _G.Config.GodhumanMaterialPassed then 
                        local MonkRemote = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman", true)
                        _G.Config.GodhumanMaterialPassed = typeof(MonkRemote) ~= 'string' and MonkRemote ~= 3
                    end
                    if not _G.Config.WaterkeyPassed then 
                        _G.Config.WaterkeyPassed = typeof(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)) ~= 'string'; 
                    end  
                    
                    if not _G.Config.PreviousHeroPassed2 then  
                        local PreviousHeroRemoteFired = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyElectricClaw", true) 
                        _G.Config.PreviousHeroPassed = typeof(PreviousHeroRemoteFired) ~= 'string' 
                        _G.Config.PreviousHeroPassed2 =  PreviousHeroRemoteFired ~= 4  
                    end                    
                    if not _G.Config.FireEssencePassed then 
                        _G.Config.FireEssencePassed = typeof(game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyDragonTalon", true))~= 'string' 
                    end     
                    if not _G.Config.IceCastleDoorPassed then 
                        _G.Config.IceCastleDoorPassed = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLibrary")   
                    end 
                end) 
                if (not _G.Config.IceCastleDoorPassed) and (_G.ServerData["PlayerBackpack"]['Library Key'] or _G.ServerData['Server Bosses']['Awakened Ice Admiral'] or _G.ServerData['PlayerData'].Level >= 1450) then 
                    _G.MeleeTask = 'Find Library Key'
                elseif not _G.Config.WaterkeyPassed and (_G.ServerData['Server Bosses']['Tide Keeper'] or _G.ServerData['PlayerData'].Level >= 1450) then 
                    _G.MeleeTask = 'Find Waterkey' 
                elseif _G.ServerData['PlayerData'].Level >= 1650 and _G.Config.PreviousHeroPassed and not _G.Config.PreviousHeroPassed2 then  
                    if not Sea3 then 
                        TeleportWorld(3) 
                    else
                        _G.MeleeTask = 'Previous Hero Puzzle' 
                    end
                elseif not _G.HavingX2 and ((Sea3 and v318 and v318 > 0) or _G.ServerData['PlayerData'].Level >= 1650) and not _G.Config.FireEssencePassed then   
                    if not Sea3 then 
                        TeleportWorld(3) 
                    else 
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                        if v316 and v316 < v318*50 then 
                            _G.MeleeTask = 'Find Fire Essence' 
                        else
                            print(v316,'v316')
                            _G.MeleeTask = ''
                        end
                    end
                else
                    _G.MeleeTask = ''
                end  
            elseif _G.Config.AllV2MeleeStyles400Mastery and MLLV['Godhuman'] == 0 then 
                if not _G.Config.GodhumanMaterialPassed then 
                    local MonkRemote = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyGodhuman", true)
                    _G.Config.GodhumanMaterialPassed = typeof(MonkRemote) ~= 'string' and MonkRemote ~= 3
                end
                if not _G.Config.GodhumanMaterialPassed then 
                    _G.MeleeTask = 'Farm Godhuman' 
                else  
                    _G.MeleeTask = ''    
                end
            else   
                _G.Config.FarmmingForGodhuman = false
                _G.MeleeTask = ''
            end 
            task.wait(3)
        end
    end)
end
AutoMeleeCheck()
AutoRaceV2 = function()
    if not Sea2 then 
        repeat 
            TeleportWorld(2)
            task.wait(3)
        until Sea2 
    end
    if _G.ServerData["PlayerBackpack"]['Flower 1'] and _G.ServerData["PlayerBackpack"]['Flower 2'] and _G.ServerData["PlayerBackpack"]['Flower 3'] then 
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "3")
        wait(5)
        _G.CurrentTask = '' 
        SetContent('Upgraded V2 Race | Returning task...')
        return
    else
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "1")
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("Alchemist", "2") 
        if not _G.ServerData["PlayerBackpack"]['Flower 1'] then 
            SetContent('Getting Blue Flower (Flower 1)')
            if workspace.Flower1.Transparency ~= 1 then
                Tweento(workspace.Flower1.CFrame)   
            else  
                SetContent('Hopping for Blue Flower',5)
                HopServer(10,true,"Blue Flower")
            end
        elseif not _G.ServerData["PlayerBackpack"]['Flower 2'] then 
            SetContent('Getting Red Flower (Flower 2)')
            Tweento(workspace.Flower2.CFrame)
        else 
            repeat 
                SetContent('Getting Yellow Flower (Flower 3)')
                KillMobList({"Swan Pirate"})
                task.wait()
            until _G.ServerData["PlayerBackpack"]['Flower 3'] or not IsPlayerAlive() 

        end
    end
end

AutoBartiloQuest = function()
    local QuestBartiloId = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo")
    if QuestBartiloId == 0 then 
        SetContent('First Bartilo task...')
        if game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:find("Swan Pirate") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:find("50") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then 
            KillMobList({"Swan Pirate"})
            repeat 
                KillMobList({"Swan Pirate"})
            until not (game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:find("Swan Pirate") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:find("50") and game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible)
        else
            Tweento(CFrame.new(-456.28952, 73.0200958, 299.895966))
            if GetDistance(CFrame.new(-456.28952, 73.0200958, 299.895966)) < 10 then 
                local args = {
                    [1] = "StartQuest",
                    [2] = "BartiloQuest",
                    [3] = 1
                }
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))
            end
        end 
    elseif QuestBartiloId == 1 then 
        SetContent('Finding Jeremy...')
        if _G.ServerData['Server Bosses']['Jeremy'] then 
            KillBoss(_G.ServerData['Server Bosses']['Jeremy'])
            _G.CurrentTask = ''
        elseif _G.ServerData['PlayerData'].Level > 500 then  
            SetContent('Hopping for Bartilo',5)
            HopServer(9,true,"Jeremy Boss")
        end
    elseif QuestBartiloId == 2 then 
        local StartCFrame =
        CFrame.new(
        -1837.46155,
        44.2921753,
        1656.19873,
        0.999881566,
        -1.03885048e-22,
        -0.0153914848,
        1.07805858e-22,
        1,
        2.53909284e-22,
        0.0153914848,
        -2.55538502e-22,
        0.999881566
    )
        if GetDistance(StartCFrame) > 400 then 
            SetContent('Starting templates puzzle...')
            Tweento(StartCFrame)
        else
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1836, 11, 1714)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1850.49329, 13.1789551, 1750.89685)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1858.87305, 19.3777466, 1712.01807)
            task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1803.94324, 16.5789185, 1750.89685)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1858.55835, 16.8604317, 1724.79541)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1869.54224, 15.987854, 1681.00659)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1800.0979, 16.4978027, 1684.52368)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1819.26343, 14.795166, 1717.90625)
                task.wait(.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(-1813.51843, 14.8604736, 1724.79541)
                _G.CurrentTask = ''
                SetContent('Done task | Returning task...')
        end
    end
end 

AutoSea2 = function()  
    if game.Workspace.Map.Ice.Door.CanCollide then
        if not _G.ServerData["PlayerBackpack"]['Key'] then  
            SetContent('Getting key to pass the door...')
            Tweento(CFrame.new(4852.2895507813, 5.651451587677, 718.53070068359))
            if GetDistance(CFrame.new(4852.2895507813, 5.651451587677, 718.53070068359)) < 5 then
                game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("DressrosaQuestProgress", "Detective")
                if _G.ServerData["PlayerBackpack"]['Key'] then EquipWeaponName("Key") end
            end 
        else 
            SetContent('Opening door...')
            EquipWeaponName("Key")
            if game:GetService("Players").LocalPlayer.Character:FindFirstChild("Key") then
                Tweento(game.Workspace.Map.Ice.Door.CFrame)
            end
        end
    else 
        SetContent('Finding Ice Admiral...')
        if _G.ServerData['Server Bosses']['Ice Admiral'] then 
            KillBoss(_G.ServerData['Server Bosses']['Ice Admiral']) 
            refreshTask()
            task.delay(5,function()
                game.ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa") 
            end)
            _G.CurrentTask = ''
        elseif _G.ServerData['PlayerData'].Level >= 700 then
            if GetDistance(CFrame.new(4852.2895507813, 5.651451587677, 718.53070068359)) < 1000 then   
                SetContent('Hopping for Ice Admiral',5)
                HopServer(9,true,"Ice Admiral")
            else
                Tweento(CFrame.new(4852.2895507813, 5.651451587677, 718.53070068359))
            end
        end
    end
end
AutoPole = function()
    if not Sea1 then 
        --TeleportWorld(1)
    end
    if _G.Config.OwnedItems["Pole (1st Form)"] then 
        refreshTask()
        return
    end 
        if _G.ServerData['Server Bosses']['Thunder God'] then 
            KillBoss(_G.ServerData['Server Bosses']['Thunder God'])
            _G.CurrentTask = ''
        elseif _G.ServerData['PlayerData'].Level > 500 then  
            SetContent('Hopping for Thunder God',5)
            HopServer(9,true,'Thunder God')
        end
end
local function IsUnlockedSaberDoor()
    for i, v in next, game:GetService("Workspace").Map.Jungle.Final:GetChildren() do
        if v:IsA("Part") and not v.CanCollide then
            return true
        end
    end
end  
local function SaberTouchTemplate()
    for i, v in next, game:GetService("Workspace").Map.Jungle.QuestPlates:GetChildren() do
        if v:IsA("Model") then
            if v.Button:FindFirstChild("TouchInterest") then
                return v
            end
        end
    end
end 
local function CupDoor()
    return workspace.Map.Desert.Burn.Part.CanCollide == false
end
AutoSaber = loadstring(game:HttpGet('https://raw.githubusercontent.com/memaybeohub/NewPage/main/AutoSaber.lua'))()--[[function()
    if not Sea1 then 
        --TeleportWorld(1)
        return;
    end
    task.wait()
    local RichSonProgress = -999
    if _G.Config.OwnedItems["Saber"] then 
        _G.CurrentTask = ''
        return
    end
    if IsUnlockedSaberDoor() then 
        SetContent('Finding Saber Expert...')
        if _G.ServerData['Server Bosses']['Saber Expert'] then 
            KillBoss(_G.ServerData['Server Bosses']['Saber Expert'])  
            if not _G.ServerData['Server Bosses']['Saber Expert'] or not _G.ServerData['Server Bosses']['Saber Expert']:FindFirstChildOfClass('Humanoid') or _G.ServerData['Server Bosses']['Saber Expert']:FindFirstChildOfClass('Humanoid').Health <= 0 then 
                _G.CurrentTask = ''
            end
        elseif _G.ServerData['PlayerData'].Level > 200 then  
            SetContent('Hopping for Shanks',5)
            HopServer(9,true,"Shanks")
        end 
    elseif game:GetService("Workspace").Map.Jungle.QuestPlates.Door.CanCollide then 
        SetContent('Touching templates in jungle...')
        local Template = SaberTouchTemplate()
        if Template then 
            Tweento(Template.Part.CFrame)
        end
    elseif CupDoor() then 
        RichSonProgress = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
        if RichSonProgress ~= 0 and RichSonProgress ~= 1 then
            if not _G.ServerData["PlayerBackpack"]['Cup'] then 
                Tweento(CFrame.new(1113.66992,7.5484705,4365.27832,-0.78613919,-2.19578524e-08,-0.618049502,1.02977182e-09,1,-3.68374984e-08,0.618049502,-2.95958493e-08,-0.78613919)) 
                SetContent('Getting cup')
            else
                EquipWeaponName('Cup')
                if _G.ServerData["PlayerBackpack"]['Cup'].Handle:FindFirstChild('TouchInterest') then 
                    SetContent('Filling cup with water...')
                    Tweento(CFrame.new(1395.77307,37.4733238,-1324.34631,-0.999978602,-6.53588605e-09,0.00654155109,-6.57083277e-09,1,-5.32077493e-09,-0.00654155109,-5.3636442e-09,-0.999978602))  
                else 
                    SetContent('Feeding sick man...')
                    Tweento(CFrame.new(1457.8768310547, 88.377502441406, -1390.6892089844))
                    if GetDistance(CFrame.new(1457.8768310547, 88.377502441406, -1390.6892089844)) < 10 then 
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                            "ProQuestProgress",
                            "SickMan"
                        )
                    end
                end
            end
        elseif RichSonProgress == 0 then
            SetContent('Finding Mob Leader...')
            if _G.ServerData['Server Bosses']['Mob Leader'] then 
                KillBoss(_G.ServerData['Server Bosses']['Mob Leader']) 
            elseif _G.ServerData['PlayerData'].Level > 500 then  
                SetContent('Hopping for Mob Leader',5)
                HopServer(9,true,"Mob Leader")  
            end
        elseif RichSonProgress == 1 then
            if _G.ServerData["PlayerBackpack"]['Relic'] then 
                EquipWeaponName("Relic") 
                Tweento(CFrame.new(-1405.3677978516, 29.977333068848, 4.5685839653015))
            else
                Tweento(CFrame.new(-1404.07996,29.8520069,5.26677656,0.888123989,-4.0340602e-09,0.459603906,7.5884703e-09,1,-5.8864642e-09,-0.459603906,8.71560069e-09,0.888123989))
                if GetDistance(CFrame.new(-1404.07996,29.8520069,5.26677656,0.888123989,-4.0340602e-09,0.459603906,7.5884703e-09,1,-5.8864642e-09,-0.459603906,8.71560069e-09,0.888123989)) < 10 then 
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
                end
            end
        end
    else 
        SetContent('Getting torch...')
        if not _G.ServerData["PlayerBackpack"]['Torch'] then  
            Tweento(game:GetService("Workspace").Map.Jungle.Torch.CFrame)
        else  
            EquipWeaponName("Torch") 
            Tweento(CFrame.new(1115.23499,4.92147732,4349.36963,-0.670654476,-2.18307523e-08,0.74176991,-9.06980624e-09,1,2.1230365e-08,-0.74176991,7.51052998e-09,-0.670654476))
        end  
    end
end]]
