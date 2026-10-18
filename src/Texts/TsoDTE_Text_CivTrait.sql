-- =============================================================================
-- TsoDTE_Text_CivTrait.sql  (WP2 文明能力「超凡者的帝国」文本)
-- 动作：InGame UpdateText + FrontEnd UpdateText（开局界面要显示特性名与说明）。
-- =============================================================================

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- 文明能力
    ('zh_Hans_CN', 'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME',
     '超凡者的帝国'),
    ('zh_Hans_CN', 'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_DESCRIPTION',
     '拥有法师塔的城市训练的陆地军事单位，获得一次免费升级。[NEWLINE]法师塔和圣地区域每回合各额外提供+1 [ICON_GreatGeneral] 大将军点数。[NEWLINE]拥有军营区域的城市不受其他文明所创 [ICON_Religion] 宗教的压力影响。'),

    -- 能力：学院训练免费升级
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_CAMPUS_TRAINED_PROMOTION_NAME',
     '学院出身'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_CAMPUS_TRAINED_PROMOTION_DESCRIPTION',
     '在拥有法师塔的城市训练，初始便拥有一次免费升级。（超凡者的帝国）'),

    -- Civilization ability
    ('en_US', 'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME',
     'Empire of the Extraordinary'),
    ('en_US', 'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_DESCRIPTION',
     'Land military units trained in a city with a Mage Tower start with a free promotion.[NEWLINE]Mage Tower and Holy Site districts each provide +1 [ICON_GreatGeneral] Great General point per turn.[NEWLINE]Cities with an Encampment district ignore pressure from [ICON_Religion] Religions founded by other civilizations.'),

    -- Ability: free promotion for Campus-trained units
    ('en_US', 'LOC_ABILITY_TSOD_CAMPUS_TRAINED_PROMOTION_NAME',
     'Campus-Trained'),
    ('en_US', 'LOC_ABILITY_TSOD_CAMPUS_TRAINED_PROMOTION_DESCRIPTION',
     'Trained in a city with a Mage Tower: starts with a free promotion. (Empire of the Extraordinary)');
