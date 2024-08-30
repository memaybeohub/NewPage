if _G.AttackFunction2 or getgenv().AttackFunction or AttackFunction then return end
task.spawn(function()
	_G.FastAttackDelay = _G.FastAttackDelay or 0.05
	if hookfunction and not islclosure(hookfunction) then
		for i, v in pairs(game.ReplicatedStorage.Assets.GUI:GetChildren()) do
			v.Enabled = false
		end
		abc = true
		task.spawn(function()
			local a = game.Players.LocalPlayer
			local b = require(a.PlayerScripts.CombatFramework.Particle)
			local c = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
			if not shared.orl then
				shared.orl = c.wrapAttackAnimationAsync
			end
			if not shared.cpc then
				shared.cpc = b.play
			end
			if abc then
				pcall(function()
					c.wrapAttackAnimationAsync = function(d, e, f, g, h)
						local i = c.getBladeHits(e, f, g)
						if i then
							b.play = function()
							end
							d:Play(1, 1, 0.001)
							h(i)
							b.play = shared.cpc
							wait(.5)
							d:Stop()
						end
					end
				end)
			end
		end)
	end
    task.spawn(function()
        for i = 1,5 do 
            repeat task.wait(1) until game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool') and (game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool').ToolTip == 'Melee' or game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool').ToolTip == 'Sword')
            print('found tool',game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool').Name)
            local acc5 = debug.getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2].activeController
            if not acc5 or not acc5.equipped then 
                repeat task.wait()
                until acc5 and acc5.equipped
            end
            for i,v in pairs(acc5.data) do  
                if typeof(v) == 'function' then 
                    hookfunction(v,function() end )
                end
            end
            wait(1+2)
        end
    end)
	local old = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
	local com = debug.getupvalue(old, 2)
	require(game.ReplicatedStorage.Util.CameraShaker):Stop()
	while task.wait(.1) do 
		task.spawn(pcall,function()
			if not getgenv().CurrentCharHum or not getgenv().CurrentCharHum.Parent or getgenv().CurrentCharHum.ClassName ~= 'Humanoid' then
				getgenv().CurrentCharHum = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
			end
			com.activeController.hitboxMagnitude = 60
			if (_G.UseFAttack) and (getgenv().CurrentCharHum and getgenv().CurrentCharHum.Parent.Stun.Value <= 0) then
				com.activeController.hitboxMagnitude = 60
				com.activeController.active = false
				com.activeController.blocking = false
				com.activeController.focusStart = 0
				com.activeController.hitSound = nil
				com.activeController.increment = 0
				com.activeController.timeToNextAttack = 0
				com.activeController.timeToNextBlock = 0
				com.activeController:attack()
			end
		end)
	end
end)
getgenv().AttackFunction = true
_G.AttackFunction2 = true
