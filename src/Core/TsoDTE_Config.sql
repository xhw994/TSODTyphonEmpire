-- WP1 开局设置界面：文明与领袖条目 + 特色项（FrontEnd UpdateDatabase）；只引用 ID 与 LOC tag（ids.md §3、§4），图标名为拟定的美术名。
-- 规则集只做风云变幻：Domain 'Players:Expansion2_Players'（照官方 Expansion2_Players.xml 与塞西尔）。

-- 1. 文明与领袖条目（同时承载文明能力、领袖能力两项展示）
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

-- 2. 特色项：特色单位、特色区域、特色建筑
-- Type 照官方填内容本身的类型 ID；SortIndex 照官方 10 / 20 / 30。
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
