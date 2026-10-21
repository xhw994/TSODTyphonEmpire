-- =============================================================================
-- TsoDTE_Compat_Cecil.sql  ·  WP18 系列联动：塞西尔（只在装了塞西尔 mod 时加载）
-- 动作：InGame UpdateDatabase，独立 action，criteria TsoDTE_ModCecil
--       （ModInUse 4883e185-c2d7-4031-aae3-b67e4e885a24 + RuleSetInUse RULESET_EXPANSION_2），LoadOrder 200。
--       LoadOrder 200 使本文件排在主动作（100）之后，两位领袖的特性都已建立。
--
-- 依赖（须已存在）：
--   LEADER_TSOD_ROSETTA_AUGUSTUS、TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS    WP1 TsoDTE_Leader.sql
--   LEADER_TSOD_GAWAIN_CECIL、TRAIT_LEADER_TSOD_GAWAIN_CECIL            塞西尔 mod（src/Core/TsoDCE_Leaders.sql）
--   MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER、REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES
--                                                                      官方（议程修正的同类写法，Agendas.xml）
--
-- 内容（master plan §8.6 前两行）：罗塞塔对高文、高文对罗塞塔各一条外交态度修正。
--   挂在各自的领袖特性上（TraitModifiers，主体是拥有该特性的玩家）；
--   条件作用于 Subject（态度的对象），REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES 判断对方是哪位领袖。
--
-- 数值 InitialValue = 6：官方 MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER 的正向 InitialValue 共 85 条
--   （Base 与 DLC 的 Gameplay/Data 统计），中位数为 6，取中值，不自拟大数。需实证（test-plan §11 A1）。
--
-- 台词（master plan §8.6 第三行）：未做。官方外交台词的结构没有对方领袖这一维度：
--   DiplomacyStatements 全部 XML 里的占位符只有 $(LEADER) / $(MOOD) / $(REASON)，
--   没有对方（OTHER / TARGET 之类）；<Leader> 列全部是 ANY。所以台词只能按说话方区分，
--   「罗塞塔遇到高文」无法单独配置。按 impl plan §6.2 的退路，只保留态度说明文本。
--
-- 不做：外交惩罚（核武相关，用户定：以可莉 mod 为准）。
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. 需求：对方是高文 / 对方是罗塞塔（作用于 Subject）
-- -----------------------------------------------------------------------------
INSERT INTO Requirements (RequirementId, RequirementType) VALUES
    ('REQ_TSOD_TYPHON_CECIL_OTHER_IS_GAWAIN',  'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES'),
    ('REQ_TSOD_TYPHON_CECIL_OTHER_IS_ROSETTA', 'REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES');

INSERT INTO RequirementArguments (RequirementId, Name, Value) VALUES
    ('REQ_TSOD_TYPHON_CECIL_OTHER_IS_GAWAIN',  'LeaderType', 'LEADER_TSOD_GAWAIN_CECIL'),
    ('REQ_TSOD_TYPHON_CECIL_OTHER_IS_ROSETTA', 'LeaderType', 'LEADER_TSOD_ROSETTA_AUGUSTUS');

INSERT INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES
    ('REQSET_TSOD_TYPHON_CECIL_OTHER_IS_GAWAIN',  'REQUIREMENTSET_TEST_ALL'),
    ('REQSET_TSOD_TYPHON_CECIL_OTHER_IS_ROSETTA', 'REQUIREMENTSET_TEST_ALL');

INSERT INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES
    ('REQSET_TSOD_TYPHON_CECIL_OTHER_IS_GAWAIN',  'REQ_TSOD_TYPHON_CECIL_OTHER_IS_GAWAIN'),
    ('REQSET_TSOD_TYPHON_CECIL_OTHER_IS_ROSETTA', 'REQ_TSOD_TYPHON_CECIL_OTHER_IS_ROSETTA');

-- -----------------------------------------------------------------------------
-- 2. 态度修正：罗塞塔对高文、高文对罗塞塔（两条对称）
--    SimpleModifierDescription：外交界面「态度」条目里那一行说明（文本在 Texts/TsoDTE_Text_Compat.sql）。
--    没有 StatementKey：这两条不是议程，AI 不会因此发出赞许或警告。
-- -----------------------------------------------------------------------------
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId) VALUES
    ('TSOD_TYPHON_CECIL_ROSETTA_TO_GAWAIN', 'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER', 'REQSET_TSOD_TYPHON_CECIL_OTHER_IS_GAWAIN'),
    ('TSOD_TYPHON_CECIL_GAWAIN_TO_ROSETTA', 'MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER', 'REQSET_TSOD_TYPHON_CECIL_OTHER_IS_ROSETTA');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_CECIL_ROSETTA_TO_GAWAIN', 'InitialValue',              '6'),
    ('TSOD_TYPHON_CECIL_ROSETTA_TO_GAWAIN', 'SimpleModifierDescription', 'LOC_DIPLO_MODIFIER_TSOD_CECIL_ROSETTA_TO_GAWAIN'),
    ('TSOD_TYPHON_CECIL_GAWAIN_TO_ROSETTA', 'InitialValue',              '6'),
    ('TSOD_TYPHON_CECIL_GAWAIN_TO_ROSETTA', 'SimpleModifierDescription', 'LOC_DIPLO_MODIFIER_TSOD_CECIL_GAWAIN_TO_ROSETTA');

-- 挂载：罗塞塔的那条挂在罗塞塔的领袖特性上，高文的那条挂在高文的领袖特性上。
INSERT INTO TraitModifiers (TraitType, ModifierId) VALUES
    ('TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', 'TSOD_TYPHON_CECIL_ROSETTA_TO_GAWAIN'),
    ('TRAIT_LEADER_TSOD_GAWAIN_CECIL',     'TSOD_TYPHON_CECIL_GAWAIN_TO_ROSETTA');

INSERT INTO ModifierStrings (ModifierId, Context, Text) VALUES
    ('TSOD_TYPHON_CECIL_ROSETTA_TO_GAWAIN', 'Sample', 'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL'),
    ('TSOD_TYPHON_CECIL_GAWAIN_TO_ROSETTA', 'Sample', 'LOC_TOOLTIP_SAMPLE_DIPLOMACY_ALL');
