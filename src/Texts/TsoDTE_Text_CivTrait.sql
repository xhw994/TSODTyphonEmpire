-- WP2 文明能力文本（InGame + FrontEnd UpdateText：开局界面要显示特性名与说明）。
-- 说明里写「学院」（法师塔替代学院，条件同时认两者）；隐藏能力 ABILITY_TSOD_CAMPUS_TRAINED_PROMOTION 没有文本。

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME',
     '超凡者的帝国'),
    ('zh_Hans_CN', 'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_DESCRIPTION',
     '拥有学院的城市训练的陆地军事单位获得一次免费升级。[NEWLINE]学院和圣地区域每回合额外提供+1 [ICON_GreatGeneral] 大将军点数。[NEWLINE]拥有军营的城市不受其他文明所创 [ICON_Religion] 宗教的压力影响。'),

    ('en_US', 'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME',
     'Empire of the Extraordinary'),
    ('en_US', 'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_DESCRIPTION',
     'Land military units trained in a city with a Campus start with a free promotion.[NEWLINE]Campus and Holy Site districts provide +1 [ICON_GreatGeneral] Great General point per turn.[NEWLINE]Cities with an Encampment ignore pressure from [ICON_Religion] Religions founded by other civilizations.');
