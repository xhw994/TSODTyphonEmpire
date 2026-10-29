-- WP8 Civilopedia articles, leader quotes, loading-screen narration, and diplomatic lines (InGame UpdateText).
-- Tag conventions follow the official CivilopediaSupport.lua FindChapterTextKey / FindPageTextKey and Gandhi's diplomatic lines; values are not hard-coded, and each pack's DESCRIPTION governs.

-- Civilization: Typhon Empire
-- PARA_1 is the civ's quote (the official civ pages have no quote slot, so it goes in the first paragraph of the history chapter)
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
     'Typhon’s armies are famed for their Transcendents. From the age of six, children with even modest talent are selected and drilled for a decade or more in one or two spells, until they can be massed by the thousand into Transcendent legions. Knightly orders such as the Winterwolf, Iron River and Black Steel Knights lead the charge, while mage corps such as the Black Flag Mage Corps ride beside them. Massed together, their "legion-class spells" can decide the fate of a fortress in a short time. A web of Mage Towers across the cities registers and senses every Transcendent in the realm, keeping this war machine firmly in the crown’s hands.'),

    ('zh_Hans_CN', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_5',
     '帝国最深的危机来自它自己的信仰。战神教会从最上层开始失控，神官接连陷入疯狂，连教皇马尔姆·杜尼特也成了异变的源头；一份被篡改的外交文书让提丰与塞西尔帝国在神明的推动下兵戎相见，边境要塞冬狼堡随之陷落。罗塞塔没有等待神明的宽恕。他与寄生在家族梦境中的“神之眼”做了一笔交易，把战神的本体拉到人间，又在冬堡群山上同时释放了复数的“湮灭之创”。在塞西尔人的协助下，失控的神明最终陨落——这一役被后人称为“冬日猎神”。'),
    ('en_US', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_5',
     'The empire’s gravest crisis came from its own faith. The Church of the God of War began to unravel from the top: priests fell into madness one after another, and even Pope Malm Dunite became a source of the corruption. A tampered diplomatic dispatch drove Typhon and the Cecil Empire into a war the god itself had engineered, and the border fortress of Winterwolf Keep fell. Rosetta did not wait for divine mercy. He struck a bargain with the Eye of God, the entity that had long haunted his family’s dreams, dragged the God of War down into the mortal world, and unleashed several Annihilation Scars at once from the peaks of Winterhold. With Cecil’s help the maddened god was finally brought down—a battle later remembered as the Winter God-Hunt.'),

    ('zh_Hans_CN', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_6',
     '战争结束后，提丰与昔日的对手坐上同一张谈判桌，加入了人类诸国的联盟与神权理事会，并在国内推行“去神圣化”，把信仰与国家权力一点点剥离。燃石酸化工厂产出的化肥“丰饶之尘”让凡人不再仰赖丰饶诸神的恩赐。这个曾经以神眷骑士为荣的帝国，如今正试着学会只依靠自己。'),
    ('en_US', 'LOC_PEDIA_CIVILIZATIONS_PAGE_CIVILIZATION_TSOD_TYPHON_EMPIRE_CHAPTER_HISTORY_PARA_6',
     'After the war Typhon sat at the same table as its former enemy, joined the alliance of human nations and the Theocratic Council, and began a policy of Desanctification at home, prying faith and state apart. The fertilizer produced by the Burnstone Acidification Works, the Dust of Plenty, freed mortals from depending on the blessings of the gods of plenty. An empire that once took pride in god-favored knights is now learning to rely on no one but itself.');

