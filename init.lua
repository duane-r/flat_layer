-- Flat_layer init.lua
-- Copyright Duane Robertson (duane@duanerobertson.com), 2019
-- Distributed under the LGPLv2.1 (https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html)

flat_layer = {}
local mod, mod_name = flat_layer, 'flat_layer'
mod.version = '20190529'
mod.path = minetest.get_modpath(minetest.get_current_modname())
mod.world = minetest.get_worldpath()

local lower_limit = 0
local upper_limit = 30000
local step = 5000


do
	local biomes = {}
	for k, v in pairs(minetest.registered_biomes) do
		local name = v.name

		if v.y_max or v.y_min then
			if v.y_max and v.y_max > (step / 2) then
				v.y_max = (step / 2)
			end
			if v.y_min and v.y_min < -(step / 2) then
				v.y_min = -(step / 2)
			end

			for y = lower_limit, upper_limit, step do
				local w = table.copy(v)
				w.y_max = y + (v.y_max or (step / 2))
				w.y_min = y + (v.y_min or -(step / 2))
				biomes[#biomes+1] = w
				if v.name and y ~= 0 then
					w.name = v.name..y
				end
				--print(name, w.y_min, w.y_max)
			end
		else
			biomes[#biomes+1] = v
		end
	end

	minetest.clear_registered_biomes()
	for k, v in pairs(biomes) do
		minetest.register_biome(v)
	end

	local decos = {}
	for k, v in pairs(minetest.registered_decorations) do
		local name = v.name or v.decoration

		if v.biomes then
			local nb = {}
			for _, ob in pairs(v.biomes) do
				nb[#nb+1] = ob
				for yb = lower_limit, upper_limit, step do
					if yb ~= 0 then
						nb[#nb+1] = ob..yb
					end
				end
			end
			v.biomes = nb
		end

		if v.y_max or v.y_min then
			if v.y_max and v.y_max > (step / 2) then
				v.y_max = (step / 2)
			end
			if v.y_min and v.y_min < -(step / 2) then
				v.y_min = -(step / 2)
			end

			for y = lower_limit, upper_limit, step do
				local w = table.copy(v)
				w.y_max = y + (v.y_max or (step / 2))
				w.y_min = y + (v.y_min or -(step / 2))
				decos[#decos+1] = w
				if v.name and y ~= 0 then
					w.name = v.name..y
				end
				--print(name, w.y_min, w.y_max)
			end
		else
			decos[#decos+1] = v
		end
	end

	-- This is the only way to change existing decorations.
	minetest.clear_registered_decorations()
	for k, v in pairs(decos) do
		minetest.register_decoration(v)
	end
end
