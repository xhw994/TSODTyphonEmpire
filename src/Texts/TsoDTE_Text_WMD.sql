-- ============================================================================
-- WP13 湮灭之创与战场再生：文本
-- 动作：InGame UpdateText（不进 FrontEnd：开局界面不显示武器与这两个能力）。
-- 登记：每个 tag 只由本文件插入一次（ids.md §4）。
-- 文本规则：效果文本不用第二人称，不写介绍（介绍放百科）。描述只说效果。
-- ============================================================================

INSERT
OR REPLACE INTO LocalizedText (Language, Tag, Text)
VALUES
    -- ---------------------------------------------------------------- zh_Hans_CN
    -- 武器
    ('zh_Hans_CN', 'LOC_WMD_TSOD_ANNIHILATION_SCAR_NAME', '湮灭之创'),

    -- 能力
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_ANNIHILATION_SCAR_NAME', '湮灭之创'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_ANNIHILATION_SCAR_DESCRIPTION', '可施放一次。施放后本单位阵亡。'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_ARMY_REGENERATION_NAME', '战场再生'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_ARMY_REGENERATION_DESCRIPTION', '每回合恢复 10 点生命。移动或战斗后同样恢复。'),

    -- 通知（消息与摘要）
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_MESSAGE', '战斗法师军团已能施放湮灭之创。'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_SUMMARY', '湮灭之创就绪'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_MESSAGE', '战斗法师军团施放湮灭之创，全员魔力枯竭阵亡。'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_SUMMARY', '湮灭之创已施放'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_MESSAGE', '战斗法师军队获得了战场再生。'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_SUMMARY', '战场再生'),

    -- 地图浮字
    ('zh_Hans_CN', 'LOC_TSOD_ANNIHILATION_SCAR_EXHAUSTED', '魔力枯竭'),

    -- ---------------------------------------------------------------- en_US
    ('en_US', 'LOC_WMD_TSOD_ANNIHILATION_SCAR_NAME', 'Annihilation Scar'),

    ('en_US', 'LOC_ABILITY_TSOD_ANNIHILATION_SCAR_NAME', 'Annihilation Scar'),
    ('en_US', 'LOC_ABILITY_TSOD_ANNIHILATION_SCAR_DESCRIPTION', 'Can be cast once. The unit dies after casting.'),
    ('en_US', 'LOC_ABILITY_TSOD_ARMY_REGENERATION_NAME', 'Battlefield Regeneration'),
    ('en_US', 'LOC_ABILITY_TSOD_ARMY_REGENERATION_DESCRIPTION', 'Heals 10 HP each turn. Also applies after moving or attacking.'),

    ('en_US', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_MESSAGE', 'A Battle Mage corps can now cast Annihilation Scar.'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_SUMMARY', 'Annihilation Scar Ready'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_MESSAGE', 'A Battle Mage corps cast Annihilation Scar; its mana was exhausted and every unit in it died.'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_SUMMARY', 'Annihilation Scar Cast'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_MESSAGE', 'A Battle Mage army gained Battlefield Regeneration.'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_SUMMARY', 'Battlefield Regeneration'),

    ('en_US', 'LOC_TSOD_ANNIHILATION_SCAR_EXHAUSTED', 'Mana Exhausted');
