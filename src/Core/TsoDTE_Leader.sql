-- WP1 罗塞塔·奥古斯都（男性皇帝）：领袖本体、文明-领袖关联、领袖能力的壳（修正由 WP3 挂）、载入画面与外交背景。
-- 同动作内排第 2，在 TsoDTE_Civilization.sql 之后。

-- 1. Types
INSERT INTO Types (Type, Kind)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS',       'KIND_LEADER'),
    ('TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', 'KIND_TRAIT');

-- 2. 领袖：男性（原作「罗塞塔大帝」「父皇」）
--    InheritFrom LEADER_DEFAULT：继承 TRAIT_LEADER_MAJOR_CIV 等默认行为（官方写法）
INSERT INTO Leaders (LeaderType, Name, InheritFrom, Sex)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LOC_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME',
     'LEADER_DEFAULT',
     'Male');

-- 3. 文明-领袖关联，首都奥尔德南
INSERT INTO CivilizationLeaders (CivilizationType, LeaderType, CapitalName)
VALUES
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE',
     'LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LOC_CITY_NAME_TSOD_ORDENAN');

-- 4. 领袖能力「凡人的韧性」的壳（修正由 WP3 挂）
INSERT INTO Traits (TraitType, Name, Description)
VALUES
    ('TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME',
     'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_DESCRIPTION');

INSERT INTO LeaderTraits (LeaderType, TraitType)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS');

-- 5. 引言：照官方写法引用百科领袖页的引言 tag（文本归 WP8）
INSERT INTO LeaderQuotes (LeaderType, Quote)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_QUOTE');

-- 6. 载入画面（美术名照塞西尔模式）
-- PlayDawnOfManAudio = 0：没有专属旁白音频，不触发官方旁白（需实证）
INSERT INTO LoadingInfo
    (LeaderType, ForegroundImage, BackgroundImage, PlayDawnOfManAudio, LeaderText)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LEADER_TSOD_ROSETTA_AUGUSTUS_LOADING_FOREGROUND',
     'LEADER_TSOD_ROSETTA_AUGUSTUS_LOADING_BACKGROUND',
     0,
     'LOC_LOADING_INFO_LEADER_TSOD_ROSETTA_AUGUSTUS');

-- 7. 外交界面背景
INSERT INTO DiplomacyInfo (Type, BackgroundImage)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS',
     'LEADER_TSOD_ROSETTA_AUGUSTUS_DIPLOMACY_BACKGROUND');

-- 8. 黑暗时代探测：Gameplay Lua 读不到 GameEras:HasDarkAge（只在 UI 环境，实机证实），
-- 故用修正把它写成玩家属性 TSOD_TYPHON_DARK_AGE，由 TsoDTE_LeaderTrait.lua 读取。
-- 需求失效后属性是否回到 0 待实证（Lua 只认 > 0）；挂在领袖特性上，读旧存档不会补挂。
INSERT INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES
    ('TSOD_TYPHON_DARK_AGE_PROBE', 'MODIFIER_PLAYER_ADJUST_PROPERTY', 'PLAYER_HAS_DARK_AGE');

INSERT INTO ModifierArguments (ModifierId, Name, Value)
VALUES
    ('TSOD_TYPHON_DARK_AGE_PROBE', 'Key',    'TSOD_TYPHON_DARK_AGE'),
    ('TSOD_TYPHON_DARK_AGE_PROBE', 'Amount', '1');

INSERT INTO TraitModifiers (TraitType, ModifierId)
VALUES
    ('TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', 'TSOD_TYPHON_DARK_AGE_PROBE');
