-- WP6 Burnstone Acidification Works text (IG + FE UpdateText); the yield and powered bonuses are listed automatically by the UI from Building_YieldChanges, so the description covers only the rest.
-- The building's own yields spill over with RegionalRange (science spills too, confirmed in-game by I1); the farm / mine / quarry bonuses apply only to this city.

INSERT
OR REPLACE INTO LocalizedText (Language, Tag, Text)
VALUES
    ('zh_Hans_CN', 'LOC_BUILDING_TSOD_BURNSTONE_WORKS_NAME', '燃石酸化工厂'),
    ('en_US', 'LOC_BUILDING_TSOD_BURNSTONE_WORKS_NAME', 'Burnstone Acidification Works'),
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
    -- Unique building trait name (official precedent: the Japan Electronics Factory trait name "Japanese Unique Building: Electronics Factory")
    (
        'zh_Hans_CN',
        'LOC_TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS_NAME',
        '提丰特色建筑：燃石酸化工厂'
    ),
    (
        'en_US',
        'LOC_TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS_NAME',
        'Typhonian unique building: Burnstone Acidification Works'
    );
