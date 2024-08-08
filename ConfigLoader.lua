local ConfigName = 'WhatABadConfig'..game.Players.LocalPlayer.Name..'.json'
local HttpService = game:GetService("HttpService")
_G.Config = {} 
local function SaveConfig()
    writefile(ConfigName,HttpService:JSONEncode(_G.Config))
end
local function LoadConfig()
    local IsFile,Data = pcall(function()
        return HttpService:JSONDecode(readfile(ConfigName))
    end)
    if IsFile then 
        if not Data or typeof(Data) ~='table' then 
            SaveConfig()
            LoadConfig()
        end
        _G.Config = Data 
        print('Readed data:',_G.Config)
        return Data 
    else
        print('You doesnt have a data file, creating new one...')
        SaveConfig()
        LoadConfig()
    end
end
LoadConfig()
task.spawn(function()
    while task.wait(.5) do 
        SaveConfig()
        if not _G.Config or typeof(_G.Config) ~= 'table' then 
            LoadConfig()
        end
    end
end)  
_G.LoadedData = true
print('Hub: Loaded Configure')