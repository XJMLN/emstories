Fire = {
	active = {},
	removed = {},
	__index = self,
	init = function(o)
		o = o or {active = {}, removed = {}}
		setmetatable(o, self)
		self.__index = self
		return o
	end
}

function Fire:createFlame(fireIndex, flameIndex, coords)
	if not self.removed[fireIndex] then
		if self.active[fireIndex] == nil then
			self.active[fireIndex] = {
				flameCoords = {},
				flames = {},
				particles = {},
				flameParticles = {}
			}
        end
		self.active[fireIndex].flameCoords[flameIndex] = coords
	end
end

function Fire:removeFlame(fireIndex, flameIndex)
	if not (fireIndex and flameIndex and self.active[fireIndex]) then
		return
	end
	if self.active[fireIndex].flames[flameIndex] and self.active[fireIndex].flames[flameIndex] > -1 then
		RemoveScriptFire(self.active[fireIndex].flames[flameIndex])
        self.active[fireIndex].flames[flameIndex] = nil
    end
	if self.active[fireIndex].particles[flameIndex] and self.active[fireIndex].particles[flameIndex] ~= 0 then
		local particles = self.active[fireIndex].particles[flameIndex]
		Citizen.SetTimeout(
			5000,
			function()
				StopParticleFxLooped(particles, false)
				RemoveParticleFx(particles, true)
			end
		)
		self.active[fireIndex].particles[flameIndex] = nil
	end
	if self.active[fireIndex].flameParticles[flameIndex] and self.active[fireIndex].flameParticles[flameIndex] ~= 0 then
		local flameParticles = self.active[fireIndex].flameParticles[flameIndex]
		Citizen.SetTimeout(
			5000,
			function()
				StopParticleFxLooped(flameParticles, false)
				RemoveParticleFx(flameParticles, true)
			end
		)
		self.active[fireIndex].flameParticles[flameIndex] = nil
	end
	self.active[fireIndex].flameCoords[flameIndex] = nil

	if self.active[fireIndex] ~= nil and countElements(self.active[fireIndex].flames) < 1 then
		self.active[fireIndex] = nil
		self.removed[fireIndex] = true
	end
end

function Fire:remove(fireIndex, callback)
	if not (self.active[fireIndex] and self.active[fireIndex].particles) then
		return
	end

	for k, v in pairs(self.active[fireIndex].flames) do
        self:removeFlame(fireIndex, k)
        Citizen.Wait(20)
	end

	Citizen.SetTimeout(
		200,
		function()
			if self.active[fireIndex] and next(self.active[fireIndex].flames) ~= nil then
				print("WARNING: A fire persisted!")
				self:remove(fireIndex)
			elseif callback then
				callback(fireIndex)
			end
		end
	)
end

function Fire:removeAll(callback)
	for k, v in pairs(self.active) do
		self:remove(k)
        Citizen.Wait(20)
	end

	self.active = {}
	self.removed = {}
	
	if callback then
		callback()
	end
end

--================================--
-- PARTICLES & FIRE EXTINGUISHING --
--================================--

Citizen.CreateThread(
	function()
		if not HasNamedPtfxAssetLoaded("scr_agencyheistb") then
			RequestNamedPtfxAsset("scr_agencyheistb")
			while not HasNamedPtfxAssetLoaded("scr_agencyheistb") do
				Wait(1)
			end
		end

        if not HasNamedPtfxAssetLoaded("scr_trevor3") then
            RequestNamedPtfxAsset("scr_trevor3")
            while not HasNamedPtfxAssetLoaded("scr_trevor3") do
                Wait(1)
            end
		end
		
		while true do
			Citizen.Wait(1500)
			for fireIndex, v in pairs(Fire.active) do
				if countElements(v.particles) ~= 0 then
					for flameIndex, _v in pairs(v.particles) do
						local isFirePresent = GetNumberOfFiresInRange(
							v.flameCoords[flameIndex].x,
							v.flameCoords[flameIndex].y,
							v.flameCoords[flameIndex].z,
							0.05
						)
						if isFirePresent == 0 then
							TriggerServerEvent('fireManager:removeFlame', fireIndex, flameIndex)
						end
					end
				end
			end
		end
	end
)

