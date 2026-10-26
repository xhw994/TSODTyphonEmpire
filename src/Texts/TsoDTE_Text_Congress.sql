-- WP17 神权理事会文本（InGame UpdateText：世界议会只在局内出现）；选项不写标签，官方决议的两个选项也只有效果句。
-- 术语（战斗力、宗教战斗力、外交支持、[ICON_Religion]、[ICON_Favor]）照官方中文本。

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- zh_Hans_CN
    ('zh_Hans_CN', 'LOC_WC_RES_TSOD_THEOCRATIC_COUNCIL_NAME', '神权理事会'),

    -- 选项 1（A）：去神圣化
    ('zh_Hans_CN', 'LOC_WORLD_CONGRESS_TSOD_DESANCTIFY_RELIGION_DESC',
     '所选 [ICON_Religion] 宗教的所有单位 -10 战斗力（普通及宗教战斗力）。'),

    -- 选项 2（B）：世俗监督
    ('zh_Hans_CN', 'LOC_WORLD_CONGRESS_TSOD_SECULAR_OVERSIGHT_DESC',
     '所有文明都可以谴责所选宗教的单位，每次谴责获得 25 点 [ICON_Favor] 外交支持。'),

    -- en_US
    ('en_US', 'LOC_WC_RES_TSOD_THEOCRATIC_COUNCIL_NAME', 'Theocratic Council'),

    ('en_US', 'LOC_WORLD_CONGRESS_TSOD_DESANCTIFY_RELIGION_DESC',
     '-10 Strength (Combat and Religious) for all units of the chosen [ICON_Religion] Religion.'),

    ('en_US', 'LOC_WORLD_CONGRESS_TSOD_SECULAR_OVERSIGHT_DESC',
     'Any player may condemn units of the chosen Religion; each condemnation grants 25 [ICON_Favor] Diplomatic Favor.');
