-- ============================================================================
-- WP6 燃石酸化工厂（特色建筑，替代工厂）
-- 规则集：风云变幻（本文件所在动作挂 TsoDTE_Expansion2 criteria）
-- 先例：日本电子厂 BUILDING_ELECTRONICS_FACTORY（官方唯一替代工厂的特色建筑），
--       Base/Buildings.xml + DLC/Expansion2/Expansion2_Buildings.xml。
-- 依赖：CIVILIZATION_TSOD_TYPHON_EMPIRE（WP1，TsoDTE_Civilization.sql 先加载）。
-- 不做：排碳、烧煤（master plan §6.3）。
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. 类型登记
-- ----------------------------------------------------------------------------
INSERT INTO
    Types (Type, Kind)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'KIND_BUILDING'),
    ('TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS', 'KIND_TRAIT');

-- ----------------------------------------------------------------------------
-- 2. 特性，挂到文明（官方先例 Traits 只填 Name）
-- ----------------------------------------------------------------------------
INSERT INTO
    Traits (TraitType, Name)
VALUES
    (
        'TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS',
        'LOC_TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS_NAME'
    );

INSERT INTO
    CivilizationTraits (CivilizationType, TraitType)
VALUES
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS');

-- ----------------------------------------------------------------------------
-- 3. 建筑主表：列值照工厂（风云变幻下 Cost 330），RegionalRange 6 保留范围辐射
-- ----------------------------------------------------------------------------
INSERT INTO
    Buildings (
        BuildingType,
        Name,
        Description,
        PrereqTech,
        PrereqDistrict,
        PurchaseYield,
        Cost,
        AdvisorType,
        Maintenance,
        CitizenSlots,
        RegionalRange,
        TraitType
    )
VALUES
    (
        'BUILDING_TSOD_BURNSTONE_WORKS',
        'LOC_BUILDING_TSOD_BURNSTONE_WORKS_NAME',
        'LOC_BUILDING_TSOD_BURNSTONE_WORKS_DESCRIPTION',
        'TECH_INDUSTRIALIZATION',
        'DISTRICT_INDUSTRIAL_ZONE',
        'YIELD_GOLD',
        330,
        'ADVISOR_GENERIC',
        2,
        1,
        6,
        'TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS'
    );

INSERT INTO
    BuildingReplaces (CivUniqueBuildingType, ReplacesBuildingType)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'BUILDING_FACTORY');

-- 前置建筑：工坊（同工厂）
INSERT INTO
    BuildingPrereqs (Building, PrereqBuilding)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'BUILDING_WORKSHOP');

-- ----------------------------------------------------------------------------
-- 4. 产出：+6 生产力、+3 科技（工厂是 +3 生产力）
-- ----------------------------------------------------------------------------
INSERT INTO
    Building_YieldChanges (BuildingType, YieldType, YieldChange)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'YIELD_PRODUCTION', 6),
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'YIELD_SCIENCE', 3);

-- 大工程师点数（同工厂）
INSERT INTO
    Building_GreatPersonPoints (BuildingType, GreatPersonClassType, PointsPerTurn)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'GREAT_PERSON_CLASS_ENGINEER', 1);

-- ----------------------------------------------------------------------------
-- 5. 风云变幻用电规则（同工厂）：需 2 电力；通电额外 +3 生产力
--    不登记 ResourceTypeConvertedToPower，所以不烧资源、不排碳
-- ----------------------------------------------------------------------------
INSERT INTO
    Buildings_XP2 (BuildingType, RequiredPower)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 2);

INSERT INTO
    Building_YieldChangesBonusWithPower (BuildingType, YieldType, YieldChange)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'YIELD_PRODUCTION', 3);

-- ----------------------------------------------------------------------------
-- 6. 末日模式「太阳耀斑」会破坏工厂；官方把电子厂也登记了。
--    该事件只在格兰哥伦比亚与玛雅包的末日模式下存在（其动作 LoadOrder 默认，
--    早于本 mod），所以照抄工厂已有的行；模式未开时查不到行，什么也不插。
-- ----------------------------------------------------------------------------
INSERT INTO
    RandomEvent_PillagedBuildings (RandomEventType, BuildingType)
SELECT
    RandomEventType,
    'BUILDING_TSOD_BURNSTONE_WORKS'
FROM
    RandomEvent_PillagedBuildings
WHERE
    BuildingType = 'BUILDING_FACTORY';

-- ----------------------------------------------------------------------------
-- 7. 本城所有农场 +5 食物（丰饶之尘）
--    先例：水磨 WATERMILL_ADDRICEFOOD（BuildingModifiers +
--    MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD）；
--    需求组用官方现成的 REQUIREMENTS_PLOT_HAS_FARM（Base/Civilizations.xml）。
-- ----------------------------------------------------------------------------
INSERT INTO
    BuildingModifiers (BuildingType, ModifierId)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'TSOD_TYPHON_BURNSTONE_WORKS_FARM_FOOD');

INSERT INTO
    Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
    (
        'TSOD_TYPHON_BURNSTONE_WORKS_FARM_FOOD',
        'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
        'REQUIREMENTS_PLOT_HAS_FARM'
    );

INSERT INTO
    ModifierArguments (ModifierId, Name, Value)
VALUES
    ('TSOD_TYPHON_BURNSTONE_WORKS_FARM_FOOD', 'YieldType', 'YIELD_FOOD'),
    ('TSOD_TYPHON_BURNSTONE_WORKS_FARM_FOOD', 'Amount', '5');
