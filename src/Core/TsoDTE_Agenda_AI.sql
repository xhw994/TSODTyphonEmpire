-- =============================================================================
-- TsoDTE_Agenda_AI.sql  (WP7 议程与 AI)
-- 动作：InGame UpdateDatabase，排在 IG UpdateDatabase 的最后（ids.md §5.2 第 8 位），
--       依赖 WP1 的 LEADER_TSOD_ROSETTA_AUGUSTUS / TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS
--       以及 WP4/WP5/WP6 的特色单位、区域、建筑 ID（AI 表无外键，仅作引用）。
-- 本文件只写本包独占的行（ids.md §5.5）：议程本体、议程特性、议程修正、AI 偏好。
-- 不写 LeaderTraits / Leaders / 单位 TypeTags，那些属于别的包。
-- =============================================================================


-- -----------------------------------------------------------------------------
-- 1. 议程「同类」本体
--    结构沿用塞西尔「真理探求」与官方历史议程（Leaders.xml / Agendas.xml）。
--    Agendas 不进 Types（官方也不登记）；议程特性要进 Types + Traits。
-- -----------------------------------------------------------------------------

INSERT INTO Types (Type, Kind)
VALUES
    ('TRAIT_AGENDA_TSOD_KINDRED', 'KIND_TRAIT');

-- 官方议程特性的 Traits 行都不带 Name / Description（如 TRAIT_AGENDA_PREFER_STANDING_ARMY）
INSERT INTO Traits (TraitType, Name, Description)
VALUES
    ('TRAIT_AGENDA_TSOD_KINDRED', NULL, NULL);

INSERT INTO Agendas (AgendaType, Name, Description)
VALUES
    ('AGENDA_TSOD_KINDRED', 'LOC_AGENDA_TSOD_KINDRED_NAME', 'LOC_AGENDA_TSOD_KINDRED_DESCRIPTION');

-- 军力部分与隐藏议程「常备军」重复，照高卢安比奥里克斯（AGENDA_AMBIORIX_ARMY）、
-- 克里奥帕特拉（AGENDA_QUEEN_OF_NILE）的先例互斥，免得随机抽到再叠一层。
INSERT INTO ExclusiveAgendas (AgendaOne, AgendaTwo)
VALUES
    ('AGENDA_TSOD_KINDRED', 'AGENDA_STANDING_ARMY');

INSERT INTO HistoricalAgendas (LeaderType, AgendaType)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS', 'AGENDA_TSOD_KINDRED');

INSERT INTO AgendaTraits (AgendaType, TraitType)
VALUES
    ('AGENDA_TSOD_KINDRED', 'TRAIT_AGENDA_TSOD_KINDRED');


-- -----------------------------------------------------------------------------
-- 2. 议程修正
--    两条都是 MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER
--    （COLLECTION_MAJOR_PLAYERS + EFFECT_DIPLOMACY_SIMPLE_EFFECT），
--    主体条件决定「对哪个文明」生效。
--
--    a) 喜欢：陆军实力不弱于她的文明
--       照官方隐藏议程「常备军」AGENDA_HIGH_STANDING_ARMY：
--       REQUIREMENT_PLAYER_MILITARY_STRENGTH_LEAD，MinimumDelta 5、DomainType DOMAIN_LAND
--       照抄；StrengthRatio 由官方的 1.2（明显更强）降到 1.0（不弱于），
--       对应 master plan §8.1「军力不弱于自己」。
--       官方常备军是隐藏议程，带 HiddenAgenda=true；本议程公开，不带。
--       态度 +8：官方公开议程的正向值多在 7～12（如 AGENDA_MODIFIER_SAME_RELIGION 8）。
--
--    b) 厌恶：向她的城市传播宗教的文明
--       照刚果姆本巴 AGENDA_MODIFIER_RELIGION_RECEIVED（+12）把方向反过来，取 -12；
--       官方萨拉丁（苏丹）AGENDA_SULTAN_RELIGION_RECEIVED 正是同一条件、-12 的先例。
-- -----------------------------------------------------------------------------

INSERT INTO TraitModifiers (TraitType, ModifierId)
VALUES
    ('TRAIT_AGENDA_TSOD_KINDRED', 'TSOD_TYPHON_AGENDA_KINDRED_STRONG_MILITARY'),
    ('TRAIT_AGENDA_TSOD_KINDRED', 'TSOD_TYPHON_AGENDA_KINDRED_RELIGION_RECEIVED');

INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
    ('TSOD_TYPHON_AGENDA_KINDRED_STRONG_MILITARY', 'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER', 'REQSET_TSOD_TYPHON_KINDRED_STRONG_MILITARY'),
    ('TSOD_TYPHON_AGENDA_KINDRED_RELIGION_RECEIVED', 'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER', 'REQSET_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED');

-- StatementKey：AI 发出赞许 / 警告时附带的理由句。
--   用官方「按议程命名」的格式（KUDO / WARNING + LEADER_ANY_REASON_AGENDA + 议程名，
--   同 AGENDA_HIGH_STANDING_ARMY），因为两条修正理由不同，按议程分开写；
--   tag 不含 ROSETTA_AUGUSTUS，不落进 WP8 的外交台词命名空间。
-- SimpleModifierDescription：外交界面「态度」条目里的那一行说明。
INSERT INTO ModifierArguments (ModifierId, Name, Value)
VALUES
    ('TSOD_TYPHON_AGENDA_KINDRED_STRONG_MILITARY', 'InitialValue', '8'),
    ('TSOD_TYPHON_AGENDA_KINDRED_STRONG_MILITARY', 'StatementKey', 'LOC_DIPLO_KUDO_LEADER_ANY_REASON_AGENDA_TSOD_KINDRED'),
    ('TSOD_TYPHON_AGENDA_KINDRED_STRONG_MILITARY', 'SimpleModifierDescription', 'LOC_DIPLO_MODIFIER_TSOD_KINDRED_STRONG_MILITARY'),
    ('TSOD_TYPHON_AGENDA_KINDRED_RELIGION_RECEIVED', 'InitialValue', '-12'),
    ('TSOD_TYPHON_AGENDA_KINDRED_RELIGION_RECEIVED', 'StatementKey', 'LOC_DIPLO_WARNING_LEADER_ANY_REASON_AGENDA_TSOD_KINDRED'),
    ('TSOD_TYPHON_AGENDA_KINDRED_RELIGION_RECEIVED', 'SimpleModifierDescription', 'LOC_DIPLO_MODIFIER_TSOD_KINDRED_RELIGION_RECEIVED');

INSERT INTO ModifierStrings (ModifierId, Context, Text)
VALUES
    ('TSOD_TYPHON_AGENDA_KINDRED_STRONG_MILITARY', 'Sample', 'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL'),
    ('TSOD_TYPHON_AGENDA_KINDRED_RELIGION_RECEIVED', 'Sample', 'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL');


-- -----------------------------------------------------------------------------
-- 3. 需求与需求组
--    REQUIRES_MAJOR_CIV_OPPONENT（Base Leaders.xml）、REQUIRES_MET_30_TURNS_AGO /
--    REQUIRES_MET_10_TURNS_AGO（Base Agendas.xml）直接复用官方行，不重复定义。
--    常备军用「相识 30 回合」，姆本巴用「相识 10 回合」，各照各的先例。
-- -----------------------------------------------------------------------------

