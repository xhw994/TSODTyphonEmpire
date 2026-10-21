-- ============================================================================
-- WP13 湮灭之创：武器、两个能力、三种通知类型
-- 动作：InGame UpdateDatabase，紧跟 TsoDTE_Unit_BattleMage.sql 之后。
-- 先例：
--   武器行照 Klee 的 WMD_JUMPY_DUMPTY（MondstadtKlee_WMDs.xml）：BlastRadius 1、
--     FalloutDuration 0，只伤单位与建筑（AffectUnits、AffectBuildings 为 1，其余为 0）。
--   ICBMStrikeRange 取可莉的 8（需实证，见测试清单）。
--   Maintenance 取 0，依据 master plan §6.1 第 3 部分（可莉填 8，那是按库存每回合收的维护费，
--     与我们的「库存 = 军队数」不合；这一处与「照可莉」不同，统筹者可改）。
--   通知：Types 登记为 KIND_NOTIFICATION，Notifications 表写全必填列（照 Base Notifications.xml）。
-- 能力：Inactive = 1，不自动给。由 TsoDTE_BattleMage.lua 按编队授予：
--   军队得湮灭之创与战场再生；军团只得战场再生。
--   没有 UnitAbilityModifiers：湮灭之创靠武器，战场再生在 Lua 里做，两者都不靠修正。
-- WMDCapable 在 TsoDTE_Unit_BattleMage.sql 里已改回 1，依赖 UnitPanel_TsoDTE.lua 的按钮过滤。
-- ============================================================================

-- ---------------------------------------------------------------------------
-- 1. 类型登记（先于所有引用它们的行）
-- ---------------------------------------------------------------------------
INSERT INTO
    Types (Type, Kind)
VALUES
    ('WMD_TSOD_ANNIHILATION_SCAR', 'KIND_WMD'),
    ('ABILITY_TSOD_ANNIHILATION_SCAR', 'KIND_ABILITY'),
    ('ABILITY_TSOD_ARMY_REGENERATION', 'KIND_ABILITY'),
    ('NOTIFICATION_TSOD_ANNIHILATION_READY', 'KIND_NOTIFICATION'),
    ('NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE', 'KIND_NOTIFICATION'),
    ('NOTIFICATION_TSOD_ARMY_REGENERATION', 'KIND_NOTIFICATION');

-- ---------------------------------------------------------------------------
-- 2. 武器（WMDs）
--    WeaponType 与 Types 行对应；Name 是本地化 tag（UnitPanel 按它的译文认武器，见 UnitPanel_TsoDTE.lua）。
-- ---------------------------------------------------------------------------
INSERT INTO
    WMDs (
        WeaponType,
        Name,
        BlastRadius,
        FalloutDuration,
        AffectPopulation,
        AffectImprovements,
        AffectBuildings,
        AffectUnits,
        AffectResources,
        AffectRoutes,
        ICBMStrikeRange,
        Maintenance
    )
VALUES
    (
        'WMD_TSOD_ANNIHILATION_SCAR',
        'LOC_WMD_TSOD_ANNIHILATION_SCAR_NAME',
        1,      -- BlastRadius：同可莉
        0,      -- FalloutDuration：没有辐射污染
        0,      -- AffectPopulation
        0,      -- AffectImprovements
        1,      -- AffectBuildings
        1,      -- AffectUnits
        0,      -- AffectResources
        0,      -- AffectRoutes
        8,      -- ICBMStrikeRange：同可莉，需实证
        0       -- Maintenance：master plan §6.1 定为 0（可莉为 8），见文件头
    );

-- ---------------------------------------------------------------------------
-- 3. 通知（Notifications）
--    类型名由 Lua 用 DB.MakeHash 取哈希。ExpiresEndOfTurn 与 AutoNotify 照官方：
--    不自动弹窗，只进右侧通知栏；READY 与 SACRIFICE 留到点掉为止。
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
        'NOTIFICATION_TSOD_ANNIHILATION_READY',
        'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_MESSAGE',
        'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_SUMMARY',
        'MID',
        0,
        0,
        0,
        0,
        1,
        1
    ),
    (
        'NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE',
        'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_MESSAGE',
        'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_SUMMARY',
        'MID',
        0,
        0,
        0,
        0,
        1,
        1
    ),
    (
        'NOTIFICATION_TSOD_ARMY_REGENERATION',
        'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_MESSAGE',
        'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_SUMMARY',
        'MID',
        1,
        0,
        0,
        0,
        1,
        1
    );

-- ---------------------------------------------------------------------------
-- 4. 能力（UnitAbilities）
--    Inactive = 1：不自动生效，由 Lua 授予。
--    ShowFloatTextWhenEarned = 0：授予时不弹官方浮字，我们自己用通知说明。
-- ---------------------------------------------------------------------------
INSERT INTO
    UnitAbilities (
        UnitAbilityType,
        Name,
        Description,
        Inactive,
        ShowFloatTextWhenEarned,
        Permanent
    )
VALUES
    (
        'ABILITY_TSOD_ANNIHILATION_SCAR',
        'LOC_ABILITY_TSOD_ANNIHILATION_SCAR_NAME',
        'LOC_ABILITY_TSOD_ANNIHILATION_SCAR_DESCRIPTION',
        1,
        0,
        1
    ),
    (
        'ABILITY_TSOD_ARMY_REGENERATION',
        'LOC_ABILITY_TSOD_ARMY_REGENERATION_NAME',
        'LOC_ABILITY_TSOD_ARMY_REGENERATION_DESCRIPTION',
        1,
        0,
        1
    );