-- Leader: Rosetta Augustus
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
     '提丰的玩法围绕学院与军营展开。法师塔取代学院，造价更低，并从相邻的军营区域获得大量[ICON_SCIENCE]科技值相邻加成，因此最好把两者成对规划；法师塔本身拥有城防、能发动远程打击，还会让敌方间谍更难得手。拥有学院的城市训练的陆地军事单位自带一次免费升级；学院和圣地会额外产出[ICON_GREATGENERAL]大将军点数；建有军营的城市不受宗教压力影响，无论对手派来多少传教士，你的后方都能保持稳定。[NEWLINE][NEWLINE]提丰战斗法师取代弩手。它不会升级，但在研究弹道学与高级弹道学之后会自动变强，并保留已获得的全部升级；让战斗法师并肩作战，还能进一步提高[ICON_RANGED]远程攻击力。燃石酸化工厂取代工厂，提供更多[ICON_PRODUCTION]生产力和额外的[ICON_SCIENCE]科技值，并让本城的农场产出更多[ICON_FOOD]食物。[NEWLINE][NEWLINE]罗塞塔本人让提丰在每个新时代获得随机的[ICON_TECHBOOSTED]尤里卡和[ICON_CIVICBOOSTED]鼓舞，进入黑暗时代时收获反而更多；在战斗中击杀敌方单位时，若你尚未研究该单位的前置科技，便会立即获得该科技的[ICON_TECHBOOSTED]尤里卡。主动与科技领先的对手交战，是提丰追赶的捷径。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_DETAILED_BODY',
     'Typhon’s play revolves around Campuses and Encampments. The Mage Tower replaces the Campus, costs less, and earns a major [ICON_SCIENCE] Science adjacency bonus from neighboring Encampment districts, so plan the two in pairs. The tower also has its own defenses, can make ranged strikes, and makes life harder for enemy spies. Land military units trained in a city with a Campus receive a free promotion. Campuses and Holy Sites generate extra [ICON_GREATGENERAL] Great General points, and cities with an Encampment ignore religious pressure, keeping your heartland stable no matter how many missionaries your rivals send.[NEWLINE][NEWLINE]The Typhon Battle Mage replaces the Crossbowman. It never upgrades, but grows stronger on its own once you research Ballistics and Advanced Ballistics, keeping every promotion it has earned. Battle Mages fighting side by side gain additional [ICON_RANGED] Ranged Strength. The Burnstone Acidification Works replaces the Factory, providing more [ICON_PRODUCTION] Production plus [ICON_SCIENCE] Science, and makes the city’s Farms yield more [ICON_FOOD] Food.[NEWLINE][NEWLINE]Rosetta himself grants a random [ICON_TECHBOOSTED] Eureka and [ICON_CIVICBOOSTED] Inspiration with each new era, and even more when a Dark Age begins. Killing an enemy unit whose prerequisite technology you have not yet researched immediately grants that technology’s [ICON_TECHBOOSTED] Eureka. Picking fights with more advanced rivals is Typhon’s shortcut to catching up.'),

    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_1',
     '罗塞塔·奥古斯都是提丰帝国的皇帝，史称“罗塞塔大帝”。他已步入中年，身形消瘦，神情阴郁，一头灰色短卷发，眼窝深陷，目光却像鹰一样锐利。他习惯穿镶金边的黑色外套，或披一件用高阶魔物皮毛制成的黑色大氅，喜欢坐在背光的高背椅里；见过他的人常说，那姿态像一头以阴影为巢的猛兽。很少有人记得，这位皇帝本人也是一位强大的施法者：刺客曾闯进他的书房，是他亲手用奥术电弧与屏障将其击退的。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_1',
     'Rosetta Augustus, Emperor of Typhon, is remembered as Rosetta the Great. Middle-aged, gaunt and somber, with short curly grey hair, deep-set eyes and the sharp gaze of a hawk, he favors a gold-trimmed black coat or a black cloak made from the pelt of some fearsome magical beast, and prefers to sit in a high-backed chair with the light behind him. Those who have met him say he resembles a predator that makes its den in the shadows. Few remember that the emperor is also a formidable spellcaster: when assassins once broke into his study, it was he who drove them off with arcs of arcane lightning and warding barriers.'),

    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_2',
     '罗塞塔继位后推行了一系列深刻的改革。他削弱分封贵族，把立法权收归皇室，重新核定全国领主的土地；他用职业常备军取代征召兵，把超凡者当作可以批量培养的士兵；他让平民识字，用田地契约法重塑乡村，又下令在帝国各个产粮区就地兴建燃石酸化工厂。改革触动了太多人的利益，他便用强硬的手腕压住反弹，再用改革带来的红利安抚那些心怀不满的封臣——或者干脆让跟不上时代的人被时代淘汰。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_2',
     'Upon taking the throne Rosetta launched sweeping reforms. He curbed the feudal nobility, claimed lawmaking for the crown and reassessed every lord’s lands. He replaced levies with a professional standing army and treated Transcendents as soldiers who could be trained in quantity. He taught commoners to read, reshaped the countryside with a land-contract law, and ordered Burnstone Acidification Works built in every grain-growing region of the empire. The reforms threatened too many interests, so he crushed resistance with an iron hand, then used the profits of reform to placate resentful vassals—or simply let those who could not keep up with the times fall behind.'),

    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_3',
     '皇帝的冷静背后，是奥古斯都家族隐藏了两百年的秘密。自奥兰戴尔大崩塌以来，梦境之神的一块碎片——“神之眼”——便寄生在家族的梦里，这道诅咒终将把族人引向疯狂。死去的奥古斯都们被困在梦中“黄昏宫殿”的画像里，向后人低语献策，也试图把他们拖进画框。神之眼曾问罗塞塔为何还没有疯，他只回答了一句：“我们，有着超乎你们想象的韧性。”事实上，这个家族在梦中与它周旋了整整两个世纪，一面假装屈服，一面偷取它的知识。在黄昏宫殿的噩梦里，奥古斯都们从未屈服。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_3',
     'Behind the emperor’s composure lay a secret the House of Augustus had kept for two centuries. Ever since the Great Collapse of Orandel, a fragment of the God of Dreams known as the Eye of God had lived as a parasite in the family’s dreams, a curse that would sooner or later lead its members into madness. The dead of the line were trapped in the portraits of the Twilight Palace, a realm of dreams where they whispered counsel to their descendants and tried to drag them into the frames. When the Eye asked Rosetta why he had not yet gone mad, he answered only: "We are far more resilient than you can imagine." In truth the family had played a game with it for two hundred years, feigning submission while stealing its knowledge. In the nightmares of the Twilight Palace, the House of Augustus never yielded.'),

    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_4',
     '罗塞塔从不拒绝任何可用之物。他会利用邪教、利用诅咒，也会利用对手的技术：第一次见到塞西尔的魔导车时，他的第一反应是把它拆成零件研究；潜伏多年的梦境教派“永眠者”中有人前来投奔时，他没有赶尽杀绝，而是选择招抚，因为在他看来，知识本身是无罪的。他与高文·塞西尔既是对手，也是彼此最清醒的观察者——在罗塞塔眼里，战争有很多种形式，“合作”也是其中之一。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_4',
     'Rosetta never refuses anything that can be put to use. He has made use of cults, of curses, and of his rivals’ technology: the first time he saw a Cecil magitech car, his first thought was to have it taken apart. When members of the Eternal Sleepers, a dream cult long hidden in his empire, came over to his side, he chose to take them in rather than wipe them out, for in his view knowledge itself is innocent. He and Gawain Cecil were rivals and also each other’s most clear-eyed observers. To Rosetta, war takes many forms, and "cooperation" is one of them.'),

    ('zh_Hans_CN', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_5',
     '罗塞塔一生最大的赌局，是战神教会失控后的那场“冬日猎神”。他与神之眼达成交易，把老友、战神教皇马尔姆·杜尼特残留的化身逐一投入火盆作为祭品，硬生生将战神的本体拉到人间；与此同时，黑曜石禁军清洗了失控的神官，冬堡群山同时释放出复数的“湮灭之创”。最终，在塞西尔人的协助下，战神陨落。战后，罗塞塔带领提丰加入人类诸国的联盟与神权理事会，推行去神圣化。对这位皇帝而言，神明从来都不是可靠的保护者。'),
    ('en_US', 'LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_CHAPTER_HISTORY_PARA_5',
     'The greatest gamble of Rosetta’s life came after the Church of the God of War lost its mind: the Winter God-Hunt. He struck a bargain with the Eye of God, cast the lingering avatars of his old friend Malm Dunite, the God of War’s Pope, one by one into a brazier as offerings, and so dragged the God of War himself into the mortal world. At the same time the Obsidian Guard purged the maddened priesthood, and the mountains of Winterhold unleashed several Annihilation Scars at once. In the end, with the help of the Cecil Empire, the god fell. After the war Rosetta led Typhon into the alliance of human nations and the Theocratic Council and set about Desanctification. To this emperor, the gods were never reliable protectors.');

