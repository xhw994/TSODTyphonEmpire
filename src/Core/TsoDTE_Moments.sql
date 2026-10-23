-- =============================================================================
-- WP12 历史时刻插图（InGame UpdateDatabase）
-- 贴图 456 x 332（同塞西尔 mod），由 tools/make_art.py 从 images/ 的设定图裁出，打进 XLPs/TsoDTE_UITextures.xlp。
--   特色单位：玛蒂尔达·奥古斯都.jpg（原著没有战斗法师的设定图，用提丰皇室的法师代替）
--   特色区域：暂用雨夜奥尔德南里的哥特尖塔（images/法师塔.jpg 是塞西尔的法师塔，只作以后建模参考，不用于提丰）
--   特色建筑：奥尔德南雨夜，燃石酸化工厂前的大道
-- 类型与数据类型照官方（Expansion1/2 的 MOMENT_ILLUSTRATION_UNIQUE_*）。
-- =============================================================================

INSERT INTO MomentIllustrations (MomentIllustrationType, MomentDataType, GameDataType, Texture) VALUES
    ('MOMENT_ILLUSTRATION_UNIQUE_UNIT',     'MOMENT_DATA_UNIT',     'UNIT_TSOD_BATTLE_MAGE',         'MOMENT_UNIT_TSOD_BATTLE_MAGE'),
    ('MOMENT_ILLUSTRATION_UNIQUE_DISTRICT', 'MOMENT_DATA_DISTRICT', 'DISTRICT_TSOD_MAGE_TOWER',      'MOMENT_DISTRICT_TSOD_MAGE_TOWER'),
    ('MOMENT_ILLUSTRATION_UNIQUE_BUILDING', 'MOMENT_DATA_BUILDING', 'BUILDING_TSOD_BURNSTONE_WORKS', 'MOMENT_BUILDING_TSOD_BURNSTONE_WORKS');
