---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

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
    for k, currentTrait in pairs(game.CurrentRun.Hero.Traits) do
        if isWeaponTrait(currentTrait) and weaponString == "" then
            weaponString = readRaritySafe(currentTrait) .. dataSeparator .. currentTrait.Name
            goto continue_loop
        end
        if isFamiliarTrait(currentTrait) and familiarString == "" then
            familiarString = buildFamiliarData(currentTrait)
            goto continue_loop
        end
        if isKeepsakeTrait(currentTrait) or isHexTrait(currentTrait) or
            isChaosCurse(currentTrait) or isExtraHadesBoon(currentTrait) or
            isExtraIcarusTrait(currentTrait) or isExtraMedeaTrait(currentTrait) or
            isExtraCirceTrait(currentTrait) or isExtraAthenaTrait(currentTrait) then
            extraString = extraString .. readRaritySafe(currentTrait) .. dataSeparator .. currentTrait.Name .. " "
            goto continue_loop
        end
        if isHammerTrait(currentTrait) or isArachneTrait(currentTrait) then
            boonList = boonList .. "Common" .. dataSeparator .. currentTrait.Name .. " "
            goto continue_loop
        end
        if game.IsGodTrait(currentTrait.Name, { ForShop = true }) or
            isChaosBlessing(currentTrait) or isMainHadesBoon(currentTrait) or
            isMainIcarusTrait(currentTrait) or isMainMedeaTrait(currentTrait) or
            isMainCirceTrait(currentTrait) or isMainAthenaTrait(currentTrait) then
            boonList = boonList .. readRaritySafe(currentTrait) .. dataSeparator .. currentTrait.Name .. " "
            goto continue_loop
        end
        if isArcanaTrait(currentTrait) then
            arcanaString = arcanaString ..
                arcanaLevelFromRarity(readRaritySafe(currentTrait)) .. dataSeparator .. currentTrait.Name .. " "
        end
        ::continue_loop::
    end

    if weaponString == "" then
        rom.log.warning("Didn't find weapon trait. Skipping cycle.")
        return
    end
    if familiarString == "INVALID" then
        rom.log.warning("Partial familiar data. Skipping cycle.")
        return
    end
    elementsString = buildElementalData()
    pinsString = buildPinData()
    vowString = buildVowData()

    if config.argus_debug then
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
    end
    local pluginsDataPath = rom.path.combine(rom.paths.plugins_data(), _PLUGIN.guid)
    local pythonPath = rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, 'py')
    local comm = ('python ' .. rom.path.combine(pythonPath, 'send_to_argus.py') -- run print script
        .. " --pluginpath " .. pluginsDataPath                                  -- tell python where to write data files
        .. " >> " .. rom.path.combine(pluginsDataPath, "py_out.txt 2>&1"))      -- redirect stdout of python to a file

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
