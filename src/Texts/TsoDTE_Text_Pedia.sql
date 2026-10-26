-- WP8 百科长文、人物与地点条目、领袖引言、载入画面旁白、外交台词（InGame UpdateText）。
-- tag 约定照官方 CivilopediaSupport.lua 的 FindChapterTextKey / FindPageTextKey 与印度甘地的外交台词；数值不写死，以各包 DESCRIPTION 为准。

-- 文明：提丰帝国
-- PARA_1 是文明引言（官方文明页没有引言位，放在历史章节的第一段）
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_1',
     '“神明并不是太可靠的保护者。”[NEWLINE]——罗塞塔·奥古斯都'),
    ('en_US', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_1',
     '"The gods are not very reliable protectors."[NEWLINE]— Rosetta Augustus'),

    ('zh_Hans_CN', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_2',
     '提丰帝国是人类诸国中最古老、也最强盛的帝国之一，由奥古斯都家族世代统治。两百年前，旧帝都奥兰戴尔在一场“大崩塌”中沉入地下。当时的皇帝事先得到预警，疏散了全城居民，又在平原上另建新都，取名奥尔德南——古巨人语中的“千年城”。帝国躲过了一场浩劫，奥古斯都家族却从此背上了一道纠缠两个世纪的诅咒。'),
    ('en_US', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_2',
     'The Typhon Empire is one of the oldest and mightiest of the human realms, ruled for generations by the House of Augustus. Two centuries ago its old capital, Orandel, sank into the earth in what became known as the Great Collapse. Forewarned, the emperor of the day evacuated the city and raised a new capital on the plains, naming it Ordenan—"City of a Thousand Years" in the ancient tongue of the giants. The empire was spared a catastrophe, but the House of Augustus inherited a curse that would haunt it for two hundred years.'),

    ('zh_Hans_CN', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_3',
     '帝国长期由三股力量支撑：分封各地的贵族、执掌兵权的骑士世家，以及作为主流信仰的战神教会。到了罗塞塔·奥古斯都的时代，皇室开始把权力一点点收回手中：立法权归于皇室，领主的土地被重新核定，征召兵让位于职业化的常备军，平民开始识字，田地契约法改变了乡村，燃石酸化工厂与帝国工造协会则把奥尔德南变成了烟囱林立的工业之都。奥尔德南议会厅的三重尖顶分别象征皇权、贵族与市民——尽管市民议员的声音仍然微弱，这个说法本身已是新政的缩影。'),
    ('en_US', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_3',
     'For centuries the empire rested on three pillars: a landed nobility, the great knightly houses that commanded its armies, and the Church of the God of War, its dominant faith. In the age of Rosetta Augustus the crown began to draw power back into its own hands. Lawmaking passed to the throne, noble estates were reassessed, levies gave way to a professional standing army, commoners learned to read, a land-contract law reshaped the countryside, and the Burnstone Acidification Works and the Imperial Artificers’ Guild turned Ordenan into a city of smokestacks. The three spires of Ordenan’s parliament hall stand for crown, nobility and citizens. The citizens’ voice there is still faint, but the symbol itself sums up the new order.'),

    ('zh_Hans_CN', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_4',
     '提丰的军队以超凡者闻名。帝国从六岁起挑选有天赋的孩子，哪怕资质平平，也让他们十几年如一日地练熟一两种法术，最终编成成千上万人的超凡者兵团。冬狼、铁河、黑钢等骑士团冲锋在前，黑旗魔法师团等法师团随行支援，他们集结起来释放的“军团级法术”，足以在很短的时间里左右一座要塞的得失。遍布各城的法师塔则登记、感应着国内的每一位超凡者，让这台战争机器始终握在皇室手中。'),
    ('en_US', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_4',
     'Typhon’s armies are famed for their Transcendents. From the age of six, children with even modest talent are selected and drilled for a decade or more in one or two spells, until they can be massed by the thousand into Transcendent legions. Knightly orders such as the Winterwolf, Iron River and Black Steel lead the charge, while mage corps such as the Black Flag Mage Corps ride beside them. Massed together, their "legion-level spells" can decide the fate of a fortress within hours. A web of Mage Towers across the cities registers and senses every Transcendent in the realm, keeping this war machine firmly in the crown’s hands.'),

    ('zh_Hans_CN', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_5',
     '帝国最深的危机来自它自己的信仰。战神教会从最上层开始失控，神官接连陷入疯狂，连教皇马尔姆·杜尼特也成了异变的源头；一份被篡改的外交文书让提丰与塞西尔帝国在神明的推动下兵戎相见，边境要塞冬狼堡随之陷落。罗塞塔没有等待神明的宽恕。他与寄生在家族梦境中的“神之眼”做了一笔交易，把战神的本体拉到人间，又在冬堡群山上同时释放了复数的“湮灭之创”。在塞西尔人的协助下，失控的神明最终陨落——这一役被后人称为“冬日猎神”。'),
    ('en_US', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_5',
     'The empire’s gravest crisis came from its own faith. The Church of the God of War began to unravel from the top: priests fell into madness one after another, and even Pope Malm Dunite became a source of the corruption. A tampered diplomatic dispatch drove Typhon and the Cecil Empire into a war the god itself had engineered, and the border fortress of Winterwolf Keep fell. Rosetta did not wait for divine mercy. He struck a bargain with the Eye of God, the entity that had long haunted his family’s dreams, dragged the God of War down into the mortal world, and unleashed several Annihilation Scars at once from the peaks of Winterhold. With Cecil’s help the maddened god was finally brought down—a battle later remembered as the Winter God-Hunt.'),

    ('zh_Hans_CN', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_6',
     '战争结束后，提丰与昔日的对手坐上同一张谈判桌，加入了人类诸国的联盟与神权理事会，并在国内推行“去神圣化”，把信仰与国家权力一点点剥离。燃石酸化工厂产出的化肥“丰饶之尘”让凡人不再仰赖丰饶诸神的恩赐。这个曾经以神眷骑士为荣的帝国，如今正试着学会只依靠自己。'),
    ('en_US', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_6',
     'After the war Typhon sat at the same table as its former enemy, joined the alliance of human nations and the Theocratic Council, and began a policy of Desanctification at home, prying faith and state apart. The fertilizer of the burnstone works, the Dust of Plenty, freed mortals from waiting on the blessings of the gods of plenty. An empire that once took pride in god-favored knights is now learning to rely on no one but itself.');

