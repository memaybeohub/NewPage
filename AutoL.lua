local namequest
local BlackListedKillPlayers = {}
IsBossDrop = function()
    if _G.HavingX2 then return end 
    if CheckEnabling and CheckEnabling('Farming Boss Drops When X2 Expired') then     
        if _G.BossDropTable then 
            for i,v in _G.BossDropTable do 
                if _G.ServerData['Server Bosses'][v] then 
                    return _G.ServerData['Server Bosses'][v]
                end
            end
        end
    end
end
getgenv().AutoL = function()
    if _G.QuestKillPlayer and not game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then 
        _G.QuestKillPlayer = false 
    end 
    local BOSSCP =  _G.ServerData['Server Bosses']['Dark Beard'] or _G.ServerData['Server Bosses']['Cake Prince'] or _G.ServerData['Server Bosses']['Dough King'] 
    if Sea3 and (not game:GetService("Workspace").Map.Turtle:FindFirstChild("TushitaGate") or _G.ServerData['PlayerData'].Level < 2000 )and not BOSSCP and _G.ServerData['Server Bosses']['rip_indra True Form'] then 
        BOSSCP = _G.ServerData['Server Bosses']['rip_indra True Form'] 
    end
    if not BOSSCP then 
        BOSSCP = IsBossDrop()
    end
    if game.PlaceId == 2753915549 and not _G.QuestKillPlayer and game.Players.LocalPlayer.Data.Level.Value >= 50 and game.ReplicatedStorage.Remotes["CommF_"]:InvokeServer("PlayerHunter") ~="I don't have anything for you right now. Come back later." then 
        namequest =
            string.gsub(
            game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,
            "Defeat ",
            ""
        )
        namequest = string.gsub(namequest, " %p(0/1)%p", "") 
        if
            game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible and
                namequest and
                game:GetService("Workspace").Characters:FindFirstChild(namequest)
            then
                _G.QuestKillPlayer = true
        end
    elseif game.PlaceId == 2753915549 and game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible and _G.QuestKillPlayer then 
        namequest =
            string.gsub(
            game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text,
            "Defeat ",
            ""
        )
        namequest = string.gsub(namequest, " %p(0/1)%p", "") 
        if #BlackListedKillPlayers >= 8 then 
            repeat 
                warn('Start Hop Server')
                HopServer(10,false,'Player Hunter Quest') 
                CancelKillPlayer() 
                task.wait(5) 
            until 5 > 6
        end
        if game.Players.LocalPlayer.PlayerGui.Main.PvpDisabled.Visible then 
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
        else
            if
            game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible and
                not game:GetService("Workspace").Characters:FindFirstChild(namequest)
            then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                warn('Cancel: not found')
            end
            if
                game.Players[namequest].Data.Level.Value < 20 or
                    game.Players[namequest].Data.Level.Value > game.Players.LocalPlayer.Data.Level.Value +300
            then
                table.insert(BlackListedKillPlayers, namequest)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                _G.QuestKillPlayer = false 
                warn('Cancel: not enough requirements |',namequest)
            end 
            if game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then
                if KillPlayer(namequest) then 
                    _G.QuestKillPlayer = false 
                    return;
                else
                    table.insert(BlackListedKillPlayers, namequest)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    _G.QuestKillPlayer = false
                end
            end
        end
    elseif not _G.QuestKillPlayer and game.PlaceId == 2753915549 and game.Players.LocalPlayer.Data.Level.Value < 120 and game.Players.LocalPlayer.Data.Level.Value >= 15 then 
        KillMobList({"Royal Squad [Lv. 525]", "Shanda [Lv. 475]"}) 
    elseif Sea2 and _G.ServerData["PlayerBackpack"]['Hidden Key'] and not _G.ServerData["Inventory Items"]["Rengoku"] then 
        if game.ReplicatedStorage.Remotes.CommF_:InvokeServer("OpenRengoku") then 
            return 
        end
        EquipWeaponName('Hidden Key')
        Tweento(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875)) 
    elseif Sea2 and (_G.ServerData["PlayerBackpack"]['Library Key'] and not _G.Config.IceCastleDoorPassed) or _G.ServerData["PlayerBackpack"]['Water Key'] then 
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
        else 
            game.ReplicatedStorage.Remotes.CommF_:InvokeServer("BuySharkmanKarate", true) 
        end
    elseif Sea2 and _G.ServerData['PlayerData'].Level >= 1350 and not _G.Config.IceCastleDoorPassed and _G.ServerData['PlayerData'].Level < 1425 and _G.ServerData['Server Bosses']['Awakened Ice Admiral'] then
        KillBoss(_G.ServerData['Server Bosses']['Awakened Ice Admiral']) 
    elseif Sea2 and _G.ServerData['PlayerData'].Level >= 1425 and not _G.Config.WaterkeyPassed and _G.ServerData['Server Bosses']['Tide Keeper'] then 
        KillBoss(_G.ServerData['Server Bosses']['Tide Keeper'])
    elseif _G.ServerData['PlayerData'].Level >= 200 and BOSSCP then 
        task.spawn(function()
            if Sea3 and not _G.LGBTCOLORQUEST then 
                local faired = game.ReplicatedStorage.Remotes.CommF_:InvokeServer("HornedMan")
                _G.LGBTCOLORQUEST = typeof(faired) ~= 'string'
                if not _G.LGBTCOLORQUEST and faired:find(BOSSCP.Name) then 
                    game.ReplicatedStorage.Remotes.CommF_:InvokeServer("HornedMan", "Bet")
                end
            end
        end)
        KillBoss(BOSSCP)
    elseif not _G.QuestKillPlayer and (_G.ServerData['PlayerData'].Level < 2550 or game.PlaceId ~= 7449423635 ) then
        FarmMobByLevel()
    else 
        if not game.Players.LocalPlayer.PlayerGui.Main:FindFirstChild("Quest").Visible then 
            FarmMobByLevel((function()
                local a = {2200,2250}
                return a[math.random(1,2)]
            end)())
        else 
            KillMobList({
                "Cookie Crafter",
                "Cake Guard",
                "Head Baker",
                "Baking Staff"
            })
        end
    end
end