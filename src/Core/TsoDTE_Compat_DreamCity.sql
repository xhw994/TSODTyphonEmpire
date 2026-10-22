-- =============================================================================
-- TsoDTE_Compat_DreamCity.sql  ·  WP18 系列联动：梦境之城宗主国（只在装了梦境之城 mod 时加载）
-- 动作：InGame UpdateDatabase，独立 action，criteria TsoDTE_ModDreamCity
--       （ModInUse 3b138c5a-bb00-42ce-9ae2-2186fbd5595b + RuleSetInUse RULESET_EXPANSION_2），LoadOrder 200。
--
-- 依赖（须已存在）：
--   MINOR_CIV_TSOD_DREAM_CITY_TRAIT     梦境之城 mod（DreamCity_Civilizations.sql，城邦特性）
--   PLAYER_IS_SUZERAIN                  官方需求组（宗主国判定，与梦境之城 DreamCity_Modifiers.sql 同用）
--   LEADER_TSOD_ROSETTA_AUGUSTUS        WP1 TsoDTE_Leader.sql
--   DISTRICT_TSOD_MAGE_TOWER            WP5 TsoDTE_District_MageTower.sql
--
-- 结构（照梦境之城 DreamCity_Modifiers.sql 文件头的两层写法，再加一层限定提丰）：
--   外层  MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER，SubjectRequirementSetId = PLAYER_IS_SUZERAIN，
--         挂在梦境之城的城邦特性上（TraitModifiers）。宗主国是谁，由这一条决定。
--     └ 内层  MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER，OwnerRequirementSetId 限定为提丰（领袖类型）。
--             主体是宗主国玩家，所以 Owner 就是宗主国。非提丰的宗主国在这一层被过滤掉。
--         └ 最内层  MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_AMENITY，SubjectRequirementSetId 限定为法师塔区域，
--                   每座法师塔 +1 宜居度。
--
-- 「有法师塔的城市 +1 宜居度」的实现：游戏规则是同一城市里每类区域只能建一座（需实证，test-plan §11 D1），
--   所以「每座法师塔 +1」就等于「有法师塔的城市 +1」。
--   宜居度效果用 EFFECT_ADJUST_DISTRICT_AMENITY（风云变幻，Class DISTRICTS），
--   照官方 Expansion2_Modifiers.xml 的 MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_AMENITY / COLLECTION_CITY_DISTRICTS 写法。
--   没有用城市级的 EFFECT_ADJUST_CITY_AMENITIES_FROM_*：官方城市级宜居度效果都带来源
--   （FROM_CITY_STATES / _RELIGION / _GREAT_PEOPLE / _GOVERNORS），界面会显示成那个来源，与法师塔无关。
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. 需求
--    OWNER_IS_ROSETTA：内层的 Owner（宗主国玩家）是提丰。
--    CITY_HAS_MAGE_TOWER：Subject 是城市，城里有法师塔（REQUIREMENT_CITY_HAS_DISTRICT，Class CITIES）。
--    DISTRICT_IS_MAGE_TOWER：Subject 是区域，就是法师塔（REQUIREMENT_DISTRICT_TYPE_MATCHES，Class DISTRICTS）。
-- -----------------------------------------------------------------------------
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('REQ_TSOD_TYPHON_DREAM_OWNER_IS_ROSETTA',       'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES'),
    ('REQ_TSOD_TYPHON_DREAM_CITY_HAS_MAGE_TOWER',    'REQUIREMENT_CITY_HAS_DISTRICT'),
    ('REQ_TSOD_TYPHON_DREAM_DISTRICT_IS_MAGE_TOWER', 'REQUIREMENT_DISTRICT_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('REQ_TSOD_TYPHON_DREAM_OWNER_IS_ROSETTA',       'LeaderType',    'LEADER_TSOD_ROSETTA_AUGUSTUS'),
    ('REQ_TSOD_TYPHON_DREAM_CITY_HAS_MAGE_TOWER',    'DistrictType', 'DISTRICT_TSOD_MAGE_TOWER'),
    ('REQ_TSOD_TYPHON_DREAM_DISTRICT_IS_MAGE_TOWER', 'DistrictType', 'DISTRICT_TSOD_MAGE_TOWER');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('REQSET_TSOD_TYPHON_DREAM_OWNER_IS_ROSETTA',       'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_DREAM_CITY_HAS_MAGE_TOWER',    'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_DREAM_DISTRICT_IS_MAGE_TOWER', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('REQSET_TSOD_TYPHON_DREAM_OWNER_IS_ROSETTA',       'REQ_TSOD_TYPHON_DREAM_OWNER_IS_ROSETTA'),
    ('REQSET_TSOD_TYPHON_DREAM_CITY_HAS_MAGE_TOWER',    'REQ_TSOD_TYPHON_DREAM_CITY_HAS_MAGE_TOWER'),
    ('REQSET_TSOD_TYPHON_DREAM_DISTRICT_IS_MAGE_TOWER', 'REQ_TSOD_TYPHON_DREAM_DISTRICT_IS_MAGE_TOWER');

-- -----------------------------------------------------------------------------
-- 2. 修正三层
-- -----------------------------------------------------------------------------
INSERT INTO Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId) VALUES
    -- 外层：挂在梦境之城特性上，Subject 为宗主国玩家
    ('TSOD_TYPHON_DREAM_SUZERAIN_AMENITY',
     'MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER', NULL, 'PLAYER_IS_SUZERAIN'),
    -- 内层：挂在宗主国玩家上，限定提丰；Subject 为城市，只挂到有法师塔的城市
    ('TSOD_TYPHON_DREAM_ROSETTA_MAGE_CITIES',
     'MODIFIER_PLAYER_CITIES_ATTACH_MODIFIER',
     'REQSET_TSOD_TYPHON_DREAM_OWNER_IS_ROSETTA', 'REQSET_TSOD_TYPHON_DREAM_CITY_HAS_MAGE_TOWER'),
    -- 最内层：Subject 为法师塔区域，每座 +1 宜居度
    ('TSOD_TYPHON_DREAM_MAGE_TOWER_AMENITY',
     'MODIFIER_CITY_DISTRICTS_ADJUST_DISTRICT_AMENITY', NULL, 'REQSET_TSOD_TYPHON_DREAM_DISTRICT_IS_MAGE_TOWER');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_DREAM_SUZERAIN_AMENITY',       'ModifierId', 'TSOD_TYPHON_DREAM_ROSETTA_MAGE_CITIES'),
    ('TSOD_TYPHON_DREAM_ROSETTA_MAGE_CITIES',    'ModifierId', 'TSOD_TYPHON_DREAM_MAGE_TOWER_AMENITY'),
    ('TSOD_TYPHON_DREAM_MAGE_TOWER_AMENITY',     'Amount',     '1');

-- 外层挂在梦境之城的城邦特性上（与梦境之城自己的三条宗主国修正并列，互不影响）。
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('MINOR_CIV_TSOD_DREAM_CITY_TRAIT', 'TSOD_TYPHON_DREAM_SUZERAIN_AMENITY');

-- 玩家看得见（城市宜居度的产出明细里会出现这一行），给一句说明，文本在 Texts/TsoDTE_Text_Compat.sql。
INSERT INTO ModifierStrings (ModifierId, Context, Text) VALUES
    ('TSOD_TYPHON_DREAM_MAGE_TOWER_AMENITY', 'Preview', 'LOC_MODIFIER_TSOD_DREAM_MAGE_TOWER_AMENITY_PREVIEW');