-- 领袖：罗塞塔·奥古斯都
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_QUOTE',
     '我们，有着超乎你们想象的韧性。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_QUOTE',
     'We are far more resilient than you can imagine.'),

    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_CAPSULE_BODY',
     '罗塞塔是一位精于计算、也敢于下注的皇帝。他把学院变成兵营，把燃石变成粮食与科技，把敌人的发明拆开研究。在游戏中，他用科技托底的军队寻求征服，并善于把黑暗时代与战场上的缴获都化为发展的养料。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_CAPSULE_BODY',
     'Rosetta is an emperor who calculates every cost and still dares to gamble. He turns schools into barracks, burnstone into bread and science, and his enemies’ inventions into parts on his workbench. In game, he seeks conquest with an army backed by technology, and turns Dark Ages and battlefield spoils alike into fuel for progress.'),

    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_DETAILED_BODY',
     '提丰的玩法围绕学院与军营展开。法师塔取代学院，造价更低，并从相邻的军营区域获得大量[ICON_SCIENCE]科技值相邻加成，因此最好把两者成对规划；法师塔本身拥有城防、能发动远程打击，还会让敌方间谍更难得手。拥有学院的城市训练的陆地军事单位自带一次免费升级；学院和圣地会额外产出[ICON_GREATGENERAL]大将军点数；建有军营的城市不受宗教压力影响，无论对手派来多少传教士，你的后方都能保持稳定。[NEWLINE][NEWLINE]提丰战斗法师取代弩手。它不会升级，但在研究弹道学与高级弹道学之后会自动变强，并保留已获得的全部晋升；让战斗法师并肩作战，还能进一步提高[ICON_RANGED]远程攻击力。燃石酸化工厂取代工厂，提供更多[ICON_PRODUCTION]生产力和额外的[ICON_SCIENCE]科技值，并让本城的农场产出更多[ICON_FOOD]食物。[NEWLINE][NEWLINE]罗塞塔本人让提丰在每个新时代获得随机的[ICON_TECHBOOSTED]尤里卡和[ICON_CIVICBOOSTED]鼓舞，进入黑暗时代时收获反而更多；在战斗中击杀敌方单位时，若你尚未研究该单位的前置科技，便会立即获得该科技的[ICON_TECHBOOSTED]尤里卡。主动与科技领先的对手交战，是提丰追赶的捷径。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_DETAILED_BODY',
     'Typhon’s play revolves around Campuses and Encampments. The Mage Tower replaces the Campus, costs less, and earns a major [ICON_SCIENCE] Science adjacency bonus from neighboring Encampment districts, so plan the two in pairs. The tower also has its own defenses, can make ranged strikes, and makes life harder for enemy spies. Land military units trained in a city with a Campus receive a free promotion. Campuses and Holy Sites generate extra [ICON_GREATGENERAL] Great General points, and cities with an Encampment ignore religious pressure, keeping your heartland stable no matter how many missionaries your rivals send.[NEWLINE][NEWLINE]The Typhon Battle Mage replaces the Crossbowman. It never upgrades, but grows stronger on its own once you research Ballistics and Advanced Ballistics, keeping every promotion it has earned. Battle Mages fighting side by side gain additional [ICON_RANGED] Ranged Strength. The Burnstone Acidification Works replaces the Factory, providing more [ICON_PRODUCTION] Production plus [ICON_SCIENCE] Science, and makes the city’s Farms yield more [ICON_FOOD] Food.[NEWLINE][NEWLINE]Rosetta himself grants a random [ICON_TECHBOOSTED] Eureka and [ICON_CIVICBOOSTED] Inspiration with each new era, and even more when a Dark Age begins. Killing an enemy unit whose prerequisite technology you have not yet researched immediately grants that technology’s [ICON_TECHBOOSTED] Eureka. Picking fights with more advanced rivals is Typhon’s shortcut to catching up.'),

    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_1',
     '罗塞塔·奥古斯都是提丰帝国的皇帝，史称“罗塞塔大帝”。他已步入中年，身形消瘦，神情阴郁，一头灰色短卷发，眼窝深陷，目光却像鹰一样锐利。他习惯穿镶金边的黑色外套，或披一件用高阶魔物皮毛制成的黑色大氅，喜欢坐在背光的高背椅里；见过他的人常说，那姿态像一头以阴影为巢的猛兽。很少有人记得，这位皇帝本人也是一位强大的施法者：刺客曾闯进他的书房，是他亲手用奥术电弧与屏障将其击退的。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_1',
     'Rosetta Augustus, Emperor of Typhon, is remembered as Rosetta the Great. Middle-aged, gaunt and somber, with short curly grey hair, deep-set eyes and the sharp gaze of a hawk, he favors a gold-trimmed black coat or a black cloak made from the pelt of some fearsome magical beast, and prefers to sit in a high-backed chair with the light behind him. Those who have met him say he resembles a predator that makes its den in the shadows. Few remember that the emperor is also a formidable spellcaster: when assassins once broke into his study, it was he who drove them off with arcs of arcane lightning and warding barriers.'),

    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_2',
     '罗塞塔继位后推行了一系列深刻的改革。他削弱分封贵族，把立法权收归皇室，重新核定全国领主的土地；他用职业常备军取代征召兵，把超凡者当作可以批量培养的士兵；他让平民识字，用田地契约法重塑乡村，又下令在帝国各个产粮区就地兴建燃石酸化工厂。改革触动了太多人的利益，他便用强硬的手腕压住反弹，再用改革带来的红利安抚那些心怀不满的封臣——或者干脆让跟不上时代的人被时代淘汰。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_2',
     'Upon taking the throne Rosetta launched sweeping reforms. He curbed the feudal nobility, claimed lawmaking for the crown and reassessed every lord’s lands. He replaced levies with a professional standing army and treated Transcendents as soldiers who could be trained in quantity. He taught commoners to read, reshaped the countryside with a land-contract law, and ordered Burnstone Acidification Works built in every grain-growing region of the empire. The reforms threatened too many interests, so he crushed resistance with an iron hand, then used the profits of reform to placate resentful vassals—or simply let those who could not keep up with the times be left behind by them.'),

    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_3',
     '皇帝的冷静背后，是奥古斯都家族隐藏了两百年的秘密。自奥兰戴尔大崩塌以来，梦境之神的一块碎片——“神之眼”——便寄生在家族的梦里，这道诅咒终将把族人引向疯狂。死去的奥古斯都们被困在梦中“黄昏宫殿”的画像里，向后人低语献策，也试图把他们拖进画框。神之眼曾问罗塞塔为何还没有疯，他只回答了一句：“我们，有着超乎你们想象的韧性。”事实上，这个家族在梦中与它周旋了整整两个世纪，一面假装屈服，一面偷取它的知识。在黄昏宫殿的噩梦里，奥古斯都们从未屈服。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_3',
     'Behind the emperor’s composure lay a secret the House of Augustus had kept for two centuries. Ever since the Great Collapse of Orandel, a fragment of the God of Dreams known as the Eye of God had lived as a parasite in the family’s dreams, a curse that would sooner or later lead its members into madness. The dead of the line were trapped in the portraits of the Twilight Palace, a realm of dream where they whispered counsel to their descendants and tried to drag them into the frames. When the Eye asked Rosetta why he had not yet gone mad, he answered only: "We are far more resilient than you can imagine." In truth the family had played a game with it for two hundred years, feigning submission while stealing its knowledge. In the nightmares of the Twilight Palace, the House of Augustus never yielded.'),

    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_4',
     '罗塞塔从不拒绝任何可用之物。他会利用邪教、利用诅咒，也会利用对手的技术：第一次见到塞西尔的魔导车时，他的第一反应是把它拆成零件研究；潜伏多年的梦境教派“永眠者”中有人前来投奔时，他没有赶尽杀绝，而是选择招抚，因为在他看来，知识本身是无罪的。他与高文·塞西尔既是对手，也是彼此最清醒的观察者——在罗塞塔眼里，战争有很多种形式，“合作”也是其中之一。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_4',
     'Rosetta never refuses anything that can be put to use. He has made use of cults, of curses, and of his rivals’ technology: the first time he saw a Cecil magitech car, his first thought was to have it taken apart. When members of the Eternal Sleepers, a dream cult long hidden in his empire, came over to his side, he chose to take them in rather than wipe them out, for in his view knowledge itself is innocent. He and Gawain Cecil were rivals and also each other’s most clear-eyed observers. To Rosetta, war takes many forms, and "cooperation" is one of them.'),

    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_5',
     '罗塞塔一生最大的赌局，是战神教会失控后的那场“冬日猎神”。他与神之眼达成交易，把老友、战神教皇马尔姆·杜尼特残留的化身逐一投入火盆作为祭品，硬生生将战神的本体拉到人间；与此同时，黑曜石禁军清洗了失控的神官，冬堡群山同时释放出复数的“湮灭之创”。最终，在塞西尔人的协助下，战神陨落。战后，罗塞塔带领提丰加入人类诸国的联盟与神权理事会，推行去神圣化。对这位皇帝而言，神明从来都不是可靠的保护者。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_5',
     'The greatest gamble of Rosetta’s life came after the Church of the God of War lost its mind: the Winter God-Hunt. He struck a bargain with the Eye of God, cast the lingering avatars of his old friend Malm Dunite, the War God’s Pope, one by one into a brazier as offerings, and so dragged the God of War himself into the mortal world. At the same time the Obsidian Guard purged the maddened priesthood, and the mountains of Winterhold unleashed several Annihilation Scars at once. In the end, with the help of the Cecil Empire, the god fell. After the war Rosetta led Typhon into the alliance of human nations and the Theocratic Council and set about Desanctification. To this emperor, the gods were never reliable protectors.');

