-- WP4 Battle Mage UNIT_TSOD_BATTLE_MAGE (replaces the Crossbowman); depends on TsoDTE_Civilization.sql creating the civ first (CivilizationTraits foreign key).
-- No upgrade: no UnitUpgrades written and no MandatoryObsoleteTech set; per-item precedents are in docs/notes.md.

-- 1. Type registration
INSERT INTO
    Types (Type, Kind)
VALUES
    ('UNIT_TSOD_BATTLE_MAGE', 'KIND_UNIT'),
    ('TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE', 'KIND_TRAIT'),
    ('ABILITY_TSOD_BATTLE_MAGE_BALLISTICS', 'KIND_ABILITY'),
    ('ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS', 'KIND_ABILITY'),
    ('ABILITY_TSOD_BATTLE_MAGE_CONCERT', 'KIND_ABILITY');

-- 2. Trait: unique unit attached to the civ (ids.md §5.5 assigns it to WP4)
INSERT INTO
    Traits (TraitType, Name, Description)
VALUES
    (
        'TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE',
        'LOC_UNIT_TSOD_BATTLE_MAGE_NAME',
        'LOC_UNIT_TSOD_BATTLE_MAGE_DESCRIPTION'
    );

INSERT INTO
    CivilizationTraits (CivilizationType, TraitType)
VALUES
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE');

-- 3. Unit row (stats copied from the Crossbowman; MandatoryObsoleteTech removed)
-- WMDCapable = 1: the unit panel gives each WMD its own button, filtered by TsoDTE_UnitPanel.lua;
-- if the UI replacement does not take effect, base-game buttons such as nuclear weapons reappear.
INSERT INTO
    Units (
        UnitType,
        Name,
        Description,
        TraitType,
        Cost,
        Maintenance,
        BaseMoves,
        BaseSightRange,
        ZoneOfControl,
        Domain,
        Combat,
        RangedCombat,
        Range,
        FormationClass,
        PromotionClass,
        AdvisorType,
        PurchaseYield,
        PrereqTech,
        WMDCapable
    )
VALUES
    (
        'UNIT_TSOD_BATTLE_MAGE',
        'LOC_UNIT_TSOD_BATTLE_MAGE_NAME',
        'LOC_UNIT_TSOD_BATTLE_MAGE_DESCRIPTION',
        'TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE',
        180,
        3,
        2,
        2,
        0,
        'DOMAIN_LAND',
        30,
        40,
        2,
        'FORMATION_CLASS_LAND_COMBAT',
        'PROMOTION_CLASS_RANGED',
        'ADVISOR_CONQUEST',
        'YIELD_GOLD',
        'TECH_MACHINERY',
        1
    );

INSERT INTO
    UnitReplaces (CivUniqueUnitType, ReplacesUnitType)
VALUES
    ('UNIT_TSOD_BATTLE_MAGE', 'UNIT_CROSSBOWMAN');

-- AI types: the Crossbowman's three plus UNITTYPE_NUCLEAR (the base game gives it only to bombers, jet bombers and nuclear submarines)
INSERT INTO
    UnitAiInfos (UnitType, AiType)
VALUES
    ('UNIT_TSOD_BATTLE_MAGE', 'UNITAI_COMBAT'),
    ('UNIT_TSOD_BATTLE_MAGE', 'UNITTYPE_RANGED'),
    ('UNIT_TSOD_BATTLE_MAGE', 'UNITTYPE_LAND_COMBAT'),
    ('UNIT_TSOD_BATTLE_MAGE', 'UNITTYPE_NUCLEAR');

-- 4. Tags: unit class and ability class
INSERT INTO
    Tags (Tag, Vocabulary)
VALUES
    ('CLASS_TSOD_BATTLE_MAGE', 'ABILITY_CLASS');

INSERT INTO
    TypeTags (Type, Tag)
VALUES
    ('UNIT_TSOD_BATTLE_MAGE', 'CLASS_RANGED'),
    ('UNIT_TSOD_BATTLE_MAGE', 'CLASS_TSOD_BATTLE_MAGE'),
    ('UNIT_TSOD_BATTLE_MAGE', 'CLASS_ALL_ERAS'),
    ('ABILITY_TSOD_BATTLE_MAGE_BALLISTICS', 'CLASS_TSOD_BATTLE_MAGE'),
    ('ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS', 'CLASS_TSOD_BATTLE_MAGE'),
    ('ABILITY_TSOD_BATTLE_MAGE_CONCERT', 'CLASS_TSOD_BATTLE_MAGE');

