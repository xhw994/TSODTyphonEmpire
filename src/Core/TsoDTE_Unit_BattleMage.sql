-- ============================================================================
-- WP4 战斗法师基础：UNIT_TSOD_BATTLE_MAGE（替代弩手）
-- 动作：InGame UpdateDatabase。依赖 TsoDTE_Civilization.sql 先建好
--       CIVILIZATION_TSOD_TYPHON_EMPIRE（CivilizationTraits 外键）。
-- 先例：
--   单位行与 UnitAiInfos 照 Base Units.xml 的 UNIT_CROSSBOWMAN；
--   成长能力照 GranColombia_Maya 的尼杭（Inactive 能力 + 标签限定 +
--     MODIFIER_PLAYER_UNITS_GRANT_ABILITY 授予 + MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH）；
--   科技条件照 AGENDA_HIGH_NUKE_LOVE（TraitModifiers + Owner + REQUIREMENT_PLAYER_HAS_TECHNOLOGY）；
--   相邻加成照希腊重装步兵 ABILITY_HOPLITE（MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER 套
--     MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH）；
--   只加远程攻击照晋升 VOLLEY / TORTOISE（REQUIREMENT_PLAYER_IS_ATTACKING + REQUIREMENT_COMBAT_TYPE_MATCHES）。
-- 不升级：不写 UnitUpgrades，也不设 MandatoryObsoleteTech（弩手是 TECH_ADVANCED_BALLISTICS）。
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. 类型登记
-- ---------------------------------------------------------------------------
INSERT INTO
    Types (Type, Kind)
VALUES
    ('UNIT_TSOD_BATTLE_MAGE', 'KIND_UNIT'),
    ('TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE', 'KIND_TRAIT'),
    ('ABILITY_TSOD_BATTLE_MAGE_BALLISTICS', 'KIND_ABILITY'),
    ('ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS', 'KIND_ABILITY'),
    ('ABILITY_TSOD_BATTLE_MAGE_CONCERT', 'KIND_ABILITY');

-- ---------------------------------------------------------------------------
-- 2. 特性：特色单位挂到文明上（ids.md §5.5 归 WP4）
-- ---------------------------------------------------------------------------
INSERT INTO
    Traits (TraitType, Name, Description)
VALUES
    (
        'TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE',
        'LOC_UNIT_TSOD_BATTLE_MAGE_NAME',
        'LOC_UNIT_TSOD_BATTLE_MAGE_DESCRIPTION'
    );

INSERT INTO
    CivilizationTraits (CivilizationType, TraitType)
VALUES
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE');

-- ---------------------------------------------------------------------------
-- 3. 单位本体（数值照弩手；去掉 MandatoryObsoleteTech；WMDCapable 为阶段 2 预留）
-- ---------------------------------------------------------------------------
INSERT INTO
    Units (
        UnitType,
        Name,
        Description,
        TraitType,
        Cost,
        Maintenance,
        BaseMoves,
        BaseSightRange,
        ZoneOfControl,
        Domain,
        Combat,
        RangedCombat,
        Range,
        FormationClass,
        PromotionClass,
        AdvisorType,
        PurchaseYield,
        PrereqTech,
        WMDCapable
    )
VALUES
    (
        'UNIT_TSOD_BATTLE_MAGE',
        'LOC_UNIT_TSOD_BATTLE_MAGE_NAME',
        'LOC_UNIT_TSOD_BATTLE_MAGE_DESCRIPTION',
        'TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE',
        180,
        3,
        2,
        2,
        0,
        'DOMAIN_LAND',
        30,
        40,
        2,
        'FORMATION_CLASS_LAND_COMBAT',
        'PROMOTION_CLASS_RANGED',
        'ADVISOR_CONQUEST',
        'YIELD_GOLD',
        'TECH_MACHINERY',
        1
    );

INSERT INTO
    UnitReplaces (CivUniqueUnitType, ReplacesUnitType)
VALUES
    ('UNIT_TSOD_BATTLE_MAGE', 'UNIT_CROSSBOWMAN');

-- AI 类型：弩手的三条 + UNITTYPE_NUCLEAR（官方只给轰炸机、喷气轰炸机、核潜艇）
INSERT INTO
    UnitAiInfos (UnitType, AiType)
VALUES
    ('UNIT_TSOD_BATTLE_MAGE', 'UNITAI_COMBAT'),
    ('UNIT_TSOD_BATTLE_MAGE', 'UNITTYPE_RANGED'),
    ('UNIT_TSOD_BATTLE_MAGE', 'UNITTYPE_LAND_COMBAT'),
    ('UNIT_TSOD_BATTLE_MAGE', 'UNITTYPE_NUCLEAR');

-- ---------------------------------------------------------------------------
-- 4. 标签：单位类与能力类
-- ---------------------------------------------------------------------------
INSERT INTO
    Tags (Tag, Vocabulary)
VALUES
    ('CLASS_TSOD_BATTLE_MAGE', 'ABILITY_CLASS');

INSERT INTO
    TypeTags (Type, Tag)