-- 载入画面旁白
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_LOADING_INFO_LEADER_TSOD_ROSETTA_AUGUSTUS',
     '罗塞塔·奥古斯都陛下，提丰的皇帝，黑铁王座的主人。两百年来，您的家族在噩梦里与神明周旋，却从未低头。如今，用学院锻造超凡者的兵团，用燃石喂饱您的子民，把敌人的每一项发明都化为己用。算清每一份代价，也别害怕押上一切——让世界看看，凡人能走多远。'),
    ('en_US', 'LOC_LOADING_INFO_LEADER_TSOD_ROSETTA_AUGUSTUS',
     'Your Imperial Majesty Rosetta Augustus, Emperor of Typhon, master of the Black Iron Throne. For two hundred years your house has dueled with a god in its nightmares and never once bowed. Now forge legions of Transcendents in your academies, feed your people with burnstone, and turn every invention of your enemies to your own ends. Weigh every cost, yet never fear to wager everything—show the world how far mortals can go.');

-- 特色单位：提丰战斗法师
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_PEDIA_UNITS_PAGE_UNIT_TSOD_BATTLE_MAGE_CHAPTER_HISTORY_PARA_1',
     '提丰战斗法师是帝国“量产超凡者”政策的产物。他们大多天赋平平，放在传统法师眼中或许连学徒都不够格，却从童年起便被集中起来，十几年如一日地只练熟一两种战斗法术。单独一人并不起眼，成千上万人集结起来，却能凝聚成令敌军胆寒的“军团级法术”。'),
    ('en_US', 'LOC_PEDIA_UNITS_PAGE_UNIT_TSOD_BATTLE_MAGE_CHAPTER_HISTORY_PARA_1',
     'The Typhon Battle Mage is the product of the empire’s policy of "mass-produced Transcendents." Most have little talent—traditional wizards might not even accept them as apprentices—but from childhood they are gathered together and drilled for a decade or more in just one or two combat spells. One alone is unremarkable. Thousands massed together can weave "legion-level spells" that strike terror into any army.'),

    ('zh_Hans_CN', 'LOC_PEDIA_UNITS_PAGE_UNIT_TSOD_BATTLE_MAGE_CHAPTER_HISTORY_PARA_2',
     '战斗法师很少单独行动。以黑旗魔法师团为代表的骑乘法师团与骑士团同步推进，为冲锋提供不间断的远程支援；军中的“顾问学者”往往也是战斗法师或随军的战神祭司。与塞西尔交战时，冬堡伯爵帕林麾下的战斗法师很快发现，足够高阶的光束法术可以穿透对方战车的护盾，并据此调整了战术。'),
    ('en_US', 'LOC_PEDIA_UNITS_PAGE_UNIT_TSOD_BATTLE_MAGE_CHAPTER_HISTORY_PARA_2',
     'Battle Mages rarely fight alone. Mounted mage corps such as the Black Flag Mage Corps advance in step with the knightly orders, giving a charge unbroken ranged support, and the "scholar advisers" attached to an army are usually Battle Mages or chaplains of the God of War. In the war with Cecil, the battle mages of Palin, Earl of Winterhold, soon learned that sufficiently powerful beam spells could pierce the shields of Cecil’s war machines, and adjusted their tactics accordingly.'),

    ('zh_Hans_CN', 'LOC_PEDIA_UNITS_PAGE_UNIT_TSOD_BATTLE_MAGE_CHAPTER_HISTORY_PARA_3',
     '与别国的军队不同，提丰并不急于把老兵换成新兵种。帝国的法术、装备与战术随时代不断更新，而这些身经百战的施法者始终留在队列里，把每一场战斗的经验带进下一场战争。他们最可怕的力量，是曾在冬堡群山上齐射、击伤了神明的战略法术——“湮灭之创”。'),
    ('en_US', 'LOC_PEDIA_UNITS_PAGE_UNIT_TSOD_BATTLE_MAGE_CHAPTER_HISTORY_PARA_3',
     'Unlike other armies, Typhon’s is in no hurry to replace its veterans with new kinds of troops. The empire’s spells, equipment and tactics are refreshed with each age, while these battle-hardened casters stay in the ranks, carrying the lessons of every battle into the next war. Their most fearsome power is the strategic spell once fired in volleys from the peaks of Winterhold to wound a god: the Annihilation Scar.');

-- 特色区域：法师塔
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_PEDIA_DISTRICTS_PAGE_DISTRICT_TSOD_MAGE_TOWER_CHAPTER_HISTORY_PARA_1',
     '提丰的法师塔远不只是研究魔法的地方。帝国依靠数量众多的法师塔和大批效忠皇室的皇家法师，对绝大多数城市中的超凡者进行登记与感应，并配套兴建了大量培训设施，专门培养更忠诚、更服从命令的“专职施法者”。这套体系耗资巨大，但提丰负担得起。'),
    ('en_US', 'LOC_PEDIA_DISTRICTS_PAGE_DISTRICT_TSOD_MAGE_TOWER_CHAPTER_HISTORY_PARA_1',
     'Typhon’s Mage Towers are far more than places to study magic. Through great numbers of towers and a host of Royal Mages loyal to the crown, the empire registers and senses the Transcendents of almost every city, backed by training facilities that turn out "professional casters" more loyal and obedient than any freelance wizard. The system is enormously expensive, but Typhon can afford it.'),

    ('zh_Hans_CN', 'LOC_PEDIA_DISTRICTS_PAGE_DISTRICT_TSOD_MAGE_TOWER_CHAPTER_HISTORY_PARA_2',
     '在边境，法师塔同时也是要塞。冬堡内城耸立着一座座法师塔，塔顶的“法师之眼”日夜监视着整个地区；战争来临时，这些高塔连成网络，成为整个防区的指挥中枢。冬日猎神那一夜，数十万超凡者正是通过这张魔法网络，把力量汇聚到了冬堡群峰之上。'),
    ('en_US', 'LOC_PEDIA_DISTRICTS_PAGE_DISTRICT_TSOD_MAGE_TOWER_CHAPTER_HISTORY_PARA_2',
     'On the frontier, a Mage Tower is also a fortress. Tower after tower rises within the inner city of Winterhold, the "mage eyes" at their summits watching the whole region day and night. In war they link into a network that serves as the command center of the entire front. On the night of the Winter God-Hunt, hundreds of thousands of Transcendents channeled their power through this network to the peaks of Winterhold.'),

    ('zh_Hans_CN', 'LOC_PEDIA_DISTRICTS_PAGE_DISTRICT_TSOD_MAGE_TOWER_CHAPTER_HISTORY_PARA_3',
     '也正因为有这张无处不在的感应网，潜入提丰城市的外国间谍往往会发现，自己的一举一动早已落在高塔上那些眼睛里。'),
    ('en_US', 'LOC_PEDIA_DISTRICTS_PAGE_DISTRICT_TSOD_MAGE_TOWER_CHAPTER_HISTORY_PARA_3',
     'And because of this all-seeing web, foreign spies who slip into a Typhon city often discover that the eyes atop the towers have been following their every move.');

