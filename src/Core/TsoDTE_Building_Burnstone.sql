-- WP6 燃石酸化工厂（特色建筑，替代工厂；风云变幻规则集）。先例：日本电子厂 BUILDING_ELECTRONICS_FACTORY。
-- 依赖 TsoDTE_Civilization.sql 先加载。

-- 1. 类型登记
INSERT INTO
    Types (Type, Kind)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'KIND_BUILDING'),
    ('TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS', 'KIND_TRAIT');

-- 2. 特性，挂到文明（官方先例 Traits 只填 Name）
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

-- 3. 建筑主表：列值照工厂（风云变幻下 Cost 330），RegionalRange 6 保留范围辐射
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

INSERT INTO
    BuildingPrereqs (Building, PrereqBuilding)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'BUILDING_WORKSHOP');

-- 4. 产出：+6 生产力、+3 科技（工厂是 +3 生产力）
INSERT INTO
    Building_YieldChanges (BuildingType, YieldType, YieldChange)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'YIELD_PRODUCTION', 6),
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'YIELD_SCIENCE', 3);

INSERT INTO
    Building_GreatPersonPoints (BuildingType, GreatPersonClassType, PointsPerTurn)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'GREAT_PERSON_CLASS_ENGINEER', 1);

-- 5. 风云变幻用电规则（同工厂）：需 2 电力；通电额外 +3 生产力
-- 不登记 ResourceTypeConvertedToPower，所以不烧资源、不排碳
INSERT INTO
    Buildings_XP2 (BuildingType, RequiredPower)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 2);

INSERT INTO
    Building_YieldChangesBonusWithPower (BuildingType, YieldType, YieldChange)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'YIELD_PRODUCTION', 3);

-- 6. 末日模式「太阳耀斑」会破坏工厂（官方连电子厂也登记了）。该事件由格兰哥伦比亚与玛雅包的
-- 末日模式提供，加载早于本 mod：照抄工厂已有的行，模式未开时查不到行，什么也不插。
INSERT INTO
    RandomEvent_PillagedBuildings (RandomEventType, BuildingType)
SELECT
    RandomEventType,
    'BUILDING_TSOD_BURNSTONE_WORKS'
FROM
    RandomEvent_PillagedBuildings
WHERE
    BuildingType = 'BUILDING_FACTORY';

-- 7. 本城所有农场 +5 食物（丰饶之尘；先例水磨 WATERMILL_ADDRICEFOOD）
-- 需求组用官方现成的 REQUIREMENTS_PLOT_HAS_FARM
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

-- 8. 本城所有矿山、采石场 +2 生产力（原作依据见 docs/notes.md）；只作用于本城，不随 RegionalRange 辐射。
-- 与农场（第 7 节）同形：每个修正一个 TEST_ALL 需求组，需求自己定义。
-- 曾用 TEST_ANY 套官方 REQUIRES_PLOT_HAS_MINE / _QUARRY，I1 实测 +2 不生效。
INSERT INTO
    BuildingModifiers (BuildingType, ModifierId)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'TSOD_TYPHON_BURNSTONE_WORKS_MINE_PRODUCTION'),
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'TSOD_TYPHON_BURNSTONE_WORKS_QUARRY_PRODUCTION');

INSERT INTO
    Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
    (
        'TSOD_TYPHON_BURNSTONE_WORKS_MINE_PRODUCTION',
        'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
        'REQSET_TSOD_TYPHON_PLOT_HAS_MINE'
    ),
    (
        'TSOD_TYPHON_BURNSTONE_WORKS_QUARRY_PRODUCTION',
        'MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD',
        'REQSET_TSOD_TYPHON_PLOT_HAS_QUARRY'
    );

INSERT INTO
    ModifierArguments (ModifierId, Name, Value)
VALUES
    ('TSOD_TYPHON_BURNSTONE_WORKS_MINE_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION'),
    ('TSOD_TYPHON_BURNSTONE_WORKS_MINE_PRODUCTION', 'Amount', '2'),
    ('TSOD_TYPHON_BURNSTONE_WORKS_QUARRY_PRODUCTION', 'YieldType', 'YIELD_PRODUCTION'),
    ('TSOD_TYPHON_BURNSTONE_WORKS_QUARRY_PRODUCTION', 'Amount', '2');

INSERT INTO
    Requirements (RequirementId, RequirementType)
VALUES
    ('REQ_TSOD_TYPHON_PLOT_HAS_MINE', 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES'),
    ('REQ_TSOD_TYPHON_PLOT_HAS_QUARRY', 'REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES');

INSERT INTO
    RequirementArguments (RequirementId, Name, Value)
VALUES
    ('REQ_TSOD_TYPHON_PLOT_HAS_MINE', 'ImprovementType', 'IMPROVEMENT_MINE'),
    ('REQ_TSOD_TYPHON_PLOT_HAS_QUARRY', 'ImprovementType', 'IMPROVEMENT_QUARRY');

INSERT INTO
    RequirementSets (RequirementSetId, RequirementSetType)
VALUES
    ('REQSET_TSOD_TYPHON_PLOT_HAS_MINE', 'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_PLOT_HAS_QUARRY', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO
    RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
    ('REQSET_TSOD_TYPHON_PLOT_HAS_MINE', 'REQ_TSOD_TYPHON_PLOT_HAS_MINE'),
    ('REQSET_TSOD_TYPHON_PLOT_HAS_QUARRY', 'REQ_TSOD_TYPHON_PLOT_HAS_QUARRY');
