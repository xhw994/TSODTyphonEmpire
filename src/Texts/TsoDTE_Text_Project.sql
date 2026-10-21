-- ============================================================================
-- WP16 去神圣化：文本
-- 动作：InGame UpdateText（项目只在局内生产面板出现，不进 FrontEnd）。
-- 归属：LOC_PROJECT_TSOD_DESANCTIFICATION_*、LOC_NOTIFICATION_TSOD_DESANCTIFICATION_*（ids.md §4）。
-- 文本规则：效果文本不用第二人称，不写介绍（介绍放百科）。描述只说效果。
-- 术语：信仰值、科技值、外交支持、Diplomatic Favor 照官方中英文本。
-- ============================================================================

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- ---------------------------------------------------------------- zh_Hans_CN
    -- 项目
    ('zh_Hans_CN', 'LOC_PROJECT_TSOD_DESANCTIFICATION_NAME', '去神圣化'),
    ('zh_Hans_CN', 'LOC_PROJECT_TSOD_DESANCTIFICATION_SHORT_NAME', '去神圣化'),
    ('zh_Hans_CN', 'LOC_PROJECT_TSOD_DESANCTIFICATION_DESCRIPTION',
     '完成时：将 [ICON_Faith] 信仰值的一半转化为等量的 [ICON_Science] 科技值，计入当前研究。[NEWLINE]获得 25 点 [ICON_Favor] 外交支持。'),

    -- 通知（消息与摘要）
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_MESSAGE',
     '去神圣化完成：信仰值的一半已转化为科技值，并获得 25 点外交支持。'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_SUMMARY', '去神圣化完成'),

    -- ---------------------------------------------------------------- en_US
    ('en_US', 'LOC_PROJECT_TSOD_DESANCTIFICATION_NAME', 'Desanctification'),
    ('en_US', 'LOC_PROJECT_TSOD_DESANCTIFICATION_SHORT_NAME', 'Desanctify'),
    ('en_US', 'LOC_PROJECT_TSOD_DESANCTIFICATION_DESCRIPTION',
     'On completion: converts half of the current [ICON_Faith] Faith into an equal amount of [ICON_Science] Science toward the current research.[NEWLINE]Grants 25 [ICON_Favor] Diplomatic Favor.'),

    ('en_US', 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_MESSAGE',
     'Desanctification complete: half of the Faith was converted into Science, and 25 Diplomatic Favor was granted.'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_SUMMARY', 'Desanctification Complete');
