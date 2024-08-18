local Players = game.Players
local CharactersFolder = workspace.Characters
local Client = Players.localPlayer;

local CombatFramework = require(Client.PlayerScripts:WaitForChild("CombatFramework"))
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local RigLib = require(game.ReplicatedStorage.CombatFramework:WaitForChild("RigLib"))


RigLib.wrapAttackAnimationAsync = function(p_u_28, p_u_29, p_u_30, p_u_31, p_u_32)
    local ac = CombatFrameworkR.activeController
    local v_u_36 = tick()
    if ac and ac.equipped then
        local v37 = RigLib.getBladeHits(p_u_29, p_u_30, p_u_31)
        if #v37 > 0 then
            do
                p_u_32(v37)
                if true and tick() - v_u_36 > 0.00164432 then
                    ReplicatedStorage.RigControllerEvent:FireServer("weaponChange", tostring(ac.currentWeaponModel))
                end
            end
        end
    end
end

function AttackFunction()
    local ac = CombatFrameworkR.activeController
    if ac and ac.equipped then
        if not getgenv().CurrentCharHum or not getgenv().CurrentCharHum.Parent or getgenv().CurrentCharHum.ClassName ~='Humanoid' then 
            getgenv().CurrentCharHum = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
        end
        if (getgenv().CurrentCharHum and getgenv().CurrentCharHum.Parent.Stun.Value <= 0) then
            ac.hitboxMagnitude = 60
            ac.active = false
            ac.blocking = false
            ac.focusStart = 0
            ac.hitSound = nil
            ac.increment = 0
            ac.timeToNextAttack = 0
            ac.timeToNextBlock = 0
            pcall(function()
                ac:attack()
            end)
        end
    end
end

task.spawn(function()
while task.wait() do 
    task.spawn(AttackFunction)
end
    end
