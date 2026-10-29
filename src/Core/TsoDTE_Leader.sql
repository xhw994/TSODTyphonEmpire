-- WP1 Rosetta Augustus (male emperor): the leader itself, the civ-leader link, the shell of the leader ability (modifiers attached by WP3), the loading screen, and the diplomacy background.
-- Second within its action, after TsoDTE_Civilization.sql.

-- 1. Types
INSERT INTO Types (Type, Kind)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS',       'KIND_LEADER'),
    ('TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', 'KIND_TRAIT');

-- 2. Leader: male (source-work titles: "Emperor Rosetta", "Father")
--    InheritFrom LEADER_DEFAULT: inherits TRAIT_LEADER_MAJOR_CIV and other default behavior (official convention)
INSERT INTO Leaders (LeaderType, Name, InheritFrom, Sex)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LOC_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME',
     'LEADER_DEFAULT',
     'Male');

-- 3. Civ-leader link; capital Ordenan
INSERT INTO CivilizationLeaders (CivilizationType, LeaderType, CapitalName)
VALUES
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE',
     'LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LOC_CITY_NAME_TSOD_ORDENAN');

-- 4. Shell of the leader ability "Resilience of Mortals" (modifiers attached by WP3)
INSERT INTO Traits (TraitType, Name, Description)
VALUES
    ('TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME',
     'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_DESCRIPTION');

INSERT INTO LeaderTraits (LeaderType, TraitType)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS');

-- 5. Quote: references the Encyclopedia leader page's quote tag, as in the official convention (the text belongs to WP8)
INSERT INTO LeaderQuotes (LeaderType, Quote)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_QUOTE');

-- 6. Loading screen (art name follows the Cecil pattern)
INSERT INTO LoadingInfo
    (LeaderType, ForegroundImage, BackgroundImage, LeaderText)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LEADER_TSOD_ROSETTA_AUGUSTUS_LOADING_FOREGROUND',
     'LEADER_TSOD_ROSETTA_AUGUSTUS_LOADING_BACKGROUND',
     'LOC_LOADING_INFO_LEADER_TSOD_ROSETTA_AUGUSTUS');

-- 7. Diplomacy screen background
INSERT INTO DiplomacyInfo (Type, BackgroundImage)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LEADER_TSOD_ROSETTA_AUGUSTUS_DIPLOMACY_BACKGROUND');

-- 8. Dark Age detection: Gameplay Lua cannot read GameEras:HasDarkAge (it exists only in the UI context; confirmed in-game),
-- so a modifier writes it as the player attribute TSOD_TYPHON_DARK_AGE, which TsoDTE_LeaderTrait.lua reads.
-- Whether the attribute returns to 0 after the requirement fails needs in-game proof (Lua only checks > 0); it is attached to the leader trait, so old saves will not pick it up retroactively.
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
    ('TSOD_TYPHON_DARK_AGE_PROBE', 'MODIFIER_PLAYER_ADJUST_PROPERTY', 'PLAYER_HAS_DARK_AGE');

INSERT INTO ModifierArguments (ModifierId, Name, Value)
VALUES
    ('TSOD_TYPHON_DARK_AGE_PROBE', 'Key',    'TSOD_TYPHON_DARK_AGE'),
    ('TSOD_TYPHON_DARK_AGE_PROBE', 'Amount', '1');

INSERT INTO TraitModifiers (TraitType, ModifierId)
VALUES
    ('TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', 'TSOD_TYPHON_DARK_AGE_PROBE');