-- Loading-screen narration
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_LOADING_INFO_LEADER_TSOD_ROSETTA_AUGUSTUS',
     '罗塞塔·奥古斯都陛下，提丰的皇帝，黑铁王座的主人。两百年来，您的家族在噩梦里与神明周旋，却从未低头。如今，用学院锻造超凡者的兵团，用燃石喂饱您的子民，把敌人的每一项发明都化为己用。算清每一份代价，也别害怕押上一切——让世界看看，凡人能走多远。'),
    ('en_US', 'LOC_LOADING_INFO_LEADER_TSOD_ROSETTA_AUGUSTUS',
     'Your Imperial Majesty Rosetta Augustus, Emperor of Typhon, master of the Black Iron Throne. For two hundred years your house has dueled with a god in its nightmares and never once bowed. Now forge legions of Transcendents in your academies, feed your people with burnstone, and turn every invention of your enemies to your own ends. Weigh every cost, yet never fear to wager everything—show the world how far mortals can go.');

-- Unique unit: Typhon Battle Mage
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_PEDIA_UNITS_PAGE_UNIT_TSOD_BATTLE_MAGE_CHAPTER_HISTORY_PARA_1',
     '提丰战斗法师是帝国“量产超凡者”政策的产物。他们大多天赋平平，放在传统法师眼中或许连学徒都不够格，却从童年起便被集中起来，十几年如一日地只练熟一两种战斗法术。单独一人并不起眼，成千上万人集结起来，却能凝聚成令敌军胆寒的“军团级法术”。'),
    ('en_US', 'LOC_PEDIA_UNITS_PAGE_UNIT_TSOD_BATTLE_MAGE_CHAPTER_HISTORY_PARA_1',
     'The Typhon Battle Mage is the product of the empire’s policy of "mass-produced Transcendents." Most have little talent—traditional wizards might not even accept them as apprentices—but from childhood they are gathered together and drilled for a decade or more in just one or two combat spells. One alone is unremarkable. Thousands massed together can weave "legion-class spells" that strike terror into any army.'),

    ('zh_Hans_CN', 'LOC_PEDIA_UNITS_PAGE_UNIT_TSOD_BATTLE_MAGE_CHAPTER_HISTORY_PARA_2',
     '战斗法师很少单独行动。以黑旗魔法师团为代表的骑乘法师团与骑士团同步推进，为冲锋提供不间断的远程支援；军中的“顾问学者”往往也是战斗法师或随军的战神祭司。与塞西尔交战时，冬堡伯爵帕林麾下的战斗法师很快发现，足够高阶的光束法术可以穿透对方战车的护盾，并据此调整了战术。'),
    ('en_US', 'LOC_PEDIA_UNITS_PAGE_UNIT_TSOD_BATTLE_MAGE_CHAPTER_HISTORY_PARA_2',
     'Battle Mages rarely fight alone. Mounted mage corps such as the Black Flag Mage Corps advance in step with the knightly orders, giving a charge unbroken ranged support, and the "scholar advisors" attached to an army are usually Battle Mages or chaplains of the God of War. In the war with Cecil, the Battle Mages of Palin, Earl of Winterhold, soon learned that sufficiently powerful beam spells could pierce the shields of Cecil’s war machines, and adjusted their tactics accordingly.'),

    ('zh_Hans_CN', 'LOC_PEDIA_UNITS_PAGE_UNIT_TSOD_BATTLE_MAGE_CHAPTER_HISTORY_PARA_3',
     '与别国的军队不同，提丰并不急于把老兵换成新兵种。帝国的法术、装备与战术随时代不断更新，而这些身经百战的施法者始终留在队列里，把每一场战斗的经验带进下一场战争。他们最可怕的力量，是曾在冬堡群山上齐射、击伤了神明的战略法术——“湮灭之创”。'),
    ('en_US', 'LOC_PEDIA_UNITS_PAGE_UNIT_TSOD_BATTLE_MAGE_CHAPTER_HISTORY_PARA_3',
     'Unlike other armies, Typhon’s is in no hurry to replace its veterans with new kinds of troops. The empire’s spells, equipment and tactics are refreshed with each age, while these battle-hardened casters stay in the ranks, carrying the lessons of every battle into the next war. Their most fearsome power is the strategic spell once fired in volleys from the peaks of Winterhold to wound a god: the Annihilation Scar.');

