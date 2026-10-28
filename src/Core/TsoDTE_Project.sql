-- WP16 Desanctification (city project, Typhon-exclusive); loaded only under Gathering Storm (it uses effects that exist only in the expansion).
-- Depends on the Mage Tower (TsoDTE_District_MageTower.sql) and the civ ability shell (TsoDTE_Civilization.sql) being loaded first.

-- 1. Type registration
INSERT INTO Types (Type, Kind) VALUES
    ('PROJECT_TSOD_DESANCTIFICATION',      'KIND_PROJECT'),
    ('MODIFIER_PLAYER_ALLOW_PROJECT_TSOD', 'KIND_MODIFIER');

-- 2. Project main row (repeatable: Projects has no Repeatable column; UnlocksFromEffect=1: players without the civ ability granting it cannot see this project)
-- No PrereqCivic: the Civics tree's "unlock" icon lists projects by it, and Projects has no TraitType column, so every civ's "Mass Media" would show this project
-- (in-game test 10-22); "Mass Media must already be researched" is expressed instead by the requirement in the section 3 unlock modifier.
INSERT INTO Projects (
    ProjectType, Name, ShortName, Description,
    PrereqDistrict, PrereqCivic, Cost, AdvisorType,
    CostProgressionModel, CostProgressionParam1, UnlocksFromEffect
) VALUES (
    'PROJECT_TSOD_DESANCTIFICATION',
    'LOC_PROJECT_TSOD_DESANCTIFICATION_NAME',
    'LOC_PROJECT_TSOD_DESANCTIFICATION_SHORT_NAME',
    'LOC_PROJECT_TSOD_DESANCTIFICATION_DESCRIPTION',
    'DISTRICT_TSOD_MAGE_TOWER', NULL, 65, 'ADVISOR_CULTURE',
    'COST_PROGRESSION_GAME_PROGRESS', 1500, 1
);

-- 3. Unlock: the civ ability attaches MODIFIER_PLAYER_ALLOW_PROJECT_TSOD (same structure as Catherine's MAGNIFICENCES_ALLOW_PROJECT)
-- Not using MODIFIER_PLAYER_ALLOW_PROJECT directly: it is defined only in the Secret Societies mode's Ethiopia_SecretSocieties_MODE.xml, which normal games do not have,
-- so, as Catherine and China do, it defines its own type with the same structure (COLLECTION_OWNER + EFFECT_ADD_PLAYER_PROJECT_AVAILABILITY).
INSERT INTO DynamicModifiers (ModifierType, CollectionType, EffectType) VALUES
    ('MODIFIER_PLAYER_ALLOW_PROJECT_TSOD', 'COLLECTION_OWNER', 'EFFECT_ADD_PLAYER_PROJECT_AVAILABILITY');

-- Requirement: the player has researched "Mass Media" (needs in-game proof: whether the modifier takes effect once research completes).
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('REQ_TSOD_TYPHON_HAS_MASS_MEDIA', 'REQUIREMENT_PLAYER_HAS_CIVIC');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('REQ_TSOD_TYPHON_HAS_MASS_MEDIA', 'CivicType', 'CIVIC_MASS_MEDIA');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('REQSET_TSOD_TYPHON_HAS_MASS_MEDIA', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('REQSET_TSOD_TYPHON_HAS_MASS_MEDIA', 'REQ_TSOD_TYPHON_HAS_MASS_MEDIA');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('TSOD_TYPHON_DESANCTIFICATION_ALLOW', 'MODIFIER_PLAYER_ALLOW_PROJECT_TSOD', 'REQSET_TSOD_TYPHON_HAS_MASS_MEDIA');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_DESANCTIFICATION_ALLOW', 'ProjectType', 'PROJECT_TSOD_DESANCTIFICATION');

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE', 'TSOD_TYPHON_DESANCTIFICATION_ALLOW');

-- 4. Diplomatic support +25 on completion
-- As with the official PROJECT_COMPLETION_*: RunOnce=1 and Permanent=1, so it is granted once at completion only and does not accumulate per turn.
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent) VALUES
    ('TSOD_TYPHON_DESANCTIFICATION_FAVOR', 'MODIFIER_PLAYER_ADD_FAVOR', 1, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_DESANCTIFICATION_FAVOR', 'Amount', '25');

INSERT INTO ProjectCompletionModifiers (ProjectType, ModifierId) VALUES
    ('PROJECT_TSOD_DESANCTIFICATION', 'TSOD_TYPHON_DESANCTIFICATION_FAVOR');

-- 5. Notification: no custom notification type is registered (in-game, custom types' notifications do not appear); Lua uses NotificationTypes.USER_DEFINED_5.
