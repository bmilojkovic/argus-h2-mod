---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.


function send_twitch_data()
	rom.log.warning("Got new trait! Count is " .. game.GetTotalTraitCount(game.CurrentRun.Hero))
	traitList = ""
	for k, currentTrait in pairs( game.CurrentRun.Hero.Traits ) do
        if game.IsGodTrait(currentTrait.Name, { ForShop = true }) then
			traitList = traitList .. currentTrait.Rarity .. "-" .. currentTrait.Name .. " "
		end
	end
	rom.log.warning("Trait list: " .. traitList)

	local comm = ('python '.. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, 'send_to_argus.py') -- run print script
		.. " > " .. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, "py_out.txt 2>&1")) -- redirect stdout of python to a file

    local py_handle, open_err = io.popen(comm, "w")
	
	if py_handle ~= nil then
		local write_succ, errmsg = py_handle:write(traitList .. "\n")
		if not write_succ then
			rom.log.warning(errmsg)
		end
		py_handle:flush()
	else
		rom.log.warning("Error in starting python script: " .. open_err)
	end
end

function trigger_Gift()
	modutil.mod.Hades.PrintOverhead(config.message)
end