-- WP17 神权理事会（世界议会新决议）；只在风云变幻下加载（Resolutions / ResolutionEffects 是资料片新增的表）。
-- 以官方「世界宗教」WC_RES_WORLD_RELIGION 为蓝本，把它的 A 反过来（master plan §8.5）；待实证项见 test-plan §10。

-- 1. 类型登记与决议主表
-- ValidationLua 用自己的：官方 WC_Validate_RegliousBan 没有 Lua 处理函数、目标由引擎特判，
-- 照抄它时目标列表是上一个验证留下的地貌，游戏崩溃（10-22 实测）；见 Scripts/TsoDTE_Congress.lua。
INSERT INTO Types (Type, Kind) VALUES
    ('WC_RES_TSOD_THEOCRATIC_COUNCIL', 'KIND_RESOLUTION');

INSERT INTO Resolutions (
    ResolutionType, TargetKind, Name,
    Effect1Description, Effect2Description,
    ValidationLua, AITargetChooser,
    InjectionOnly, EarliestEra
) VALUES (
    'WC_RES_TSOD_THEOCRATIC_COUNCIL', 'RELIGION', 'LOC_WC_RES_TSOD_THEOCRATIC_COUNCIL_NAME',
    'LOC_WORLD_CONGRESS_TSOD_DESANCTIFY_RELIGION_DESC',
    'LOC_WORLD_CONGRESS_TSOD_SECULAR_OVERSIGHT_DESC',
    'WC_Validate_TsoDTE_TheocraticCouncil', 'ReligiousTarget',
    0, 'ERA_MODERN'
);

-- 2. 选项 1 的修正：去神圣化
-- 类型照官方 WC_RES_RELIGIOUS_UNITS_STRENGTH，但它的 Amount 是 +10、不能复用，故另起 ModifierId 写 -10。
-- 负值是否生效、目标宗教是否由投票传入：见 test-plan §10（C2、C3）。
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('TSOD_TYPHON_COUNCIL_RELIGIOUS_STRENGTH_DOWN', 'MODIFIER_MAJOR_PLAYERS_ADJUST_UNITS_RELIGIOUS_STRENGTH_BY_RELIGION_TYPE');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_COUNCIL_RELIGIOUS_STRENGTH_DOWN', 'Amount', '-10');

-- 3. 决议效果行
-- 选项 2 复用官方 ANYONE_CONDEMNS_FOR_FAVOR，不另建修正。
-- ResolutionEffectId 210、215：官方最大到 205，工坊 mod 里没有 ResolutionEffects 行（已查）。
INSERT INTO ResolutionEffects (ResolutionEffectId, ResolutionType, WhichEffect, ModifierId) VALUES
    (210, 'WC_RES_TSOD_THEOCRATIC_COUNCIL', 1, 'TSOD_TYPHON_COUNCIL_RELIGIOUS_STRENGTH_DOWN'),
    (215, 'WC_RES_TSOD_THEOCRATIC_COUNCIL', 2, 'ANYONE_CONDEMNS_FOR_FAVOR');

-- 4. AI 偏好：提丰 AI 支持本决议（选项 1）
-- Favored 只到「决议」一级、不指定选项；Favored=1 对应选项 1 是按官方 WC_RES_WORLD_RELIGION 的对照推断，未实证
-- （test-plan §10.5 C5）；若相反，删这三行不影响决议本身。
INSERT INTO AiListTypes (ListType) VALUES
    ('TSOD_TYPHON_ROSETTA_RESOLUTIONS');

INSERT INTO AiLists (ListType, LeaderType, AgendaType, System) VALUES
    ('TSOD_TYPHON_ROSETTA_RESOLUTIONS', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', NULL, 'Resolutions');

INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
    ('TSOD_TYPHON_ROSETTA_RESOLUTIONS', 'WC_RES_TSOD_THEOCRATIC_COUNCIL', 1, 0);
