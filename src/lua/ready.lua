---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- here is where your mod sets up all the things it will do.
-- this file will not be reloaded if it changes during gameplay
-- 	so you will most likely want to have it reference
--	values and functions later defined in `reload.lua`.

local function attemptArgusLogin()
   local pluginsDataPath = rom.path.combine(rom.paths.plugins_data(), _PLUGIN.guid)
   local pythonPath = rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, 'py')
   local comm = ('python ' .. rom.path.combine(pythonPath, 'send_to_argus.py') -- run print script
      .. " --pluginpath " .. pluginsDataPath                                   -- tell python where to store data
      .. " --login"                                                            -- we are doing only login now
      .. " >> " .. rom.path.combine(pluginsDataPath, "py_auth_out.txt 2>&1"))  -- redirect stdout of python to a file

   local pyHandle, openErr = io.popen(comm, "r")

   if pyHandle == nil then
      rom.log.warning("Error in starting python script: " .. openErr)
   end
end

local twitchUpdateEvents = {
   --"PickupWeaponKit",                   -- equip weapon in crossroads
   --"UseFamiliar",                       -- equip familiar in crossroads
   --"EquipKeepsake",
   --"CloseMetaUpgradeCardScreen",        -- main arcana screen closed
   --"CloseUpgradeMetaUpgradeCardScreen", -- insight arcana screen closed
   --"CloseShrineUpgradeScreen",          -- close vow shrine
   --"StartNewRun",                       -- exiting crossroads
   "LeaveRoom"
}

local function initialSetup()
   -- remove python log files on startup
   removeFileIfExists(rom.path.combine(rom.paths.plugins_data(), _PLUGIN.guid, "py_out.txt"))
   removeFileIfExists(rom.path.combine(rom.paths.plugins_data(), _PLUGIN.guid, "py_auth_out.txt"))
   makePluginsDataIfNeeded()

   -- try to login with argus. if we have logged in previously this will do nothing
   attemptArgusLogin()

   -- set up our send functions
   for k, functionName in ipairs(twitchUpdateEvents) do
      modutil.mod.Path.Wrap(functionName, function(base, ...)
         base(...)
         game.thread(sendTwitchData)
      end)
   end
end

initialSetup()
