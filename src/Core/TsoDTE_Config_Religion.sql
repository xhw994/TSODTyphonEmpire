-- WP14 开局选项「启用战神教」（FrontEnd UpdateDatabase）。
-- InGame 宗教动作的 criteria TsoDTE_WarGodReligion 读 Game / TSOD_TYPHON_WAR_GOD_RELIGION = 1。

INSERT INTO Parameters
    (Key1, Key2, ParameterId, Name, Description, Domain, DefaultValue,
     ConfigurationGroup, ConfigurationId, GroupId, SortIndex)
VALUES
    ('Ruleset', 'RULESET_EXPANSION_2', 'TsodTyphonWarGodReligion',
     'LOC_TSOD_TYPHON_WAR_GOD_RELIGION_OPTION_NAME',
     'LOC_TSOD_TYPHON_WAR_GOD_RELIGION_OPTION_DESCRIPTION',
     'bool', 1, 'Game', 'TSOD_TYPHON_WAR_GOD_RELIGION', 'AdvancedOptions', 2050);