VALUES
    ('UNIT_TSOD_BATTLE_MAGE', 'CLASS_RANGED'),
    ('UNIT_TSOD_BATTLE_MAGE', 'CLASS_TSOD_BATTLE_MAGE'),
    ('UNIT_TSOD_BATTLE_MAGE', 'CLASS_ALL_ERAS'),
    ('ABILITY_TSOD_BATTLE_MAGE_BALLISTICS', 'CLASS_TSOD_BATTLE_MAGE'),
    ('ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS', 'CLASS_TSOD_BATTLE_MAGE'),
    ('ABILITY_TSOD_BATTLE_MAGE_CONCERT', 'CLASS_TSOD_BATTLE_MAGE');

-- ---------------------------------------------------------------------------
-- 5. 能力
--    两个成长能力 Inactive = 1：不自动生效，只能由授予修正给（同尼杭）。
--    军团级法术 Inactive = 0：凡带 CLASS_TSOD_BATTLE_MAGE 的单位自动拥有（同重装步兵）。
-- ---------------------------------------------------------------------------
INSERT INTO
    UnitAbilities (UnitAbilityType, Name, Description, Inactive)
VALUES
    (
        'ABILITY_TSOD_BATTLE_MAGE_BALLISTICS',
        'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_NAME',
        'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_DESCRIPTION',
        1
    ),
    (
        'ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS',
        'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_NAME',
        'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_DESCRIPTION',
        1
    ),
    (
        'ABILITY_TSOD_BATTLE_MAGE_CONCERT',
        'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_NAME',
        'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_DESCRIPTION',
        0
    );

INSERT INTO
    UnitAbilityModifiers (UnitAbilityType, ModifierId)
VALUES
    ('ABILITY_TSOD_BATTLE_MAGE_BALLISTICS', 'TSOD_TYPHON_BATTLE_MAGE_BALLISTICS_STRENGTH'),
    ('ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS', 'TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_STRENGTH'),
    ('ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS', 'TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_RANGED'),
    ('ABILITY_TSOD_BATTLE_MAGE_CONCERT', 'TSOD_TYPHON_BATTLE_MAGE_CONCERT');

-- 授予修正挂在本包自己的特色单位特性上（ids.md §5.5），不碰 WP1 的文明能力壳
INSERT INTO
    TraitModifiers (TraitType, ModifierId)
VALUES
    ('TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE', 'TSOD_TYPHON_BATTLE_MAGE_GRANT_BALLISTICS'),
    ('TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE', 'TSOD_TYPHON_BATTLE_MAGE_GRANT_ADV_BALLISTICS');

-- ---------------------------------------------------------------------------
-- 6. 修正
--    成长（累加）：机械 40/30 → 弹道学 60/50 → 高级弹道学 85/70（远程/近战）
--      弹道学       ：基础战斗力 +20
--      高级弹道学   ：基础战斗力 +20，另加只在远程攻击时生效的 +5
--    军团级法术：相邻有另一个战斗法师时，远程攻击 +5
-- ---------------------------------------------------------------------------
INSERT INTO
    Modifiers (ModifierId, ModifierType, OwnerRequirementSetId, SubjectRequirementSetId)
VALUES
    (
        'TSOD_TYPHON_BATTLE_MAGE_GRANT_BALLISTICS',
        'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',
        'REQSET_TSOD_TYPHON_PLAYER_HAS_BALLISTICS',
        NULL
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_GRANT_ADV_BALLISTICS',
        'MODIFIER_PLAYER_UNITS_GRANT_ABILITY',
        'REQSET_TSOD_TYPHON_PLAYER_HAS_ADV_BALLISTICS',
        NULL
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_BALLISTICS_STRENGTH',
        'MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH',
        NULL,
        NULL
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_STRENGTH',
        'MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH',
        NULL,
        NULL
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_RANGED',
        'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',
        NULL,
        'REQSET_TSOD_TYPHON_BATTLE_MAGE_RANGED_ATTACK'
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_CONCERT',
        'MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER',
        NULL,
        'REQSET_TSOD_TYPHON_ADJACENT_BATTLE_MAGE'
    ),
    (
        'TSOD_TYPHON_BATTLE_MAGE_CONCERT_STRENGTH',
        'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH',
        NULL,
        'REQSET_TSOD_TYPHON_BATTLE_MAGE_RANGED_ATTACK'
    );

INSERT INTO
    ModifierArguments (ModifierId, Name, Value)
VALUES
    ('TSOD_TYPHON_BATTLE_MAGE_GRANT_BALLISTICS', 'AbilityType', 'ABILITY_TSOD_BATTLE_MAGE_BALLISTICS'),
    ('TSOD_TYPHON_BATTLE_MAGE_GRANT_ADV_BALLISTICS', 'AbilityType', 'ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS'),
    ('TSOD_TYPHON_BATTLE_MAGE_BALLISTICS_STRENGTH', 'Amount', '20'),
    ('TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_STRENGTH', 'Amount', '20'),
    ('TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_RANGED', 'Amount', '5'),
    ('TSOD_TYPHON_BATTLE_MAGE_CONCERT', 'ModifierId', 'TSOD_TYPHON_BATTLE_MAGE_CONCERT_STRENGTH'),
    ('TSOD_TYPHON_BATTLE_MAGE_CONCERT_STRENGTH', 'Amount', '5');

