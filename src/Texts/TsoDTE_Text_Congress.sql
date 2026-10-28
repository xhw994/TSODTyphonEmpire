-- WP17 Theocratic Council text (InGame UpdateText: the World Congress appears only in-game); options carry no label, and the official resolution's two options also have only effect sentences.
-- Terms (combat strength, religious combat strength, diplomatic support, [ICON_Religion], [ICON_Favor]) follow the official Chinese localization.

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- zh_Hans_CN
    ('zh_Hans_CN', 'LOC_WC_RES_TSOD_THEOCRATIC_COUNCIL_NAME', '神权理事会'),

    -- Option 1 (A): Desanctification
    ('zh_Hans_CN', 'LOC_WORLD_CONGRESS_TSOD_DESANCTIFY_RELIGION_DESC',
     '所选 [ICON_Religion] 宗教的所有单位 -10 战斗力（普通及宗教战斗力）。'),

    -- Option 2 (B): secular supervision
    ('zh_Hans_CN', 'LOC_WORLD_CONGRESS_TSOD_SECULAR_OVERSIGHT_DESC',
     '所有文明都可以谴责所选宗教的单位，每次谴责获得 25 点 [ICON_Favor] 外交支持。'),

    -- en_US
    ('en_US', 'LOC_WC_RES_TSOD_THEOCRATIC_COUNCIL_NAME', 'Theocratic Council'),

    ('en_US', 'LOC_WORLD_CONGRESS_TSOD_DESANCTIFY_RELIGION_DESC',
     '-10 Strength (Combat and Religious) for all units of the chosen [ICON_Religion] Religion.'),

    ('en_US', 'LOC_WORLD_CONGRESS_TSOD_SECULAR_OVERSIGHT_DESC',
     'All players may condemn units of the chosen [ICON_Religion] Religion, and doing so grants 25 [ICON_Favor] Diplomatic Favor.');
