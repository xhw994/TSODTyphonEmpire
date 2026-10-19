-- ============================================================================
-- WP6 燃石酸化工厂 文本（IG UpdateText + FE UpdateText）
-- 百科长文归 WP8（TsoDTE_Text_Pedia.sql），不在这里。
-- 产出与通电加成由界面按 Building_YieldChanges / _BonusWithPower 自动列出，
-- 描述分两类：建筑本身产出（随 RegionalRange 辐射，照官方工厂、核电站的风云变幻句式）；
-- 农场、矿山与采石场加成（BuildingModifiers，只作用于本城）。
-- 科技是否也辐射待实测；照核电站先例按「辐射」写。
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
        '提丰特色建筑。其+6 [ICON_Production] 生产力和+3 [ICON_Science] 科技值加成延伸到6单元格内的所有市中心（前提是其尚未从其他的此建筑获得加成）。[NEWLINE]此城市所有农场+5 [ICON_Food] 食物，所有矿山和采石场+2 [ICON_Production] 生产力；这两项加成不延伸到其他城市。'
    ),
    (
        'en_US',
        'LOC_BUILDING_TSOD_BURNSTONE_WORKS_DESCRIPTION',
        'A building unique to Typhon. Its +6 [ICON_Production] Production and +3 [ICON_Science] Science bonus is extended to all City Centers within 6 tiles that do not already have a bonus from this building type.[NEWLINE]Farms in this city provide +5 [ICON_Food] Food, and Mines and Quarries in this city provide +2 [ICON_Production] Production. These two bonuses do not extend to other cities.'
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
