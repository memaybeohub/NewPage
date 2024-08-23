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
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local RigLib = require(waitforobj(game.ReplicatedStorage.CombatFramework, "RigLib"))

local VU = get.VirtualUser
require(Client.PlayerScripts.CombatFramework.Particle).play = function() end
require(game.ReplicatedStorage.Util.CameraShaker):Stop()
RigLib.wrapAttackAnimationAsync = function(p_u_28, p_u_29, p_u_30, p_u_31, p_u_32)
    local ac = CombatFrameworkR.activeController
    local v_u_36 = tick()
    if ac and ac.equipped then
        local v37 = RigLib.getBladeHits(p_u_29, p_u_30, p_u_31)
        if #v37 > 0 then
            do
                p_u_32(v37)
                if true and tick() - v_u_36 > 0.00014 then
                    ReplicatedStorage.RigControllerEvent:FireServer("weaponChange", tostring(ac.currentWeaponModel))
                end
            end
        end
    end
end
--[[
task.spawn(function()
    repeat task.wait(1) until game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool') and (game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool').ToolTip == 'Melee' or game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool').ToolTip == 'Sword')
    print('found tool',game.Players.LocalPlayer.Character:FindFirstChildOfClass('Tool').Name)
    local acc5 = getupvalues(require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework))[2].activeController
    if not acc5 or not acc5.equipped then 
        repeat task.wait()
        until acc5 and acc5.equipped
    end
    for i,v in pairs(acc5.data) do  
        if typeof(v) == 'function' then 
            hookfunction(v,function() end )
        end
    end
end)
]]
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
        if _G.UseFAttack then 
            print('Using fat')
            AttackFunction()
        end
    end
end)