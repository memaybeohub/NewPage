getgenv().AutoFullMoon = function()
    local url = 'http://103.238.234.228:10000/find/moon/Full%20Moon'
    local starting = tick()
    local nearest = -math.huge 
    local chooses
    local foundServers = game:GetService('HttpService'):JSONDecode(game:HttpGet(url))
    local realtime = tonumber(game:HttpGet('http://103.238.234.228:10000/time'))
    for i,v in foundServers do 
        if not v.Mess:find('End') and tonumber(string.split(v.NumPlayer,'/')[1]) < 10 and v._id ~= game.JobId and v.MoonOn >= realtime and realtime-v.MoonOn > nearest then 
            nearest = realtime-v.MoonOn
            chooses = v
        end
    end
    print(chooses.NumPlayer,nearest)
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, chooses._id, game.Players.LocalPlayer)
end





