-- 5. Abilities
-- Ballistics Growth ability Inactive = 1: granted only by the grant modifier (same as Nihang); Legion-Class Spell Inactive = 0: units with the tag get it automatically (same as Heavy Infantry).
INSERT INTO
    UnitAbilities (UnitAbilityType, Name, Description, Inactive)
VALUES
    (
        'ABILITY_TSOD_BATTLE_MAGE_BALLISTICS',
        'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_NAME',
        'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_DESCRIPTION',
        1
    ),
    (
        'ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS',
        'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_NAME',
        'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_DESCRIPTION',
        1
    ),
    (
        'ABILITY_TSOD_BATTLE_MAGE_CONCERT',
        'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_NAME',
        'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_DESCRIPTION',
        0
    );

INSERT INTO
    UnitAbilityModifiers (UnitAbilityType, ModifierId)
VALUES
    ('ABILITY_TSOD_BATTLE_MAGE_BALLISTICS', 'TSOD_TYPHON_BATTLE_MAGE_BALLISTICS_STRENGTH'),
    ('ABILITY_TSOD_BATTLE_MAGE_BALLISTICS', 'TSOD_TYPHON_BATTLE_MAGE_BALLISTICS_RANGED'),
    ('ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS', 'TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_STRENGTH'),
    ('ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS', 'TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_RANGED'),
    ('ABILITY_TSOD_BATTLE_MAGE_CONCERT', 'TSOD_TYPHON_BATTLE_MAGE_CONCERT');

-- The grant modifier attaches to the mod's own unique unit trait (ids.md §5.5) and does not touch WP1's civ ability shell
INSERT INTO
    TraitModifiers (TraitType, ModifierId)
VALUES
    ('TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE', 'TSOD_TYPHON_BATTLE_MAGE_GRANT_BALLISTICS'),
    ('TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE', 'TSOD_TYPHON_BATTLE_MAGE_GRANT_ADV_BALLISTICS');

-- 6. Modifiers: cumulative growth, Mechanical 40/30 → Ballistics 60/50 → Advanced Ballistics 85/70 (ranged/melee)
-- MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH changes only melee, not ranged (confirmed in-game, I1),
-- so melee uses the base combat strength modifier (shown in the panel), and ranged uses the ordinary combat strength modifier "when attacking at range" (shown in the combat preview).
INSERT INTO
    Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
VALUES
    (
        'TSOD_TYPHON_BATTLE_MAGE_GRANT_BALLISTICS',
        'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',
        'REQSET_TSOD_TYPHON_PLAYER_HAS_BALLISTICS',
        NULL
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_GRANT_ADV_BALLISTICS',
        'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',
        'REQSET_TSOD_TYPHON_PLAYER_HAS_ADV_BALLISTICS',
        NULL
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_BALLISTICS_STRENGTH',
        'MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH',
        NULL,
        NULL
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_BALLISTICS_RANGED',
        'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',
        NULL,
        'REQSET_TSOD_TYPHON_BATTLE_MAGE_RANGED_ATTACK'
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_STRENGTH',
        'MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH',
        NULL,
        NULL
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_RANGED',
        'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',
        NULL,
        'REQSET_TSOD_TYPHON_BATTLE_MAGE_RANGED_ATTACK'
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_CONCERT',
        'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER',
        NULL,
        'REQSET_TSOD_TYPHON_ADJACENT_BATTLE_MAGE'
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_CONCERT_STRENGTH',
        'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',
        NULL,
        'REQSET_TSOD_TYPHON_BATTLE_MAGE_RANGED_ATTACK'
    );

INSERT INTO
    ModifierArguments (ModifierId, Name, Value)
