-- =============================================================================
-- TsoDTE_Text_MageTower.sql  ·  WP5 法师塔文本
-- 动作：InGame UpdateText + FrontEnd UpdateText（开局界面要显示区域名与说明）
-- 归属：LOC_DISTRICT_TSOD_MAGE_TOWER_NAME / _DESCRIPTION（ids.md §4）
--       LOC_DISTRICT_TSOD_MAGE_TOWER_ENCAMPMENT_SCIENCE（新相邻加成说明，本包新增）
-- 百科长文（PEDIA 系列 tag）归 WP8，不在这里。
-- 措辞照官方：天文台 / 奥皮杜姆的区域说明、Government_Science 的相邻说明、总督「安保专家」的间谍说明。
-- =============================================================================

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- 区域名
    ('en_US',      'LOC_DISTRICT_TSOD_MAGE_TOWER_NAME', 'Mage Tower'),
    ('zh_Hans_CN', 'LOC_DISTRICT_TSOD_MAGE_TOWER_NAME', '法师塔'),

    -- 区域说明（开局界面、建造面板、百科摘要共用）
    ('en_US',      'LOC_DISTRICT_TSOD_MAGE_TOWER_DESCRIPTION',
     'A district unique to Typhon for scientific endeavors. Replaces the Campus district and cheaper to build. The Mage Tower district is defensible with a ranged attack. Enemy Spies operate at 1 level below normal in this city.[NEWLINE][NEWLINE]Receives all standard Campus adjacency bonuses, plus +2 [ICON_Science] Science for each adjacent Encampment district.'),
    ('zh_Hans_CN', 'LOC_DISTRICT_TSOD_MAGE_TOWER_DESCRIPTION',
     '提丰特色科学研究区域。替代“学院”区域，且建造花费更低。“法师塔”区域具有防御力且可执行远程攻击。敌方间谍在此城中的行动等级减1。[NEWLINE][NEWLINE]保留“学院”的全部相邻加成；此外每与一个“军营”区域相邻，则+2 [ICON_Science] 科技值。'),

    -- 新相邻加成：每个相邻军营 +2 科技（{1_num} 由游戏填入实际加成值）
    ('en_US',      'LOC_DISTRICT_TSOD_MAGE_TOWER_ENCAMPMENT_SCIENCE', '+{1_num} [ICON_Science] Science from each adjacent Encampment.'),
    ('zh_Hans_CN', 'LOC_DISTRICT_TSOD_MAGE_TOWER_ENCAMPMENT_SCIENCE', '+{1_num} [ICON_Science] 科技值来自每个相邻的军营。');
