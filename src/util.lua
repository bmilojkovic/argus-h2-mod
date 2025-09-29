
---@diagnostic disable: lowercase-global

function startsWith(str, start)
   return str:sub(1, #start) == start
end

function endsWith(str, ending)
   return ending == "" or str:sub(-#ending) == ending
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

function isArachneTrait(trait)
	return trait.IsCostumeTrait ~= nil and trait.IsCostumeTrait
end

function isChaosBlessing(trait)
	return trait.Name ~= nil and startsWith(trait.Name, "Chaos") and endsWith(trait.Name, "Blessing")
end

function isChaosCurse(trait)
	return trait.Name ~= nil and startsWith(trait.Name, "Chaos") and endsWith(trait.Name, "Curse")
end

function isHadesBoon(trait)
	return trait.Name ~= nil and startsWith(trait.Name, "Hades") and endsWith(trait.Name, "Boon")
end
