-- WP14 War God Faith icons (InGame UpdateIcons, criteria TsoDTE_Expansion2). The UI fetches the image by "ICON_" .. ReligionType.
-- Temporarily borrows official custom religion 4 (the lion); a collision happens only if the player picks that custom religion themselves.
INSERT INTO IconAliases (Name, OtherName) VALUES
    ('ICON_RELIGION_TSOD_WAR_GOD', 'ICON_RELIGION_CUSTOM_4');
