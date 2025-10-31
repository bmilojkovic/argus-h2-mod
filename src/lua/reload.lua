---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.

function printHeroTraits()
    local printString = ""
    --[[if game.CurrentRun ~= nil and game.CurrentRun.Hero ~= nil and game.CurrentRun.Hero.Traits ~= nil then
        for k, currentTrait in pairs(game.CurrentRun.Hero.Traits) do
            if currentTrait.Name ~= nil then
                printString = printString .. stringifyTable(currentTrait) .. " "
            end
        end
        rom.log.warning(printString)
    end]] --
    rom.log.warning(stringifyTable(game.CurrentRun.Hero.Traits))
end
