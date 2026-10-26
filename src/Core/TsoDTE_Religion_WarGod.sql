-- WP14 战神教（InGame，criteria TsoDTE_WarGodReligion）。照 Historical Religions：Types + Religions + 时刻插图，不挂 FavoredReligions。
-- 百科页由官方查询按 Religions 自动生成，正文在 Texts/TsoDTE_Text_Religion.sql。

INSERT INTO Types (Type, Kind) VALUES
    ('RELIGION_TSOD_WAR_GOD', 'KIND_RELIGION');

INSERT INTO Religions (ReligionType, Name, IconString, Pantheon, RequiresCustomName, Color) VALUES
    ('RELIGION_TSOD_WAR_GOD', 'LOC_RELIGION_TSOD_WAR_GOD', 'Wg', 0, 0, 'COLOR_RELIGION_TSOD_WAR_GOD');

-- 临时借官方自定义宗教 4 的插图（狮子），与临时图标一致。
INSERT INTO MomentIllustrations (MomentIllustrationType, MomentDataType, GameDataType, Texture) VALUES
    ('MOMENT_ILLUSTRATION_RELIGION', 'MOMENT_DATA_RELIGION', 'RELIGION_TSOD_WAR_GOD', 'PM_FoundedReligion_Custom4');
