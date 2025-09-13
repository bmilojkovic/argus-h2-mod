---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

local file = rom.path.combine(rom.paths.Content, 'Game/Text/en/ShellText.en.sjson')

game.OnControlPressed({'Gift', function()
	return trigger_Gift()
end})

modutil.mod.Path.Wrap("AddTraitToHero", function(base, ...)
	newTrait = base(...)
	rom.log.warning("Got new trait! Count is " .. game.GetTotalTraitCount(game.CurrentRun.Hero))
	traitList = ""
	for k, currentTrait in pairs( game.CurrentRun.Hero.Traits ) do
        if game.IsGodTrait(currentTrait.Name, { ForShop = true }) then
			traitList = traitList .. currentTrait.Name .. "-" .. currentTrait.Rarity .. " "
		end
	end
	rom.log.warning("Trait list: " .. traitList)
	send_twitch_data(traitList)
	return newTrait
end)
