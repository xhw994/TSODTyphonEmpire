-- WP2 civ ability text (InGame + FrontEnd UpdateText: the start screen shows the trait name and description).
-- The description says "Campus" (the Mage Tower replaces Campus, and the condition accepts both); the hidden ability ABILITY_TSOD_CAMPUS_TRAINED_PROMOTION has no text.

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME',
     '超凡者的帝国'),
    ('zh_Hans_CN', 'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_DESCRIPTION',
     '拥有学院的城市训练的陆地军事单位获得一次免费升级。[NEWLINE]学院和圣地区域每回合额外提供+1 [ICON_GreatGeneral] 大将军点数。[NEWLINE]拥有军营的城市不受其他文明所创 [ICON_Religion] 宗教的压力影响。'),

    ('en_US', 'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME',
     'Empire of the Extraordinary'),
    ('en_US', 'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_DESCRIPTION',
     'Land military units trained in a city with a Campus start with a free promotion.[NEWLINE]Campus and Holy Site districts provide +1 [ICON_GreatGeneral] Great General point per turn.[NEWLINE]Cities with an Encampment ignore religious pressure from [ICON_Religion] Religions founded by other civilizations.');
