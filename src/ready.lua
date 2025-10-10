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
      for k, v in pairs(someTable) do
         k = '"' .. k .. '"'
         s = s .. k .. ' : ' .. stringifyTable(v) .. ','
      end
      return s .. '} '
   else
      return "\"" .. tostring(someTable) .. "\""
   end
end

game.OnControlPressed({ 'Gift', function()
   return triggerGift()
end })

local twitchUpdateEvents = {
   --"PickupWeaponKit",                   -- equip weapon in crossroads
   --"UseFamiliar",                       -- equip familiar in crossroads
   --"EquipKeepsake",
   --"CloseMetaUpgradeCardScreen",        -- main arcana screen closed
   --"CloseUpgradeMetaUpgradeCardScreen", -- insight arcana screen closed
   --"CloseShrineUpgradeScreen",          -- close vow shrine
   --"StartNewRun",                       -- exiting crossroads
   "LeaveRoom" -- leave a room
}
for k, functionName in ipairs(twitchUpdateEvents) do
   modutil.mod.Path.Wrap(functionName, function(base, ...)
      base(...)
      game.thread(sendTwitchData)
   end)
end
