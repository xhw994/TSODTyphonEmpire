-- ============================================================================
-- 阶段 2 实机反馈第 6 项：黄昏宫殿与何不用之的通知文本
-- 动作：InGame UpdateText（不进 FrontEnd：通知只在局内出现）。
-- 占位符由 Lua 用 Locale.Lookup(tag, 参数…) 填入，按参数位置对应 {1_…}、{2_…}。
--   LOC_NOTIFICATION_TSOD_TWILIGHT_BOOST_MESSAGE：{1_Boosts} = 若干条目用分隔符拼成的串
--   LOC_NOTIFICATION_TSOD_KILL_BOOST_MESSAGE：{1_Unit} 被杀单位名，{2_Boost} = 一条「科技的尤里卡」
--   LOC_NOTIFICATION_TSOD_BOOST_EUREKA / _INSPIRATION：一条尤里卡 / 鼓舞，参数为科技 / 市政名
-- 效果文本不用第二人称，不写介绍（介绍放百科）。
-- 英文专名「何不用之 = Why Not Use It」是暂定译名，已登记在 docs/ids.md §6。
-- ============================================================================

INSERT
OR REPLACE INTO LocalizedText (Language, Tag, Text)
VALUES
    -- ---------------------------------------------------------------- zh_Hans_CN
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_TWILIGHT_BOOST_SUMMARY', '黄昏宫殿'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_TWILIGHT_BOOST_MESSAGE', '进入新时代，黄昏宫殿授予了{1_Boosts}。'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_KILL_BOOST_SUMMARY', '何不用之'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_KILL_BOOST_MESSAGE', '击杀敌方{1_Unit}，授予了{2_Boost}。'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_BOOST_EUREKA', '{1_Tech}的尤里卡'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_BOOST_INSPIRATION', '{1_Civic}的鼓舞'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_BOOST_SEPARATOR', '、'),

    -- ---------------------------------------------------------------- en_US
    ('en_US', 'LOC_NOTIFICATION_TSOD_TWILIGHT_BOOST_SUMMARY', 'Twilight Palace'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_TWILIGHT_BOOST_MESSAGE', 'Entering a new era, the Twilight Palace granted {1_Boosts}.'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_KILL_BOOST_SUMMARY', 'Why Not Use It'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_KILL_BOOST_MESSAGE', 'Killing an enemy {1_Unit} granted {2_Boost}.'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_BOOST_EUREKA', 'Eureka for {1_Tech}'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_BOOST_INSPIRATION', 'Inspiration for {1_Civic}'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_BOOST_SEPARATOR', ', ');
