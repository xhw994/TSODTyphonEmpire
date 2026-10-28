-- War God Faith (InGame, criteria TsoDTE_Expansion2): Types + Religions + moment illustration, as in Historical Religions.
-- No FavoredReligions. The pedia page is generated from Religions; its text is in Texts/TsoDTE_Text_Religion.sql.

INSERT INTO Types (Type, Kind) VALUES
    ('RELIGION_TSOD_WAR_GOD', 'KIND_RELIGION');

INSERT INTO Religions (ReligionType, Name, IconString, Pantheon, RequiresCustomName, Color) VALUES
    ('RELIGION_TSOD_WAR_GOD', 'LOC_RELIGION_TSOD_WAR_GOD', 'Wg', 0, 0, 'COLOR_RELIGION_TSOD_WAR_GOD');

-- Temporarily borrows the illustration of official custom religion 4 (the lion), matching the temporary icon.
INSERT INTO MomentIllustrations (MomentIllustrationType, MomentDataType, GameDataType, Texture) VALUES
    ('MOMENT_ILLUSTRATION_RELIGION', 'MOMENT_DATA_RELIGION', 'RELIGION_TSOD_WAR_GOD', 'PM_FoundedReligion_Custom4');