-- Unique district: Mage Tower
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

-- Unique building: Burnstone Acidification Works
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    ('zh_Hans_CN', 'LOC_PEDIA_BUILDINGS_PAGE_BUILDING_TSOD_BURNSTONE_WORKS_CHAPTER_HISTORY_PARA_1',
     '燃石是提丰东北海岸常见的一种灰白色沉积岩，经过酸化处理后能变成高效的化肥，提丰人称之为“丰饶之尘”。罗塞塔下令在帝国所有的产粮区就地兴建燃石酸化工厂，让化肥不必长途运输便能撒进田里，农场与养猪场也随之一同兴旺起来。'),
    ('en_US', 'LOC_PEDIA_BUILDINGS_PAGE_BUILDING_TSOD_BURNSTONE_WORKS_CHAPTER_HISTORY_PARA_1',
     'Burnstone is a greyish-white sedimentary rock common along Typhon’s northeastern coast. Acidified, it becomes a potent fertilizer the Typhonians call the Dust of Plenty. Rosetta ordered Burnstone Acidification Works built on site in every grain-growing region of the empire, so that fertilizer could go straight into the fields without long hauls, and farms and pig farms flourished together.'),

    ('zh_Hans_CN', 'LOC_PEDIA_BUILDINGS_PAGE_BUILDING_TSOD_BURNSTONE_WORKS_CHAPTER_HISTORY_PARA_2',
     '燃石的价值远不止于农业。它是丰饶之尘与晶石基质的原料，酸化时产生的副产物“灰晶”也是一种魔导材料；一座燃石矿场甚至让衰败的莫比乌斯港重获生机。奥尔德南的燃石酸化工厂竖着百米高的烟囱，与纺织厂、印刷厂和符文铸造厂比邻而立，帝都终年不散的雾气里，从此也混进了工厂的怪味。'),
    ('en_US', 'LOC_PEDIA_BUILDINGS_PAGE_BUILDING_TSOD_BURNSTONE_WORKS_CHAPTER_HISTORY_PARA_2',
     'Burnstone’s value goes far beyond farming. It is the raw material for both the Dust of Plenty and crystal matrices, and the byproduct of acidification, "grey crystal," is itself a magitech material. A single burnstone quarry even brought the declining Port Mobius back to life. In Ordenan the acidification works raise hundred-meter smokestacks beside textile mills, printing houses and rune foundries, and the fog that never leaves the capital now carries their peculiar smell.'),

    ('zh_Hans_CN', 'LOC_PEDIA_BUILDINGS_PAGE_BUILDING_TSOD_BURNSTONE_WORKS_CHAPTER_HISTORY_PARA_3',
     '就连塞西尔人也承认，提丰的燃石酸化工厂比他们的炼金工厂早了五年。更深远的影响落在信仰上：凡人靠丰饶之尘就能吃饱饭，便绕开了“神恩”，丰饶诸神的神国也因此滋生腐化。一座化肥工厂，就这样成了提丰走向去神圣化的伏笔。'),
    ('en_US', 'LOC_PEDIA_BUILDINGS_PAGE_BUILDING_TSOD_BURNSTONE_WORKS_CHAPTER_HISTORY_PARA_3',
     'Even the Cecilians admitted that Typhon’s acidification works were five years ahead of their own alchemical factories. The deeper consequences were spiritual: once mortals could feed themselves with the Dust of Plenty, they had bypassed "divine grace," and corruption began to fester in the divine kingdoms of the gods of plenty. A fertilizer plant thus became a quiet prelude to Typhon’s Desanctification.');

