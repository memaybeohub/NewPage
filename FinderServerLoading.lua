local HOSTURL = 'http://103.238.234.228'
getgenv().blacklistedservers = {}
getgenv().FindServer = function(typeFind,findStr,callCheck)
    if not blacklistedservers then 
        getgenv().blacklistedservers = {}
    end
    local url = HOSTURL..':10000/find/'..tostring(typeFind).."/"..tostring(findStr)
    local starting = tick()
    local chooses
    local foundServers = game:GetService('HttpService'):JSONDecode(game:HttpGet(url))
    local realtime = tonumber(game:HttpGet(HOSTURL..':10000/time'))
    callCheck = callCheck or function() return true end 
    for i,v in foundServers do 
        if (not blacklistedservers[i] or blacklistedservers[i] < 5 )
        and tonumber(string.split(v.NumPlayer,'/')[1]) < 10
         and v._id ~= game.JobId 
         and callCheck(v,realtime) then 
            chooses = v
            blacklistedservers[v._id] = blacklistedservers[v._id] and blacklistedservers[v._id]+1 or 1
        end
    end
    return chooses
end 
getgenv().AutoRipIndraHop = function()
    if not blacklistedservers then 
        getgenv().blacklistedservers = {}
    end
    local chooses
    local min = math.huge
    local realtime = tonumber(game:HttpGet(HOSTURL..':10000/time')) 
    for i,v in pairs(game:GetService('HttpService'):JSONDecode(game:HttpGet(HOSTURL..":10000/steal/boss"))) do 
        if v.boss:find('rip') and realtime-v.foundOn < min and v.count < 12 and (not blacklistedservers[i] or blacklistedservers[i] < 5 ) then 
            min = realtime-v.foundOn
            chooses = v 
            chooses._id = i
        end
    end
    if chooses and chooses._id and min < 20 then 
        if SetContent then 
            SetContent('Hopping for drip india '..tostring(min))
        end
        if not blacklistedservers[chooses._id] then 
            blacklistedservers[chooses._id] = 0 
        end
        blacklistedservers[chooses._id]+=1
        print(blacklistedservers[chooses._id],'time',blacklistedservers[chooses._id] < 5)
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, chooses._id, game.Players.LocalPlayer)
    end
    return chooses
end
getgenv().AutoMirageIslandHop = function()
    if not blacklistedservers then 
        getgenv().blacklistedservers = {}
    end
    local chooses
    local min = math.huge
    local realtime = tonumber(game:HttpGet(HOSTURL..':10000/time')) 
    for i,v in pairs(game:GetService('HttpService'):JSONDecode(game:HttpGet(HOSTURL..":10000/steal/mirage"))) do 
        if realtime-v.foundOn < min and v.count < 12 and (not blacklistedservers[i] or blacklistedservers[i] < 5 ) then 
            min = realtime-v.foundOn
            chooses = v 
            chooses._id = i
        end
    end
    if chooses and chooses._id and min < 20 then 
        if SetContent then 
            SetContent('Hopping for mirage '..tostring(min))
        end
        if not blacklistedservers[chooses._id] then 
            blacklistedservers[chooses._id] = 0 
        end
        blacklistedservers[chooses._id]+=1
        print(blacklistedservers[chooses._id],'time',blacklistedservers[chooses._id] < 5)
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, chooses._id, game.Players.LocalPlayer)
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