Fire = {
	registered = {},
	random = {},
	active = {},
	binds = {},
	activeBinds = {},
	__index = self,
	init = function(o)
		o = o or {registered = {}, random = {}, active = {}, binds = {}, activeBinds = {}}
		setmetatable(o, self)
		self.__index = self
		return o
	end
}


function Fire:create(coords, maximumSpread, spreadChance)
	maximumSpread = maximumSpread and maximumSpread or Config.Fire.maximumSpreads
	spreadChance = spreadChance and spreadChance or Config.Fire.fireSpreadChance

	local fireIndex = highestIndex(self.active)
	fireIndex = fireIndex + 1

	self.active[fireIndex] = {
		maxSpread = maxSpread,
		spreadChance = spreadChance
	}

	self:createFlame(fireIndex, coords)

	local spread = true

	-- Spreading
	Citizen.CreateThread(
		function()
			while spread do
				Citizen.Wait(2000)
				local index, flames = highestIndex(self.active, fireIndex)
				if flames ~= 0 and flames <= maximumSpread then
					for k, v in ipairs(self.active[fireIndex]) do
						index, flames = highestIndex(self.active, fireIndex)
						local rndSpread = math.random(100)
						if count ~= 0 and flames <= maximumSpread and rndSpread <= spreadChance then
							local x = self.active[fireIndex][k].x
							local y = self.active[fireIndex][k].y
							local z = self.active[fireIndex][k].z
	
							local xSpread = math.random(-3, 3)
							local ySpread = math.random(-3, 3)
	
							coords = vector3(x + xSpread, y + ySpread, z)
	
							self:createFlame(fireIndex, coords)
						end
					end
				elseif flames == 0 then
					break
				end
			end
		end
	)

	self.active[fireIndex].stopSpread = function()
		spread = false
	end

	return fireIndex
end

function Fire:createFlame(fireIndex, coords)
	local flameIndex = highestIndex(self.active, fireIndex) + 1
	self.active[fireIndex][flameIndex] = coords
	TriggerClientEvent('fireClient:createFlame', -1, fireIndex, flameIndex, coords)
end

function Fire:remove(fireIndex)
	if not (self.active[fireIndex] and next(self.active[fireIndex])) then
		return false
	end
	self.active[fireIndex].stopSpread()
	TriggerClientEvent('fireClient:removeFire', -1, fireIndex)
	self.active[fireIndex] = {}
	return true
end

function Fire:removeFlame(fireIndex, flameIndex)
	if self.active[fireIndex] and self.active[fireIndex][flameIndex] then
		self.active[fireIndex][flameIndex] = nil
		if type(next(self.active[fireIndex])) == "string" and self.activeBinds[fireIndex] then
			self.binds[self.activeBinds[fireIndex]][fireIndex] = nil

			if self.activeBinds[fireIndex] == self.currentRandom and next(self.binds[self.activeBinds[fireIndex]]) == nil then
				self.currentRandom = nil
			end

			self.activeBinds[fireIndex] = nil
		end
	end
	TriggerClientEvent('fireClient:removeFlame', -1, fireIndex, flameIndex)
end

function Fire:removeAll()
	TriggerClientEvent('fireClient:removeAllFires', -1)
	for k, v in pairs(self.active) do
		if v.stopSpread then
			v.stopSpread()
		end
	end
	self.active = {}
	self.binds = {}
	self.currentRandom = nil
end

function Fire:addFlame(registeredFireID, coords, spread, chance)
	if not (registeredFireID and coords and spread and chance and self.registered[registeredFireID]) then
		return false
	end

	local flameID = highestIndex(self.registered[registeredFireID].flames) + 1

	self.registered[registeredFireID].flames[flameID] = {}
	self.registered[registeredFireID].flames[flameID].coords = coords
	self.registered[registeredFireID].flames[flameID].spread = spread
	self.registered[registeredFireID].flames[flameID].chance = chance

	self:saveRegistered()

	return flameID
end

function Fire:deleteFlame(registeredFireID, flameID)
	if not (self.registered[registeredFireID] and self.registered[registeredFireID].flames[flameID]) then
		return false
	end

	table.remove(self.registered[registeredFireID].flames, flameID)

	self:saveRegistered()

	return true
end

function Fire:setRandom(registeredFireID, random)
	random = random or nil
	registeredFireID = tonumber(registeredFireID)

	if not registeredFireID or not self.registered[registeredFireID] then
		return false
	end

	self.registered[registeredFireID].random = random
	self.random[registeredFireID] = random

	self:saveRegistered()

	return true
end

function Fire:updateRandom() -- Creates a table containing all fires with random flag enabled
	self.random = {}
	if not (self.registered and next(self.registered) ~= nil) then
		return
	end
	for k, v in pairs(self.registered) do
		if v.random == true then
			self.random[k] = true
		end
	end
end


RegisterNetEvent('fireManager:requestSync')
AddEventHandler(
	'fireManager:requestSync',
	function()
		if source > 0 then
			TriggerClientEvent('fireClient:synchronizeFlames', source, Fire.active)
		end
	end
)

RegisterNetEvent('fireManager:createFlame')
AddEventHandler(
	'fireManager:createFlame',
	function(fireIndex, coords)
		Fire:createFlame(fireIndex, coords)
	end
)

RegisterNetEvent('fireManager:createFire')
AddEventHandler(
	'fireManager:createFire',
	function()
		Fire:create(coords, maximumSpread, spreadChance)
	end
)

RegisterNetEvent('fireManager:removeFire')
AddEventHandler(
	'fireManager:removeFire',
	function(fireIndex)
		Fire:remove(fireIndex)
	end
)

RegisterNetEvent('fireManager:removeAllFires')
AddEventHandler(
	'fireManager:removeAllFires',
	function()
		Fire:removeAll()
	end
)

RegisterNetEvent('fireManager:removeFlame')
AddEventHandler(
	'fireManager:removeFlame',
	function(fireIndex, flameIndex)
		Fire:removeFlame(fireIndex, flameIndex)
	end
)



function highestIndex(table, fireIndex)
	if not table then
		return
	end
	local table = fireIndex ~= nil and table[fireIndex] or table
	local index = 0
	local count = 0

	for k, v in ipairs(table) do
		count = count + 1
		if k >= index then
			index = k
		end
	end

	return index, count
end

function table.length(t)
	if not t or type(t) ~= "table" then
		return
	end

	local count = 0

	for k, v in pairs(t) do count = count + 1 end

	return count
end

function table.random(t)
	if not t or type(t) ~= "table" or next(t) == nil then
		return false
	end

	local randomPosition = math.random(1, table.length(t))
	local currentPosition = 0
	local randomKey = nil

	for k, v in pairs(t) do -- Select a random registered fire
		currentPosition = currentPosition + 1

		if currentPosition == randomPosition then
			randomKey = k
			break
		end
	end

	return randomKey, t[randomKey]
end

