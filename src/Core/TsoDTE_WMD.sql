-- WP13 湮灭之创：武器与两个能力（紧跟 TsoDTE_Unit_BattleMage.sql 之后）；武器行照可莉的 WMD_JUMPY_DUMPTY。
-- 能力 Inactive=1，由 TsoDTE_BattleMage.lua 授予；没有 UnitAbilityModifiers（效果靠武器和 Lua）。

-- 1. 类型登记（先于所有引用它们的行）
INSERT INTO
    Types (Type, Kind)
VALUES
    ('WMD_TSOD_ANNIHILATION_SCAR', 'KIND_WMD'),
    ('ABILITY_TSOD_ANNIHILATION_SCAR', 'KIND_ABILITY'),
    ('ABILITY_TSOD_ARMY_REGENERATION', 'KIND_ABILITY');

-- 2. 武器（WMDs）：UnitPanel_TsoDTE.lua 按 Name 的译文认武器
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
        8,      -- 同可莉，需实证
        0       -- 可莉为 8；库存 = 军团数，不按库存收维护费（master plan §6.1）
    );

-- 3. 能力（UnitAbilities）：ShowFloatTextWhenEarned = 0，授予时不弹官方浮字，改用通知。
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
