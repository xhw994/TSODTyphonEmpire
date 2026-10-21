-- ============================================================================
-- TsoDTE_Congress.sql  ·  WP17 神权理事会（世界议会的新决议）
-- 动作：InGame UpdateDatabase（criteria TsoDTE_Expansion2），登记在 TsoDTE_Project.sql 之后。
-- 只在 RuleSetInUse RULESET_EXPANSION_2 下加载：Resolutions、ResolutionEffects 是风云变幻新增的表。
--
-- 依赖（须先加载或已存在）：
--   TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS   WP1 TsoDTE_Leader.sql（AI 清单绑定用）
--   ANYONE_CONDEMNS_FOR_FAVOR            官方 Expansion2_Congress.xml 的 Modifiers 行（Amount 25）
--   MODIFIER_MAJOR_PLAYERS_ADJUST_UNITS_RELIGIOUS_STRENGTH_BY_RELIGION_TYPE
--                                        官方 Expansion2_Modifiers.xml（DynamicModifiers 行，
--                                        COLLECTION_MAJOR_PLAYERS + EFFECT_ADJUST_UNITS_RELIGIOUS_STRENGTH_BY_RELIGION_TYPE）
--   校验函数名 WC_Validate_RegliousBan、AI 选目标 ReligiousTarget：拼写照官方（Reglious 是官方的拼写），
--      两者在安装目录的 Lua 里都没有定义，由引擎处理；目标列表是否正确见 test-plan §10.3 V1。
--
-- 设计（master plan §8.5）：以官方「世界宗教」WC_RES_WORLD_RELIGION 为蓝本，把它的 A 反过来。
--   选项 1（WhichEffect=1）去神圣化：所选宗教的所有单位 -10 战斗力（普通及宗教战斗力）。
--   选项 2（WhichEffect=2）世俗监督：同官方 B，所有文明可谴责所选宗教的单位，每次获得 25 外交支持。
--   时代：EarliestEra=ERA_MODERN，与「世界宗教」（LatestEra=ERA_INDUSTRIAL）首尾衔接。
--   TargetKind=RELIGION：目标是一个宗教，由投票选出。
--   效果文本在 Texts/TsoDTE_Text_Congress.sql；决议与效果都不挂外交惩罚（用户定：以可莉 mod 为准）。
--
-- 为什么选项 1 要自己的 ModifierId：官方 WC_RES_RELIGIOUS_UNITS_STRENGTH 的 Amount 是 +10，不能复用。
--   用同一个 ModifierType 另起一个 ModifierId，Amount 写 -10（见第 2 段）。
--
-- 没有工坊先例（gamefiles_grep --scope workshop 查 ResolutionEffectId 无匹配），以下全部需实证，
-- 测试与退路见 docs/test-plan-I1.md §10：
--   C1 新决议能否进入议程池（Scripts/WorldCongress.lua 的 CanUseResolutions 对未列出的决议直接放行，
--      静态上没有拦截，但池子怎么抽由引擎决定）；
--   C2 Amount = -10 是否真的减少战斗力（方向与数值）；
--   C3 选项 1 的目标宗教是否由投票结果传入。官方同类修正的 ModifierArguments 只有 Amount，
--      没有宗教参数，只能推断由引擎注入；
--   C4 现代时代后世界议会能否抽到本决议；
--   C5 AI 偏好（第 4 段）是否使提丰投选项 1。Favored 只表达「支持该决议」，选哪一边由引擎决定，
--      本文件按官方同类决议的 Favored 与选项序号的对应推断，未实证。
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. 类型登记与决议主表
--    InjectionOnly 照官方（缺省 0，即允许议会自己抽到）。
--    ValidationLua、AITargetChooser 照官方「世界宗教」复用。
--    LatestEra 不设，照官方 WC_RES_DIPLOVICTORY 等现代决议的写法（只设 EarliestEra）。
-- ----------------------------------------------------------------------------
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
    'WC_Validate_RegliousBan', 'ReligiousTarget',
    0, 'ERA_MODERN'
);

-- ----------------------------------------------------------------------------
-- 2. 选项 1 的修正：去神圣化
--    类型照官方 WC_RES_RELIGIOUS_UNITS_STRENGTH（MODIFIER_MAJOR_PLAYERS_ADJUST_UNITS_RELIGIOUS_STRENGTH_BY_RELIGION_TYPE），
--    官方那个 ModifierId 的 Amount 是 +10，这里另起 ModifierId，Amount 为 -10。
--    负值是否生效、目标宗教是否由投票传入：见 test-plan §10（C2、C3）。
--    退路（impl plan §6.2）：若负值不生效，换成正面效果，或不做这个决议。
-- ----------------------------------------------------------------------------
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('TSOD_TYPHON_COUNCIL_RELIGIOUS_STRENGTH_DOWN', 'MODIFIER_MAJOR_PLAYERS_ADJUST_UNITS_RELIGIOUS_STRENGTH_BY_RELIGION_TYPE');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_COUNCIL_RELIGIOUS_STRENGTH_DOWN', 'Amount', '-10');

-- ----------------------------------------------------------------------------
-- 3. 决议效果行
--    选项 2 直接复用官方的 ANYONE_CONDEMNS_FOR_FAVOR（照官方 WC_RES_WORLD_RELIGION 的写法，不另建修正）。
--    ResolutionEffectId 210、215：官方最大到 205，工坊 mod 里没有 ResolutionEffects 行（已查）。
-- ----------------------------------------------------------------------------
INSERT INTO ResolutionEffects (ResolutionEffectId, ResolutionType, WhichEffect, ModifierId) VALUES
    (210, 'WC_RES_TSOD_THEOCRATIC_COUNCIL', 1, 'TSOD_TYPHON_COUNCIL_RELIGIOUS_STRENGTH_DOWN'),
    (215, 'WC_RES_TSOD_THEOCRATIC_COUNCIL', 2, 'ANYONE_CONDEMNS_FOR_FAVOR');

-- ----------------------------------------------------------------------------
-- 4. AI 偏好：提丰 AI 支持本决议（选项 1，见文件头 C5）
--    结构照 TsoDTE_Agenda_AI.sql 的 TSOD_TYPHON_ROSETTA_* 清单：
--    AiLists.LeaderType 填 TRAIT_LEADER_*（官方 322 处无一填 LEADER_*），System 填 Resolutions。
--    官方对 WC_RES_WORLD_RELIGION 的 Favored（Expansion2_AI.xml）：DevoutResolutions、
--      EnthusiasticDiscipleResolutions、SaintResolutions、ZealotResolutions、DharmaResolutions 为 true；
--      IntolerantResolutions、AyyubidDynastyResolutions、CounterReformerResolutions 为 false。
--    Favored 表只到「决议」一级，不指定选项。上面的 Favored=1 对应选项 1，是按官方这个对照推断的，未实证。
--    若实测相反，删这三行（退路见 test-plan §10.6），不影响决议本身。
-- ----------------------------------------------------------------------------
INSERT INTO AiListTypes (ListType) VALUES
    ('TSOD_TYPHON_ROSETTA_RESOLUTIONS');

INSERT INTO AiLists (ListType, LeaderType, AgendaType, System) VALUES
    ('TSOD_TYPHON_ROSETTA_RESOLUTIONS', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', NULL, 'Resolutions');

INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
    ('TSOD_TYPHON_ROSETTA_RESOLUTIONS', 'WC_RES_TSOD_THEOCRATIC_COUNCIL', 1, 0);
