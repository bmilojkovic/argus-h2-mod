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
local NOVOWS = "NOVOWS"
local NOARCANA = "NOARCANA"
local dataSeparator = ";;"

local function buildPinData()
	local pinData = ""
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
	local elements = {"Fire", "Air", "Earth", "Water", "Aether"}
	local elementsString = ""
	for _,element in ipairs(elements) do
		elementsString = elementsString .. element .. ":" .. game.CurrentRun.Hero.Elements[element] .. dataSeparator
	end

	--cut off the last dataSeparator
	if string.len(elementsString) > 0 then
		elementsString = string.sub(elementsString, 0, string.len(elementsString) - string.len(dataSeparator))
	end

	return elementsString
end

local function readRaritySafe(trait)
	if trait.Rarity == nil then return "Common" end
	if trait.IsElementalTrait ~= nil and trait.IsElementalTrait then return "Infusion" end
	return trait.Rarity
end

local function buildVowData()
	local vowString = ""
	if game.GameState.ShrineUpgrades ~= nil then
		for vowName, vowLevel in pairs(game.GameState.ShrineUpgrades) do
			if vowLevel ~= 0 then
				vowString = vowString .. vowLevel .. dataSeparator .. vowName .. " "
			end
		end
	end

	if vowString == "" then vowString = NOVOWS end
	
	return vowString
end

local function buildArcanaData()
	local arcanaString = ""
	if game.GameState.MetaUpgradeState ~= nil then
		for arcanaName, arcanaTable in pairs(game.GameState.MetaUpgradeState) do
			if arcanaTable.Equipped and arcanaTable.Level ~= nil then
				arcanaString = arcanaString .. arcanaTable.Level .. dataSeparator .. arcanaName .. " "
			end
		end
	end

	if arcanaString == "" then arcanaString = NOARCANA end

	return arcanaString
end

local function writeToPythonProcess(pyHandle, mainString, failString)
	local writeSucc, errmsg
	if mainString ~= "" then
		writeSucc, errmsg = pyHandle:write(mainString .. "\n")
	else
		writeSucc, errmsg = pyHandle:write(failString .. "\n")
	end
	if not writeSucc then
		rom.log.warning(errmsg)
	end
end

function sendTwitchData()
	local pinsString = ""
	local weaponString = ""
	local familiarString = ""
	local extraString = ""
	local boonList = ""
	local vowString = ""
	local arcanaString = ""
	for k, currentTrait in pairs( game.CurrentRun.Hero.Traits ) do
		if isWeaponTrait(currentTrait) and weaponString == "" then
			weaponString = readRaritySafe(currentTrait) .. dataSeparator .. currentTrait.Name
			goto continue_loop
		end
		if isFamiliarTrait(currentTrait) and familiarString == "" then
			familiarString = currentTrait.Name
			goto continue_loop
		end
		if isKeepsakeTrait(currentTrait) or isHexTrait(currentTrait) or isChaosCurse(currentTrait) or isHadesBoon(currentTrait) then
			extraString = extraString .. readRaritySafe(currentTrait) .. dataSeparator .. currentTrait.Name .. " "
			goto continue_loop
		end
        if game.IsGodTrait(currentTrait.Name, { ForShop = true }) or isChaosBlessing(currentTrait) then
			boonList = boonList .. readRaritySafe(currentTrait) .. dataSeparator .. currentTrait.Name .. " "
			goto continue_loop
		end
		if isHammerTrait(currentTrait) or isArachneTrait(currentTrait) then
			boonList = boonList .. "Common" .. dataSeparator .. currentTrait.Name .. " "
			goto continue_loop
		end
		::continue_loop::
	end
	
	if weaponString == "" then
		rom.log.warning("Didn't find weapon trait. Skipping cycle.")
		return
	end
	elementsString = buildElementalData()
	pinsString = buildPinData()
	vowString = buildVowData()
	arcanaString = buildArcanaData()
	if boonList ~= "" then
		rom.log.warning("Boon list: " .. boonList)
	end
	if weaponString ~= "" then
		rom.log.warning("Weapon: " .. weaponString)
	end
	if familiarString ~= "" then
		rom.log.warning("Familiar: " .. familiarString)
	end
	if extraString ~= "" then
		rom.log.warning("Extra: " .. extraString)
	end
	if elementsString ~= "" then
		rom.log.warning("Elements: " .. elementsString)
	end
	if pinsString ~= "" then
		rom.log.warning("Pins: " .. pinsString)
	end
	if vowString ~= "" then
		rom.log.warning("Vows: " .. vowString)
	end
	if arcanaString ~= "" then
		rom.log.warning("Arcana: " .. arcanaString)
	end
	local comm = ('python '.. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, 'send_to_argus.py') -- run print script
		.. " --pluginpath " .. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid) -- tell python where it is running
		.. " >> " .. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, "py_out.txt 2>&1")) -- redirect stdout of python to a file

    local pyHandle, openErr = io.popen(comm, "w")
	
	if pyHandle ~= nil then
		writeToPythonProcess(pyHandle, boonList, NOBOONS)
		writeToPythonProcess(pyHandle, weaponString, NOWEAPONS)
		writeToPythonProcess(pyHandle, familiarString, NOFAMILIARS)
		writeToPythonProcess(pyHandle, extraString, NOEXTRAS)
		writeToPythonProcess(pyHandle, elementsString, NOELEMENTS)
		writeToPythonProcess(pyHandle, pinsString, NOPINS)
		writeToPythonProcess(pyHandle, vowString, NOVOWS)
		writeToPythonProcess(pyHandle, arcanaString, NOARCANA)
		
		pyHandle:flush()
	else
		rom.log.warning("Error in starting python script: " .. openErr)
	end
end

function triggerGift()
	rom.log.warning(stringifyTable(game.CurrentRun.Hero.Traits))
	rom.log.warning("------")
	rom.log.warning(buildArcanaData())
end