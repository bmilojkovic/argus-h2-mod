---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

local dataSeparator = ";;"

function isWeaponTrait(traitName)
	return string.find(traitName, "Aspect") or string.find(traitName, "DummyWeapon")
end

function build_elemental_data()
	if game.CurrentRun.Hero.Elements == nil then return "NOELEMENTS" end
	elements = {"Fire", "Air", "Earth", "Water", "Aether"}
	elementString = ""
	for _,element in ipairs(elements) do
		elementString = elementString .. element .. ":" .. game.CurrentRun.Hero.Elements[element] .. dataSeparator
	end

	--cut off the last dataSeparator
	elementString = string.sub(elementString, 0, string.len(elementString) - string.len(dataSeparator))

	return elementString
end

function send_twitch_data()
	weaponString = nil
	boonList = ""
	for k, currentTrait in pairs( game.CurrentRun.Hero.Traits ) do
		if isWeaponTrait(currentTrait.Name) and weaponString == nil then
			if currentTrait.Rarity == nil then
				rarity = "Common"
			else
				rarity = currentTrait.Rarity
			end
			weaponString = rarity .. dataSeparator .. currentTrait.Name
		end
        if game.IsGodTrait(currentTrait.Name, { ForShop = true }) then
			boonList = boonList .. currentTrait.Rarity .. dataSeparator .. currentTrait.Name .. " "
		end
	end
	elementsString = build_elemental_data()
	if game.GameState.EquippedFamiliar ~= nil then
		familiarString = game.GameState.EquippedFamiliar
	end
	rom.log.warning("Boon list: " .. boonList)
	if weaponString ~= nil then
		rom.log.warning("Weapon: " .. weaponString)
	end
	if familiarString ~= nil then
		rom.log.warning("Familiar: " .. familiarString)
	end
	if elementsString ~= nil then
		rom.log.warning("Elements: " .. elementsString)
	end
	local comm = ('python '.. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, 'send_to_argus.py') -- run print script
		.. " > " .. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, "py_out.txt 2>&1")) -- redirect stdout of python to a file

    local pyHandle, openErr = io.popen(comm, "w")
	
	if pyHandle ~= nil then
		local writeSucc, errmsg = pyHandle:write(boonList .. "\n")
		if not writeSucc then
			rom.log.warning(errmsg)
		end
		writeSucc, errmsg = pyHandle:write((weaponString or "NOWEAPON") .. "\n")
		if not writeSucc then
			rom.log.warning(errmsg)
		end
		writeSucc, errmsg = pyHandle:write((familiarString or "NOFAMILIAR") .. "\n")
		if not writeSucc then
			rom.log.warning(errmsg)
		end
		writeSucc, errmsg = pyHandle:write((elementString or "NOELEMENTS") .. "\n")
		if not writeSucc then
			rom.log.warning(errmsg)
		end
		pyHandle:flush()
	else
		rom.log.warning("Error in starting python script: " .. openErr)
	end
end

function trigger_gift()
	rom.log.warning(stringify_table(game.CurrentRun.Hero.Elements))
	modutil.mod.Hades.PrintOverhead(config.message)
end