-- 特色建筑：燃石酸化工厂
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_PEDIA_BUILDINGS_PAGE_BUILDING_TSOD_BURNSTONE_WORKS_CHAPTER_HISTORY_PARA_1',
     '燃石是提丰东北海岸常见的一种灰白色沉积岩，经过酸化处理后能变成高效的化肥，提丰人称之为“丰饶之尘”。罗塞塔下令在帝国所有的产粮区就地兴建燃石酸化工厂，让化肥不必长途运输便能撒进田里，农场与养猪场也随之一同兴旺起来。'),
    ('en_US', 'LOC_PEDIA_BUILDINGS_PAGE_BUILDING_TSOD_BURNSTONE_WORKS_CHAPTER_HISTORY_PARA_1',
     'Burnstone is a greyish-white sedimentary rock common along Typhon’s northeastern coast. Acidified, it becomes a potent fertilizer the Typhonese call the Dust of Plenty. Rosetta ordered Burnstone Acidification Works built on site in every grain-growing region of the empire, so that fertilizer could go straight into the fields without long hauls, and farms and pig yards flourished together.'),

    ('zh_Hans_CN', 'LOC_PEDIA_BUILDINGS_PAGE_BUILDING_TSOD_BURNSTONE_WORKS_CHAPTER_HISTORY_PARA_2',
     '燃石的价值远不止于农业。它是丰饶之尘与晶石基质的原料，酸化时产生的副产物“灰晶”也是一种魔导材料；一座燃石矿场甚至让衰败的莫比乌斯港重获生机。奥尔德南的燃石酸化工厂竖着百米高的烟囱，与纺织厂、印刷厂和符文铸造厂比邻而立，帝都终年不散的雾气里，从此也混进了工厂的怪味。'),
    ('en_US', 'LOC_PEDIA_BUILDINGS_PAGE_BUILDING_TSOD_BURNSTONE_WORKS_CHAPTER_HISTORY_PARA_2',
     'Burnstone’s value goes far beyond farming. It is the raw material for both the Dust of Plenty and crystal matrices, and the byproduct of acidification, "grey crystal," is itself a magitech material. A single burnstone quarry even brought the declining Port Mobius back to life. In Ordenan the acidification works raise hundred-meter smokestacks beside textile mills, printing houses and rune foundries, and the fog that never leaves the capital now carries their peculiar smell.'),

    ('zh_Hans_CN', 'LOC_PEDIA_BUILDINGS_PAGE_BUILDING_TSOD_BURNSTONE_WORKS_CHAPTER_HISTORY_PARA_3',
     '就连塞西尔人也承认，提丰的燃石酸化工厂比他们的炼金工厂早了五年。更深远的影响落在信仰上：凡人靠丰饶之尘就能吃饱饭，便绕开了“神恩”，丰饶诸神的神国也因此滋生腐化。一座化肥工厂，就这样成了提丰走向去神圣化的伏笔。'),
    ('en_US', 'LOC_PEDIA_BUILDINGS_PAGE_BUILDING_TSOD_BURNSTONE_WORKS_CHAPTER_HISTORY_PARA_3',
     'Even the Cecilians admitted that Typhon’s acidification works were five years ahead of their own alchemical factories. The deeper consequences were spiritual: once mortals could feed themselves with the Dust of Plenty, they had bypassed "divine grace," and corruption began to fester in the divine kingdoms of the gods of plenty. A fertilizer plant thus became a quiet prelude to Typhon’s Desanctification.');

-- 自定义分组页：分组名
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGEGROUP_TSOD_TYPHON_PEOPLE_NAME', '提丰帝国：人物'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGEGROUP_TSOD_TYPHON_PEOPLE_NAME', 'Typhon Empire: People'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGEGROUP_TSOD_TYPHON_PLACES_NAME', '提丰帝国：地点'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGEGROUP_TSOD_TYPHON_PLACES_NAME', 'Typhon Empire: Places');

