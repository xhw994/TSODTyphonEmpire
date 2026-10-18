-- =============================================================================
-- TsoDTE_District_MageTower.sql  ·  WP5 法师塔（替代学院）
-- 动作：InGame UpdateDatabase（criteria TsoDTE_Expansion2）
--   本文件用到风云变幻才有的表 / 行：Districts_XP2、PROMOTION_SPACE_ROCK，
--   以及迭起兴衰起才有的 MODIFIER_CITY_ADJUST_SPY_BONUS，不能在原版规则集下加载。
-- 依赖：CIVILIZATION_TSOD_TYPHON_EMPIRE（WP1 的 TsoDTE_Civilization.sql，须先加载）
-- 先例：玛雅「天文台」、朝鲜「书院」（替代学院）；高卢「奥皮杜姆」（区域城防与远程攻击）
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. 类型登记
-- -----------------------------------------------------------------------------
INSERT INTO Types (Type, Kind) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER',                    'KIND_DISTRICT'),
    ('TRAIT_CIVILIZATION_DISTRICT_TSOD_MAGE_TOWER', 'KIND_TRAIT');

-- -----------------------------------------------------------------------------
-- 2. 特色区域特性（照天文台 / 奥皮杜姆：特性名直接用区域名，不另设说明）
-- -----------------------------------------------------------------------------
INSERT INTO Traits (TraitType, Name) VALUES
    ('TRAIT_CIVILIZATION_DISTRICT_TSOD_MAGE_TOWER', 'LOC_DISTRICT_TSOD_MAGE_TOWER_NAME');

INSERT INTO CivilizationTraits (CivilizationType, TraitType) VALUES
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'TRAIT_CIVILIZATION_DISTRICT_TSOD_MAGE_TOWER');

-- -----------------------------------------------------------------------------
-- 3. 区域主表
--    学院的值照抄（解锁、掠夺、顾问、造价曲线、维护费……），造价减半为 27；
--    ZOC / HitPoints / CityStrengthModifier 照奥皮杜姆（ZOC=1, HitPoints=100, CityStrengthModifier=2）。
--    CaptureRemovesBuildings 保持学院的 0（图书馆等建筑被占领时不消失）。
-- -----------------------------------------------------------------------------
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

-- 风云变幻：能远程攻击的区域都要给射程。
-- 先例：DISTRICT_CITY_CENTER / ENCAMPMENT / OPPIDUM / IKANDA / THANH 在 Districts_XP2 里都是 AttackRange=2。
INSERT INTO Districts_XP2 (DistrictType, AttackRange) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 2);

-- -----------------------------------------------------------------------------
-- 4. 学院的附属行（照天文台先例，数值与学院相同）
-- -----------------------------------------------------------------------------
INSERT INTO District_GreatPersonPoints (DistrictType, GreatPersonClassType, PointsPerTurn) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'GREAT_PERSON_CLASS_SCIENTIST', 1);

INSERT INTO District_CitizenYieldChanges (DistrictType, YieldType, YieldChange) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'YIELD_SCIENCE', 2);

INSERT INTO District_TradeRouteYields (DistrictType, YieldType, YieldChangeAsOrigin, YieldChangeAsDomesticDestination, YieldChangeAsInternationalDestination) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'YIELD_FOOD',    0, 1, 0),
    ('DISTRICT_TSOD_MAGE_TOWER', 'YIELD_SCIENCE', 0, 0, 1);

-- -----------------------------------------------------------------------------
-- 5. 相邻加成
-- 5a. 保留学院的全部相邻加成：加载时从学院现有的行复制。
--     不逐条写死，是因为学院的相邻加成随规则集 / DLC / 游戏模式而变（书院、天文台各自补过）：
--       原版        Mountains_Science1~5、Jungle_Science、District_Science、GBR_Science
--       迭起兴衰起  Government_Science
--       风云变幻    Geothermal_Science、Reef_Science、Pamukkale_Science
--       秘密结社模式 LeyLine_Science（埃塞俄比亚包，LoadOrder 0，早于本 mod 的 100）
--     风云变幻规则集下预期 12 行，秘密结社模式下 13 行（需实证）。
-- -----------------------------------------------------------------------------
INSERT INTO District_Adjacencies (DistrictType, YieldChangeId)
SELECT 'DISTRICT_TSOD_MAGE_TOWER', YieldChangeId
FROM District_Adjacencies
WHERE DistrictType = 'DISTRICT_CAMPUS';

