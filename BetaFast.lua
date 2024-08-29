local get = setmetatable({}, {
    __index = function(a, b)
        return game:GetService(b) or game[b]
    end
})

local Players = get.Players
local CharactersFolder = workspace.Characters
local Client = Players.localPlayer;

local findobj, findobjofclass, waitforobj = get.FindFirstChild, get.FindFirstChildOfClass, get.WaitForChild
local CombatFramework = require(waitforobj(Client.PlayerScripts, "CombatFramework"))
local CombatFrameworkR = debug.getupvalues(CombatFramework)[2]
local RigLib = require(waitforobj(game.ReplicatedStorage.CombatFramework, "RigLib"))

local VU = get.VirtualUser
require(Client.PlayerScripts.CombatFramework.Particle).play = function() end
require(game.ReplicatedStorage.Util.CameraShaker):Stop()
RigLib.wrapAttackAnimationAsync = function(p_u_28, p_u_29, p_u_30, p_u_31, p_u_32)
    local ac = CombatFrameworkR.activeController
    if ac and ac.equipped then
        local v37 = RigLib.getBladeHits(p_u_29, p_u_30, p_u_31)
        if #v37 > 0 then
            p_u_32(v37)
        end
    end
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
local abc = require(game:GetService("ReplicatedStorage").CombatFramework.RigLib)
local plr = game.Players.LocalPlayer

getgenv().AttackHit = function()
    for i = 1, 1 do
        if (getgenv().CurrentCharHum and getgenv().CurrentCharHum.Parent.Stun.Value <= 0)  then 
            local bladehit = abc.getBladeHits(plr.Character,{plr.Character.HumanoidRootPart},60)
            if #bladehit > 0 then
                pcall(function()
                    CombatFrameworkR.activeController.timeToNextAttack = -1
                    CombatFrameworkR.activeController.attacking = false
                    CombatFrameworkR.activeController.blocking = false
                    CombatFrameworkR.activeController.timeToNextBlock = 0
                    CombatFrameworkR.activeController.increment = math.huge
                    CombatFrameworkR.activeController.hitboxMagnitude = 200
                    CombatFrameworkR.activeController.focusStart = 0
                    game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange",tostring(p13.currentWeaponModel))
                    game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, 1, "")
                end)
            end
        end
    end
end
getgenv().AttackFunction = function()
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
        if _G.UseFAttack then 
            task.spawn(AttackFunction)
            task.spawn(AttackHit)
            task.wait(.15)
        end
    end
end)