-- ============================================================================
-- 阶段 2 实机反馈第 6 项：黄昏宫殿与何不用之的尤里卡 / 鼓舞通知类型
-- 动作：InGame UpdateDatabase，紧跟 TsoDTE_WMD.sql 之后。
-- 授予与发送在 Scripts/TsoDTE_LeaderTrait.lua；这里只登记类型与通知行。
-- 不复用官方 NOTIFICATION_TECH_BOOST / NOTIFICATION_CIVIC_BOOST：
--   它们的激活处理（Base/Assets/UI/Panels/NotificationPanel.lua 的 OnTechBoostActivateNotification）
--   要读通知上的 TechIndex / TechProgress / TechSource，Lua 的 SendNotification 传不了这些值，
--   点击没有反应；而且它们和引擎自己触发的提升共用 TECH_BOOST 分组。
-- 照 WMD 的 NOTIFICATION_TSOD_ANNIHILATION_* 写法：不自动弹窗，只进右侧通知栏，点掉为止。
-- 这里的 Message / Summary 是静态 tag；Lua 发送时传入同一个 tag 经 Locale.Lookup 取文本
-- （点名科技、市政、单位时带参数）。
-- 两个类型只因摘要（标题）不同：黄昏宫殿与何不用之各一个。
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. 类型登记
-- ---------------------------------------------------------------------------
INSERT INTO
    Types (Type, Kind)
VALUES
    ('NOTIFICATION_TSOD_TWILIGHT_BOOST', 'KIND_NOTIFICATION'),
    ('NOTIFICATION_TSOD_KILL_BOOST', 'KIND_NOTIFICATION');

-- ---------------------------------------------------------------------------
-- 2. 通知（Notifications）：列同 TsoDTE_WMD.sql，不自动弹窗，点掉为止。
-- ---------------------------------------------------------------------------
INSERT INTO
    Notifications (
        NotificationType,
        Message,
        Summary,
        SeverityType,
        ExpiresEndOfTurn,
        ExpiresEndOfNextTurn,
        AutoNotify,
        AutoActivate,
        VisibleInUI,
        ShowIconSinglePlayer
    )
VALUES
    (
        'NOTIFICATION_TSOD_TWILIGHT_BOOST',
        'LOC_NOTIFICATION_TSOD_TWILIGHT_BOOST_MESSAGE',
        'LOC_NOTIFICATION_TSOD_TWILIGHT_BOOST_SUMMARY',
        'MID',
        0,
        0,
        0,
        0,
        1,
        1
    ),
    (
        'NOTIFICATION_TSOD_KILL_BOOST',
        'LOC_NOTIFICATION_TSOD_KILL_BOOST_MESSAGE',
        'LOC_NOTIFICATION_TSOD_KILL_BOOST_SUMMARY',
        'MID',
        0,
        0,
        0,
        0,
        1,
        1
    );
