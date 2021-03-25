function getLicense(plr)
	local license
	for k, v in ipairs(GetPlayerIdentifiers(plr)) do
	   if string.match(v, "license:") then
		  license = v
		  break
	   end
	end
	return license
end

RegisterNetEvent("mpcreator:getSkinData")
AddEventHandler("mpcreator:getSkinData",function()
    local source = source 
    local identifier = string.gsub(getLicense(source),"license:","")
    MySQL.Async.fetchAll('SELECT skin FROM em_users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(users)
		local row = users[1]
        if (row and row.skin) then
		    local skin = json.decode(row.skin)
			TriggerClientEvent("mpcreator:OpenClothesMenu",source,skin)
        end
	end)
end)


RegisterServerEvent('em_shop_skins:save')
AddEventHandler('em_shop_skins:save', function(skin)
	local source = source
    local identifier = string.gsub(getLicense(source),"license:","")
	MySQL.Async.execute('UPDATE em_users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = identifier
	})
end)

RegisterServerEvent("em_shop_skins:getPlayerSkin")
AddEventHandler("em_shop_skins:getPlayerSkin",function(source,cb)

	local identifier = string.gsub(getLicense(source),"license:","")

	MySQL.Async.fetchAll('SELECT skin FROM em_users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(users)
		local user, skin = users[1]

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)