-- 人物
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- 裴迪南
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_FERDINAND_CHAPTER_CONTENT_TITLE', '裴迪南·温德尔'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_FERDINAND_CHAPTER_CONTENT_TITLE', 'Ferdinand Wendell'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_FERDINAND_CHAPTER_CONTENT_PARA_1',
     '裴迪南·温德尔大公是温德尔家族的家主。这个家族与塞西尔家族一样古老，世代统领冬狼骑士团，继承人要先通过战神的试炼，才能继承“狼将军”的称号。裴迪南本人是前前代的狼将军，被誉为提丰最强大的“骑士领主”，也是罗塞塔最信任的公爵：皇帝离开帝都时，正是他坐镇国内督理政务，而他执掌的护国骑士团只效忠皇室，与战神教会毫无瓜葛。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_FERDINAND_CHAPTER_CONTENT_PARA_1',
     'Grand Duke Ferdinand Wendell is the head of House Wendell, a family as old as the House of Cecil that has led the Winterwolf Knights for generations. Its heirs must pass the trial of the God of War before they may inherit the title of Wolf General. Ferdinand himself was Wolf General two generations ago and is hailed as Typhon’s mightiest "knight-lord." He is also Rosetta’s most trusted duke: when the emperor leaves the capital it is Ferdinand who governs in his stead, and the knightly order he commands answers to the crown alone, with no ties to the Church of the God of War.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_FERDINAND_CHAPTER_CONTENT_PARA_2',
     '裴迪南的独子巴德多年前失踪，孙女安德莎由他一手教导，成为提丰史上最年轻的狼将军。战神教会失控时，老友教皇马尔姆借助精神干涉扭曲了裴迪南的认知，提丰发给塞西尔的解释文书竟被篡改成了战争宣言。罗塞塔却告诉他，这不是他的错——随后把清理军中教会势力的名单交到了他手上。多年以后，安德莎带回了一个消息：巴德还活着，就在塞西尔。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_FERDINAND_CHAPTER_CONTENT_PARA_2',
     'Ferdinand’s only son, Bard, vanished years ago, and he raised his granddaughter Andesha himself until she became the youngest Wolf General in Typhon’s history. When the Church of the God of War went astray, his old friend Pope Malm twisted his perceptions through mental interference, and the explanation Typhon sent to Cecil was altered into a declaration of war. Rosetta told him it was not his fault—and then handed him the list for purging the church’s influence from the army. Years later, Andesha brought home news: Bard was alive, and living in Cecil.'),

    -- 安德莎
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ANDESHA_CHAPTER_CONTENT_TITLE', '安德莎·温德尔'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ANDESHA_CHAPTER_CONTENT_TITLE', 'Andesha Wendell'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ANDESHA_CHAPTER_CONTENT_PARA_1',
     '安德莎·温德尔是裴迪南大公的孙女，也是提丰史上最年轻的狼将军，率领冬狼骑士团驻守帝国西北边陲的冬狼堡。她与玛蒂尔达公主是挚友，冬堡伯爵帕林则是从小照顾她的长辈。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ANDESHA_CHAPTER_CONTENT_PARA_1',
     'Andesha Wendell, granddaughter of Grand Duke Ferdinand, is the youngest Wolf General in Typhon’s history, commanding the Winterwolf Knights at Winterwolf Keep on the empire’s northwestern frontier. Princess Matilda is her close friend, and Palin, Earl of Winterhold, has looked after her since she was a child.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ANDESHA_CHAPTER_CONTENT_PARA_2',
     '战神教会把提丰推向战争时，安德莎看穿了神明的意图：神要的只是战争本身，而投降也是战争的一环。她在塞西尔人的轰炸中身负重伤，随后带着冬狼骑士团、黑旗魔法师团和幸存的常备兵团整体投降，成了第一位在战场上投降的狼将军。消息传回帝都，罗塞塔反而感到了一丝欣慰：她保住的是帝国最精锐的军队，而不是一座注定守不住的城堡。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ANDESHA_CHAPTER_CONTENT_PARA_2',
     'When the Church of the God of War pushed Typhon into war, Andesha saw through the god’s design: it wanted war for its own sake, and surrender, too, was a part of war. Badly wounded in Cecil’s bombardment, she surrendered together with the Winterwolf Knights, the Black Flag Mage Corps and the surviving standing troops, becoming the first Wolf General ever to surrender on the battlefield. When the news reached the capital, Rosetta felt something close to relief: she had preserved the empire’s finest army rather than a castle that could not be held.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ANDESHA_CHAPTER_CONTENT_PARA_3',
     '塞西尔人治好了她的眼伤，眼睛却留下了异样，她主动要求保留这道印记，作为对自己的提醒。归国之后，祖父对她说：她没有守住冬狼堡，却守住了更重要的东西。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ANDESHA_CHAPTER_CONTENT_PARA_3',
     'The Cecilians healed her wounded eye, but it was left changed, and she asked to keep the mark as a reminder to herself. When she came home, her grandfather told her that although she had not held Winterwolf Keep, she had held on to something far more important.'),

    -- 温莎
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINDSOR_CHAPTER_CONTENT_TITLE', '温莎·玛佩尔'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINDSOR_CHAPTER_CONTENT_TITLE', 'Windsor Marpel'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINDSOR_CHAPTER_CONTENT_PARA_1',
     '温莎·玛佩尔是提丰皇家法师协会的会长、罗塞塔大帝的首席法师顾问，地位与公爵相当，是帝国最强大的施法者之一，被尊为传奇法师。她常穿一身淡紫色法袍，仪态端庄稳重。年轻时，她是老法师丹尼尔的第一位学徒，天资卓绝，没过几年，她拿出的成果便连导师都难以驾驭。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINDSOR_CHAPTER_CONTENT_PARA_1',
     'Windsor Marpel is President of Typhon’s Royal Mage Association and chief arcane adviser to Rosetta the Great, ranking alongside the dukes as one of the empire’s mightiest spellcasters, a legendary mage. Poised and composed, she usually wears robes of pale violet. In her youth she was the first apprentice of the old wizard Daniel, and so gifted that within a few years her work had outgrown even her master’s grasp.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINDSOR_CHAPTER_CONTENT_PARA_2',
     '罗塞塔创立的许多设施都出自温莎的设计。她是皇帝改革中最可靠的技术支柱，也是少数知晓宫廷秘密的人——女仆长戴安娜那具来自古代的身体，正是由她定期维护保养。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINDSOR_CHAPTER_CONTENT_PARA_2',
     'Many of the institutions Rosetta founded were designed by Windsor. She is the most dependable technical pillar of the emperor’s reforms and one of the few privy to the court’s secrets: it is she who regularly maintains the ancient body of the head maid, Diana.'),

    -- 帕林
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_PALIN_CHAPTER_CONTENT_TITLE', '帕林·冬堡'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_PALIN_CHAPTER_CONTENT_TITLE', 'Palin Winterhold'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_PALIN_CHAPTER_CONTENT_PARA_1',
     '冬堡伯爵帕林·冬堡是一位强大的战斗法师。他的家族数百年来扎根北方群山，作为冬狼防线的后盾守卫着冬堡；他本人统领黑旗魔法师团，常身披深蓝色的繁星法袍出现在战场上。二十年前北方边境的一次互相援救，让他与裴迪南·温德尔结下了持续至今的友谊，安德莎也一直把他当作可以依靠的长辈。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_PALIN_CHAPTER_CONTENT_PARA_1',
     'Palin Winterhold, Earl of Winterhold, is a formidable battle mage. His family has been rooted in the northern mountains for centuries, guarding Winterhold as the rear bulwark of the Winterwolf line, and he himself commands the Black Flag Mage Corps, taking the field in a deep blue robe patterned with stars. Twenty years ago an exchange of rescues on the northern frontier forged a lasting friendship between him and Ferdinand Wendell, and Andesha has always looked to him as an elder she can rely on.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_PALIN_CHAPTER_CONTENT_PARA_2',
     '冬狼堡陷落前，帕林提前撤回了后方，因此饱受国内贵族的质疑，甚至有人认为他比投降的安德莎还不光彩。他很快用行动作答，指导前线部队制定了一系列对抗塞西尔机械部队的有效战术。冬狼堡失守后，原本位于第二防线的冬堡成了最前线，也成了冬日猎神的战场——当湮灭之创从群峰之上接连升起时，坐镇要塞群指挥全局的正是帕林。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_PALIN_CHAPTER_CONTENT_PARA_2',
     'Because he withdrew before Winterwolf Keep fell, Palin faced harsh doubts at court. Some nobles even called him more disgraceful than Andesha, who had surrendered. He answered with deeds, devising a series of effective tactics for the frontline troops against Cecil’s machines. After the Keep fell, Winterhold, once the second line of defense, became the front line—and the battlefield of the Winter God-Hunt. As Annihilation Scars rose one after another from the peaks, it was Palin who directed the fortress complex.'),

    -- 戴安娜
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_DIANA_CHAPTER_CONTENT_TITLE', '戴安娜'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_DIANA_CHAPTER_CONTENT_TITLE', 'Diana'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_DIANA_CHAPTER_CONTENT_PARA_1',
     '戴安娜是黑曜石宫的女仆长，黑发黑裙，举止优雅，已经效忠奥古斯都家族数百年。宫中都说她从不犯错、永远警醒，也没有人能从她脸上读出她在想什么。她同时调派着提丰的暗探“游荡者”部队：战神教会出事时，正是她的游荡者最先查明神官们遭受了精神污染，也是她亲自监视着教皇马尔姆。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_DIANA_CHAPTER_CONTENT_PARA_1',
     'Diana, head maid of the Obsidian Palace—black-haired, black-clad and impeccably graceful—has served the House of Augustus for centuries. At court they say she never errs and is ever vigilant, and no one can read her thoughts from her face. She also directs Typhon’s covert agents, the Wanderers: when the Church of the God of War began to falter, it was her Wanderers who first confirmed that its priests had suffered mental corruption, and she who personally kept watch over Pope Malm.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_DIANA_CHAPTER_CONTENT_PARA_2',
     '后来人们才知道，戴安娜并不是人类，而是古代刚铎帝国的“铁人”——一名型号老旧的天文台治安员。她在七百年前脱离了铁人网络，丢失了部分记忆；独处时，她会不由自主地一遍遍画下同一幅画，连她自己也说不清那是什么。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_DIANA_CHAPTER_CONTENT_PARA_2',
     'Only later did the world learn that Diana is not human at all, but an "Iron Soldier" of the ancient Gondor Empire—an old-model observatory security unit. She left the Iron network seven centuries ago and lost part of her memory. When alone, she finds herself drawing the same picture over and over, though even she cannot say what it shows.'),

    -- 玛蒂尔达
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_MATILDA_CHAPTER_CONTENT_TITLE', '玛蒂尔达·奥古斯都'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_MATILDA_CHAPTER_CONTENT_TITLE', 'Matilda Augustus'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_MATILDA_CHAPTER_CONTENT_PARA_1',
     '玛蒂尔达·奥古斯都是罗塞塔的女儿、提丰的公主。她举止端庄，言辞得体，对魔导技术格外关注，也颇有专业见识。她曾作为特使率团访问塞西尔，乘坐魔能列车穿越异国，在宴会上与高文·塞西尔从容交谈，回国时带回的远不止外交辞令。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_MATILDA_CHAPTER_CONTENT_PARA_1',
     'Matilda Augustus, Rosetta’s daughter, is a princess of Typhon. Dignified and articulate, she takes a keen and well-informed interest in magitech. As Typhon’s envoy she once led a delegation to Cecil, crossing that foreign land by magic-powered train and conversing at ease with Gawain Cecil at banquets—and she brought home far more than diplomatic niceties.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_MATILDA_CHAPTER_CONTENT_PARA_2',
     '罗塞塔亲自教导这位继承人，让她坐在书房里旁听帝国最机密的谈话、协助处理政务。玛蒂尔达很快学会了父亲的思考方式：谈判桌上能得到多少，取决于在谈判桌外做了多少准备。她身上同样流淌着奥古斯都家族的血，也同样背负着那道诅咒。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_MATILDA_CHAPTER_CONTENT_PARA_2',
     'Rosetta teaches his heir himself, letting her sit in on the empire’s most secret conversations in his study and help with affairs of state. Matilda soon learned to think as her father does: what you win at the negotiating table depends on how well you have prepared away from it. The blood of the House of Augustus runs in her veins—and with it, the curse.'),

    -- 马尔姆
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_MALM_CHAPTER_CONTENT_TITLE', '马尔姆·杜尼特'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_MALM_CHAPTER_CONTENT_TITLE', 'Malm Dunite'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_MALM_CHAPTER_CONTENT_PARA_1',
     '马尔姆·杜尼特是战神教会的教皇。战神是提丰的主流信仰，而马尔姆曾第一个站出来支持罗塞塔加冕；他是罗塞塔的长辈与朋友，也是裴迪南多年的老友。但罗塞塔早就看清：在成为任何人的朋友之前，马尔姆首先是战神的教皇——当神权与皇权出现分歧，一个虔诚的信徒只会忠于自己的神。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_MALM_CHAPTER_CONTENT_PARA_1',
     'Malm Dunite was Pope of the Church of the God of War, the dominant faith of Typhon, and the first to stand up in support of Rosetta’s coronation. He was an elder and a friend to Rosetta and an old companion of Ferdinand. Yet Rosetta had long understood that before he was anyone’s friend, Malm was the War God’s Pope—and when the interests of church and crown diverge, a devout believer stays loyal to his god.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_MALM_CHAPTER_CONTENT_PARA_2',
     '战神陷入疯狂后，异变从教会最上层蔓延开来，马尔姆本人成了污染的源头。他死后，残留的化身仍化作幻影出没，扰乱人们的心智。在冬日猎神中，罗塞塔把捕获的大半化身逐一投入火盆，作为与神之眼交易的祭品，将战神拉到了人间。他说，正因为马尔姆曾是他的朋友，那个顶着朋友面孔的东西才更没有资格留在世上。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_MALM_CHAPTER_CONTENT_PARA_2',
     'When the god descended into madness, the corruption spread from the very top of the church, and Malm himself became its source. Even after his death his lingering avatars haunted the empire as phantoms, clouding men’s minds. During the Winter God-Hunt, Rosetta cast more than half of the captured avatars one by one into a brazier—the offering in his bargain with the Eye of God—and so dragged the God of War into the mortal world. Precisely because Malm had been his friend, he said, the thing wearing his friend’s face had no right to remain.');

