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
        ::continue_loop::
    end

    if weaponString == "" then
        rom.log.info("Didn't find weapon trait. Skipping cycle.")
        return
    end
    if familiarString == "INVALID" then
        rom.log.info("Partial familiar data. Skipping cycle.")
        return
    end
    elementsString = buildElementalData()
    pinsString = buildPinData()
    vowString = buildVowData()
    arcanaString = buildArcanaData()
    if boonList ~= "" then
        rom.log.info("Boon list: " .. boonList)
    end
    if weaponString ~= "" then
        rom.log.info("Weapon: " .. weaponString)
    end
    if familiarString ~= "" then
        rom.log.info("Familiar: " .. familiarString)
    end
    if extraString ~= "" then
        rom.log.info("Extra: " .. extraString)
    end
    if elementsString ~= "" then
        rom.log.info("Elements: " .. elementsString)
    end
    if pinsString ~= "" then
        rom.log.info("Pins: " .. pinsString)
    end
    if vowString ~= "" then
        rom.log.info("Vows: " .. vowString)
    end
    if arcanaString ~= "" then
        rom.log.info("Arcana: " .. arcanaString)
    end
    local comm = ('python ' .. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, 'send_to_argus.py') -- run print script
        .. " --pluginpath " .. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid)                     -- tell python where it is running
        .. " >> " .. rom.path.combine(rom.paths.plugins(), _PLUGIN.guid, "py_out.txt 2>&1"))           -- redirect stdout of python to a file

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
