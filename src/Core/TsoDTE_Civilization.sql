-- ============================================================================
-- TsoDTE_Civilization.sql  (WP1)
-- 提丰帝国：文明本体、城市名、市民名、文明能力的壳
-- 动作：InGame UpdateDatabase（同动作内排第 1，见 docs/ids.md §5.2）
-- 文本：Texts/TsoDTE_Text_CivLeader.sql（WP1）；
--       LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME / _DESCRIPTION 归 WP2。
-- 文明能力的修正（TraitModifiers）由 WP2 挂在本文件建的壳上。
-- 领袖与 CivilizationLeaders 在 TsoDTE_Leader.sql（被引用的 Leaders 行先建）。
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Types
-- ----------------------------------------------------------------------------
INSERT INTO Types (Type, Kind)
VALUES
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE',       'KIND_CIVILIZATION'),
    ('TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE', 'KIND_TRAIT');

-- ----------------------------------------------------------------------------
-- 2. 文明
--    RandomCityNameDepth 同塞西尔（5）；民族 ETHNICITY_EURO。
-- ----------------------------------------------------------------------------
INSERT INTO Civilizations
    (CivilizationType, Name, Description, Adjective,
     RandomCityNameDepth, StartingCivilizationLevelType, Ethnicity)
VALUES
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE',
     'LOC_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME',
     'LOC_CIVILIZATION_TSOD_TYPHON_EMPIRE_DESCRIPTION',
     'LOC_CIVILIZATION_TSOD_TYPHON_EMPIRE_ADJECTIVE',
     5,
     'CIVILIZATION_LEVEL_FULL_CIV',
     'ETHNICITY_EURO');

-- ----------------------------------------------------------------------------
-- 3. 文明能力「超凡者的帝国」的壳（修正由 WP2 挂）
-- ----------------------------------------------------------------------------
INSERT INTO Traits (TraitType, Name, Description)
VALUES
    ('TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE',
     'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME',
     'LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_DESCRIPTION');

INSERT INTO CivilizationTraits (CivilizationType, TraitType)
VALUES
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE');

-- ----------------------------------------------------------------------------
-- 4. 城市名：57 个，顺序照 master plan §11.2
--    首都在前，再是原作重要城市、贵族封地，最后按北、中、南。
--    插入顺序即自增 ID 顺序，游戏按此顺序取名（RandomCityNameDepth 内随机）。
-- ----------------------------------------------------------------------------
INSERT INTO CityNames (CivilizationType, CityName)
VALUES
    -- 首都与原作重要城市
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_ORDENAN'),             --  1 奥尔德南（首都）
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_WINTERHOLD'),          --  2 冬堡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_MOBIUS'),              --  3 莫比乌斯
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_ORANDEL'),             --  4 奥兰戴尔
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_WINTERWOLF_KEEP'),     --  5 冬狼堡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_TARENKINS'),           --  6 塔伦金斯
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_SUTIM'),               --  7 苏提姆
    -- 贵族封地
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_SEWENHOLD'),           --  8 赛文堡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_DULUR'),               --  9 杜勒
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_HALLMARK'),            -- 10 霍尔马克
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_DART'),                -- 11 达特
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_FABRO'),               -- 12 法布罗
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_COLMANRONI'),          -- 13 科尔曼罗尼
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_MALIK'),               -- 14 马利克
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_MORGLOCK'),            -- 15 摩格洛克
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_HEMIL'),               -- 16 赫米尔
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_PLATINPHIS'),          -- 17 铂金菲斯
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_MUSE'),                -- 18 缪斯
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_TASSOS_ISLE'),         -- 19 塔索斯岛
    -- 北部
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_SARIEL'),              -- 20 萨里尔
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_DUVOSSON_SHIRE'),      -- 21 杜沃松郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_HAMAR_SHIRE'),         -- 22 哈玛尔郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_DUSSON_SHIRE'),        -- 23 杜松郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_ENKIHAWK_SHIRE'),      -- 24 恩奇霍克郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_TURAN_SHIRE'),         -- 25 图兰郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_JULESHOLD'),           -- 26 于勒堡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_SUTINI'),              -- 27 苏提尼
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_LUCIA'),               -- 28 卢西亚
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_NIMIAS'),              -- 29 尼米亚斯
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_GOLDSAND_SHIRE'),      -- 30 金沙郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_BUTTERFIELD_SHIRE'),   -- 31 巴特菲尔德郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_PINEWOOD_TOWN'),       -- 32 松林镇
    -- 中部
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_RAVENHOLD'),           -- 33 瑞文堡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_CORNELIAN'),           -- 34 康奈利安
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_KAZ'),                 -- 35 卡兹
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_BLACKMOUNTAIN_SHIRE'), -- 36 黑山郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_KAPVI'),               -- 37 卡普维
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_COLIN'),               -- 38 科林
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_ASLANTE'),             -- 39 亚斯兰特
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_OSOL'),                -- 40 奥索尔
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_DORIA'),               -- 41 多利亚
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_SEISS_SHIRE'),         -- 42 西斯郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_KATROL'),              -- 43 卡特罗尔
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_HEMIT'),               -- 44 赫米特
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_RICKHOLD'),            -- 45 瑞克堡
    -- 南部
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_SHAFREND_SHIRE'),      -- 46 沙夫伦德郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_VITO_SHIRE'),          -- 47 维托郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_KELMAN'),              -- 48 凯尔曼
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_ANGRAY_SHIRE'),        -- 49 安格雷郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_MOGORAY'),             -- 50 莫戈雷
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_NOTTLAND'),            -- 51 诺特兰
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_SEASIDE_SHIRE'),       -- 52 滨海郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_BALTA'),               -- 53 巴尔塔
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_KATANI'),              -- 54 卡塔尼
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_ADELIN'),              -- 55 亚德林
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_SOUTHSEA_SHIRE'),      -- 56 南海郡
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITY_NAME_TSOD_LANIA_SHIRE');         -- 57 兰尼亚郡

-- ----------------------------------------------------------------------------
-- 5. 市民名（master plan §11.3）：Female 1 = 女
--    含「主要角色可选」6 人；戴安娜按 §11.3 不收（她不是人类）。
-- ----------------------------------------------------------------------------
INSERT INTO CivilizationCitizenNames (CivilizationType, CitizenName, Female)
VALUES
    -- 男
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_BOMEL',     0),  -- 博迈尔
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_HEMIL',     0),  -- 赫米尔
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_MOREY',     0),  -- 莫里
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_CLERMONT',  0),  -- 克雷蒙特
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_MORGLOCK',  0),  -- 摩格洛克
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_PALIN',     0),  -- 帕林
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_OWEN',      0),  -- 欧文
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_DANIEL',    0),  -- 丹尼尔
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_GEORGE',    0),  -- 乔治
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_BERTOMUND', 0),  -- 贝托蒙德
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_MALM',      0),  -- 马尔姆
    -- 女
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_GINA',      1),  -- 金娜
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_MARY',      1),  -- 玛丽
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_TALIA',     1),  -- 塔利亚
    -- 主要角色（可选）
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_ANDESHA',   1),  -- 安德莎
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_WINDSOR',   1),  -- 温莎
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_MATILDA',   1),  -- 玛蒂尔达
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_HADIREN',   0),  -- 哈迪伦
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_FERDINAND', 0),  -- 裴迪南
    ('CIVILIZATION_TSOD_TYPHON_EMPIRE', 'LOC_CITIZEN_NAME_TSOD_BARD',      0);  -- 巴德
