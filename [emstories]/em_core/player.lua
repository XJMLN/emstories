Players = Extends(nil)
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

Players.fromId = function(id)
    return Players.all[tostring(id)]
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
            name = GetPlayerName(playerId),
            skin = row.skin,
            money = tonumber(row.money),
            UID = tonumber(row.id)
        }
        Players.set(playerId,userData)

        if (callback ~= nil) then
            callback(callback)
        end
        print('loaded ' .. GetPlayerName(playerId) .. ' (' .. playerId .. '|' .. identifier .. ')')
        TriggerEvent("em_core:playerLoaded",playerId)
        TriggerClientEvent("skinchanger:loadSkin",playerId,json.decode(row.skin),nil)
        TriggerClientEvent("em_core_client:playerLoaded",playerId,userData)
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
                    MySQL.Async.execute("INSERT INTO em_users (login,identifier) VALUES (@login,@identifier)",{
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

function Players:save(playerId,cb)
    print('saving')
end

Players.getMoney = function(playerId)
    return Players.all[tostring(playerId)].money
end

Players.takeMoney = function(playerId, amount)
    local money = Players.all[tostring(playerId)].money
    local newValue = money - amount
    if (newValue<0) then
        newValue = 0
    end
    local UID = Players.all[tostring(playerId)].UID
    Players.all[tostring(playerId)].money = newValue
    TriggerClientEvent("em_core_client:PlayerMoneyChange",playerId,newValue)
    MySQL.Async.execute("UPDATE em_users SET money=@money WHERE id=@id",{['@id']=UID,['@money']=newValue},function(rowChanged)
    end)
    return true
end

RegisterNetEvent("playerJoining")
AddEventHandler("playerJoining",function()
    local playerId = source
    Players.onJoin(playerId)
end)

AddEventHandler('playerDropped', function (reason)
    Players.all[tostring(source)]=nil
    TriggerEvent("em_core:playerDropped",source)
end)
  
exports('PlayersGetAllPlayers',function()
    return Players.getAllPlayers()
end)
exports('PlayersGetPlayerFromId',Players.fromId)
exports('PlayersGetMoney',Players.getMoney)
exports("PlayersTakeMoney",Players.takeMoney)
AddEventHandler("onResourceStart",function(resource)
    if (GetCurrentResourceName() == resource) then
        local allPlayers = GetPlayers()
        for _,playerId in ipairs(allPlayers) do
            Players.onJoin(playerId)
        end
    end
end)