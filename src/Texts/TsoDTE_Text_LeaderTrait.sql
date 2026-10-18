-- =============================================================================
-- WP3 领袖能力文本
-- 加载：InGame UpdateText + FrontEnd UpdateText
-- tag 归属见 docs/ids.md §4：LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME / _DESCRIPTION
-- =============================================================================

INSERT OR REPLACE INTO LocalizedText
        (Language,      Tag,                                                    Text)
VALUES  ('zh_Hans_CN',  'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME',           '凡人的韧性'),
        ('zh_Hans_CN',  'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_DESCRIPTION',    '在黄昏宫殿的噩梦里，奥古斯都们从未屈服。[NEWLINE][NEWLINE]每进入一个新时代，从该时代随机获得1个 [ICON_TechBoosted] 尤里卡和1个 [ICON_CivicBoosted] 鼓舞；若新时代是黑暗时代，改为各2个。[NEWLINE]战斗中击杀敌方单位后，若您尚未研究该单位的前置科技，立即获得该科技的 [ICON_TechBoosted] 尤里卡。'),
        ('en_US',       'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME',           'Resilience of Mortals'),
        ('en_US',       'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_DESCRIPTION',    'Through the nightmares of the Twilight Palace, the House of Augustus never yielded.[NEWLINE][NEWLINE]When you enter a new era, earn 1 random [ICON_TechBoosted] Eureka and 1 random [ICON_CivicBoosted] Inspiration from that era. If the new era is a Dark Age, earn 2 of each instead.[NEWLINE]After killing an enemy unit in combat, if you have not yet researched that unit''s prerequisite technology, immediately earn its [ICON_TechBoosted] Eureka.');
