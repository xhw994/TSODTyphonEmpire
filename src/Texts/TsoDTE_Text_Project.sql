-- WP16 Desanctification text (InGame UpdateText: the project appears only in the in-game production panel); effect text does not use second person, and descriptions state only the effect.
-- Terms: faith value, science value, diplomatic support, and Diplomatic Favor follow the official Chinese and English text.

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- zh_Hans_CN
    ('zh_Hans_CN', 'LOC_PROJECT_TSOD_DESANCTIFICATION_NAME', '去神圣化'),
    ('zh_Hans_CN', 'LOC_PROJECT_TSOD_DESANCTIFICATION_SHORT_NAME', '去神圣化'),
    ('zh_Hans_CN', 'LOC_PROJECT_TSOD_DESANCTIFICATION_DESCRIPTION',
     '需要“法师塔”区域与“大众传媒”市政。[NEWLINE]完成时：将 [ICON_Faith] 信仰值的一半转化为等量的 [ICON_Science] 科技值，计入当前研究。[NEWLINE]获得 25 点 [ICON_Favor] 外交支持。'),

    -- Notifications (messages and summary)
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_MESSAGE',
     '去神圣化完成：信仰值的一半已转化为科技值，并获得 25 点外交支持。'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_SUMMARY', '去神圣化完成'),

    -- en_US
    ('en_US', 'LOC_PROJECT_TSOD_DESANCTIFICATION_NAME', 'Desanctification'),
    ('en_US', 'LOC_PROJECT_TSOD_DESANCTIFICATION_SHORT_NAME', 'Desanctification'),
    ('en_US', 'LOC_PROJECT_TSOD_DESANCTIFICATION_DESCRIPTION',
     'Requires a Mage Tower district and the Mass Media civic.[NEWLINE]On completion: converts half of the current [ICON_Faith] Faith into an equal amount of [ICON_Science] Science toward the current research.[NEWLINE]Grants 25 [ICON_Favor] Diplomatic Favor.'),

    ('en_US', 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_MESSAGE',
     'Desanctification complete: half of the Faith was converted into Science, and 25 Diplomatic Favor was granted.'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_SUMMARY', 'Desanctification Complete');
