-- =============================================================================
-- WP3 领袖能力文本
-- 加载：InGame UpdateText + FrontEnd UpdateText
-- tag 归属见 docs/ids.md §4：LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME / _DESCRIPTION
-- 描述只写效果、不用第二人称（I1 反馈）；介绍性文字由 WP8 放进领袖百科。
-- =============================================================================

INSERT OR REPLACE INTO LocalizedText
        (Language,      Tag,                                                    Text)
VALUES  ('zh_Hans_CN',  'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME',           '凡人的韧性'),
        ('zh_Hans_CN',  'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_DESCRIPTION',    '每进入一个新时代，从该时代随机获得1个 [ICON_TechBoosted] 尤里卡和1个 [ICON_CivicBoosted] 鼓舞；若新时代是黑暗时代，改为各2个。[NEWLINE]战斗中击杀敌方单位后，若尚未研究该单位的前置科技，立即获得该科技的 [ICON_TechBoosted] 尤里卡。'),
        ('en_US',       'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME',           'Resilience of Mortals'),
        ('en_US',       'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_DESCRIPTION',    'Entering a new era grants 1 random [ICON_TechBoosted] Eureka and 1 random [ICON_CivicBoosted] Inspiration from that era, or 2 of each if the new era is a Dark Age.[NEWLINE]Combat victories trigger the [ICON_TechBoosted] Eureka for the defeated unit''s prerequisite technology if it has not been researched yet.');