-- 5b. 新增：每个相邻的军营区域 +2 科技（「大量相邻加成」的标准值；写法照 Government_Science）
INSERT INTO Adjacency_YieldChanges (ID, Description, YieldType, YieldChange, TilesRequired, AdjacentDistrict) VALUES
    ('TSOD_TYPHON_MAGE_TOWER_ENCAMPMENT_SCIENCE', 'LOC_DISTRICT_TSOD_MAGE_TOWER_ENCAMPMENT_SCIENCE', 'YIELD_SCIENCE', 2, 1, 'DISTRICT_ENCAMPMENT');

INSERT INTO District_Adjacencies (DistrictType, YieldChangeId) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'TSOD_TYPHON_MAGE_TOWER_ENCAMPMENT_SCIENCE');

-- -----------------------------------------------------------------------------
-- 6. 反间谍：敌方间谍在本城的行动等级 -1
--    数值照领事馆（CONSULATE_SPY_BONUS, Amount=1）。领事馆用的
--    MODIFIER_PLAYER_CITIES_ADJUST_SPY_BONUS 只在埃塞俄比亚包里定义，这里改用资料片自带的
--    MODIFIER_CITY_ADJUST_SPY_BONUS（COLLECTION_OWNER + EFFECT_ADJUST_CITY_SPY_BONUS，
--    总督「安保专家」「本地线人」同款）。挂在 DistrictModifiers 上时 OWNER 解析为区域所在城市，
--    先例：DISTRICT_IKANDA 的 MODIFIER_CITY_CORPS_ARMY_ADJUST_DISCOUNT、DISTRICT_COTHON 的 MODIFIER_CITY_ADJUST_UNIT_DOMAIN_PRODUCTION。
-- -----------------------------------------------------------------------------
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('TSOD_TYPHON_MAGE_TOWER_SPY_DEFENSE', 'MODIFIER_CITY_ADJUST_SPY_BONUS');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_MAGE_TOWER_SPY_DEFENSE', 'Amount', '1');

INSERT INTO DistrictModifiers (DistrictType, ModifierId) VALUES
    ('DISTRICT_TSOD_MAGE_TOWER', 'TSOD_TYPHON_MAGE_TOWER_SPY_DEFENSE');

-- -----------------------------------------------------------------------------
-- 7. 风云变幻：摇滚乐队「太空摇滚」晋升对学院的加成也给法师塔
--    先例：书院（Expansion1_Expansion2.xml）、天文台（GranColombia_Maya_Expansion2.xml）
--    各自补了 ROCKBAND_SPACE_ROCK_<区域> 与 _MODIFIER 两条，数值与学院版相同。
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- 未写、有意交给替代关系（DistrictReplaces）处理的学院引用，官方书院 / 天文台也都没补：
--   Buildings.PrereqDistrict（图书馆、大学、研究实验室、伊斯兰学校）、
--   Buildings.AdjacentDistrict（桑科雷大学、阿蒙森-斯科特科考站）、
--   GreatPersonClasses / GreatPersonIndividuals（大科学家激活）、Projects（学院研究资助）、
--   Boosts（有记载的历史）、UnitOperations（窃取科技推动）、政策 / 总督 / 信条的
--   DistrictType 参数、EmergencyScoreSources（空间站紧急状况）、Improvement_Adjacencies
--   （Mission_Science_Campus）、RANDOM_EVENT_SOLAR_FLARE。
-- 不归本包：图标（WP9，按惯例名 ICON_DISTRICT_TSOD_MAGE_TOWER / _FOW）、模型（WP10）、
--   历史时刻插图（WP12）、AI 偏好（WP7）、开局界面 PlayerItems（WP1）、百科（WP8）。
-- -----------------------------------------------------------------------------
