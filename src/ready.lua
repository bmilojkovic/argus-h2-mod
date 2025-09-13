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
	send_twitch_data()
	return newTrait
end)