-- 地点
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- 奥尔德南
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ORDENAN_CHAPTER_CONTENT_TITLE', '奥尔德南'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ORDENAN_CHAPTER_CONTENT_TITLE', 'Ordenan'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ORDENAN_CHAPTER_CONTENT_PARA_1',
     '奥尔德南是提丰帝国的首都，名字源于古巨人语，意为“千年城”。它作为帝都只有两百年历史：旧帝都奥兰戴尔在大崩塌中沉入地下之前，早有准备的皇帝便已在这片平原上建起了新都。但骄傲的提丰人相信，它会像神话中的巨人王朝一样矗立千年。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ORDENAN_CHAPTER_CONTENT_PARA_1',
     'Ordenan, capital of the Typhon Empire, takes its name from the ancient tongue of the giants: "City of a Thousand Years." It has been the capital for only two centuries—before the old capital of Orandel sank in the Great Collapse, a forewarned emperor had already built a new seat on these plains—yet the proud Typhonese believe it will stand for a millennium, like the giant dynasties of legend.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ORDENAN_CHAPTER_CONTENT_PARA_2',
     '整座城市规划得井然有序，宛如一个棱角分明的几何图形：哥特式尖塔鳞次栉比，帝国大道贯穿全城，常年不散的浓雾笼罩着一切。皇宫黑曜石宫中安放着皇帝的黑铁王座，议会厅的三重尖顶象征皇权、贵族与市民；到了罗塞塔的时代，燃石酸化工厂的百米烟囱也加入了这片天际线。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_ORDENAN_CHAPTER_CONTENT_PARA_2',
     'The whole city is laid out with rigorous order, like a sharp-edged geometric figure: Gothic spires crowd one another, the Imperial Avenue runs through its heart, and a fog that never lifts shrouds everything. The Obsidian Palace houses the emperor’s Black Iron Throne, the three spires of the parliament hall stand for crown, nobility and citizens, and in Rosetta’s day the hundred-meter smokestacks of the acidification works joined the skyline.'),

    -- 冬堡
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINTERHOLD_CHAPTER_CONTENT_TITLE', '冬堡'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINTERHOLD_CHAPTER_CONTENT_TITLE', 'Winterhold'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINTERHOLD_CHAPTER_CONTENT_PARA_1',
     '冬堡是冬堡伯爵家族世代镇守的北方山地要塞，坐落在群峰之间，原本是冬狼堡背后的第二道防线与支援基地。内城建有兵营，一座座法师塔高高耸立，塔顶的法师之眼日夜监视着整个地区。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINTERHOLD_CHAPTER_CONTENT_PARA_1',
     'Winterhold is the mountain fortress of the north, held for generations by the Earls of Winterhold. Set among a ring of peaks, it was originally the second line of defense and the support base behind Winterwolf Keep. Barracks fill its inner city, Mage Tower after Mage Tower rises above them, and the mage eyes at their summits watch the whole region day and night.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINTERHOLD_CHAPTER_CONTENT_PARA_2',
     '冬狼堡陷落后，冬堡成了前线的核心节点，也成了冬日猎神的战场。那一夜，冬堡主峰与周围十余座山峰同时燃起直冲云霄的魔力光柱，数十万超凡者在山脚下连成一张巨大的魔法网络；湮灭之创一发接一发地从峰顶法阵坠向被拉到人间的战神，直到魔力浪涌烧毁了整道防线的魔力通路。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINTERHOLD_CHAPTER_CONTENT_PARA_2',
     'After Winterwolf Keep fell, Winterhold became the linchpin of the front—and the battlefield of the Winter God-Hunt. That night, columns of magical light blazed skyward from the main summit and a dozen peaks around it, while hundreds of thousands of Transcendents below formed one vast magical web. One Annihilation Scar after another fell from the mountaintop arrays upon the God of War, dragged into the mortal world, until the surging mana had burned out every channel of the defensive line.'),

    -- 冬狼堡
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINTERWOLF_KEEP_CHAPTER_CONTENT_TITLE', '冬狼堡'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINTERWOLF_KEEP_CHAPTER_CONTENT_TITLE', 'Winterwolf Keep'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINTERWOLF_KEEP_CHAPTER_CONTENT_PARA_1',
     '冬狼堡是提丰帝国西北边陲的边境要塞，直面昔日的安苏王国、后来的塞西尔帝国，是冬狼防线的核心。温德尔家族的狼将军率领冬狼骑士团世代驻守于此；玛蒂尔达公主出访塞西尔之前，也曾在这里的城墙上与好友安德莎并肩漫步。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINTERWOLF_KEEP_CHAPTER_CONTENT_PARA_1',
     'Winterwolf Keep is the border fortress on Typhon’s northwestern frontier, facing what was once the Kingdom of Ansu and later the Cecil Empire, and the heart of the Winterwolf line. The Wolf Generals of House Wendell and their Winterwolf Knights have garrisoned it for generations. Before her mission to Cecil, Princess Matilda walked its walls beside her friend Andesha.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINTERWOLF_KEEP_CHAPTER_CONTENT_PARA_2',
     '当战神教会把提丰推入战争，冬狼堡首当其冲。守将安德莎在重伤后带领守军投降，塞西尔的旗帜随即在城头升起，战线被推进到提丰境内。对帝国而言，这是一次耻辱，也是一次清醒的止损：冬狼堡丢了，帝国最精锐的军团却保住了。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_WINTERWOLF_KEEP_CHAPTER_CONTENT_PARA_2',
     'When the Church of the God of War dragged Typhon into war, Winterwolf Keep bore the first blow. Its commander, Andesha, gravely wounded, surrendered the garrison. Cecil’s banner soon flew over its walls, and the front moved into Typhon itself. For the empire it was a humiliation, and also a clear-headed cutting of losses: the Keep was lost, but the empire’s finest legions were saved.'),

    -- 奥兰戴尔之喉
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_THROAT_OF_ORANDEL_CHAPTER_CONTENT_TITLE', '奥兰戴尔之喉'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_THROAT_OF_ORANDEL_CHAPTER_CONTENT_TITLE', 'Throat of Orandel'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_THROAT_OF_ORANDEL_CHAPTER_CONTENT_PARA_1',
     '奥兰戴尔之喉是奥兰戴尔地区中央一道坍塌的巨大山谷，提丰的旧帝都就沉没在它的深处。两百年前，地底遗迹失控，梦境之神的碎片突然活化，引发了“大崩塌”；提丰皇室事先得到预警，及时疏散了全城居民，避免了数以万计的伤亡。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_THROAT_OF_ORANDEL_CHAPTER_CONTENT_PARA_1',
     'The Throat of Orandel is a vast collapsed valley at the heart of the Orandel region. Typhon’s old capital lies swallowed in its depths. Two centuries ago an ancient ruin beneath the city ran out of control and a fragment of the God of Dreams suddenly awoke, causing the Great Collapse. Forewarned, the imperial family evacuated the entire city in time and spared tens of thousands of lives.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_THROAT_OF_ORANDEL_CHAPTER_CONTENT_PARA_2',
     '奥古斯都家族的诅咒正是从这里开始的。更少有人知道，那道预警来自梦境教派“永眠者”：他们的总部一直藏在废墟的地下深处，在精神暗示与梦境禁制的掩护下研究禁忌的知识，整整两个世纪无人察觉。直到某个黎明，山谷中传出低沉的轰鸣，有人看见一个蜘蛛般的虚幻巨影正攀上山谷的边缘。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_THROAT_OF_ORANDEL_CHAPTER_CONTENT_PARA_2',
     'The curse of the House of Augustus began here. Fewer know that the warning came from a dream cult, the Eternal Sleepers, whose headquarters lay hidden deep beneath the ruins. Shielded by mental suggestion and dream wards, they pursued forbidden knowledge there for two full centuries without anyone noticing—until one dawn a low roar rose from the valley, and witnesses saw a vast, spider-like phantom climbing over its rim.'),

    -- 黄昏宫殿
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_TWILIGHT_PALACE_CHAPTER_CONTENT_TITLE', '黄昏宫殿'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_TWILIGHT_PALACE_CHAPTER_CONTENT_TITLE', 'Twilight Palace'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_TWILIGHT_PALACE_CHAPTER_CONTENT_PARA_1',
     '黄昏宫殿只存在于奥古斯都家族的梦里。那是一座华美而空旷的宫殿：立柱高耸，穹顶壮观，提丰风格的尖顶窄窗里透进永远停在黄昏的光线，没有侍从，也没有卫兵。一条望不到尽头的走廊两侧，挂满了每一位已经离世的奥古斯都的肖像。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_TWILIGHT_PALACE_CHAPTER_CONTENT_PARA_1',
     'The Twilight Palace exists only in the dreams of the House of Augustus. It is a magnificent, empty place: soaring columns, a vast dome, and narrow pointed windows in the Typhon style that admit a light forever stuck at dusk. There are no servants and no guards. Along a corridor with no visible end hang the portraits of every Augustus who has ever died.'),
    ('zh_Hans_CN', 'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_TWILIGHT_PALACE_CHAPTER_CONTENT_PARA_2',
     '这些画像会开口说话。它们为后人出谋划策，也低声引诱，想把活着的人拖进画框；越往走廊深处，画像越古老，目光也越冷漠。这一切原是神之眼囚禁奥古斯都家族的牢笼——至少它一直这么以为。直到弑神那一天，它才发现宫殿里的先祖之影陪着它演了两百年的戏：第一位被它寄生的奥古斯都大帝终其一生未曾屈服，他的意志顺着血脉，一直传到了罗塞塔身上。'),
    ('en_US',      'LOC_PEDIA_CONCEPTS_PAGE_TSOD_TYPHON_TWILIGHT_PALACE_CHAPTER_CONTENT_PARA_2',
     'The portraits speak. They offer counsel to their descendants, and they whisper temptations too, hoping to pull the living into their frames. The deeper the corridor runs, the older the portraits and the colder their eyes. All of this was meant to be the Eye of God’s prison for the House of Augustus—or so the Eye always believed. Only on the day of the god-slaying did it learn that the shades of the palace had been playing a part for two hundred years: the first Augustus it ever possessed had never submitted, and his will had passed down the bloodline all the way to Rosetta.');