Citizen.CreateThread(
	function()
		while true do
			local pedCoords = GetEntityCoords(GetPlayerPed(-1))
			while syncInProgress do
				Citizen.Wait(10)
			end
			for fireIndex, v in pairs(Fire.active) do
				for flameIndex, coords in pairs(Fire.active[fireIndex].flameCoords) do
					Citizen.Wait(10)
					if not syncInProgress and Fire.active[fireIndex] and Fire.active[fireIndex].flameCoords[flameIndex] and not Fire.active[fireIndex].particles[flameIndex] and #(coords - pedCoords) < 300.0 then
						local z = coords.z
		
						repeat
							Wait(0)
							ground, newZ = GetGroundZFor_3dCoord(coords.x, coords.y, z, 1)
							if not ground then
								z = z + 0.1
							end
						until ground
						z = newZ
	
						Fire.active[fireIndex].flames[flameIndex] = StartScriptFire(coords.x, coords.y, z, 0, false)

						if Fire.active[fireIndex].flames[flameIndex] then -- Make sure the fire has been spawned properly
							Fire.active[fireIndex].flameCoords[flameIndex] = vector3(coords.x, coords.y, z)
		
							SetPtfxAssetNextCall("scr_agencyheistb")
							
							Fire.active[fireIndex].particles[flameIndex] = StartParticleFxLoopedAtCoord(
								"scr_env_agency3b_smoke",
								Fire.active[fireIndex].flameCoords[flameIndex].x,
								Fire.active[fireIndex].flameCoords[flameIndex].y,
								Fire.active[fireIndex].flameCoords[flameIndex].z + 1.0,
								0.0,
								0.0,
								0.0,
								1.0,
								false,
								false,
								false,
								false
							)
						
							SetPtfxAssetNextCall("scr_trevor3")
						
							Fire.active[fireIndex].flameParticles[flameIndex] = StartParticleFxLoopedAtCoord(
								"scr_trev3_trailer_plume",
								Fire.active[fireIndex].flameCoords[flameIndex].x,
								Fire.active[fireIndex].flameCoords[flameIndex].y,
								Fire.active[fireIndex].flameCoords[flameIndex].z + 1.2,
								0.0,
								0.0,
								0.0,
								1.0,
								false,
								false,
								false,
								false
							)
	
						else
							Fire.active[fireIndex].flames[flameIndex] = nil
						end
					end
				end
			end
			Citizen.Wait(1500)
		end
	end
)




RegisterNetEvent('playerSpawned')
AddEventHandler(
	'playerSpawned',
	function()
		print("Requested synchronization..")
		TriggerServerEvent('fireManager:requestSync')
	end
)


RegisterNetEvent('fireClient:synchronizeFlames')
AddEventHandler(
	'fireClient:synchronizeFlames',
	function(fires)
		syncInProgress = true
		Fire:removeAll(
			function()
				for k, v in pairs(fires) do
					for _k, _v in ipairs(v) do
						Fire:createFlame(k, _k, _v)
					end
				end
				syncInProgress = false
			end
		)
	end
)

RegisterNetEvent('fireClient:removeFire')
AddEventHandler(
	'fireClient:removeFire',
	function(fireIndex)
		while syncInProgress do
			Citizen.Wait(10)
		end
		Fire:remove(fireIndex)
	end
)

RegisterNetEvent('fireClient:removeAllFires')
AddEventHandler(
	'fireClient:removeAllFires',
	function()
		while syncInProgress do
			Citizen.Wait(10)
		end
		Fire:removeAll()
	end
)

RegisterNetEvent("fireClient:removeFlame")
AddEventHandler(
    "fireClient:removeFlame",
	function(fireIndex, flameIndex)
		while syncInProgress do
			Citizen.Wait(10)
		end
		Fire:removeFlame(fireIndex, flameIndex)
		
    end
)

RegisterNetEvent("fireClient:createFlame")
AddEventHandler(
    "fireClient:createFlame",
	function(fireIndex, flameIndex, coords)
		syncInProgress = true
		Fire:createFlame(fireIndex, flameIndex, coords)
		syncInProgress = false
    end
)


function countElements(table)
	local count = 0
	if type(table) == "table" then
		for k, v in pairs(table) do
			count = count + 1
		end
	end
	return count
end