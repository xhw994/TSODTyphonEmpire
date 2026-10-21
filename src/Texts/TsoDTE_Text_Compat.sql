-- =============================================================================
-- TsoDTE_Text_Compat.sql  ·  WP18 系列联动：文本
-- 动作：InGame UpdateText，无 criteria（三条文本装不装联动都无害；未加载的联动不会引用它们）。
-- 不进 FrontEnd：联动只在局内生效。
-- 中文写 LocalizedText（zh_Hans_CN）；英文写 BaseGameText（官方视图，等价于 LocalizedText 中 en_US，塞西尔同用）。
-- 文本规则：不用第二人称，不写介绍性文字。
-- 归属：ids.md §4（WP18 行）。
-- =============================================================================

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- 态度说明（外交界面「态度」条目）
    ('zh_Hans_CN', 'LOC_DIPLO_MODIFIER_TSOD_CECIL_ROSETTA_TO_GAWAIN',
     '罗塞塔·奥古斯都视高文·塞西尔为宿敌，宿敌亦是同类'),
    ('zh_Hans_CN', 'LOC_DIPLO_MODIFIER_TSOD_CECIL_GAWAIN_TO_ROSETTA',
     '高文·塞西尔视罗塞塔·奥古斯都为宿敌，宿敌亦是同类'),

    -- 产出明细（宜居度）
    ('zh_Hans_CN', 'LOC_MODIFIER_TSOD_DREAM_MAGE_TOWER_AMENITY_PREVIEW',
     '提丰为梦境之城的宗主国时，每座法师塔 +1 [ICON_Amenities] 宜居度');

INSERT OR REPLACE INTO BaseGameText (Tag, Text) VALUES
    ('LOC_DIPLO_MODIFIER_TSOD_CECIL_ROSETTA_TO_GAWAIN',
     'Rosetta Augustus sees Gawain Cecil as a rival, and a rival is still one of his kind'),
    ('LOC_DIPLO_MODIFIER_TSOD_CECIL_GAWAIN_TO_ROSETTA',
     'Gawain Cecil sees Rosetta Augustus as a rival, and a rival is still one of his kind'),
    ('LOC_MODIFIER_TSOD_DREAM_MAGE_TOWER_AMENITY_PREVIEW',
     'While Typhon is suzerain of Dream City, each Mage Tower grants +1 [ICON_Amenities] Amenity');
