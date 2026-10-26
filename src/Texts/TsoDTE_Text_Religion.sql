-- WP14 战神教文本（FrontEnd + InGame UpdateText）：开局选项、宗教名、百科。
-- 百科 tag 照官方宗教页：LOC_PEDIA_RELIGIONS_PAGE_<ReligionType>_CHAPTER_HISTORY_PARA_n。

INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_TSOD_TYPHON_WAR_GOD_RELIGION_OPTION_NAME', '启用战神教'),
    ('en_US',      'LOC_TSOD_TYPHON_WAR_GOD_RELIGION_OPTION_NAME', 'Enable War God Faith'),
    ('zh_Hans_CN', 'LOC_TSOD_TYPHON_WAR_GOD_RELIGION_OPTION_DESCRIPTION',
     '将《黎明之剑》的战神教加入可创立的宗教，任何文明都可选用。关闭后不加载。'),
    ('en_US',      'LOC_TSOD_TYPHON_WAR_GOD_RELIGION_OPTION_DESCRIPTION',
     'Adds the War God Faith from The Sword of Dawn to the religions that can be founded. Any civilization may choose it. When off, it is not loaded.'),

    ('zh_Hans_CN', 'LOC_RELIGION_TSOD_WAR_GOD', '战神教'),
    ('en_US',      'LOC_RELIGION_TSOD_WAR_GOD', 'War God Faith'),

    ('zh_Hans_CN', 'LOC_PEDIA_RELIGIONS_PAGE_RELIGION_TSOD_WAR_GOD_CHAPTER_HISTORY_PARA_1',
     '战神教即原作中的战神教会，信奉战神凯尔。凯尔是战士与骑士之神，在正神之中力量仅次于圣光之神。他庇护一切勇士，为战争赐福；他的神力也能对抗亵渎、察觉邪恶，因此虔诚的信徒追查邪教徒时往往格外敏锐。'),
    ('en_US',      'LOC_PEDIA_RELIGIONS_PAGE_RELIGION_TSOD_WAR_GOD_CHAPTER_HISTORY_PARA_1',
     'The War God Faith is the Church of the God of War from the novel, devoted to Kel. Kel is the god of warriors and knights, second in power among the orthodox gods only to the God of Holy Light. He shelters every brave fighter and blesses war, and his power also wards off blasphemy and senses evil, so his devout followers are unusually sharp when hunting cultists.'),

    ('zh_Hans_CN', 'LOC_PEDIA_RELIGIONS_PAGE_RELIGION_TSOD_WAR_GOD_CHAPTER_HISTORY_PARA_2',
     '凯尔在人类诸国广受信奉，在提丰更是主流信仰，骑士阶层尤其虔诚。蒙神眷顾的骑士能借凯尔之名施展近乎神术的力量；温德尔家族的继承人也必须先通过战神的考核与试炼，才能接过“狼将军”的称号。教典宣称凯尔不屑以魔法战胜敌人——而提丰最倚重的，恰恰是成千上万的超凡者法师。'),
    ('en_US',      'LOC_PEDIA_RELIGIONS_PAGE_RELIGION_TSOD_WAR_GOD_CHAPTER_HISTORY_PARA_2',
     'Kel is worshipped throughout the human realms and is the dominant faith of Typhon, where the knightly class is especially devout. Knights who enjoy his favor can call on his name to wield a power close to divine magic, and the heirs of House of Wendell must pass the trial of the God of War before they may take up the title of Wolf General. His scripture claims that Kel scorns to defeat his enemies with magic—yet what Typhon relies on most is its legions of Transcendent mages.'),

    ('zh_Hans_CN', 'LOC_PEDIA_RELIGIONS_PAGE_RELIGION_TSOD_WAR_GOD_CHAPTER_HISTORY_PARA_3',
     '历代战神教皇以一柄铁质权杖为象征。战神的祭火呈铁灰色，权杖顿地之声如同战锤击打盾牌。教典描绘的神国里，欢呼者步道的尽头立着凯尔的竞技场，神明时常以化身走进场中，亲自指点受眷顾的勇士。'),
    ('en_US',      'LOC_PEDIA_RELIGIONS_PAGE_RELIGION_TSOD_WAR_GOD_CHAPTER_HISTORY_PARA_3',
     'The symbol of the Popes of the God of War is an iron scepter handed down from one Pope to the next. The god’s sacred fire burns iron-grey, and when the scepter strikes the ground it rings like a war hammer on a shield. In the divine realm described by the scripture, Kel’s arena stands at the end of the Avenue of Cheers, where the god often enters in the form of an avatar to train the champions he favors.'),

    ('zh_Hans_CN', 'LOC_PEDIA_RELIGIONS_PAGE_RELIGION_TSOD_WAR_GOD_CHAPTER_HISTORY_PARA_4',
     '战神陷入疯狂后，教会从最上层开始失控，教皇马尔姆·杜尼特本人成了污染的源头。在冬日猎神中，罗塞塔手执马尔姆留下的铁杖完成了最后的献祭，把战神的本体拉到人间。冬堡群山前，一个铁灰色的巨人一步步逼近要塞，最终在塞西尔人的协助下陨落。'),
    ('en_US',      'LOC_PEDIA_RELIGIONS_PAGE_RELIGION_TSOD_WAR_GOD_CHAPTER_HISTORY_PARA_4',
     'When the god descended into madness, the church came apart from the very top, and Pope Malm Dunite himself became the source of the corruption. During the Winter God-Hunt, Rosetta took up the iron scepter Malm had left behind to complete the final offering and dragged the God of War himself into the mortal world. Before the mountains of Winterhold an iron-grey giant marched step by step on the fortress, and with Cecil’s help it was finally brought down.');
