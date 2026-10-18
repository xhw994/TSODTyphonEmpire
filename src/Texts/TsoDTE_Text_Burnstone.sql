-- ============================================================================
-- WP6 燃石酸化工厂 文本（IG UpdateText + FE UpdateText）
-- 百科长文归 WP8（TsoDTE_Text_Pedia.sql），不在这里。
-- 产出与通电加成由界面按 Building_YieldChanges / _BonusWithPower 自动列出，
-- 描述只写特有效果与范围辐射（照官方工厂、核电站的风云变幻描述句式）。
-- ============================================================================

INSERT
OR REPLACE INTO LocalizedText (Language, Tag, Text)
VALUES
    -- 建筑名
    ('zh_Hans_CN', 'LOC_BUILDING_TSOD_BURNSTONE_WORKS_NAME', '燃石酸化工厂'),
    ('en_US', 'LOC_BUILDING_TSOD_BURNSTONE_WORKS_NAME', 'Burnstone Acidification Works'),
    -- 建筑描述
    (
        'zh_Hans_CN',
        'LOC_BUILDING_TSOD_BURNSTONE_WORKS_DESCRIPTION',
        '提丰特色建筑。此城市所有农场+5 [ICON_Food] 食物。其 [ICON_Production] 生产力和 [ICON_Science] 科技值加成延伸到6单元格内的所有市中心（前提是其尚未从其他的此建筑获得加成）。'
    ),
    (
        'en_US',
        'LOC_BUILDING_TSOD_BURNSTONE_WORKS_DESCRIPTION',
        'A building unique to Typhon. All Farms in this city provide +5 [ICON_Food] Food. Its [ICON_Production] Production and [ICON_Science] Science bonus is extended to all City Centers within 6 tiles that do not already have a bonus from this building type.'
    ),
    -- 特色建筑特性名（官方先例：日本电子厂的特性名「日本特色建筑：电子厂」）
    (
        'zh_Hans_CN',
        'LOC_TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS_NAME',
        '提丰特色建筑：燃石酸化工厂'
    ),
    (
        'en_US',
        'LOC_TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS_NAME',
        'Typhon unique building: Burnstone Acidification Works'
    );
