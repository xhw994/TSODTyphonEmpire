-- WP1 game-setup screen: civ and leader entries + unique items (FrontEnd UpdateDatabase); references only IDs and LOC tags (ids.md §3, §4).
-- Ruleset: Gathering Storm only; Domain 'Players:Expansion2_Players' (same as the official Expansion2_Players.xml and Cecil).

-- 1. Civ and leader entries (also carries the civ ability and leader ability displays)
INSERT INTO Players
    (Domain,
     CivilizationType, CivilizationName, CivilizationIcon,
     CivilizationAbilityName, CivilizationAbilityDescription, CivilizationAbilityIcon,
     LeaderType, LeaderName, LeaderIcon,
     LeaderAbilityName, LeaderAbilityDescription, LeaderAbilityIcon,
     Portrait, PortraitBackground)
VALUES
    ('Players:Expansion2_Players',
     'CIVILIZATION_TSOD_TYPHON_EMPIRE',
     'LOC_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME',
     'ICON_CIVILIZATION_TSOD_TYPHON_EMPIRE',
     'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME',
     'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_DESCRIPTION',
     'ICON_CIVILIZATION_TSOD_TYPHON_EMPIRE',
     'LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LOC_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME',
     'ICON_LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME',
     'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_DESCRIPTION',
     'ICON_LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LEADER_TSOD_ROSETTA_AUGUSTUS_NEUTRAL',
     'LEADER_TSOD_ROSETTA_AUGUSTUS_BACKGROUND');

-- 2. Unique items: unique unit, unique district, unique building
-- Type follows the official convention of using the content's own type ID; SortIndex follows the official 10 / 20 / 30.
INSERT INTO PlayerItems
    (Domain, CivilizationType, LeaderType, Type, Name, Description, Icon, SortIndex)
VALUES
    ('Players:Expansion2_Players',
     'CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LEADER_TSOD_ROSETTA_AUGUSTUS',
     'UNIT_TSOD_BATTLE_MAGE',
     'LOC_UNIT_TSOD_BATTLE_MAGE_NAME',
     'LOC_UNIT_TSOD_BATTLE_MAGE_DESCRIPTION',
     'ICON_UNIT_TSOD_BATTLE_MAGE',
     10),
    ('Players:Expansion2_Players',
     'CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LEADER_TSOD_ROSETTA_AUGUSTUS',
     'DISTRICT_TSOD_MAGE_TOWER',
     'LOC_DISTRICT_TSOD_MAGE_TOWER_NAME',
     'LOC_DISTRICT_TSOD_MAGE_TOWER_DESCRIPTION',
     'ICON_DISTRICT_TSOD_MAGE_TOWER',
     20),
    ('Players:Expansion2_Players',
     'CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LEADER_TSOD_ROSETTA_AUGUSTUS',
     'BUILDING_TSOD_BURNSTONE_WORKS',
     'LOC_BUILDING_TSOD_BURNSTONE_WORKS_NAME',
     'LOC_BUILDING_TSOD_BURNSTONE_WORKS_DESCRIPTION',
     'ICON_BUILDING_TSOD_BURNSTONE_WORKS',
     30);
