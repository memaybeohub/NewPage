local blacklistedservers = {}
getgenv().FindServer = function(typeFind,findStr,callCheck)
    local url = 'http://103.77.173.109:10000/find/'..tostring(typeFind).."/"..tostring(findStr)
    local starting = tick()
    local chooses
    local foundServers = game:GetService('HttpService'):JSONDecode(game:HttpGet(url))
    local realtime = tonumber(game:HttpGet('http://103.77.173.109:10000/time'))
    callCheck = callCheck or function() return true end 
    for i,v in foundServers do 
        if not (blacklistedservers[v._id] or blacklistedservers[v._id] >= 5) and tonumber(string.split(v.NumPlayer,'/')[1]) < 10 and v._id ~= game.JobId and callCheck(v,realtime) then 
            chooses = v
            blacklistedservers[v._id] = blacklistedservers[v._id] and blacklistedservers[v._id]+1 or 1
        end
    end
    return chooses
end 
getgenv().AutoRipIndraHop = function()
    local chooses
    local min = math.huge
    local realtime = tonumber(game:HttpGet('http://103.77.173.109:10000/time')) 
    for i,v in pairs(game:GetService('HttpService'):JSONDecode(game:HttpGet("http://103.77.173.109:10000/steal/boss"))) do 
        if not (blacklistedservers[v._id] or blacklistedservers[v._id] >= 5) and v.boss:find('rip') and realtime-v.foundOn < min and v.count < 12 then 
            min = realtime-v.foundOn
            chooses = v 
            chooses._id = i
            blacklistedservers[v._id] = blacklistedservers[v._id] and blacklistedservers[v._id]+1 or 1
        end
    end
    if chooses and choose._id then 
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, choose._id, game.Players.LocalPlayer)
    end
    return chooses
end
getgenv().FindAndJoinServer = function(typeFind,findStr,callCheck)
    local xiuz = FindServer(typeFind,findStr,callCheck)
    if xiuz and xiuz._id and xiuz._id ~= 'None' then
        table.foreach(xiuz,print)
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, xiuz._id, game.Players.LocalPlayer)
    end
end 