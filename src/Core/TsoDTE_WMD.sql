-- WP13 Annihilation Scar: the weapons and two abilities (right after TsoDTE_Unit_BattleMage.sql); the weapon rows copy the values of an existing WMD mod.
-- Abilities are Inactive=1, granted by TsoDTE_BattleMage.lua; no UnitAbilityModifiers (the effect comes from the weapon and Lua).

-- 1. Type registration (before all rows that reference them)
INSERT INTO
    Types (Type, Kind)
VALUES
    ('WMD_TSOD_ANNIHILATION_SCAR', 'KIND_WMD'),
    ('ABILITY_TSOD_ANNIHILATION_SCAR', 'KIND_ABILITY'),
    ('ABILITY_TSOD_ARMY_REGENERATION', 'KIND_ABILITY');

-- 2. Weapons (WMDs): TsoDTE_UnitPanel.lua recognizes weapons by the localized text of Name
INSERT INTO
    WMDs (
        WeaponType,
        Name,
        BlastRadius,
        FalloutDuration,
        AffectPopulation,
        AffectImprovements,
        AffectBuildings,
        AffectUnits,
        AffectResources,
        AffectRoutes,
        ICBMStrikeRange,
        Maintenance
    )
VALUES
    (
        'WMD_TSOD_ANNIHILATION_SCAR',
        'LOC_WMD_TSOD_ANNIHILATION_SCAR_NAME',
        1,
        0,
        0,
        0,
        1,
        1,
        0,
        0,
        8,      -- value from an existing WMD mod, needs in-game proof
        0       -- value 8 from an existing WMD mod; stock = legion count, no upkeep charged per stock (master plan §6.1)
    );

-- 3. Abilities (UnitAbilities): ShowFloatTextWhenEarned = 0, so the base-game floating text is not shown on grant; a notification is used instead.
INSERT INTO
    UnitAbilities (
        UnitAbilityType,
        Name,
        Description,
        Inactive,
        ShowFloatTextWhenEarned,
        Permanent
    )
VALUES
    (
        'ABILITY_TSOD_ANNIHILATION_SCAR',
        'LOC_ABILITY_TSOD_ANNIHILATION_SCAR_NAME',
        'LOC_ABILITY_TSOD_ANNIHILATION_SCAR_DESCRIPTION',
        1,
        0,
        1
    ),
    (
        'ABILITY_TSOD_ARMY_REGENERATION',
        'LOC_ABILITY_TSOD_ARMY_REGENERATION_NAME',
        'LOC_ABILITY_TSOD_ARMY_REGENERATION_DESCRIPTION',
        1,
        0,
        1
    );
