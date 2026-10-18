-- ============================================================================
-- TsoDTE_Colors.sql  (WP1)
-- 提丰配色（master plan §9.2）：黑底红徽，两组备用色
-- 动作：InGame UpdateColors + FrontEnd UpdateColors（照塞西尔）
-- 约定（照官方 PlayerColors.xml）：PrimaryColor = 底色，SecondaryColor = 徽记色。
-- 命名照塞西尔 TsoDCE_Colors.sql：COLOR_PLAYER_TSOD_<文明>_<用途>
-- 颜色值格式 R,G,B,A（0–255），与官方 PlayerStandardColors.xml 相同。
-- ============================================================================

INSERT INTO Colors (Type, Color)
VALUES
    -- 主色：黑底红徽
    ('COLOR_PLAYER_TSOD_TYPHON_EMPIRE_PRIMARY',        '22,20,22,255'),
    ('COLOR_PLAYER_TSOD_TYPHON_EMPIRE_SECONDARY',      '196,26,32,255'),
    -- 备用 1：红底黑徽（反色）
    ('COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT1_PRIMARY',   '164,20,28,255'),
    ('COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT1_SECONDARY', '22,20,22,255'),
    -- 备用 2：红底金徽（原文「金红色的旗帜」）
    ('COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT2_PRIMARY',   '150,18,26,255'),
    ('COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT2_SECONDARY', '228,182,78,255');

INSERT INTO PlayerColors
    (Type, Usage, PrimaryColor, SecondaryColor,
     Alt1PrimaryColor, Alt1SecondaryColor,
     Alt2PrimaryColor, Alt2SecondaryColor)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS',
     'Unique',
     'COLOR_PLAYER_TSOD_TYPHON_EMPIRE_PRIMARY',
     'COLOR_PLAYER_TSOD_TYPHON_EMPIRE_SECONDARY',
     'COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT1_PRIMARY',
     'COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT1_SECONDARY',
     'COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT2_PRIMARY',
     'COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT2_SECONDARY');
