
NOBOONS = "NOBOONS"
NOWEAPONS = "NOWEAPONS"
NOFAMILIARS = "NOFAMILIARS"
NOEXTRAS = "NOEXTRAS"
NOELEMENTS = "NOELEMENTS"
NOPINS = "NOPINS"
NOVOWS = "NOVOWS"
NOARCANA = "NOARCANA"

def get_test_data(which_test):
    if which_test == "test1":
        boon_data = "Common;;ApolloManaBoon Rare;;AphroditeSpecialBoon Epic;;PoseidonWeaponBoon Heroic;;PoseidonCastBoon Common;;DaggerBlinkAoETrait Duo;;PoseidonSplashSprintBoon Rare;;DoubleRewardBoon Legendary;;AmplifyConeBoon Infusion;;ElementalDodgeBoon"
        weapon_data = "Rare;;DaggerBlockAspect"
        familiar_data = "LastStandFamiliar 2;;LastStandFamiliar 3;;FamiliarCatResourceBonus 4;;FamiliarCatAttacks"
        extra_data = "Epic;;ForceZeusBoonKeepsake Common;;SpellSummonTrait"
        elemental_data = "Fire:1;;Water:0;;Earth:3;;Air:0;;Aether:0"
        pin_data = "RandomStatusBoon;;AresExCastBoon;;GoodStuffBoon"
        vow_data = "4;;BossDifficultyShrineUpgrade 1;;MinibossCountShrineUpgrade 2;;NextBiomeEnemyShrineUpgrade 2;;BiomeSpeedShrineUpgrade"
        arcana_data = "3;;ScreenReroll 3;;StatusVulnerability 2;;ChanneledCast 3;;HealthRegen 3;;LowManaDamageBonus 1;;CastCount 3;;SorceryRegenUpgrade"
    elif which_test == "test2":
        boon_data = "Common;;ApolloWeaponBoon"
        weapon_data = NOWEAPONS
        familiar_data = NOFAMILIARS
        extra_data = NOEXTRAS
        elemental_data = NOELEMENTS
        pin_data = NOPINS
        vow_data = NOVOWS
        arcana_data = NOARCANA
    elif which_test == "pins":
        boon_data = "Common;;ApolloManaBoon Rare;;AphroditeSpecialBoon Epic;;PoseidonWeaponBoon Heroic;;PoseidonCastBoon Common;;DaggerBlinkAoETrait Duo;;PoseidonSplashSprintBoon Rare;;DoubleRewardBoon Legendary;;AmplifyConeBoon Infusion;;ElementalDodgeBoon"
        weapon_data = "Rare;;DaggerBlockAspect"
        familiar_data = "LastStandFamiliar 2;;LastStandFamiliar 3;;FamiliarCatResourceBonus 4;;FamiliarCatAttacks"
        extra_data = "Epic;;ForceZeusBoonKeepsake Common;;SpellSummonTrait"
        elemental_data = "Fire:1;;Water:0;;Earth:3;;Air:0;;Aether:0"
        pin_data = "LuckyBoon;;ElementalUnifiedBoon;;GoodStuffBoon"
        vow_data = "4;;BossDifficultyShrineUpgrade 1;;MinibossCountShrineUpgrade 2;;NextBiomeEnemyShrineUpgrade 2;;BiomeSpeedShrineUpgrade"
        arcana_data = "3;;ScreenReroll 3;;StatusVulnerability 2;;ChanneledCast 3;;HealthRegen 3;;LowManaDamageBonus 1;;CastCount 3;;SorceryRegenUpgrade"
    else:
        boon_data = NOBOONS
        weapon_data = NOWEAPONS
        familiar_data = NOFAMILIARS
        extra_data = NOEXTRAS
        elemental_data = NOELEMENTS
        pin_data = NOPINS
        vow_data = NOVOWS
        arcana_data = NOARCANA
    return boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data, vow_data, arcana_data