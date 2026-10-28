-- WP3 leader ability text (InGame + FrontEnd UpdateText); descriptions state only the effect and do not use second person (I1 feedback); the introductory text is in the leader Civilopedia.

INSERT OR REPLACE INTO LocalizedText
        (Language,      Tag,                                                    Text)
VALUES  ('zh_Hans_CN',  'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME',           '凡人的韧性'),
        ('zh_Hans_CN',  'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_DESCRIPTION',    '每进入一个新时代，从该时代随机获得1个 [ICON_TechBoosted] 尤里卡和1个 [ICON_CivicBoosted] 鼓舞；若为黑暗时代，改为各2个。[NEWLINE]战斗中击杀敌方单位后，若尚未研究该单位的前置科技，立即获得该科技的 [ICON_TechBoosted] 尤里卡。'),
        ('en_US',       'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME',           'Resilience of Mortals'),
        ('en_US',       'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_DESCRIPTION',    'Entering a new era grants 1 random [ICON_TechBoosted] Eureka and 1 random [ICON_CivicBoosted] Inspiration from that era, or 2 of each if it is a Dark Age.[NEWLINE]Killing an enemy unit in combat grants the [ICON_TechBoosted] Eureka for that unit''s prerequisite technology, if it has not been researched yet.');

-- Notification (the summary uses the leader ability name directly, LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME)
INSERT OR REPLACE INTO LocalizedText
        (Language,      Tag,                                        Text)
VALUES  ('zh_Hans_CN',  'LOC_TSOD_TYPHON_BOOST_NOTIFY_ERA',         '进入新时代，获得{1_Items}。'),
        ('zh_Hans_CN',  'LOC_TSOD_TYPHON_BOOST_NOTIFY_DARK_AGE',    '黑暗时代，额外获得{1_Items}。'),
        ('zh_Hans_CN',  'LOC_TSOD_TYPHON_BOOST_NOTIFY_KILL',        '击杀{1_Unit}，获得{2_Item}。'),
        ('zh_Hans_CN',  'LOC_TSOD_TYPHON_BOOST_ITEM_EUREKA',        '“{1_Tech}”的 [ICON_TechBoosted] 尤里卡'),
        ('zh_Hans_CN',  'LOC_TSOD_TYPHON_BOOST_ITEM_INSPIRATION',   '“{1_Civic}”的 [ICON_CivicBoosted] 鼓舞'),
        ('zh_Hans_CN',  'LOC_TSOD_TYPHON_BOOST_ITEM_SEPARATOR',     '、'),
        ('en_US',       'LOC_TSOD_TYPHON_BOOST_NOTIFY_ERA',         'New era: gained {1_Items}.'),
        ('en_US',       'LOC_TSOD_TYPHON_BOOST_NOTIFY_DARK_AGE',    'Dark Age: also gained {1_Items}.'),
        ('en_US',       'LOC_TSOD_TYPHON_BOOST_NOTIFY_KILL',        'Enemy {1_Unit} killed: gained {2_Item}.'),
        ('en_US',       'LOC_TSOD_TYPHON_BOOST_ITEM_EUREKA',        '[ICON_TechBoosted] Eureka for {1_Tech}'),
        ('en_US',       'LOC_TSOD_TYPHON_BOOST_ITEM_INSPIRATION',   '[ICON_CivicBoosted] Inspiration for {1_Civic}'),
        ('en_US',       'LOC_TSOD_TYPHON_BOOST_ITEM_SEPARATOR',     ', ');