VALUES
    ('TSOD_TYPHON_BATTLE_MAGE_GRANT_BALLISTICS', 'AbilityType', 'ABILITY_TSOD_BATTLE_MAGE_BALLISTICS'),
    ('TSOD_TYPHON_BATTLE_MAGE_GRANT_ADV_BALLISTICS', 'AbilityType', 'ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS'),
    ('TSOD_TYPHON_BATTLE_MAGE_BALLISTICS_STRENGTH', 'Amount', '20'),
    ('TSOD_TYPHON_BATTLE_MAGE_BALLISTICS_RANGED', 'Amount', '20'),
    ('TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_STRENGTH', 'Amount', '20'),
    ('TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_RANGED', 'Amount', '25'),
    ('TSOD_TYPHON_BATTLE_MAGE_CONCERT', 'ModifierId', 'TSOD_TYPHON_BATTLE_MAGE_CONCERT_STRENGTH'),
    ('TSOD_TYPHON_BATTLE_MAGE_CONCERT_STRENGTH', 'Amount', '5');

-- 7. Requirements
INSERT INTO
    Requirements (RequirementId, RequirementType)
VALUES
    ('REQ_TSOD_TYPHON_PLAYER_HAS_BALLISTICS', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY'),
    ('REQ_TSOD_TYPHON_PLAYER_HAS_ADV_BALLISTICS', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY'),
    ('REQ_TSOD_TYPHON_PLAYER_IS_ATTACKING', 'REQUIREMENT_PLAYER_IS_ATTACKING'),
    ('REQ_TSOD_TYPHON_COMBAT_IS_RANGED', 'REQUIREMENT_COMBAT_TYPE_MATCHES'),
    ('REQ_TSOD_TYPHON_ADJACENT_BATTLE_MAGE', 'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TYPE_MATCHES');

INSERT INTO
    RequirementArguments (RequirementId, Name, Value)
VALUES
    ('REQ_TSOD_TYPHON_PLAYER_HAS_BALLISTICS', 'TechnologyType', 'TECH_BALLISTICS'),
    ('REQ_TSOD_TYPHON_PLAYER_HAS_ADV_BALLISTICS', 'TechnologyType', 'TECH_ADVANCED_BALLISTICS'),
    ('REQ_TSOD_TYPHON_COMBAT_IS_RANGED', 'CombatType', 'COMBAT_RANGED'),
    ('REQ_TSOD_TYPHON_ADJACENT_BATTLE_MAGE', 'UnitType', 'UNIT_TSOD_BATTLE_MAGE');

INSERT INTO
    RequirementSets (RequirementSetId, RequirementSetType)
VALUES
    ('REQSET_TSOD_TYPHON_PLAYER_HAS_BALLISTICS', 'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_PLAYER_HAS_ADV_BALLISTICS', 'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_BATTLE_MAGE_RANGED_ATTACK', 'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_ADJACENT_BATTLE_MAGE', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO
    RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
    ('REQSET_TSOD_TYPHON_PLAYER_HAS_BALLISTICS', 'REQ_TSOD_TYPHON_PLAYER_HAS_BALLISTICS'),
    ('REQSET_TSOD_TYPHON_PLAYER_HAS_ADV_BALLISTICS', 'REQ_TSOD_TYPHON_PLAYER_HAS_ADV_BALLISTICS'),
    ('REQSET_TSOD_TYPHON_BATTLE_MAGE_RANGED_ATTACK', 'REQ_TSOD_TYPHON_PLAYER_IS_ATTACKING'),
    ('REQSET_TSOD_TYPHON_BATTLE_MAGE_RANGED_ATTACK', 'REQ_TSOD_TYPHON_COMBAT_IS_RANGED'),
    ('REQSET_TSOD_TYPHON_ADJACENT_BATTLE_MAGE', 'REQ_TSOD_TYPHON_ADJACENT_BATTLE_MAGE');

-- 8. Combat preview text (Preview)
-- Written only on the inner layer (same as Heavy Infantry); the outer CONCERT layer is not written. Base combat strength modifiers count toward the panel's base value and are neither shown in the preview nor written.
-- The text holds only the ability name (same as the official "+5 Volley (upgrade)"); the effect description is in the ability description.
INSERT INTO
    ModifierStrings (ModifierId, Context, Text)
VALUES
    ('TSOD_TYPHON_BATTLE_MAGE_BALLISTICS_RANGED', 'Preview', 'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_PREVIEW'),
    ('TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_RANGED', 'Preview', 'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_PREVIEW'),
    ('TSOD_TYPHON_BATTLE_MAGE_CONCERT_STRENGTH', 'Preview', 'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_PREVIEW');