INSERT INTO Requirements (RequirementId, RequirementType)
VALUES
    ('REQ_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'REQUIREMENT_PLAYER_MILITARY_STRENGTH_LEAD'),
    ('REQ_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED', 'REQUIREMENT_PLAYER_RELIGION_RECEIVED');

INSERT INTO RequirementArguments (RequirementId, Name, Value)
VALUES
    ('REQ_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'MinimumDelta', '5'),
    ('REQ_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'StrengthRatio', '1.0'),
    ('REQ_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'DomainType', 'DOMAIN_LAND');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType)
VALUES
    ('REQSET_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId)
VALUES
    ('REQSET_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'REQUIRES_MAJOR_CIV_OPPONENT'),
    ('REQSET_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'REQUIRES_MET_30_TURNS_AGO'),
    ('REQSET_TSOD_TYPHON_KINDRED_STRONG_MILITARY', 'REQ_TSOD_TYPHON_KINDRED_STRONG_MILITARY'),
    ('REQSET_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED', 'REQUIRES_MAJOR_CIV_OPPONENT'),
    ('REQSET_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED', 'REQUIRES_MET_10_TURNS_AGO'),
    ('REQSET_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED', 'REQ_TSOD_TYPHON_KINDRED_RELIGION_RECEIVED');


-- -----------------------------------------------------------------------------
-- 4. AI 偏好
--    AiLists.LeaderType 填的是 Trait（官方 322 处无一填 LEADER_*）。
--    领袖性格类清单挂在领袖特性 TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS 上
--    （官方先例：AlexanderPreferWar → TRAIT_LEADER_TO_WORLDS_END、
--     CleopatraDistricts → TRAIT_LEADER_MEDITERRANEAN、VictoriaUnits → TRAIT_LEADER_PAX_BRITANNICA）；
--    议程自身的行为清单挂在议程特性上，走 AgendaType 列
--    （官方先例：StandingArmyPseudoYields → TRAIT_AGENDA_PREFER_STANDING_ARMY）。
--
--    宗教倾向「中等」= 不挂官方的 ForbidReligiousVictory / LowReligiousPreferenceYields
--    （低），也不挂 FavorReligiousVictory（高），只偏好圣地；见报告。
-- -----------------------------------------------------------------------------

INSERT INTO AiListTypes (ListType)
VALUES
    ('TSOD_TYPHON_ROSETTA_VICTORIES'),
    ('TSOD_TYPHON_ROSETTA_DISTRICTS'),
    ('TSOD_TYPHON_ROSETTA_BUILDINGS'),
    ('TSOD_TYPHON_ROSETTA_UNITS'),
    ('TSOD_TYPHON_KINDRED_PSEUDOYIELDS');

INSERT INTO AiLists (ListType, LeaderType, AgendaType, System)
VALUES
    ('TSOD_TYPHON_ROSETTA_VICTORIES', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', NULL, 'Strategies'),
    ('TSOD_TYPHON_ROSETTA_DISTRICTS', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', NULL, 'Districts'),
    ('TSOD_TYPHON_ROSETTA_BUILDINGS', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', NULL, 'Buildings'),
    ('TSOD_TYPHON_ROSETTA_UNITS', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', NULL, 'Units'),
    ('TSOD_TYPHON_KINDRED_PSEUDOYIELDS', NULL, 'TRAIT_AGENDA_TSOD_KINDRED', 'PseudoYields');

INSERT INTO AiFavoredItems (ListType, Item, Favored, Value)
VALUES
    -- 胜利倾向：Strategies 的 Value 越小越偏好。
    --   征服 -2 照亚历山大 AlexanderPreferWar；科技 -1 照官方 FavorScienceVictory。
    ('TSOD_TYPHON_ROSETTA_VICTORIES', 'VICTORY_STRATEGY_MILITARY_VICTORY', 1, -2),
    ('TSOD_TYPHON_ROSETTA_VICTORIES', 'VICTORY_STRATEGY_SCIENCE_VICTORY', 1, -1),

    -- 区域：学院、军营、圣地 + 特色区域法师塔（替代学院）。
    --   官方区域清单只用 Favored=true；学院与法师塔都列上，
    --   不论 AI 按被替代的类型还是按特色类型打分都能命中。
    ('TSOD_TYPHON_ROSETTA_DISTRICTS', 'DISTRICT_CAMPUS', 1, 0),
    ('TSOD_TYPHON_ROSETTA_DISTRICTS', 'DISTRICT_ENCAMPMENT', 1, 0),
    ('TSOD_TYPHON_ROSETTA_DISTRICTS', 'DISTRICT_HOLY_SITE', 1, 0),
    ('TSOD_TYPHON_ROSETTA_DISTRICTS', 'DISTRICT_TSOD_MAGE_TOWER', 1, 0),

    -- 建筑：燃石酸化工厂（替代工厂）。
    ('TSOD_TYPHON_ROSETTA_BUILDINGS', 'BUILDING_TSOD_BURNSTONE_WORKS', 1, 0),

    -- 单位：Units 清单用 Value 调造兵优先级（官方 VictoriaUnits 军事工程师 +1；
    --   工坊 Sukritact 对特色单位用 Favored=1, Value=1）。
    ('TSOD_TYPHON_ROSETTA_UNITS', 'UNIT_TSOD_BATTLE_MAGE', 1, 1),

    -- 议程自身：照官方 StandingArmyPseudoYields 原值，让她自己也维持大规模常备军，
    --   与「同类」议程看重军力一致（已与 AGENDA_STANDING_ARMY 互斥，不会叠加）。
    ('TSOD_TYPHON_KINDRED_PSEUDOYIELDS', 'PSEUDOYIELD_STANDING_ARMY_NUMBER', 1, 33),
    ('TSOD_TYPHON_KINDRED_PSEUDOYIELDS', 'PSEUDOYIELD_STANDING_ARMY_VALUE', 1, 50);
