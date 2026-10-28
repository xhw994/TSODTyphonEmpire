-- WP5 Mage Tower (replaces Campus); loaded only under the Gathering Storm ruleset: Districts_XP2, PROMOTION_SPACE_ROCK, and MODIFIER_CITY_ADJUST_SPY_BONUS, which exists only from Rise and Fall onward.
-- Depends on TsoDTE_Civilization.sql being loaded first; precedents: Maya's Observatory, Korea's Seowon, Gaul's Oppidum.

-- 1. Type registration
INSERT INTO Types (Type, Kind) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER',                    'KIND_DISTRICT'),
    ('TRAIT_CIVILIZATION_DISTRICT_TSOD_MAGE_TOWER', 'KIND_TRAIT');

-- 2. Unique district trait (follows the Observatory / Oppidum: the trait name is the district name, no separate description)
INSERT INTO Traits (TraitType, Name) VALUES
    ('TRAIT_CIVILIZATION_DISTRICT_TSOD_MAGE_TOWER', 'LOC_DISTRICT_TSOD_MAGE_TOWER_NAME');

INSERT INTO CivilizationTraits (CivilizationType, TraitType) VALUES
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'TRAIT_CIVILIZATION_DISTRICT_TSOD_MAGE_TOWER');

-- 3. Main district row
-- Values copied from the Campus; cost halved to 27; ZOC / HitPoints / CityStrengthModifier follow the Oppidum.
-- CaptureRemovesBuildings kept at the Campus's 0 (buildings such as the Library do not disappear when the district is captured).
INSERT INTO Districts (
    DistrictType, Name, Description, PrereqTech,
    PlunderType, PlunderAmount, AdvisorType,
    Cost, CostProgressionModel, CostProgressionParam1, Maintenance,
    RequiresPlacement, RequiresPopulation, Aqueduct, NoAdjacentCity, InternalOnly,
    ZOC, HitPoints, CaptureRemovesBuildings, CaptureRemovesCityDefenses,
    MilitaryDomain, CityStrengthModifier, TraitType
) VALUES (
    'DISTRICT_TSOD_MAGE_TOWER', 'LOC_DISTRICT_TSOD_MAGE_TOWER_NAME', 'LOC_DISTRICT_TSOD_MAGE_TOWER_DESCRIPTION', 'TECH_WRITING',
    'PLUNDER_SCIENCE', 25, 'ADVISOR_TECHNOLOGY',
    27, 'COST_PROGRESSION_NUM_UNDER_AVG_PLUS_TECH', 40, 1,
    1, 1, 0, 0, 0,
    1, 100, 0, 0,
    'NO_DOMAIN', 2, 'TRAIT_CIVILIZATION_DISTRICT_TSOD_MAGE_TOWER'
);

INSERT INTO DistrictReplaces (CivUniqueDistrictType, ReplacesDistrictType) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'DISTRICT_CAMPUS');

-- Gathering Storm: every district that can attack at range needs a range (precedent: City Center, Encampment and Oppidum all have AttackRange=2 in Districts_XP2).
INSERT INTO Districts_XP2 (DistrictType, AttackRange) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 2);

-- 4. Companion row of the Campus (follows the Observatory precedent; values same as the Campus)
INSERT INTO District_GreatPersonPoints (DistrictType, GreatPersonClassType, PointsPerTurn) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'GREAT_PERSON_CLASS_SCIENTIST', 1);

INSERT INTO District_CitizenYieldChanges (DistrictType, YieldType, YieldChange) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'YIELD_SCIENCE', 2);

INSERT INTO District_TradeRouteYields (DistrictType, YieldType, YieldChangeAsOrigin, YieldChangeAsDomesticDestination, YieldChangeAsInternationalDestination) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'YIELD_FOOD',    0, 1, 0),
    ('DISTRICT_TSOD_MAGE_TOWER', 'YIELD_SCIENCE', 0, 0, 1);

-- 5. Adjacency bonuses
-- 5a. Keeps all of the Campus's adjacency bonuses: copied from the Campus's existing rows at load time rather than hard-coded one by one,
--     since the Campus's adjacency bonuses vary with ruleset, DLC and game mode (details and expected row counts in docs/notes.md).
INSERT INTO District_Adjacencies (DistrictType, YieldChangeId)
SELECT 'DISTRICT_TSOD_MAGE_TOWER', YieldChangeId
FROM District_Adjacencies
WHERE DistrictType = 'DISTRICT_CAMPUS';

-- 5b. New: +2 Science for each adjacent Encampment district (the standard value for "large adjacency"; written like Government_Science)
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) VALUES
    ('TSOD_TYPHON_MAGE_TOWER_ENCAMPMENT_SCIENCE', 'LOC_DISTRICT_TSOD_MAGE_TOWER_ENCAMPMENT_SCIENCE', 'YIELD_SCIENCE', 2, 1, 'DISTRICT_ENCAMPMENT');

INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'TSOD_TYPHON_MAGE_TOWER_ENCAMPMENT_SCIENCE');

-- 6. Counter-espionage: enemy spy operations in this city -1 level
-- Value follows the Consulate (Amount=1), but its MODIFIER_PLAYER_CITIES_ADJUST_SPY_BONUS is defined only in the Ethiopia pack,
-- so the expansion's own MODIFIER_CITY_ADJUST_SPY_BONUS is used instead; when attached to DistrictModifiers, OWNER resolves to the district's city.
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('TSOD_TYPHON_MAGE_TOWER_SPY_DEFENSE', 'MODIFIER_CITY_ADJUST_SPY_BONUS');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_MAGE_TOWER_SPY_DEFENSE', 'Amount', '1');

INSERT INTO DistrictModifiers (DistrictType, ModifierId) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'TSOD_TYPHON_MAGE_TOWER_SPY_DEFENSE');

-- 7. Gathering Storm: the Space Rock rock band's promotion bonus to the Campus also applies to the Mage Tower
-- The Seowon and Observatory each got their own ROCKBAND_SPACE_ROCK_<district> and _MODIFIER rows; values same as the Campus version.
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER',          'MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT'),
    ('TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER_MODIFIER', 'MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER',          'DistrictType', 'DISTRICT_TSOD_MAGE_TOWER'),
    ('TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER',          'Amount',       '1'),
    ('TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER_MODIFIER', 'DistrictType', 'DISTRICT_TSOD_MAGE_TOWER'),
    ('TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER_MODIFIER', 'Amount',       '500');

INSERT INTO UnitPromotionModifiers (UnitPromotionType, ModifierId) VALUES
    ('PROMOTION_SPACE_ROCK', 'TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER'),
    ('PROMOTION_SPACE_ROCK', 'TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER_MODIFIER');

-- The Campus's other references (building prerequisite districts, Great People, projects, policies...) are intentionally handled by DistrictReplaces; the list is in docs/notes.md.