-- 外交台词（基调：阴郁、克制、客气里带刀；master plan §8.4），多数按原著改写（对照见 docs/dialogue-draft.md）。
-- 被玩家消灭、玩家拒绝友好、接受代表团三句保留原稿；照官方甘地的整套 DIPLO_*_LEADER_GANDHI_ANY 做齐。
-- 议程理由句（KUDO / WARNING 的 REASON）由 WP7 写，这里只写 _EXIT 两句。
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- 初次见面
    ('zh_Hans_CN', 'LOC_DIPLO_FIRST_MEET_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '我是罗塞塔·奥古斯都。初次见面，我对任何势力都会保留三份质疑——说说看，你想让提丰相信什么？'),
    ('en_US',      'LOC_DIPLO_FIRST_MEET_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'I am Rosetta Augustus. Every power I meet for the first time gets three measures of doubt from me. So—what would you have Typhon believe?'),
    ('zh_Hans_CN', 'LOC_DIPLO_FIRST_MEET_VISIT_RECIPIENT_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '若你愿意在这大雾天里来奥尔德南，我会很高兴。有些东西，值得你亲眼看看。'),
    ('en_US',      'LOC_DIPLO_FIRST_MEET_VISIT_RECIPIENT_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'If you would come to Ordenan through this fog, I would be glad of it. Some things are worth seeing with your own eyes.'),
    ('zh_Hans_CN', 'LOC_DIPLO_FIRST_MEET_NEAR_INITIATOR_POSITIVE_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '你如此慷慨，这份人情我记下了。提丰不会白白欠人。'),
    ('en_US',      'LOC_DIPLO_FIRST_MEET_NEAR_INITIATOR_POSITIVE_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Such generosity. I will remember the favor—Typhon does not stay in anyone’s debt.'),
    ('zh_Hans_CN', 'LOC_DIPLO_FIRST_MEET_NO_MANS_INFO_EXCHANGE_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '我们浪费了太多精力打听邻居的秘密。交换一下首都的位置吧——省得彼此费心。'),
    ('en_US',      'LOC_DIPLO_FIRST_MEET_NO_MANS_INFO_EXCHANGE_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'We have wasted too much effort prying into our neighbors’ secrets. Let us exchange the locations of our capitals and spare ourselves the trouble.'),

    -- 问候
    ('zh_Hans_CN', 'LOC_DIPLO_GREETING_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '我一向忙得要死。有什么要紧的事，直说。'),
    ('en_US',      'LOC_DIPLO_GREETING_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'I am always run off my feet. If it matters, say it plainly.'),

    -- 友好宣言
    ('zh_Hans_CN', 'LOC_DIPLO_DECLARE_FRIEND_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '你是个强大的对手，但在这件事上，你可以是我们的朋友。签一份友好宣言吧。'),
    ('en_US',      'LOC_DIPLO_DECLARE_FRIEND_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'You are a formidable rival, but in this matter you can be our friend. Let us declare our friendship.'),
    ('zh_Hans_CN', 'LOC_DIPLO_ACCEPT_DECLARE_FRIEND_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '不错，你做了正确的选择。'),
    ('en_US',      'LOC_DIPLO_ACCEPT_DECLARE_FRIEND_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Good. You made the right choice.'),
    ('zh_Hans_CN', 'LOC_DIPLO_REJECT_DECLARE_FRIEND_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '遗憾。我会记住这一点。'),
    ('en_US',      'LOC_DIPLO_REJECT_DECLARE_FRIEND_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Regrettable. I will remember this.'),
    ('zh_Hans_CN', 'LOC_DIPLO_ACCEPT_DECLARE_FRIEND_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '有时候，需要冒点险才能面对未来的挑战。这份友好，我接了。'),
    ('en_US',      'LOC_DIPLO_ACCEPT_DECLARE_FRIEND_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Sometimes one must take a risk to face what is coming. I accept this friendship.'),
    ('zh_Hans_CN', 'LOC_DIPLO_REJECT_DECLARE_FRIEND_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '我甚至不会过多地信任你本人。提丰可以是伙伴，但不会是任何人的消耗品。'),
    ('en_US',      'LOC_DIPLO_REJECT_DECLARE_FRIEND_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'I would not even trust you yourself very far. Typhon can be a partner, but it will be no one’s expendable.'),

    -- 宣战 / 被宣战
    ('zh_Hans_CN', 'LOC_DIPLO_DECLARE_WAR_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '这场战争早晚会来。既然你把它带来了，提丰就把它变成一个机会。'),
    ('en_US',      'LOC_DIPLO_DECLARE_WAR_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'This war was always coming. Since you have brought it, Typhon will make an opportunity of it.'),
    ('zh_Hans_CN', 'LOC_DIPLO_DECLARE_WAR_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '现在是动手的时候了。成本与收益，已经达到了最佳平衡。'),
    ('en_US',      'LOC_DIPLO_DECLARE_WAR_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'The time to act has come. Cost and benefit have reached their best balance.'),

    -- 战败
    ('zh_Hans_CN', 'LOC_DIPLO_DEFEAT_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '必须有人对这一切负责。这一次，轮到我了。'),
    ('en_US',      'LOC_DIPLO_DEFEAT_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Someone must answer for all of this. This time, it is my turn.'),
    ('zh_Hans_CN', 'LOC_DIPLO_DEFEAT_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '两百年的噩梦都没能让奥古斯都低头。你赢了这一局——仅此而已。'),
    ('en_US',      'LOC_DIPLO_DEFEAT_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Two hundred years of nightmares could not make an Augustus bow. You have won this round—nothing more.'),

    -- 代表团
    ('zh_Hans_CN', 'LOC_DIPLO_ACCEPT_DELEGATION_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '代表团可以留下。他们会看到很多东西——我们允许他们看到的那些。'),
    ('en_US',      'LOC_DIPLO_ACCEPT_DELEGATION_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Your delegation may stay. They will see a great deal—everything we allow them to see.'),
    ('zh_Hans_CN', 'LOC_DIPLO_REJECT_DELEGATION_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '告诉你的使节，他可以离开奥尔德南了。我们会体面地把他送到边境。'),
    ('en_US',      'LOC_DIPLO_REJECT_DELEGATION_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Tell your envoy he may leave Ordenan. We will see him to the border with all due dignity.'),
    ('zh_Hans_CN', 'LOC_DIPLO_DELEGATION_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '信函和信使终究不够。我派了一支代表团过去——一个帝国对另一个帝国，该有的礼仪和郑重。'),
    ('en_US',      'LOC_DIPLO_DELEGATION_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Letters and couriers are never enough. I have sent a delegation—the courtesy and gravity one empire owes another.'),

    -- 谴责
    ('zh_Hans_CN', 'LOC_DIPLO_DENOUNCE_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '谴责？被诅咒了两百年的奥古斯都，从来没怕过任何人的审判。'),
    ('en_US',      'LOC_DIPLO_DENOUNCE_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'A denunciation? The Augustus line has been cursed for two hundred years, and it has never feared anyone’s judgment.'),
    ('zh_Hans_CN', 'LOC_DIPLO_DENOUNCE_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '我从未真正信任过你的诚意。对提丰而言，信任你这样的人，代价太过高昂。[NEWLINE]（谴责你）'),
    ('en_US',      'LOC_DIPLO_DENOUNCE_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'I never truly trusted your sincerity. For Typhon, trusting someone like you costs far too much. (Denounces You)'),

    -- 议程：赞许 / 警告后的收尾句（理由句归 WP7）
    ('zh_Hans_CN', 'LOC_DIPLO_KUDO_EXIT_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '你的军队强过我的预估。你和我是一类人——这样的对手，才值得认真算计。'),
    ('en_US',      'LOC_DIPLO_KUDO_EXIT_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Your army is stronger than I estimated. You and I are the same kind—and only a rival like that is worth careful calculation.'),
    ('zh_Hans_CN', 'LOC_DIPLO_WARNING_EXIT_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '我与神明打了两百年交道，被它们附身的人是什么味道，闭着眼睛都闻得出。让你的传教士离开我的城市。'),
    ('en_US',      'LOC_DIPLO_WARNING_EXIT_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'I have dealt with gods for two hundred years. I can smell the ones they possess with my eyes closed. Get your missionaries out of my cities.'),

    -- 同盟
    ('zh_Hans_CN', 'LOC_DIPLO_MAKE_ALLIANCE_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '战争有很多种形式，合作是其中之一。结盟吧——我们图谋着彼此，这样的盟约才牢靠。'),
    ('en_US',      'LOC_DIPLO_MAKE_ALLIANCE_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'War takes many forms, and cooperation is one of them. Let us ally—each of us scheming against the other is what makes the pact hold.'),

    -- 交易（玩家接受 / 拒绝罗塞塔提出的交易后，他的回应）
    ('zh_Hans_CN', 'LOC_DIPLO_ACCEPT_MAKE_DEAL_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '成交。纸张轻薄，契约沉重。'),
    ('en_US',      'LOC_DIPLO_ACCEPT_MAKE_DEAL_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Agreed. Paper is light; a contract is heavy.'),
    ('zh_Hans_CN', 'LOC_DIPLO_REJECT_MAKE_DEAL_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '拒绝就拒绝吧。交易总能在私下进行——总会有人愿意倒向提丰的。'),
    ('en_US',      'LOC_DIPLO_REJECT_MAKE_DEAL_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Refuse, then. Deals can always be made in private—someone will always lean toward Typhon.'),

    -- 和平
    ('zh_Hans_CN', 'LOC_DIPLO_MAKE_PEACE_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '这场火烧得够旺了。你我都不希望它继续烧下去——不如现在就让它熄灭。'),
    ('en_US',      'LOC_DIPLO_MAKE_PEACE_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'This fire has burned hot enough. Neither of us wants it to keep burning—let us put it out now.'),
    ('zh_Hans_CN', 'LOC_DIPLO_MAKE_PEACE_AI_ACCEPT_DEAL_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '这个和平，我只能接受——也乐于接受。'),
    ('en_US',      'LOC_DIPLO_MAKE_PEACE_AI_ACCEPT_DEAL_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'This peace I can only accept—and I accept it gladly.'),
    ('zh_Hans_CN', 'LOC_DIPLO_MAKE_PEACE_AI_REFUSE_DEAL_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '提丰不能接受。这一条，没有商量的余地。'),
    ('en_US',      'LOC_DIPLO_MAKE_PEACE_AI_REFUSE_DEAL_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Typhon cannot accept that. There is no room to bargain on this.'),

    -- 开放边境
    ('zh_Hans_CN', 'LOC_DIPLO_OPEN_BORDERS_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '我们毗邻而居，各有所产，本应互通有无。开放边境吧，让商路先通起来。'),
    ('en_US',      'LOC_DIPLO_OPEN_BORDERS_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'We are neighbors, each with our own goods, and ought to trade. Open the borders and let the trade roads run first.'),
    ('zh_Hans_CN', 'LOC_DIPLO_ACCEPT_OPEN_BORDERS_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '边境可以开放。享受权利，便要承担对等的义务和责任。'),
    ('en_US',      'LOC_DIPLO_ACCEPT_OPEN_BORDERS_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'The border can be opened. Whoever enjoys a right bears an equal duty.'),
    ('zh_Hans_CN', 'LOC_DIPLO_REJECT_OPEN_BORDERS_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '除了提丰的土地，别的都可以谈。边境，不在其列。'),
    ('en_US',      'LOC_DIPLO_REJECT_OPEN_BORDERS_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Anything but Typhon’s land can be discussed. The border is not on the table.'),

    -- 边境驻军警告
    ('zh_Hans_CN', 'LOC_DIPLO_WARNING_TOO_MANY_TROOPS_NEAR_ME_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '你的军队，还要在我的边境上驻扎多久？我希望得到你的直接答复。'),
    ('en_US',      'LOC_DIPLO_WARNING_TOO_MANY_TROOPS_NEAR_ME_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'How much longer will your army stay on my border? I would like a direct answer.');
