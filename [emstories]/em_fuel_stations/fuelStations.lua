fuelStations = {}

function stations_changePrice()
    for i,v in ipairs(fuelStations) do
        v.price = math.random(1,3)
        MySQL.Async.execute("UPDATE em_fuel_stations SET station_price=@price WHERE station_active=1 AND station_id=@ID",{['@price']=v.price,['@ID']=v.station_id},function(ret) end)
    end
    print("[FUEL SYSTEM] Nastąpiła zmiana cen na stacjach paliw!")
    SetTimeout(21600000,stations_changePrice)
end

function stations_getPetrolStations(player)
    local n = 0
    MySQL.Async.fetchAll("SELECT station_id,station_price,station_pumps FROM em_fuel_stations WHERE station_active=1",{},function(stations)
        for _,v in ipairs(stations) do
            fuelStations[v.station_id] = {}
            fuelStations[v.station_id]['station_id'] = v.station_id
            fuelStations[v.station_id]['pumps'] = json.decode(v.station_pumps)
            fuelStations[v.station_id]['price'] = v.station_price
            n = n + 1
        end
        print("Loaded "..n.." petrol stations")
        if (not player) then
            TriggerClientEvent("em_fuelStations:createStations",-1,fuelStations)
        else
            TriggerClientEvent("em_fuelStations:createStations",player,fuelStations)
        end
    end)

end

function stations_getPrice(stationId)
    local plrMoney = exports.em_core:PlayersGetMoney(source)
    TriggerClientEvent("em_fuelStations:returnStationPrice",source,fuelStations[stationId]['price'],plrMoney)
end

function stations_verifyPayment(price,fuel)
    local plrMoney = exports.em_core:PlayersGetMoney(source)
    if (plrMoney < price) then return end

    exports.em_core:PlayersTakeMoney(source,price)
    TriggerClientEvent("em_fuelStations:fuelCar",source,fuel)
end
RegisterNetEvent("em_fuelStations:verifyMoney")
AddEventHandler("em_fuelStations:verifyMoney",stations_verifyPayment)
RegisterNetEvent("em_fuelStations:getPriceForStation")
AddEventHandler("em_fuelStations:getPriceForStation",stations_getPrice)
AddEventHandler("em_core:playerLoaded",stations_getPetrolStations)
AddEventHandler("onResourceStart",function(resname)
    if (GetCurrentResourceName() == resname) then
        stations_getPetrolStations(false)
        Citizen.Wait(5000)
        stations_changePrice()
        SetTimeout(21600000,stations_changePrice) -- co 3h zmiana cen
    end
end)