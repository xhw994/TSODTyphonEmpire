-- =============================================================================
-- TsoDTE_Project.sql  ·  WP16 去神圣化（城市项目，提丰专属）
-- 动作：InGame UpdateDatabase（criteria TsoDTE_Expansion2），登记在 TsoDTE_District_MageTower.sql 之后。
-- 依赖（须先加载）：
--   DISTRICT_TSOD_MAGE_TOWER            WP5 TsoDTE_District_MageTower.sql
--   TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE  WP1 TsoDTE_Civilization.sql
--   CIVIC_MASS_MEDIA                    原版现代市政（Base Gameplay/Data/Civics.xml），用在解锁修正的需求上
--   REQUIREMENT_PLAYER_HAS_CIVIC         官方需求（参数 CivicType；用例 Expansion2_Civilizations.xml）
--   MODIFIER_PLAYER_ADD_FAVOR           风云变幻（Expansion2/Data/Expansion2_Modifiers.xml，EFFECT_ADD_PLAYER_FAVOR）
--   EFFECT_ADD_PLAYER_PROJECT_AVAILABILITY  风云变幻，参数 ProjectType
-- 本文件用到风云变幻才有的效果，只在 RuleSetInUse RULESET_EXPANSION_2 下加载。
--
-- 解锁方式（照凯瑟琳「宫廷庆典」PROJECT_COURT_FESTIVAL，CatherineDeMedici_Projects.xml）：
--   Projects 行 UnlocksFromEffect=1；文明能力挂一条 MODIFIER_PLAYER_ALLOW_PROJECT_TSOD，
--   它是 DynamicModifiers 里 COLLECTION_OWNER + EFFECT_ADD_PLAYER_PROJECT_AVAILABILITY 的组合。
--   没有直接用 MODIFIER_PLAYER_ALLOW_PROJECT：该类型只在 DLC/Ethiopia/Data/Ethiopia_SecretSocieties_MODE.xml
--   里定义，那个文件只在「秘密结社」模式下加载，普通对局里不存在。照凯瑟琳 / 中国（_CATHERINE / _CHINA）
--   的做法，在本包自己定义一条同样结构的类型。
--
-- 可重复：Projects 表没有 Repeatable 列，不设 MaxPlayerInstances 即可重复（同 PROJECT_ENHANCE_DISTRICT_*）。
-- 造价：照凯瑟琳宫廷庆典的 65 / COST_PROGRESSION_GAME_PROGRESS 1500（暂定，进游戏再调）。
-- 完成时的两件事：外交支持由下面的 ProjectCompletionModifiers 给；信仰转科技由 Scripts/TsoDTE_Project.lua 做。
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. 类型登记
-- -----------------------------------------------------------------------------
INSERT INTO Types (Type, Kind) VALUES
    ('PROJECT_TSOD_DESANCTIFICATION',      'KIND_PROJECT'),
    ('MODIFIER_PLAYER_ALLOW_PROJECT_TSOD', 'KIND_MODIFIER');

-- -----------------------------------------------------------------------------
-- 2. 项目主表
--    PrereqDistrict：城市须有法师塔（项目只在有该区域的城市里出现）。
--    不设 PrereqCivic：市政树的「解锁」图标按 PrereqCivic 列项目，而 Projects 没有 TraitType 列，
--      设了的话所有文明的「大众传媒」上都会显示这个项目（10-22 实测：塞西尔也看得到，只是造不了）。
--      所以「须已研究大众传媒」改由第 3 段解锁修正的需求表达，只有提丰会被授予。
--    UnlocksFromEffect=1：没有文明能力授予的玩家看不到这个项目（非提丰不可见）。
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- 3. 解锁：文明能力挂 MODIFIER_PLAYER_ALLOW_PROJECT_TSOD（结构同凯瑟琳的 MAGNIFICENCES_ALLOW_PROJECT）
-- -----------------------------------------------------------------------------
INSERT INTO DynamicModifiers (ModifierType, CollectionType, EffectType) VALUES
    ('MODIFIER_PLAYER_ALLOW_PROJECT_TSOD', 'COLLECTION_OWNER', 'EFFECT_ADD_PLAYER_PROJECT_AVAILABILITY');

-- 需求：玩家已研究「大众传媒」。需实证：研究完成后修正是否随之生效（项目是否出现在生产列表）。
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

-- -----------------------------------------------------------------------------
-- 4. 完成时外交支持 +25
--    照官方项目完成修正（Base Projects.xml 的 PROJECT_COMPLETION_*）：RunOnce=1 与 Permanent=1，
--    只在完成的那一刻给一次，不随回合累加。挂在 ProjectCompletionModifiers 上，主体是完成项目的玩家。
--    MODIFIER_PLAYER_ADD_FAVOR 的 Collection 是 COLLECTION_OWNER，效果 EFFECT_ADD_PLAYER_FAVOR（参数 Amount）。
--    先例：CIVIC_FUTURE_CIVIC 的 CIVIC_GRANT_FAVOR 也用这一组合。
-- -----------------------------------------------------------------------------
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent) VALUES
    ('TSOD_TYPHON_DESANCTIFICATION_FAVOR', 'MODIFIER_PLAYER_ADD_FAVOR', 1, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_DESANCTIFICATION_FAVOR', 'Amount', '25');

INSERT INTO ProjectCompletionModifiers (ProjectType, ModifierId) VALUES
    ('PROJECT_TSOD_DESANCTIFICATION', 'TSOD_TYPHON_DESANCTIFICATION_FAVOR');

-- -----------------------------------------------------------------------------
-- 5. 通知：不登记自定义通知类型（实机里自定义类型的通知不出现）。
--    Scripts/TsoDTE_Project.lua 用 NotificationTypes.USER_DEFINED_5，消息与摘要文本在 Texts/TsoDTE_Text_Project.sql。
-- -----------------------------------------------------------------------------
