-- WP5 Mage Tower text (InGame + FrontEnd UpdateText: the start screen shows the district name and description).
-- Wording follows the official text: the Observatory / Oppidum district descriptions, Government_Science's adjacency description, and the Governor's spy description (Security Expert).

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('en_US',      'LOC_DISTRICT_TSOD_MAGE_TOWER_NAME', 'Mage Tower'),
    ('zh_Hans_CN', 'LOC_DISTRICT_TSOD_MAGE_TOWER_NAME', '法师塔'),

    -- Encampment adjacency bonus is not written here: the UI lists it automatically under the adjacency bonuses from District_Adjacencies (I1 feedback).
    ('en_US',      'LOC_DISTRICT_TSOD_MAGE_TOWER_DESCRIPTION',
     'A district unique to Typhon for scientific endeavors. Replaces the Campus district and cheaper to build. The Mage Tower district is defensible with a ranged attack. Enemy Spies operate at 1 level below normal in this city.'),
    ('zh_Hans_CN', 'LOC_DISTRICT_TSOD_MAGE_TOWER_DESCRIPTION',
     '提丰特色科学研究区域。替代“学院”区域，且建造花费更低。“法师塔”区域具有防御力且可执行远程攻击。敌方间谍在此城中的行动等级减1。'),

    -- New adjacency bonus ({1_num} is filled in by the game with the actual bonus value)
    ('en_US',      'LOC_DISTRICT_TSOD_MAGE_TOWER_ENCAMPMENT_SCIENCE', '+{1_num} [ICON_Science] Science from the adjacent Encampment district.'),
    ('zh_Hans_CN', 'LOC_DISTRICT_TSOD_MAGE_TOWER_ENCAMPMENT_SCIENCE', '+{1_num} [ICON_Science] 科技值来自每个相邻的军营。');
