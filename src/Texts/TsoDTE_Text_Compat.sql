-- WP18 series crossover text (InGame UpdateText, no criteria: crossovers not loaded will not reference them; in-game only, not in FrontEnd).
-- Chinese goes in LocalizedText and English in BaseGameText (the official view, equivalent to LocalizedText en_US; Cecil uses it too).

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- Attitude description (the "attitude" entry in the diplomacy screen)
    ('zh_Hans_CN', 'LOC_DIPLO_MODIFIER_TSOD_CECIL_ROSETTA_TO_GAWAIN',
     '罗塞塔·奥古斯都视高文·塞西尔为宿敌，宿敌亦是同类'),
    ('zh_Hans_CN', 'LOC_DIPLO_MODIFIER_TSOD_CECIL_GAWAIN_TO_ROSETTA',
     '高文·塞西尔视罗塞塔·奥古斯都为宿敌，宿敌亦是同类');

INSERT OR REPLACE INTO BaseGameText (Tag, Text) VALUES
    ('LOC_DIPLO_MODIFIER_TSOD_CECIL_ROSETTA_TO_GAWAIN',
     'Rosetta Augustus sees Gawain Cecil as a rival, but a rival is still a kindred spirit'),
    ('LOC_DIPLO_MODIFIER_TSOD_CECIL_GAWAIN_TO_ROSETTA',
     'Gawain Cecil sees Rosetta Augustus as a rival, but a rival is still a kindred spirit');
