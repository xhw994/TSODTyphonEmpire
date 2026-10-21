-- ============================================================================
-- WP4 战斗法师基础：文本
-- 动作：InGame UpdateText + FrontEnd UpdateText（开局界面显示特色单位名与说明）。
-- 百科长文归 WP8（Texts/TsoDTE_Text_Pedia.sql），不在这里。
-- ============================================================================

INSERT
OR REPLACE INTO LocalizedText (Language, Tag, Text)
VALUES
    -- 单位（同时被 TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE 的 Name / Description 引用）
    ('zh_Hans_CN', 'LOC_UNIT_TSOD_BATTLE_MAGE_NAME', '战斗法师'),
    (
        'zh_Hans_CN',
        'LOC_UNIT_TSOD_BATTLE_MAGE_DESCRIPTION',
        '中世纪提丰特色远程单位，替代弩手。其 [ICON_Strength] 战斗力随时代成长。与至少一个其他战斗法师相邻时，+5 [ICON_Ranged] 远程攻击力（不叠加）。'
    ),

    -- 能力：弹道学成长
-- （三个能力的 DESCRIPTION 只写名字：单位面板悬停提示会把能力的 Description 整句列出来，
--  I1 反馈要求只显示技能名；效果说明在单位描述和百科里。）
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_NAME', '弹道学成长'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_DESCRIPTION', '弹道学成长'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_PREVIEW', '+{1_Amount} 弹道学成长'),

    -- 能力：高级弹道学成长
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_NAME', '高级弹道学成长'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_DESCRIPTION', '高级弹道学成长'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_PREVIEW', '+{1_Amount} 高级弹道学成长'),

    -- 能力：军团级法术
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_NAME', '军团级法术'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_DESCRIPTION', '军团级法术'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_PREVIEW', '+{1_Amount} 军团级法术'),

    -- ---------------------------------------------------------------- en_US
    ('en_US', 'LOC_UNIT_TSOD_BATTLE_MAGE_NAME', 'Battle Mage'),
    (
        'en_US',
        'LOC_UNIT_TSOD_BATTLE_MAGE_DESCRIPTION',
        'Typhon unique Medieval era ranged unit that replaces the Crossbowman. Its [ICON_Strength] Combat Strength grows with the eras. +5 [ICON_Ranged] Ranged Strength when adjacent to at least one other Battle Mage (does not stack).'
    ),

    ('en_US', 'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_NAME', 'Ballistics Growth'),
    ('en_US', 'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_DESCRIPTION', 'Ballistics Growth'),
    ('en_US', 'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_PREVIEW', '+{1_Amount} Ballistics Growth'),

    ('en_US', 'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_NAME', 'Advanced Ballistics Growth'),
    ('en_US', 'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_DESCRIPTION', 'Advanced Ballistics Growth'),
    ('en_US', 'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_PREVIEW', '+{1_Amount} Advanced Ballistics Growth'),

    ('en_US', 'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_NAME', 'Legion-Class Spell'),
    ('en_US', 'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_DESCRIPTION', 'Legion-Class Spell'),
    ('en_US', 'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_PREVIEW', '+{1_Amount} Legion-Class Spell');
