-- WP5 法师塔（替代学院）；只在风云变幻规则集加载：Districts_XP2、PROMOTION_SPACE_ROCK，以及迭起兴衰起才有的 MODIFIER_CITY_ADJUST_SPY_BONUS。
-- 依赖 TsoDTE_Civilization.sql 先加载；先例：玛雅「天文台」、朝鲜「书院」、高卢「奥皮杜姆」。

-- 1. 类型登记
INSERT INTO Types (Type, Kind) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER',                    'KIND_DISTRICT'),
    ('TRAIT_CIVILIZATION_DISTRICT_TSOD_MAGE_TOWER', 'KIND_TRAIT');

-- 2. 特色区域特性（照天文台 / 奥皮杜姆：特性名直接用区域名，不另设说明）
INSERT INTO Traits (TraitType, Name) VALUES
    ('TRAIT_CIVILIZATION_DISTRICT_TSOD_MAGE_TOWER', 'LOC_DISTRICT_TSOD_MAGE_TOWER_NAME');

INSERT INTO CivilizationTraits (CivilizationType, TraitType) VALUES
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'TRAIT_CIVILIZATION_DISTRICT_TSOD_MAGE_TOWER');

-- 3. 区域主表
-- 学院的值照抄，造价减半为 27；ZOC / HitPoints / CityStrengthModifier 照奥皮杜姆。
-- CaptureRemovesBuildings 保持学院的 0（图书馆等建筑被占领时不消失）。
INSERT INTO Districts (
    DistrictType, Name, Description, PrereqTech,
    PlunderType, PlunderAmount, AdvisorType,
    Cost, CostProgressionModel, CostProgressionParam1, Maintenance,
    RequiresPlacement, RequiresPopulation, Aqueduct, NoAdjacentCity, InternalOnly,
    ZOC, HitPoints, CaptureRemovesBuildings, CaptureRemovesCityDefenses,
    MilitaryDomain, CityStrengthModifier, TraitType
) VALUES (
    'DISTRICT_TSOD_MAGE_TOWER', 'LOC_DISTRICT_TSOD_MAGE_TOWER_NAME', 'LOC_DISTRICT_TSOD_MAGE_TOWER_DESCRIPTION', 'TECH_WRITING',
    'PLUNDER_SCIENCE', 25, 'ADVISOR_TECHNOLOGY',
    27, 'COST_PROGRESSION_NUM_UNDER_AVG_PLUS_TECH', 40, 1,
    1, 1, 0, 0, 0,
    1, 100, 0, 0,
    'NO_DOMAIN', 2, 'TRAIT_CIVILIZATION_DISTRICT_TSOD_MAGE_TOWER'
);

INSERT INTO DistrictReplaces (CivUniqueDistrictType, ReplacesDistrictType) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'DISTRICT_CAMPUS');

-- 风云变幻：能远程攻击的区域都要给射程（先例：城市中心、军营、奥皮杜姆在 Districts_XP2 里都是 AttackRange=2）。
INSERT INTO Districts_XP2 (DistrictType, AttackRange) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 2);

-- 4. 学院的附属行（照天文台先例，数值与学院相同）
INSERT INTO District_GreatPersonPoints (DistrictType, GreatPersonClassType, PointsPerTurn) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'GREAT_PERSON_CLASS_SCIENTIST', 1);

INSERT INTO District_CitizenYieldChanges (DistrictType, YieldType, YieldChange) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'YIELD_SCIENCE', 2);

INSERT INTO District_TradeRouteYields (DistrictType, YieldType, YieldChangeAsOrigin, YieldChangeAsDomesticDestination, YieldChangeAsInternationalDestination) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'YIELD_FOOD',    0, 1, 0),
    ('DISTRICT_TSOD_MAGE_TOWER', 'YIELD_SCIENCE', 0, 0, 1);

-- 5. 相邻加成
-- 5a. 保留学院的全部相邻加成：加载时从学院现有的行复制，不逐条写死——
--     学院的相邻加成随规则集 / DLC / 游戏模式而变（明细与预期行数见 docs/notes.md）。
INSERT INTO District_Adjacencies (DistrictType, YieldChangeId)
SELECT 'DISTRICT_TSOD_MAGE_TOWER', YieldChangeId
FROM District_Adjacencies
WHERE DistrictType = 'DISTRICT_CAMPUS';

-- 5b. 新增：每个相邻的军营区域 +2 科技（「大量相邻加成」的标准值；写法照 Government_Science）
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) VALUES
    ('TSOD_TYPHON_MAGE_TOWER_ENCAMPMENT_SCIENCE', 'LOC_DISTRICT_TSOD_MAGE_TOWER_ENCAMPMENT_SCIENCE', 'YIELD_SCIENCE', 2, 1, 'DISTRICT_ENCAMPMENT');

INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'TSOD_TYPHON_MAGE_TOWER_ENCAMPMENT_SCIENCE');

-- 6. 反间谍：敌方间谍在本城的行动等级 -1
-- 数值照领事馆（Amount=1），但它的 MODIFIER_PLAYER_CITIES_ADJUST_SPY_BONUS 只在埃塞俄比亚包里定义，
-- 故改用资料片自带的 MODIFIER_CITY_ADJUST_SPY_BONUS；挂在 DistrictModifiers 上时 OWNER 解析为区域所在城市。
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('TSOD_TYPHON_MAGE_TOWER_SPY_DEFENSE', 'MODIFIER_CITY_ADJUST_SPY_BONUS');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_MAGE_TOWER_SPY_DEFENSE', 'Amount', '1');

INSERT INTO DistrictModifiers (DistrictType, ModifierId) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'TSOD_TYPHON_MAGE_TOWER_SPY_DEFENSE');

-- 7. 风云变幻：摇滚乐队「太空摇滚」晋升对学院的加成也给法师塔
-- 书院、天文台各自补了 ROCKBAND_SPACE_ROCK_<区域> 与 _MODIFIER 两条，数值同学院版。
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER',          'MODIFIER_PLAYER_UNIT_ADJUST_ROCK_BAND_LEVEL_DISTRICT'),
    ('TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER_MODIFIER', 'MODIFIER_PLAYER_UNIT_ADJUST_TOURISM_BOMB_DISTRICT');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER',          'DistrictType', 'DISTRICT_TSOD_MAGE_TOWER'),
    ('TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER',          'Amount',       '1'),
    ('TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER_MODIFIER', 'DistrictType', 'DISTRICT_TSOD_MAGE_TOWER'),
    ('TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER_MODIFIER', 'Amount',       '500');

INSERT INTO UnitPromotionModifiers (UnitPromotionType, ModifierId) VALUES
    ('PROMOTION_SPACE_ROCK', 'TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER'),
    ('PROMOTION_SPACE_ROCK', 'TSOD_TYPHON_ROCKBAND_SPACE_ROCK_MAGE_TOWER_MODIFIER');

-- 学院的其余引用（建筑前置区域、伟人、项目、政策……）有意交给 DistrictReplaces 处理，清单见 docs/notes.md。
