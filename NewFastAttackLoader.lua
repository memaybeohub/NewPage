if hookfunction and not islclosure(hookfunction) then 
    for i,v in pairs(game.ReplicatedStorage.Assets.GUI:GetChildren()) do 
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
                    if i and #i > 0 then
                        h(i)
                        b.play = shared.cpc
                    end
                end
            end)
        end
    end)
end
local old = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
local com = getupvalue and getupvalue(old, 2) or debug and debug.getupvalue and debug.getupvalue(old, 2) or getupvalues and getupvalues(old)[2] or debug.getupvalues and debug.getupvalues(old)[2]
require(game.ReplicatedStorage.Util.CameraShaker):Stop()
local lastAttack = 0
game:GetService("RunService").Stepped:Connect(
    function()
        pcall(
            function()
                if not _G.CurrentCharHum or not _G.CurrentCharHum.Parent or _G.CurrentCharHum.ClassName ~='Humanoid' then 
                    _G.CurrentCharHum = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
                end
                if (_G.UseFAttack or UseFastAttack) and (_G.CurrentCharHum and _G.CurrentCharHum.Parent.Stun.Value == 0) and tick()-lastAttack >= .05 then
                    lastAttack = tick()
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
            end
        )
    end
)