-- Diplomatic lines (tone: grim, restrained, polite with a blade in it; master plan §8.4); most are adapted from the original work (comparison in docs/dialogue-draft.md).
-- The three lines for being destroyed by the player, the player refusing friendship, and accepting a delegation are kept from the original draft; the full set of DIPLO_*_LEADER_GANDHI_ANY entries is covered, following official Gandhi.
-- Reason sentences for agendas (the REASON of KUDO / WARNING) are written by WP7; only the two _EXIT lines are written here.
INSERT OR REPLACE INTO LocalizedText (Language, Tag, Text) VALUES
    -- First meeting
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

    -- Greetings
    ('zh_Hans_CN', 'LOC_DIPLO_GREETING_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '我一向忙得要死。有什么要紧的事，直说。'),
    ('en_US',      'LOC_DIPLO_GREETING_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'I am always swamped. If it matters, say it plainly.'),

    -- Declaration of friendship
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
     'I would not even trust you personally very far. Typhon can be a partner, but never anyone’s expendable asset.'),

    -- Declaring war / being declared war on
    ('zh_Hans_CN', 'LOC_DIPLO_DECLARE_WAR_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '这场战争早晚会来。既然你把它带来了，提丰就把它变成一个机会。'),
    ('en_US',      'LOC_DIPLO_DECLARE_WAR_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'This war was always coming. Since you have brought it, Typhon will make an opportunity of it.'),
    ('zh_Hans_CN', 'LOC_DIPLO_DECLARE_WAR_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '现在是动手的时候了。成本与收益，已经达到了最佳平衡。'),
    ('en_US',      'LOC_DIPLO_DECLARE_WAR_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'The time to act has come. Cost and benefit have reached their best balance.'),

    -- Defeat
    ('zh_Hans_CN', 'LOC_DIPLO_DEFEAT_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '必须有人对这一切负责。这一次，轮到我了。'),
    ('en_US',      'LOC_DIPLO_DEFEAT_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Someone must answer for all of this. This time, it is my turn.'),
    ('zh_Hans_CN', 'LOC_DIPLO_DEFEAT_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '两百年的噩梦都没能让奥古斯都低头。你赢了这一局——仅此而已。'),
    ('en_US',      'LOC_DIPLO_DEFEAT_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Two hundred years of nightmares could not make an Augustus bow. You have won this round—nothing more.'),

    -- Delegation
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

    -- Condemnation
    ('zh_Hans_CN', 'LOC_DIPLO_DENOUNCE_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '谴责？被诅咒了两百年的奥古斯都，从来没怕过任何人的审判。'),
    ('en_US',      'LOC_DIPLO_DENOUNCE_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'A denunciation? The Augustus line has been cursed for two hundred years, and it has never feared anyone’s judgment.'),
    ('zh_Hans_CN', 'LOC_DIPLO_DENOUNCE_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '我从未真正信任过你的诚意。对提丰而言，信任你这样的人，代价太过高昂。[NEWLINE]（谴责你）'),
    ('en_US',      'LOC_DIPLO_DENOUNCE_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'I never truly trusted your sincerity. For Typhon, trusting someone like you costs far too much. (Denounces You)'),

    -- Agenda: closing line after praise / warning (reason sentences are by WP7)
    ('zh_Hans_CN', 'LOC_DIPLO_KUDO_EXIT_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '你的军队强过我的预估。你和我是一类人——这样的对手，才值得认真算计。'),
    ('en_US',      'LOC_DIPLO_KUDO_EXIT_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Your army is stronger than I estimated. You and I are of a kind—and only a rival like you is worth careful calculation.'),
    ('zh_Hans_CN', 'LOC_DIPLO_WARNING_EXIT_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '我与神明打了两百年交道，被它们附身的人是什么味道，闭着眼睛都闻得出。让你的传教士离开我的城市。'),
    ('en_US',      'LOC_DIPLO_WARNING_EXIT_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'I have dealt with gods for two hundred years. I can smell the ones they possess with my eyes closed. Get your missionaries out of my cities.'),

    -- Alliance
    ('zh_Hans_CN', 'LOC_DIPLO_MAKE_ALLIANCE_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '战争有很多种形式，合作是其中之一。结盟吧——我们图谋着彼此，这样的盟约才牢靠。'),
    ('en_US',      'LOC_DIPLO_MAKE_ALLIANCE_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'War takes many forms, and cooperation is one of them. Let us ally—each of us scheming against the other is what makes the pact hold.'),

    -- Trade (his response after the player accepts or rejects a trade Rosetta offers)
    ('zh_Hans_CN', 'LOC_DIPLO_ACCEPT_MAKE_DEAL_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '成交。纸张轻薄，契约沉重。'),
    ('en_US',      'LOC_DIPLO_ACCEPT_MAKE_DEAL_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Agreed. Paper is light; a contract is heavy.'),
    ('zh_Hans_CN', 'LOC_DIPLO_REJECT_MAKE_DEAL_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '拒绝就拒绝吧。交易总能在私下进行——总会有人愿意倒向提丰的。'),
    ('en_US',      'LOC_DIPLO_REJECT_MAKE_DEAL_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Refuse, then. Deals can always be made in private—someone will always lean toward Typhon.'),

    -- Peace
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

    -- Open borders
    ('zh_Hans_CN', 'LOC_DIPLO_OPEN_BORDERS_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '我们毗邻而居，各有所产，本应互通有无。开放边境吧，让商路先通起来。'),
    ('en_US',      'LOC_DIPLO_OPEN_BORDERS_FROM_AI_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'We are neighbors, each with our own goods, and ought to trade. Open the borders and let the trade routes connect first.'),
    ('zh_Hans_CN', 'LOC_DIPLO_ACCEPT_OPEN_BORDERS_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '边境可以开放。享受权利，便要承担对等的义务和责任。'),
    ('en_US',      'LOC_DIPLO_ACCEPT_OPEN_BORDERS_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'The border can be opened. Whoever enjoys a right bears an equal duty.'),
    ('zh_Hans_CN', 'LOC_DIPLO_REJECT_OPEN_BORDERS_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '除了提丰的土地，别的都可以谈。边境，不在其列。'),
    ('en_US',      'LOC_DIPLO_REJECT_OPEN_BORDERS_FROM_HUMAN_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'Anything but Typhon’s land can be discussed. The border is not on the table.'),

    -- Border garrison warning
    ('zh_Hans_CN', 'LOC_DIPLO_WARNING_TOO_MANY_TROOPS_NEAR_ME_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     '你的军队，还要在我的边境上驻扎多久？我希望得到你的直接答复。'),
    ('en_US',      'LOC_DIPLO_WARNING_TOO_MANY_TROOPS_NEAR_ME_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY',
     'How much longer will your army stay on my border? I would like a direct answer.');
