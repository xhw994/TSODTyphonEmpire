-- WP13 Annihilation Scar and battlefield regeneration text (InGame UpdateText: the start screen does not show the weapon or these two abilities); each tag is inserted only once, by this file.
-- The two abilities' DESCRIPTION holds only the name (same as the Battle Mage's other abilities; I1 feedback: the hover tip lists the whole sentence); the effect is written in LOC_UNIT_TSOD_BATTLE_MAGE_DESCRIPTION.

INSERT
OR REPLACE INTO LocalizedText (Language, Tag, Text)
VALUES
    -- zh_Hans_CN
    ('zh_Hans_CN', 'LOC_WMD_TSOD_ANNIHILATION_SCAR_NAME', '湮灭之创'),

    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_ANNIHILATION_SCAR_NAME', '湮灭之创'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_ANNIHILATION_SCAR_DESCRIPTION', '湮灭之创'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_ARMY_REGENERATION_NAME', '战场再生'),
    ('zh_Hans_CN', 'LOC_ABILITY_TSOD_ARMY_REGENERATION_DESCRIPTION', '战场再生'),

    -- Notifications (messages and summary)
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_MESSAGE', '战斗法师军队已能施放湮灭之创。'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_SUMMARY', '湮灭之创就绪'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_MESSAGE', '战斗法师军队施放湮灭之创，全员魔力枯竭阵亡。'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_SUMMARY', '湮灭之创已施放'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_MESSAGE', '战斗法师军团获得了战场再生，每回合恢复生命。'),
    ('zh_Hans_CN', 'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_SUMMARY', '战场再生'),

    -- Map floating text
    ('zh_Hans_CN', 'LOC_TSOD_ANNIHILATION_SCAR_EXHAUSTED', '魔力枯竭'),

    -- en_US
    ('en_US', 'LOC_WMD_TSOD_ANNIHILATION_SCAR_NAME', 'Annihilation Scar'),

    ('en_US', 'LOC_ABILITY_TSOD_ANNIHILATION_SCAR_NAME', 'Annihilation Scar'),
    ('en_US', 'LOC_ABILITY_TSOD_ANNIHILATION_SCAR_DESCRIPTION', 'Annihilation Scar'),
    ('en_US', 'LOC_ABILITY_TSOD_ARMY_REGENERATION_NAME', 'Battlefield Regeneration'),
    ('en_US', 'LOC_ABILITY_TSOD_ARMY_REGENERATION_DESCRIPTION', 'Battlefield Regeneration'),

    ('en_US', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_MESSAGE', 'A Battle Mage army can now cast Annihilation Scar.'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_SUMMARY', 'Annihilation Scar Ready'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_MESSAGE', 'A Battle Mage army cast Annihilation Scar; its mana was exhausted and every unit in it died.'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_SUMMARY', 'Annihilation Scar Cast'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_MESSAGE', 'A Battle Mage corps gained Battlefield Regeneration and now heals every turn.'),
    ('en_US', 'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_SUMMARY', 'Battlefield Regeneration'),

    ('en_US', 'LOC_TSOD_ANNIHILATION_SCAR_EXHAUSTED', 'Mana Exhausted');
