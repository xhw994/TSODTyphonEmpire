-- WP6 Burnstone Acidification Works (unique building replacing the Factory; Gathering Storm ruleset). Precedent: Japan's BUILDING_ELECTRONICS_FACTORY.
-- Depends on TsoDTE_Civilization.sql being loaded first.

-- 1. Type registration
INSERT INTO
    Types (Type, Kind)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'KIND_BUILDING'),
    ('TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS', 'KIND_TRAIT');

-- 2. Trait, attached to the civ (base-game precedent: Traits fill only Name)
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

-- 3. Main building row: column values follow the Factory (Cost 330 under Gathering Storm); RegionalRange 6 kept for the regional-range spillover.
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

-- 4. Yields: +6 Production, +3 Science (the Factory gives +3 Production)
INSERT INTO
    Building_YieldChanges (BuildingType, YieldType, YieldChange)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'YIELD_PRODUCTION', 6),
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'YIELD_SCIENCE', 3);

INSERT INTO
    Building_GreatPersonPoints (BuildingType, GreatPersonClassType, PointsPerTurn)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'GREAT_PERSON_CLASS_ENGINEER', 1);

-- 5. Gathering Storm power rules (same as the Factory): needs 2 power; +3 Production extra when powered
-- Does not register ResourceTypeConvertedToPower, so it burns no resources and emits no carbon.
INSERT INTO
    Buildings_XP2 (BuildingType, RequiredPower)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 2);

INSERT INTO
    Building_YieldChangesBonusWithPower (BuildingType, YieldType, YieldChange)
VALUES
    ('BUILDING_TSOD_BURNSTONE_WORKS', 'YIELD_PRODUCTION', 3);

-- 6. Doomsday "Solar Flare" event destroys Factories (the base game registers the Electronics Factory as well). The event comes from the Apocalypse mode of the Gran Colombia and Maya pack, which loads before this mod:
-- it copies the Factory's existing row; if the mode is off the row is not found and nothing is inserted.
INSERT INTO
    RandomEvent_PillagedBuildings (RandomEventType, BuildingType)
SELECT
    RandomEventType,
    'BUILDING_TSOD_BURNSTONE_WORKS'
FROM
    RandomEvent_PillagedBuildings
WHERE
    BuildingType = 'BUILDING_FACTORY';

-- 7. All farms in this city +5 Food (Dust of Plenty; precedent: the Watermill's WATERMILL_ADDRICEFOOD)
-- The requirement set uses the official REQUIREMENTS_PLOT_HAS_FARM
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

-- 8. All mines and quarries in this city +2 Production (base-game basis: see docs/notes.md); applies only to this city, not spilled over by RegionalRange.
-- Same shape as the farms (section 7): one TEST_ALL requirement set per modifier, each with its own requirements.
-- Previously used TEST_ANY over the official REQUIRES_PLOT_HAS_MINE / _QUARRY; the I1 in-game test showed the +2 did not apply.
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
