-- WP16 去神圣化（城市项目，提丰专属）；只在风云变幻下加载（用到资料片才有的效果）。
-- 依赖法师塔（TsoDTE_District_MageTower.sql）与文明能力壳（TsoDTE_Civilization.sql）先加载。

-- 1. 类型登记
INSERT INTO Types (Type, Kind) VALUES
    ('PROJECT_TSOD_DESANCTIFICATION',      'KIND_PROJECT'),
    ('MODIFIER_PLAYER_ALLOW_PROJECT_TSOD', 'KIND_MODIFIER');

-- 2. 项目主表（可重复：Projects 没有 Repeatable 列；UnlocksFromEffect=1：没有文明能力授予的玩家看不到本项目）
-- 不设 PrereqCivic：市政树的「解锁」图标按它列项目，Projects 又没有 TraitType 列，会让所有文明的「大众传媒」都显示本项目
-- （10-22 实测）；「须已研究大众传媒」改由第 3 节解锁修正的需求表达。
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

-- 3. 解锁：文明能力挂 MODIFIER_PLAYER_ALLOW_PROJECT_TSOD（结构同凯瑟琳的 MAGNIFICENCES_ALLOW_PROJECT）
-- 不直接用 MODIFIER_PLAYER_ALLOW_PROJECT：它只在秘密结社模式的 Ethiopia_SecretSocieties_MODE.xml 里定义，普通对局不存在，
-- 故照凯瑟琳 / 中国的做法自己定义同结构的类型（COLLECTION_OWNER + EFFECT_ADD_PLAYER_PROJECT_AVAILABILITY）。
INSERT INTO DynamicModifiers (ModifierType, CollectionType, EffectType) VALUES
    ('MODIFIER_PLAYER_ALLOW_PROJECT_TSOD', 'COLLECTION_OWNER', 'EFFECT_ADD_PLAYER_PROJECT_AVAILABILITY');

-- 需求：玩家已研究「大众传媒」（待实证：研究完成后修正是否随之生效）。
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

-- 4. 完成时外交支持 +25
-- 照官方 PROJECT_COMPLETION_*：RunOnce=1 与 Permanent=1，只在完成那一刻给一次，不随回合累加。
INSERT INTO Modifiers (ModifierId, ModifierType, RunOnce, Permanent) VALUES
    ('TSOD_TYPHON_DESANCTIFICATION_FAVOR', 'MODIFIER_PLAYER_ADD_FAVOR', 1, 1);

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_DESANCTIFICATION_FAVOR', 'Amount', '25');

INSERT INTO ProjectCompletionModifiers (ProjectType, ModifierId) VALUES
    ('PROJECT_TSOD_DESANCTIFICATION', 'TSOD_TYPHON_DESANCTIFICATION_FAVOR');

-- 5. 通知：不登记自定义通知类型（实机里自定义类型的通知不出现），Lua 用 NotificationTypes.USER_DEFINED_5。
