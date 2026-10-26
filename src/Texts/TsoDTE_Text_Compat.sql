-- WP18 系列联动文本（InGame UpdateText，无 criteria：未加载的联动不会引用它们；只在局内生效，不进 FrontEnd）。
-- 中文写 LocalizedText，英文写 BaseGameText（官方视图，等价于 LocalizedText 的 en_US，塞西尔同用）。

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- 态度说明（外交界面「态度」条目）
    ('zh_Hans_CN', 'LOC_DIPLO_MODIFIER_TSOD_CECIL_ROSETTA_TO_GAWAIN',
     '罗塞塔·奥古斯都视高文·塞西尔为宿敌，宿敌亦是同类'),
    ('zh_Hans_CN', 'LOC_DIPLO_MODIFIER_TSOD_CECIL_GAWAIN_TO_ROSETTA',
     '高文·塞西尔视罗塞塔·奥古斯都为宿敌，宿敌亦是同类');

INSERT OR REPLACE INTO BaseGameText (Tag, Text) VALUES
    ('LOC_DIPLO_MODIFIER_TSOD_CECIL_ROSETTA_TO_GAWAIN',
     'Rosetta Augustus sees Gawain Cecil as a rival, and a rival is still one of his kind'),
    ('LOC_DIPLO_MODIFIER_TSOD_CECIL_GAWAIN_TO_ROSETTA',
     'Gawain Cecil sees Rosetta Augustus as a rival, and a rival is still one of his kind');
