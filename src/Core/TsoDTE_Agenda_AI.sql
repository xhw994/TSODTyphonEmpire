-- WP7 Kindred agenda and AI preferences; the last file in the IG UpdateDatabase (ids.md §5.2).
-- AI tables have no foreign keys; the WP1 / WP4–6 IDs here are references only.

-- 1. The Kindred agenda itself (Agendas are not in Types and the base game does not register them; the agenda's trait needs Types + Traits)

INSERT INTO Types (Type, Kind)
VALUES
    ('TRAIT_AGENDA_TSOD_KINDRED', 'KIND_TRAIT');

INSERT INTO Traits (TraitType, Name, Description)
VALUES
    ('TRAIT_AGENDA_TSOD_KINDRED', NULL, NULL);

INSERT INTO Agendas (AgendaType, Name, Description)
VALUES
    ('AGENDA_TSOD_KINDRED', 'LOC_AGENDA_TSOD_KINDRED_NAME', 'LOC_AGENDA_TSOD_KINDRED_DESCRIPTION');

-- Overlaps with the army part of the hidden Standing Army agenda, so the two are mutually exclusive (precedent: Ambiorix and Cleopatra).
INSERT INTO ExclusiveAgendas (AgendaOne, AgendaTwo)
VALUES
    ('AGENDA_TSOD_KINDRED', 'AGENDA_STANDING_ARMY');

INSERT INTO HistoricalAgendas (LeaderType, AgendaType)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS', 'AGENDA_TSOD_KINDRED');

INSERT INTO AgendaTraits (AgendaType, TraitType)
VALUES
    ('AGENDA_TSOD_KINDRED', 'TRAIT_AGENDA_TSOD_KINDRED');


-- 2. Agenda modifier (MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER; the subject condition decides which civ it applies to)
-- Army condition copied from AGENDA_HIGH_STANDING_ARMY; StrengthRatio lowered from 1.2 to 1.0 (no weaker than); basis for the attitude values in docs/notes.md.

INSERT INTO TraitModifiers (TraitType, ModifierId)
VALUES
    ('TRAIT_AGENDA_TSOD_KINDRED', 'TSOD_TYPHON_AGENDA_KINDRED_STRONG_MILITARY'),
    ('TRAIT_AGENDA_TSOD_KINDRED', 'TSOD_TYPHON_AGENDA_KINDRED_RELIGION_RECEIVED');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
    ('TSOD_TYPHON_AGENDA_KINDRED_STRONG_MILITARY', 'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER', 'REQSET_TSOD_TYPHON_KINDRED_STRONG_MILITARY'),
    ('TSOD_TYPHON_AGENDA_KINDRED_RELIGION_RECEIVED', 'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER', 'REQSET_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED');

-- The StatementKey tag does not contain ROSETTA_AUGUSTUS, so it does not fall into the WP8 diplomacy-statement namespace.
INSERT INTO ModifierArguments (ModifierId, Name, Value)
VALUES
    ('TSOD_TYPHON_AGENDA_KINDRED_STRONG_MILITARY', 'InitialValue', '8'),
    ('TSOD_TYPHON_AGENDA_KINDRED_STRONG_MILITARY', 'StatementKey', 'LOC_DIPLO_KUDO_LEADER_ANY_REASON_AGENDA_TSOD_KINDRED'),
    ('TSOD_TYPHON_AGENDA_KINDRED_STRONG_MILITARY', 'SimpleModifierDescription', 'LOC_DIPLO_MODIFIER_TSOD_KINDRED_STRONG_MILITARY'),
    ('TSOD_TYPHON_AGENDA_KINDRED_RELIGION_RECEIVED', 'InitialValue', '-12'),
    ('TSOD_TYPHON_AGENDA_KINDRED_RELIGION_RECEIVED', 'StatementKey', 'LOC_DIPLO_WARNING_LEADER_ANY_REASON_AGENDA_TSOD_KINDRED'),
    ('TSOD_TYPHON_AGENDA_KINDRED_RELIGION_RECEIVED', 'SimpleModifierDescription', 'LOC_DIPLO_MODIFIER_TSOD_KINDRED_RELIGION_RECEIVED');

INSERT INTO ModifierStrings (ModifierId, Context, Text)
VALUES
    ('TSOD_TYPHON_AGENDA_KINDRED_STRONG_MILITARY', 'Sample', 'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL'),
    ('TSOD_TYPHON_AGENDA_KINDRED_RELIGION_RECEIVED', 'Sample', 'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL');


-- 3. Requirements and requirement sets (REQUIRES_MAJOR_CIV_OPPONENT / REQUIRES_MET_*_TURNS_AGO reuse official rows; the turns-known counts follow precedent)

INSERT INTO Requirements (RequirementId, RequirementType)
VALUES
    ('REQ_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'REQUIREMENT_PLAYER_MILITARY_STRENGTH_LEAD'),
    ('REQ_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED', 'REQUIREMENT_PLAYER_RELIGION_RECEIVED');

INSERT INTO RequirementArguments (RequirementId, Name, Value)
VALUES
    ('REQ_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'MinimumDelta', '5'),
    ('REQ_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'StrengthRatio', '1.0'),
    ('REQ_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'DomainType', 'DOMAIN_LAND');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
    ('REQSET_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
    ('REQSET_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'REQUIRES_MAJOR_CIV_OPPONENT'),
    ('REQSET_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'REQUIRES_MET_30_TURNS_AGO'),
    ('REQSET_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'REQ_TSOD_TYPHON_KINDRED_STRONG_MILITARY'),
    ('REQSET_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED', 'REQUIRES_MAJOR_CIV_OPPONENT'),
    ('REQSET_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED', 'REQUIRES_MET_10_TURNS_AGO'),
    ('REQSET_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED', 'REQ_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED');


-- 4. AI preferences
-- AiLists.LeaderType is filled with the Trait (none of the 322 official rows fill LEADER_*); the agenda's own list hangs off the agenda trait and uses the AgendaType column.
-- Religious inclination "medium": no ForbidReligiousVictory / LowReligiousPreferenceYields / FavorReligiousVictory; only prefers holy sites.

INSERT INTO AiListTypes (ListType)
VALUES
    ('TSOD_TYPHON_ROSETTA_VICTORIES'),
    ('TSOD_TYPHON_ROSETTA_DISTRICTS'),
    ('TSOD_TYPHON_ROSETTA_BUILDINGS'),
    ('TSOD_TYPHON_ROSETTA_UNITS'),
    ('TSOD_TYPHON_KINDRED_PSEUDOYIELDS');

INSERT INTO AiLists (ListType, LeaderType, AgendaType, System)
VALUES
    ('TSOD_TYPHON_ROSETTA_VICTORIES', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', NULL, 'Strategies'),
    ('TSOD_TYPHON_ROSETTA_DISTRICTS', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', NULL, 'Districts'),
    ('TSOD_TYPHON_ROSETTA_BUILDINGS', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', NULL, 'Buildings'),
    ('TSOD_TYPHON_ROSETTA_UNITS', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', NULL, 'Units'),
    ('TSOD_TYPHON_KINDRED_PSEUDOYIELDS', NULL, 'TRAIT_AGENDA_TSOD_KINDRED', 'PseudoYields');

INSERT INTO AiFavoredItems (ListType, Item, Favored, Value)
VALUES
    -- Lower Value in Strategies means a stronger preference (conquest -2 follows AlexanderPreferWar, science -1 follows FavorScienceVictory).
    ('TSOD_TYPHON_ROSETTA_VICTORIES', 'VICTORY_STRATEGY_MILITARY_VICTORY', 1, -2),
    ('TSOD_TYPHON_ROSETTA_VICTORIES', 'VICTORY_STRATEGY_SCIENCE_VICTORY', 1, -1),

    -- Both Campus and Mage Tower are listed, so the match works whether the AI scores by the replaced type or the unique type.
    ('TSOD_TYPHON_ROSETTA_DISTRICTS', 'DISTRICT_CAMPUS', 1, 0),
    ('TSOD_TYPHON_ROSETTA_DISTRICTS', 'DISTRICT_ENCAMPMENT', 1, 0),
    ('TSOD_TYPHON_ROSETTA_DISTRICTS', 'DISTRICT_HOLY_SITE', 1, 0),
    ('TSOD_TYPHON_ROSETTA_DISTRICTS', 'DISTRICT_TSOD_MAGE_TOWER', 1, 0),

    ('TSOD_TYPHON_ROSETTA_BUILDINGS', 'BUILDING_TSOD_BURNSTONE_WORKS', 1, 0),

    -- Units' Value sets build priority (precedent: VictoriaUnits; the Sukritact unique unit in a Workshop mod, 1 / 1).
    ('TSOD_TYPHON_ROSETTA_UNITS', 'UNIT_TSOD_BATTLE_MAGE', 1, 1),

    -- The agenda itself: keeps the original StandingArmyPseudoYields value (already mutually exclusive with AGENDA_STANDING_ARMY, so it does not stack).
    ('TSOD_TYPHON_KINDRED_PSEUDOYIELDS', 'PSEUDOYIELD_STANDING_ARMY_NUMBER', 1, 33),
    ('TSOD_TYPHON_KINDRED_PSEUDOYIELDS', 'PSEUDOYIELD_STANDING_ARMY_VALUE', 1, 50);
