---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

function stringifyTable(someTable)
	if type(someTable) == 'table' then
      local s = '{ '
      for k,v in pairs(someTable) do
         k = '"'..k..'"'
         s = s .. k .. ' : ' .. stringifyTable(v) .. ','
      end
      return s .. '} '
   else
      return "\"" .. tostring(someTable) .. "\""
   end
end

game.OnControlPressed({'Gift', function()
	return triggerGift()
end})

modutil.mod.Path.Wrap("AddTraitToHero", function(base, ...)
	local newTrait = base(...)
   game.thread(sendTwitchData)
	return newTrait
end)

modutil.mod.Path.Wrap("EquipKeepsake", function(base, ...)
   base(...)
   game.thread(sendTwitchData)
end)