-- 需实证（impl plan §6.2 WP4）：MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH 对远程攻击力是否生效，
-- 官方只有尼杭（近战单位）一个先例。验证方法见 WP4 回报。若远程不变，启用下面的退路：
-- 两条 +20 改为普通战斗力修正（同样作用于远程攻击，只是面板显示为加成而不是基础值）。
-- UPDATE Modifiers
-- SET ModifierType = 'MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH'
-- WHERE ModifierId IN (
--     'TSOD_TYPHON_BATTLE_MAGE_BALLISTICS_STRENGTH',
--     'TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_STRENGTH'
-- );

-- ---------------------------------------------------------------------------
-- 7. 需求
-- ---------------------------------------------------------------------------
INSERT INTO
    Requirements (RequirementId, RequirementType)
VALUES
    ('REQ_TSOD_TYPHON_PLAYER_HAS_BALLISTICS', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY'),
    ('REQ_TSOD_TYPHON_PLAYER_HAS_ADV_BALLISTICS', 'REQUIREMENT_PLAYER_HAS_TECHNOLOGY'),
    ('REQ_TSOD_TYPHON_PLAYER_IS_ATTACKING', 'REQUIREMENT_PLAYER_IS_ATTACKING'),
    ('REQ_TSOD_TYPHON_COMBAT_IS_RANGED', 'REQUIREMENT_COMBAT_TYPE_MATCHES'),
    ('REQ_TSOD_TYPHON_ADJACENT_BATTLE_MAGE', 'REQUIREMENT_PLOT_ADJACENT_FRIENDLY_UNIT_TYPE_MATCHES');

INSERT INTO
    RequirementArguments (RequirementId, Name, Value)
VALUES
    ('REQ_TSOD_TYPHON_PLAYER_HAS_BALLISTICS', 'TechnologyType', 'TECH_BALLISTICS'),
    ('REQ_TSOD_TYPHON_PLAYER_HAS_ADV_BALLISTICS', 'TechnologyType', 'TECH_ADVANCED_BALLISTICS'),
    ('REQ_TSOD_TYPHON_COMBAT_IS_RANGED', 'CombatType', 'COMBAT_RANGED'),
    ('REQ_TSOD_TYPHON_ADJACENT_BATTLE_MAGE', 'UnitType', 'UNIT_TSOD_BATTLE_MAGE');

INSERT INTO
    RequirementSets (RequirementSetId, RequirementSetType)
VALUES
    ('REQSET_TSOD_TYPHON_PLAYER_HAS_BALLISTICS', 'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_PLAYER_HAS_ADV_BALLISTICS', 'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_BATTLE_MAGE_RANGED_ATTACK', 'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_ADJACENT_BATTLE_MAGE', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO
    RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
    ('REQSET_TSOD_TYPHON_PLAYER_HAS_BALLISTICS', 'REQ_TSOD_TYPHON_PLAYER_HAS_BALLISTICS'),
    ('REQSET_TSOD_TYPHON_PLAYER_HAS_ADV_BALLISTICS', 'REQ_TSOD_TYPHON_PLAYER_HAS_ADV_BALLISTICS'),
    ('REQSET_TSOD_TYPHON_BATTLE_MAGE_RANGED_ATTACK', 'REQ_TSOD_TYPHON_PLAYER_IS_ATTACKING'),
    ('REQSET_TSOD_TYPHON_BATTLE_MAGE_RANGED_ATTACK', 'REQ_TSOD_TYPHON_COMBAT_IS_RANGED'),
    ('REQSET_TSOD_TYPHON_ADJACENT_BATTLE_MAGE', 'REQ_TSOD_TYPHON_ADJACENT_BATTLE_MAGE');

-- ---------------------------------------------------------------------------
-- 8. 战斗预览说明（Preview）
--    串联用的外层 TSOD_TYPHON_BATTLE_MAGE_CONCERT 不写（同重装步兵，只给内层写）。
--    两条基础战斗力修正也写上：若它计入基础值而不进预览，这两行只是用不上；
--    若改走退路，预览里正好需要它们。
-- ---------------------------------------------------------------------------
INSERT INTO
    ModifierStrings (ModifierId, Context, Text)
VALUES
    ('TSOD_TYPHON_BATTLE_MAGE_BALLISTICS_STRENGTH', 'Preview', 'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_PREVIEW'),
    ('TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_STRENGTH', 'Preview', 'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_PREVIEW'),
    ('TSOD_TYPHON_BATTLE_MAGE_ADV_BALLISTICS_RANGED', 'Preview', 'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_PREVIEW'),
    ('TSOD_TYPHON_BATTLE_MAGE_CONCERT_STRENGTH', 'Preview', 'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_PREVIEW');
