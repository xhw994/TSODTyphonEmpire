-- =============================================================================
-- WP3 领袖能力：凡人的韧性（TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS）
-- 加载：InGame UpdateDatabase，排在 TsoDTE_Leader.sql（建特性壳）之后
--
-- 本文件只挂修正。Types / Traits / LeaderTraits 由 WP1 的 TsoDTE_Leader.sql 建，这里不插。
-- 击杀给尤里卡（何不用之）在 Scripts/TsoDTE_LeaderTrait.lua。
--
-- 黄昏宫殿：
--   每进入新时代：1 个随机尤里卡 + 1 个随机鼓舞
--     先例：城邦首尔 MINOR_CIV_SEOUL_TECH_BOOST_BONUS（Amount=1，无需求）
--           城邦维尔纽斯 MINOR_CIV_VILNIUS_CIVIC_BOOST_BONUS（市政版）
--   新时代是黑暗时代：再各 1 个（合计各 2 个）
--     需求：REQUIREMENT_PLAYER_HAS_DARK_AGE（官方 XP1/XP2 PLAYER_HAS_DARK_AGE 的写法，无参数）
--     放在 OwnerRequirementSetId：先例 HIGH_DIFFICULTY_FREE_TECH_BOOSTS（同一 ModifierType，
--     需求放 Owner）；COLLECTION_OWNER 下 Owner 与 Subject 是同一个玩家。
--
-- 需实证：进入新时代的那一刻，「是否黑暗时代」是否已经更新。
--   若未更新，黑暗时代那一组会滞后一个时代（在离开黑暗时代时才给）。退路见 WP3 回报。
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Requirements
-- -----------------------------------------------------------------------------
INSERT INTO Requirements
        (RequirementId,                             RequirementType)
VALUES  ('REQ_TSOD_TYPHON_PLAYER_HAS_DARK_AGE',      'REQUIREMENT_PLAYER_HAS_DARK_AGE');

INSERT INTO RequirementSets
        (RequirementSetId,                          RequirementSetType)
VALUES  ('REQSET_TSOD_TYPHON_PLAYER_HAS_DARK_AGE',   'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements
        (RequirementSetId,                          RequirementId)
VALUES  ('REQSET_TSOD_TYPHON_PLAYER_HAS_DARK_AGE',   'REQ_TSOD_TYPHON_PLAYER_HAS_DARK_AGE');

-- -----------------------------------------------------------------------------
-- Modifiers
-- -----------------------------------------------------------------------------
INSERT INTO Modifiers
        (ModifierId,                                        ModifierType,                                               OwnerRequirementSetId)
VALUES  ('TSOD_TYPHON_TWILIGHT_PALACE_TECH_BOOST',           'MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_ON_NEW_ERA',  NULL),
        ('TSOD_TYPHON_TWILIGHT_PALACE_CIVIC_BOOST',          'MODIFIER_PLAYER_GRANT_RANDOM_CIVIC_BOOST_ON_NEW_ERA',       NULL),
        ('TSOD_TYPHON_TWILIGHT_PALACE_DARK_TECH_BOOST',      'MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_ON_NEW_ERA',  'REQSET_TSOD_TYPHON_PLAYER_HAS_DARK_AGE'),
        ('TSOD_TYPHON_TWILIGHT_PALACE_DARK_CIVIC_BOOST',     'MODIFIER_PLAYER_GRANT_RANDOM_CIVIC_BOOST_ON_NEW_ERA',       'REQSET_TSOD_TYPHON_PLAYER_HAS_DARK_AGE');

INSERT INTO ModifierArguments
        (ModifierId,                                        Name,       Value)
VALUES  ('TSOD_TYPHON_TWILIGHT_PALACE_TECH_BOOST',           'Amount',   '1'),
        ('TSOD_TYPHON_TWILIGHT_PALACE_CIVIC_BOOST',          'Amount',   '1'),
        ('TSOD_TYPHON_TWILIGHT_PALACE_DARK_TECH_BOOST',      'Amount',   '1'),
        ('TSOD_TYPHON_TWILIGHT_PALACE_DARK_CIVIC_BOOST',     'Amount',   '1');

-- -----------------------------------------------------------------------------
-- TraitModifiers（本包所有：挂到 WP1 建的领袖特性壳上）
-- -----------------------------------------------------------------------------
INSERT INTO TraitModifiers
        (TraitType,                                 ModifierId)
VALUES  ('TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS',       'TSOD_TYPHON_TWILIGHT_PALACE_TECH_BOOST'),
        ('TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS',       'TSOD_TYPHON_TWILIGHT_PALACE_CIVIC_BOOST'),
        ('TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS',       'TSOD_TYPHON_TWILIGHT_PALACE_DARK_TECH_BOOST'),
        ('TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS',       'TSOD_TYPHON_TWILIGHT_PALACE_DARK_CIVIC_BOOST');
