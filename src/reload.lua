---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

local NOBOONS = "NOBOONS"
local NOPINS = "NOPINS"
local NOWEAPONS = "NOWEAPONS"
local NOFAMILIARS = "NOFAMILIARS"
local NOEXTRAS = "NOEXTRAS"
local NOELEMENTS = "NOELEMENTS"
local dataSeparator = ";;"

local function buildPinData()
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

local function buildElementalData()
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

local function writeToPythonProcess(pyHandle, mainString, failString)
	local writeSucc, errmsg = pyHandle:write((mainString or failString) .. "\n")
	if not writeSucc then
		rom.log.warning(errmsg)
	end
end

local function readRaritySafe(trait)
	if trait.Rarity == nil then return "Common" end
	if trait.IsElementalTrait ~= nil and trait.IsElementalTrait then return "Infusion" end
	return trait.Rarity
end

function sendTwitchData()
	pinsString = nil
	weaponString = nil
	familiarString = nil
	extraString = ""
	boonList = ""
	for k, currentTrait in pairs( game.CurrentRun.Hero.Traits ) do
		if isWeaponTrait(currentTrait) and weaponString == nil then
			weaponString = readRaritySafe(currentTrait) .. dataSeparator .. currentTrait.Name
		end
		if isFamiliarTrait(currentTrait) and familiarString == nil then
			familiarString = currentTrait.Name
		end
		if isKeepsakeTrait(currentTrait) or isHexTrait(currentTrait) or isChaosCurse(currentTrait) then
			extraString = extraString .. readRaritySafe(currentTrait) .. dataSeparator .. currentTrait.Name .. " "
		end
        if game.IsGodTrait(currentTrait.Name, { ForShop = true }) then
			boonList = boonList .. readRaritySafe(currentTrait) .. dataSeparator .. currentTrait.Name .. " "
		end
		if isChaosBlessing(currentTrait) or isHadesBoon(currentTrait) then
			boonList = boonList .. readRaritySafe(currentTrait) .. dataSeparator .. currentTrait.Name .. " "
		end
		if isHammerTrait(currentTrait) or isArachneTrait(currentTrait) then
			boonList = boonList .. "Common" .. dataSeparator .. currentTrait.Name .. " "
		end
		
	end
	if boonList == "" then boonList = nil end
	
	elementsString = buildElementalData()
	pinsString = buildPinData()
	if boonList ~= nil then
		rom.log.warning("Boon list: " .. boonList)
	end
	if weaponString ~= nil then
		rom.log.warning("Weapon: " .. weaponString)
	end
	if familiarString ~= nil then
		rom.log.warning("Familiar: " .. familiarString)
	end
	if extraString ~= nil then
		rom.log.warning("Extra: " .. extraString)
	end
	if elementsString ~= nil then
		rom.log.warning("Elements: " .. elementsString)
	end
	if pinsString ~= nil then
		rom.log.warning("Pins: " .. pinsString)
	end
	local comm = ('python '.. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, 'send_to_argus.py') -- run print script
		.. " --pluginpath " .. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid) -- tell python where it is running
		.. " > " .. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, "py_out.txt 2>&1")) -- redirect stdout of python to a file

    local pyHandle, openErr = io.popen(comm, "w")
	
	if pyHandle ~= nil then
		writeToPythonProcess(pyHandle, boonList, NOBOONS)
		writeToPythonProcess(pyHandle, weaponString, NOWEAPONS)
		writeToPythonProcess(pyHandle, familiarString, NOFAMILIARS)
		writeToPythonProcess(pyHandle, extraString, NOEXTRAS)
		writeToPythonProcess(pyHandle, elementString, NOELEMENTS)
		writeToPythonProcess(pyHandle, pinsString, NOPINS)
		
		pyHandle:flush()
	else
		rom.log.warning("Error in starting python script: " .. openErr)
	end
end

function triggerGift()
	rom.log.warning(stringifyTable(game.CurrentRun.Hero.Traits))
end