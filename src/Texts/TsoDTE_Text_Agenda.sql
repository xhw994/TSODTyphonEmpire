-- WP7 议程文本：议程名与说明、态度条目说明（SimpleModifierDescription）、赞许 / 警告理由句（StatementKey）。
-- 罗塞塔本人的外交台词（tag 带 TSOD_ROSETTA_AUGUSTUS 的那批）归 WP8，不在这里。

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text)
VALUES
    -- 议程本体
    ('zh_Hans_CN', 'LOC_AGENDA_TSOD_KINDRED_NAME', '同类'),
    ('zh_Hans_CN', 'LOC_AGENDA_TSOD_KINDRED_DESCRIPTION', '一直设法维持强大的陆军。喜欢陆军实力不弱于他的文明。讨厌把宗教传进他的城市的文明。'),

    -- 态度条目说明
    ('zh_Hans_CN', 'LOC_DIPLO_MODIFIER_TSOD_KINDRED_STRONG_MILITARY', '你的陆军不弱于他的，罗塞塔·奥古斯都视你为同类'),
    ('zh_Hans_CN', 'LOC_DIPLO_MODIFIER_TSOD_KINDRED_RELIGION_RECEIVED', '你把宗教传进了他的城市，罗塞塔·奥古斯都对此十分厌恶'),

    -- 赞许 / 警告的理由句（照姆本巴的括注格式）
    ('zh_Hans_CN', 'LOC_DIPLO_KUDO_LEADER_ANY_REASON_AGENDA_TSOD_KINDRED', '（您的陆军实力不弱于提丰）'),
    ('zh_Hans_CN', 'LOC_DIPLO_WARNING_LEADER_ANY_REASON_AGENDA_TSOD_KINDRED', '（您把宗教传进了提丰的城市）'),

    -- Agenda
    ('en_US', 'LOC_AGENDA_TSOD_KINDRED_NAME', 'Kindred'),
    ('en_US', 'LOC_AGENDA_TSOD_KINDRED_DESCRIPTION', 'Always tries to keep a strong army. Likes civilizations whose land forces are no weaker than his. Dislikes civilizations that bring their Religion to his cities.'),

    -- Attitude modifiers
    ('en_US', 'LOC_DIPLO_MODIFIER_TSOD_KINDRED_STRONG_MILITARY', 'Rosetta Augustus sees his own kind in you, for your army is no weaker than his'),
    ('en_US', 'LOC_DIPLO_MODIFIER_TSOD_KINDRED_RELIGION_RECEIVED', 'Rosetta Augustus resents you bringing your religion into his cities'),

    -- Kudo / warning reasons
    ('en_US', 'LOC_DIPLO_KUDO_LEADER_ANY_REASON_AGENDA_TSOD_KINDRED', '(Your land forces are no weaker than Typhon''s)'),
    ('en_US', 'LOC_DIPLO_WARNING_LEADER_ANY_REASON_AGENDA_TSOD_KINDRED', '(You have brought your Religion into Typhon''s cities)');
