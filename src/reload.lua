---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

local NOBOONS = "NOBOONS"
local NOPINS = "NOPINS"
local NOWEAPONS = "NOWEAPONS"
local NOFAMILIARS = "NOFAMILIARS"
local NOKEEPSAKES = "NOKEEPSAKES"
local NOELEMENTS = "NOELEMENTS"
local dataSeparator = ";;"

function isWeaponTrait(trait)
	return trait.Slot ~= nil and trait.Slot == "Aspect"
end

function isHammerTrait(trait)
	return trait.IsHammerTrait ~= nil and trait.IsHammerTrait
end

function isKeepsakeTrait(trait)
	return trait.Slot ~= nil and trait.Slot == "Keepsake"
end

function build_pin_data()
	pinData = ""
	if (game.GameState.StoreItemPins ~= nil) then
		
		for _, v in ipairs(game.GameState.StoreItemPins) do
			if v["Name"] ~= nil then
				pinData = pinData .. v["Name"] .. dataSeparator
			end
		end

		--cut off the last dataSeparator
		if string.len(pinData) > 0 then
			pinData = string.sub(pinData, 0, string.len(pinData) - string.len(dataSeparator))
		end
		
	else
		return NOPINS
	end

	return pinData
end

function build_elemental_data()
	if game.CurrentRun.Hero.Elements == nil then return NOELEMENTS end
	elements = {"Fire", "Air", "Earth", "Water", "Aether"}
	elementString = ""
	for _,element in ipairs(elements) do
		elementString = elementString .. element .. ":" .. game.CurrentRun.Hero.Elements[element] .. dataSeparator
	end

	--cut off the last dataSeparator
	if string.len(elementString) > 0 then
		elementString = string.sub(elementString, 0, string.len(elementString) - string.len(dataSeparator))
	end

	return elementString
end

function write_to_python_process(pyHandle, mainString, failString)
	pyHandle:write((mainString or failString) .. "\n")
	--[[
	local writeSucc, errmsg = pyHandle:write((mainString or failString) .. "\n")
	if not writeSucc then
		rom.log.warning(errmsg)
	end
	]]
end

function send_twitch_data()
	pinsString = nil
	weaponString = nil
	keepsakeString = nil
	boonList = ""
	for k, currentTrait in pairs( game.CurrentRun.Hero.Traits ) do
		if isWeaponTrait(currentTrait) and weaponString == nil then
			if currentTrait.Rarity == nil then
				rarity = "Common"
			else
				rarity = currentTrait.Rarity
			end
			weaponString = rarity .. dataSeparator .. currentTrait.Name
		end
		if isKeepsakeTrait(currentTrait) and keepsakeString == nil then
			if currentTrait.Rarity == nil then
				rarity = "Common"
			else
				rarity = currentTrait.Rarity
			end
			keepsakeString = rarity .. dataSeparator .. currentTrait.Name
		end
		if isHammerTrait(currentTrait) then
			boonList = boonList .. "Common" .. dataSeparator .. currentTrait.Name .. " "
		end
        if game.IsGodTrait(currentTrait.Name, { ForShop = true }) then
			boonList = boonList .. currentTrait.Rarity .. dataSeparator .. currentTrait.Name .. " "
		end
	end
	if boonList == "" then boonList = nil end
	
	elementsString = build_elemental_data()
	if game.GameState.EquippedFamiliar ~= nil then
		familiarString = game.GameState.EquippedFamiliar
	end
	pinsString = build_pin_data()
	if boonList ~= nil then
		rom.log.warning("Boon list: " .. boonList)
	end
	if weaponString ~= nil then
		rom.log.warning("Weapon: " .. weaponString)
	end
	if familiarString ~= nil then
		rom.log.warning("Familiar: " .. familiarString)
	end
	if keepsakeString ~= nil then
		rom.log.warning("Keepsake: " .. keepsakeString)
	end
	if elementsString ~= nil then
		rom.log.warning("Elements: " .. elementsString)
	end
	if pinsString ~= nil then
		rom.log.warning("Pins: " .. pinsString)
	end
	local comm = ('python '.. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, 'send_to_argus.py') -- run print script
		.. " > " .. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, "py_out.txt 2>&1")) -- redirect stdout of python to a file

    local pyHandle, openErr = io.popen(comm, "w")
	
	if pyHandle ~= nil then
		write_to_python_process(pyHandle, boonList, NOBOONS)
		write_to_python_process(pyHandle, weaponString, NOWEAPONS)
		write_to_python_process(pyHandle, familiarString, NOFAMILIARS)
		write_to_python_process(pyHandle, keepsakeString, NOKEEPSAKES)
		write_to_python_process(pyHandle, elementString, NOELEMENTS)
		write_to_python_process(pyHandle, pinsString, NOPINS)
		
		pyHandle:flush()
	else
		rom.log.warning("Error in starting python script: " .. openErr)
	end
end

function trigger_gift()
	rom.log.warning(stringify_table(game.CurrentRun.Hero.Traits))
	modutil.mod.Hades.PrintOverhead(config.message)
end