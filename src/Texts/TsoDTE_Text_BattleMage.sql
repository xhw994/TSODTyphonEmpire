-- WP4 Battle Mage text (InGame + FrontEnd UpdateText: the start screen shows the unique unit name and description); the long Civilopedia article is in Text_Pedia.

INSERT
OR REPLACE INTO LocalizedText (Language, Tag, Text)
VALUES
    -- Unit (also referenced by the Name / Description of TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE)
    ('zh_Hans_CN', 'LOC_UNIT_TSOD_BATTLE_MAGE_NAME', '战斗法师'),
    (
        'zh_Hans_CN',
        'LOC_UNIT_TSOD_BATTLE_MAGE_DESCRIPTION',
        '中世纪提丰特色远程单位，替代弩手。其 [ICON_Strength] 战斗力随研究弹道学和高级弹道学提升。与至少一个其他战斗法师相邻时，+5 [ICON_Ranged] 远程攻击力（不叠加）。组成军团或军队后每回合恢复生命；组成军队后可施放一次“湮灭之创”，施放后整支军队阵亡。'
    ),

    -- Ability: Ballistics Growth
-- The DESCRIPTION of the three abilities holds only the name: the unit panel hover tip lists the whole sentence (I1 feedback); the effect is described in the unit description and the Civilopedia.
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_NAME', '弹道学成长'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_DESCRIPTION', '弹道学成长'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_BALLISTICS_PREVIEW', '+{1_Amount} 弹道学成长'),

    -- Ability: Advanced Ballistics Growth
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_NAME', '高级弹道学成长'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_DESCRIPTION', '高级弹道学成长'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS_PREVIEW', '+{1_Amount} 高级弹道学成长'),

    -- Ability: Legion-Class Spell
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_NAME', '军团级法术'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_DESCRIPTION', '军团级法术'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_BATTLE_MAGE_CONCERT_PREVIEW', '+{1_Amount} 军团级法术'),

    -- en_US
    ('en_US', 'LOC_UNIT_TSOD_BATTLE_MAGE_NAME', 'Battle Mage'),
    (
        'en_US',
        'LOC_UNIT_TSOD_BATTLE_MAGE_DESCRIPTION',
        'Typhonian unique Medieval era ranged unit that replaces the Crossbowman. Its [ICON_Strength] Combat Strength grows as Ballistics and Advanced Ballistics are researched. +5 [ICON_Ranged] Ranged Strength when adjacent to at least one other Battle Mage (does not stack). Corps and armies heal every turn. An army can cast Annihilation Scar once; the whole army dies after casting.'
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
