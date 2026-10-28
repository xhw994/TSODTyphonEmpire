-- War God Faith icons (InGame UpdateIcons), written by tools/make_religion_art.py --icons.
-- The UI looks up "ICON_" .. ReligionType; sizes follow the official religion atlases 22 / 50 / 100 / 270.
INSERT INTO IconTextureAtlases (Name, IconSize, IconsPerRow, IconsPerColumn, Filename) VALUES
    ('ICON_ATLAS_TSOD_TYPHON_RELIGION', 22, 1, 1, 'ICON_RELIGION_TSOD_WAR_GOD_22'),
    ('ICON_ATLAS_TSOD_TYPHON_RELIGION', 50, 1, 1, 'ICON_RELIGION_TSOD_WAR_GOD_50'),
    ('ICON_ATLAS_TSOD_TYPHON_RELIGION', 100, 1, 1, 'ICON_RELIGION_TSOD_WAR_GOD_100'),
    ('ICON_ATLAS_TSOD_TYPHON_RELIGION', 270, 1, 1, 'ICON_RELIGION_TSOD_WAR_GOD_270');

INSERT INTO IconDefinitions (Name, Atlas, "Index") VALUES
    ('ICON_RELIGION_TSOD_WAR_GOD', 'ICON_ATLAS_TSOD_TYPHON_RELIGION', 0);
