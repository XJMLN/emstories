Players = {}
Players.all = {}

--- @function Players.getAllPlayers
--- Get all players
Players.getAllPlayers = function()
    return Players.all
end

--- @function Players.forEach
--- Excecute callback for all players
Players.forEach = function(callback)
    for k,v in pairs(Players.all) do
        callback(v)
    end
end

--- @function Players.set
--- Add player to Player.all
Players.set = function(id, player)
    Players.all[tostring(id)] = player
end

--- @function Players.fromIdentifier
--- Get Player from Identifier
Players.fromIdentifier = function(identifier)
    for k,v in pairs(Players.all) do
        if v.identifier == identifier then
            return v
        end
    end
    return nil
end

--- @function Players.load
Players.load = function(identifier, playerId, callback)
    print("Loading "..GetPlayerName(playerId).. " ("..playerId.." | "..identifier..")")

    MySQL.Async.fetchAll("SELECT * FROM em_users WHERE identifier=@identifier",{["@identifier"]=identifier},function(result)
        local row = result[1]
        local userData = {
            playerId = playerId,
            identifier = identifier,
            name = GetPlayerName(playerId)
        }
        Players.set(playerId,userData)

        if (callback ~= nil) then
            callback(callback)
        end
        print('loaded ' .. GetPlayerName(playerId) .. ' (' .. playerId .. '|' .. identifier .. ')')
    end)

end

Players.saveAll = function(cb)
    Players.forEach(function(player) player:save() end)
end

Players.onJoin = function(playerId)
    local identifier
    for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
        if string.match(v, 'license:') then
            identifier = string.sub(v, 9)
            break
        end
    end
    
    if (identifier) then
        if Players.fromIdentifier(identifier) then
            DropPlayer(playerId,"Wystąpił problem podczas ładowania Twojego konta!\nKod błędu: same-identifier-ingame\n\nBłąd jest spowodowany przez gracza który posiada ten sam identyfikator jak Twój.")
        else
            print('client connected =>', GetPlayerName(playerId) .. ' (' .. playerId .. '|' .. identifier .. ')')
            MySQL.Async.fetchScalar('SELECT 1 FROM em_users WHERE identifier = @identifier', {['@identifier'] = identifier}, 
            function(result)
                if result then
                    MySQL.Async.execute("UPDATE em_users SET datetime_last=NOW() WHERE identifier=@identifier",{['@identifier']=identifier},function(rowChanged)
                        Players.load(identifier,playerId)
                    end)
                else
                    MySQL.Async.execute("INSERT INTO em_users (login,license) VALUES (@login,@identifier)",{
                        ["@login"]=GetPlayerName(playerId),
                        ["@identifier"]=identifier
                    },function(rowsChanged)
                        Players.load(identifier,playerId)
                    end)
                end
            end)
        end
    else
        DropPlayer(playerId,"Wystąpił problem podczas ładowania Twojego konta!\nKod błędu: no-identifier-ingame\n\nPrzyczyna błędu jest nie znana, Twój identyfikator nie został znaleziony. Połącz się ponownie.")
    end
end

function Players:save(cb)
    print('saving')
end
RegisterNetEvent("playerJoining")
AddEventHandler("playerJoining",function()
    local playerId = source
    Players.onJoin(playerId)
end)