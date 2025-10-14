---@diagnostic disable: lowercase-global

function stringifyTable(someTable)
	if type(someTable) == 'table' then
		local s = '{ '
		for k, v in pairs(someTable) do
			k = '"' .. k .. '"'
			s = s .. k .. ' : ' .. stringifyTable(v) .. ','
		end
		return s .. '} '
	else
		return "\"" .. tostring(someTable) .. "\""
	end
end

function removeFileIfExists(fileName)
	local file = io.open(fileName, "r")
	if file then
		io.close(file) -- Close the file handle if it was successfully opened
		-- File exists, proceed with deletion
		local success, err = os.remove(fileName)
		if success then
			rom.log.info("File '" .. fileName .. "' deleted successfully.")
		else
			rom.log.warning("Error deleting file '" .. fileName .. "': " .. err)
		end
	end
end

function listContains(list, item)
	for _, value in ipairs(list) do
		if value == item then
			return true
		end
	end

	return false
end

function startsWith(str, start)
	return str:sub(1, #start) == start
end

function endsWith(str, ending)
	return ending == "" or str:sub(- #ending) == ending
end

function isWeaponTrait(trait)
	return trait.Slot ~= nil and trait.Slot == "Aspect"
end

function isHammerTrait(trait)
	return trait.IsHammerTrait ~= nil and trait.IsHammerTrait
end

function isKeepsakeTrait(trait)
	return trait.Slot ~= nil and trait.Slot == "Keepsake"
end

function isHexTrait(trait)
	return trait.Slot ~= nil and trait.Slot == "Spell"
end

function isFamiliarTrait(trait)
	return trait.Slot ~= nil and trait.Slot == "Familiar"
end

local arachneTraits = { "VitalityCostume", "ManaCostume", "AgilityCostume", "CastDamageCostume", "IncomeCostume",
	"HighArmorCostume", "SpellCostume", "EscalatingCostume" }

function isArachneTrait(trait)
	return trait.Name ~= nil and listContains(arachneTraits, trait.Name)
end

local mainIcarusTraits = { "FocusAttackDamageTrait",
	"FocusSpecialDamageTrait", "OmegaExplodeBoon", "CastHazardBoon",
	"UpgradeHammerBoon" };
local extraIcarusTraits = { "BreakInvincibleArmorBoon", "BreakExplosiveArmorBoon", "SupplyDropBoon" };

function isMainIcarusTrait(trait)
	return trait.Name ~= nil and listContains(mainIcarusTraits, trait.Name)
end

function isExtraIcarusTrait(trait)
	return trait.Name ~= nil and listContains(extraIcarusTraits, trait.Name)
end

function isChaosBlessing(trait)
	return trait.Name ~= nil and startsWith(trait.Name, "Chaos") and endsWith(trait.Name, "Blessing")
end

function isChaosCurse(trait)
	return trait.Name ~= nil and startsWith(trait.Name, "Chaos") and endsWith(trait.Name, "Curse")
end

local mainHadesTraits = { "HadesDeathDefianceDamageBoon",
	"HadesCastProjectileBoon", "HadesChronosDebuffBoon", "HadesDashSweepBoon",
	"HadesManaUrnBoon" };
local extraHadesTraits = { "HadesLifestealBoon", "HadesPreDamageBoon", "HadesInvisibilityRetaliateBoon" };

function isMainHadesBoon(trait)
	return trait.Name ~= nil and listContains(mainHadesTraits, trait.Name)
end

function isExtraHadesBoon(trait)
	return trait.Name ~= nil and listContains(extraHadesTraits, trait.Name)
end

local mainMedeaTraits = { "HealingOnDeathCurse",
	"MoneyOnDeathCurse", "ManaOverTimeCurse", "SpawnDamageCurse",
	"ArmorPenaltyCurse", "SlowProjectileCurse", "DeathDefianceRetaliateCurse" };
local extraMedeaTraits = { "NewStatusDamage" };

function isMainMedeaTrait(trait)
	return trait.Name ~= nil and listContains(mainMedeaTraits, trait.Name)
end

function isExtraMedeaTrait(trait)
	return trait.Name ~= nil and listContains(extraMedeaTraits, trait.Name)
end

local mainCirceTraits = { "CirceSorceryDamageBoon", "RandomArcanaTrait",
	"CirceShrinkTrait", "CirceEnlargeTrait", "HealAmplifyTrait",
	"DoubleFamiliarTrait", "RemoveShrineTrait", "ArcanaRarityTrait" };
local extraCirceTraits = { "ExPolymorphBoon" };

function isMainCirceTrait(trait)
	return trait.Name ~= nil and listContains(mainCirceTraits, trait.Name)
end

function isExtraCirceTrait(trait)
	return trait.Name ~= nil and listContains(extraCirceTraits, trait.Name)
end

local mainAthenaTraits = { "DeathDefianceRefillBoon", "FocusLastStandBoon",
	"ManaSpearBoon", "InvulnerabilityCastBoon",
	"InvulnerabilityDashBoon" };
local extraAthenaTraits = { "RetaliateInvulnerabilityBoon", "AthenaProjectileBoon",
	"OlympianSpellCountBoon" };

function isMainAthenaTrait(trait)
	return trait.Name ~= nil and listContains(mainAthenaTraits, trait.Name)
end

function isExtraAthenaTrait(trait)
	return trait.Name ~= nil and listContains(extraAthenaTraits, trait.Name)
end
