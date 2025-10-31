---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

NOBOONS = "NOBOONS"
NOPINS = "NOPINS"
NOWEAPONS = "NOWEAPONS"
NOFAMILIARS = "NOFAMILIARS"
NOEXTRAS = "NOEXTRAS"
NOELEMENTS = "NOELEMENTS"
NOVOWS = "NOVOWS"
NOARCANA = "NOARCANA"
dataSeparator = ";;"

function buildPinData()
    local pinData = ""
    if (game.GameState.StoreItemPins ~= nil) then
        for _, v in ipairs(game.GameState.StoreItemPins) do
            if v["Name"] ~= nil then
                pinData = pinData .. v["Name"] .. dataSeparator
            end
        end

        --cut off the last dataSeparator
        if string.len(pinData) > 0 then
            pinData = string.sub(pinData, 0, string.len(pinData) - string.len(dataSeparator))
        end
    else
        return NOPINS
    end

    return pinData
end

function buildElementalData()
    if game.CurrentRun.Hero.Elements == nil then return NOELEMENTS end
    local elements = { "Fire", "Air", "Earth", "Water", "Aether" }
    local elementsString = ""
    for _, element in ipairs(elements) do
        elementsString = elementsString .. element .. ":" .. game.CurrentRun.Hero.Elements[element] .. dataSeparator
    end

    --cut off the last dataSeparator
    if string.len(elementsString) > 0 then
        elementsString = string.sub(elementsString, 0, string.len(elementsString) - string.len(dataSeparator))
    end

    return elementsString
end

function readRaritySafe(trait)
    if trait.IsElementalTrait ~= nil and trait.IsElementalTrait then return "Infusion" end
    if trait.Rarity == nil then return "Common" end
    return trait.Rarity
end

function buildVowData()
    local vowString = ""
    if game.GameState.ShrineUpgrades ~= nil then
        for vowName, vowLevel in pairs(game.GameState.ShrineUpgrades) do
            if vowLevel ~= 0 then
                vowString = vowString .. vowLevel .. dataSeparator .. vowName .. " "
            end
        end
    end

    if vowString == "" then vowString = NOVOWS end

    return vowString
end

local familiarTraitMap = {
    HealthFamiliar = { "HealthFamiliar", "FamiliarFrogResourceBonus" },
    CritFamiliar = { "CritFamiliar", "FamiliarRavenResourceBonus" },
    LastStandFamiliar = { "LastStandFamiliar", "FamiliarCatResourceBonus" },
    DigFamiliar = { "DigFamiliar", "FamiliarHoundResourceBonus" },
    DodgeFamiliar = { "DodgeFamiliar", "FamiliarPolecatResourceBonus" },
}

function buildFamiliarData(familiarTrait)
    if familiarTrait == nil or familiarTrait.Name == nil then
        return NOFAMILIARS
    end

    local familiarString = familiarTrait.Name

    local familiarTraits = familiarTraitMap[familiarTrait.Name];
    local traitCounter = 1

    for ind, fam in pairs(familiarTraits) do
        for k, heroTrait in pairs(game.CurrentRun.Hero.Traits) do
            if heroTrait.Name ~= nil and heroTrait.StackNum ~= nil and heroTrait.Name == fam then
                familiarString = familiarString .. " " .. heroTrait.StackNum .. dataSeparator .. heroTrait.Name
                traitCounter = traitCounter + 1
            end
        end
    end

    if traitCounter ~= 3 then
        return "INVALID"
    end

    return familiarString
end
