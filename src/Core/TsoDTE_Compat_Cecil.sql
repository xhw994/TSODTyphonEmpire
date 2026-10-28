-- WP18 series crossover: Cecil (separate action, criteria TsoDTE_ModCecil, LoadOrder 200; both leaders' traits already exist).
-- One diplomatic-attitude modifier each way: Rosetta Augustus toward Gawain, and Gawain toward Rosetta (master plan §8.6); the basis for the InitialValue values and the choice of statements is in docs/notes.md.

-- 1. Requirements: the other party is Gawain / the other party is Rosetta (applies to Subject)
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('REQ_TSOD_TYPHON_CECIL_OTHER_IS_GAWAIN',  'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES'),
    ('REQ_TSOD_TYPHON_CECIL_OTHER_IS_ROSETTA', 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('REQ_TSOD_TYPHON_CECIL_OTHER_IS_GAWAIN',  'LeaderType', 'LEADER_TSOD_GAWAIN_CECIL'),
    ('REQ_TSOD_TYPHON_CECIL_OTHER_IS_ROSETTA', 'LeaderType', 'LEADER_TSOD_ROSETTA_AUGUSTUS');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('REQSET_TSOD_TYPHON_CECIL_OTHER_IS_GAWAIN',  'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_CECIL_OTHER_IS_ROSETTA', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('REQSET_TSOD_TYPHON_CECIL_OTHER_IS_GAWAIN',  'REQ_TSOD_TYPHON_CECIL_OTHER_IS_GAWAIN'),
    ('REQSET_TSOD_TYPHON_CECIL_OTHER_IS_ROSETTA', 'REQ_TSOD_TYPHON_CECIL_OTHER_IS_ROSETTA');

-- 2. Attitude modifiers: Rosetta toward Gawain and Gawain toward Rosetta (two symmetric entries)
-- No StatementKey: not an agenda, so the AI will not give praise or warnings because of it.
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('TSOD_TYPHON_CECIL_ROSETTA_TO_GAWAIN', 'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER', 'REQSET_TSOD_TYPHON_CECIL_OTHER_IS_GAWAIN'),
    ('TSOD_TYPHON_CECIL_GAWAIN_TO_ROSETTA', 'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER', 'REQSET_TSOD_TYPHON_CECIL_OTHER_IS_ROSETTA');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_CECIL_ROSETTA_TO_GAWAIN', 'InitialValue',              '6'),
    ('TSOD_TYPHON_CECIL_ROSETTA_TO_GAWAIN', 'SimpleModifierDescription', 'LOC_DIPLO_MODIFIER_TSOD_CECIL_ROSETTA_TO_GAWAIN'),
    ('TSOD_TYPHON_CECIL_GAWAIN_TO_ROSETTA', 'InitialValue',              '6'),
    ('TSOD_TYPHON_CECIL_GAWAIN_TO_ROSETTA', 'SimpleModifierDescription', 'LOC_DIPLO_MODIFIER_TSOD_CECIL_GAWAIN_TO_ROSETTA');

INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', 'TSOD_TYPHON_CECIL_ROSETTA_TO_GAWAIN'),
    ('TRAIT_LEADER_TSOD_GAWAIN_CECIL',     'TSOD_TYPHON_CECIL_GAWAIN_TO_ROSETTA');

INSERT INTO ModifierStrings (ModifierId, Context, Text) VALUES
    ('TSOD_TYPHON_CECIL_ROSETTA_TO_GAWAIN', 'Sample', 'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL'),
    ('TSOD_TYPHON_CECIL_GAWAIN_TO_ROSETTA', 'Sample', 'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL');
