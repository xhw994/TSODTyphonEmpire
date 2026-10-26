# 代码注释迁出的说明

代码注释只留「为什么这样写」的短句；放不下、又值得留的依据（设计取舍、官方先例、原作章节）按源文件分节记在这里。
实机验证过的引擎事实见 `test-log.md`，待测项见 `test-plan-I1.md`，这里不重复。

## src/Core/TsoDTE_Agenda_AI.sql

- 「喜欢」：陆军实力不弱于他。照官方隐藏议程「常备军」`AGENDA_HIGH_STANDING_ARMY` 的 `REQUIREMENT_PLAYER_MILITARY_STRENGTH_LEAD`（`MinimumDelta` 5、`DomainType` `DOMAIN_LAND`）；`StrengthRatio` 由官方的 1.2（明显更强）降到 1.0（不弱于），对应 master plan §8.1「军力不弱于自己」。官方常备军带 `HiddenAgenda`，本议程公开，不带。
- 态度值：喜欢 +8（官方公开议程的正向值多在 7～12，如 `AGENDA_MODIFIER_SAME_RELIGION` 8）。「厌恶」向他的城市传播宗教的文明取 -12：把刚果姆本巴 `AGENDA_MODIFIER_RELIGION_RECEIVED`（+12）反过来，官方萨拉丁 `AGENDA_SULTAN_RELIGION_RECEIVED` 正是同一条件、-12。
- `StatementKey` 照官方「按议程命名」的格式（`KUDO` / `WARNING` + `LEADER_ANY_REASON_AGENDA` + 议程名，同 `AGENDA_HIGH_STANDING_ARMY`）。整体结构沿用塞西尔「真理探求」与官方历史议程（Leaders.xml / Agendas.xml）。
- AI 清单挂载先例：`AlexanderPreferWar` → `TRAIT_LEADER_TO_WORLDS_END`，`CleopatraDistricts` → `TRAIT_LEADER_MEDITERRANEAN`，`VictoriaUnits` → `TRAIT_LEADER_PAX_BRITANNICA`；议程自身的清单 `StandingArmyPseudoYields` → `TRAIT_AGENDA_PREFER_STANDING_ARMY`（走 `AgendaType` 列）。
- 宗教倾向「中等」：不挂 `ForbidReligiousVictory` / `LowReligiousPreferenceYields`（低），也不挂 `FavorReligiousVictory`（高），只偏好圣地。

## src/Core/TsoDTE_Building_Burnstone.sql

- 矿山、采石场 +2 生产力（第 8 节）：原作依据第 747 章「燃石的开采矿场」。数值：鲁尔河谷是奇观，给 +1；特色建筑取 +2，实测后再调。挂在 `BuildingModifiers` 上，只作用于本城地块。
- I1 第二轮实测：草原丘陵矿山（工业化后）是 2 粮 4 锤 = 丘陵 1 + 矿山 1 + 学徒 1 + 工业化 1，+2 没加上，同文件农场 +5 生效。第一版是一个修正 + `REQUIREMENTSET_TEST_ANY` 套两条官方需求（`REQUIRES_PLOT_HAS_MINE` / `_QUARRY`）；改成与农场同形：矿山、采石场各一个修正、各一个 `TEST_ALL` 需求组，需求自己定义（`REQUIREMENT_PLOT_IMPROVEMENT_TYPE_MATCHES`，同官方 `REQUIRES_PLOT_HAS_FARM`）。
- 不做：排碳、烧煤（master plan §6.3）。

## src/Core/TsoDTE_CivTrait.sql

- 先例：马普切 `TRAIT_TOQUI_UNIT_EXPERIENCE_FROM_GOVERNOR`（玩家 → 本玩家城市 ATTACH → 城市训练的单位授予能力）；`CORBACI_FREE_PROMOTION` / `OKIHTCITAW_FREE_PROMOTION`（能力内的一次性升级）；`ABILITY_OLIGARCHY_LEGACY_MELEE_BUFF` 等官方无说明能力（只写 `Inactive`）。
- 大将军点数：内层照抄万神殿「神圣之光」`DIVINE_SPARK_*_MODIFIER`（`MODIFIER_SINGLE_CITY_DISTRICTS_ADJUST_GREAT_PERSON_POINTS`），类别换成 `GREAT_PERSON_CLASS_GENERAL`。
- 宗教压力：内层照抄总督莫克沙「神之堡垒」`CARDINAL_CITADEL_OF_GOD_PRESSURE`（`MODIFIER_SINGLE_CITY_RELIGION_IGNORE_PRESSURE`，`Enable=true`）。

## src/Core/TsoDTE_Compat_Cecil.sql

- `InitialValue = 6`：官方 `MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER` 的正向 `InitialValue` 共 85 条（Base 与 DLC 的 Gameplay/Data 统计），中位数为 6，取中值，不自拟大数。需实证（test-plan §11 A1）。
- 台词未做：官方外交台词的结构没有对方领袖这一维度（`DiplomacyStatements` 全部 XML 里的占位符只有 `$(LEADER)` / `$(MOOD)` / `$(REASON)`，`<Leader>` 列全是 `ANY`），「罗塞塔遇到高文」无法单独配置。按 impl plan §6.2 的退路，只保留态度说明文本。
- 修正挂在各自的领袖特性上（主体是拥有该特性的玩家），条件作用于 Subject（态度的对象），`REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES` 判断对方是哪位领袖。不做外交惩罚（核武相关，用户定：以可莉 mod 为准）。

## src/Core/TsoDTE_Congress.sql

- 官方 `WC_RES_WORLD_RELIGION` 的 Favored（Expansion2_AI.xml）：`DevoutResolutions`、`EnthusiasticDiscipleResolutions`、`SaintResolutions`、`ZealotResolutions`、`DharmaResolutions` 为 true；`IntolerantResolutions`、`AyyubidDynastyResolutions`、`CounterReformerResolutions` 为 false。Favored 只到「决议」一级，本文件 Favored=1 对应选项 1 是按这个对照推断的。
- 决议行：`EarliestEra` = `ERA_MODERN`，与「世界宗教」（`LatestEra` = `ERA_INDUSTRIAL`）首尾衔接；`LatestEra` 不设，同官方 `WC_RES_DIPLOVICTORY` 等现代决议。`InjectionOnly` 照官方（缺省 0）；`AITargetChooser` 复用官方 `ReligiousTarget`。
- 选项 1（`WhichEffect` 1）去神圣化：所选宗教的所有单位 -10 战斗力（普通及宗教战斗力）；选项 2（2）世俗监督：同官方 B，所有文明可谴责所选宗教的单位，每次获得 25 外交支持。效果文本在 Texts/TsoDTE_Text_Congress.sql。
- 没有工坊先例（`gamefiles_grep --scope workshop` 查 `ResolutionEffectId` 无匹配）；官方 `Scripts/WorldCongress.lua` 的 `CanUseResolutions` 对未列出的决议直接放行。

## src/Core/TsoDTE_District_MageTower.sql

- 数值：学院的值照抄（解锁、掠夺、顾问、造价曲线、维护费），造价减半为 27；`ZOC` 1、`HitPoints` 100、`CityStrengthModifier` 2 照高卢「奥皮杜姆」。
- 相邻加成（5a）从学院现有的行复制，因为学院的相邻加成随规则集 / DLC / 游戏模式而变：原版 `Mountains_Science1~5`、`Jungle_Science`、`District_Science`、`GBR_Science`；迭起兴衰起 `Government_Science`；风云变幻 `Geothermal_Science`、`Reef_Science`、`Pamukkale_Science`；秘密结社模式 `LeyLine_Science`（埃塞俄比亚包，LoadOrder 0，早于本 mod 的 100）。风云变幻规则集下预期 12 行，秘密结社模式下 13 行（需实证）。
- 反间谍（第 6 节）：数值照领事馆 `CONSULATE_SPY_BONUS`。`MODIFIER_CITY_ADJUST_SPY_BONUS` 是 `COLLECTION_OWNER` + `EFFECT_ADJUST_CITY_SPY_BONUS`（总督「安保专家」「本地线人」同款）；挂在 `DistrictModifiers` 上时 OWNER 解析为区域所在城市，先例 `DISTRICT_IKANDA` 的 `MODIFIER_CITY_CORPS_ARMY_ADJUST_DISCOUNT`、`DISTRICT_COTHON` 的 `MODIFIER_CITY_ADJUST_UNIT_DOMAIN_PRODUCTION`。
- 太空摇滚（第 7 节）：书院（Expansion1_Expansion2.xml）、天文台（GranColombia_Maya_Expansion2.xml）各自补了 `ROCKBAND_SPACE_ROCK_<区域>` 与 `_MODIFIER` 两条，数值与学院版相同。
- 有意交给 `DistrictReplaces` 处理、没有补的学院引用（官方书院、天文台也都没补）：`Buildings.PrereqDistrict`（图书馆、大学、研究实验室、伊斯兰学校）、`Buildings.AdjacentDistrict`（桑科雷大学、阿蒙森-斯科特科考站）、`GreatPersonClasses` / `GreatPersonIndividuals`（大科学家激活）、`Projects`（学院研究资助）、`Boosts`（有记载的历史）、`UnitOperations`（窃取科技推动）、政策 / 总督 / 信条的 `DistrictType` 参数、`EmergencyScoreSources`（空间站紧急状况）、`Improvement_Adjacencies`（`Mission_Science_Campus`）、`RANDOM_EVENT_SOLAR_FLARE`。
- 不归本包：图标（WP9，按惯例名 `ICON_DISTRICT_TSOD_MAGE_TOWER` / `_FOW`）、模型（WP10）、历史时刻插图（WP12）、AI 偏好（WP7）、开局界面 `PlayerItems`（WP1）、百科（WP8）。

## src/Core/TsoDTE_Leader.sql

- 领袖为男性：原作称「罗塞塔大帝」「父皇」。`InheritFrom` `LEADER_DEFAULT` 继承 `TRAIT_LEADER_MAJOR_CIV` 等默认行为（官方写法）。
- 黑暗时代探测用到的官方件：`MODIFIER_PLAYER_ADJUST_PROPERTY`（Base Modifiers.xml，参数 `Key` / `Amount`；官方用例 `TRAIT_GOLDEN_AGE_UNLOCK_DARK_POLICIES`）；需求集 `PLAYER_HAS_DARK_AGE`（Expansion1_Leaders.xml，`REQUIREMENT_PLAYER_HAS_DARK_AGE`）。

## src/Core/TsoDTE_Project.sql

- 解锁照凯瑟琳「宫廷庆典」`PROJECT_COURT_FESTIVAL`（CatherineDeMedici_Projects.xml）：`UnlocksFromEffect` 1，文明能力挂一条 `DynamicModifiers` 里 `COLLECTION_OWNER` + `EFFECT_ADD_PLAYER_PROJECT_AVAILABILITY` 的修正；自定义类型的做法照凯瑟琳 / 中国（`_CATHERINE` / `_CHINA`）。
- 造价 65 / `COST_PROGRESSION_GAME_PROGRESS` 1500 照凯瑟琳宫廷庆典（暂定，进游戏再调）。
- 官方件：`CIVIC_MASS_MEDIA`（Base Civics.xml）；`REQUIREMENT_PLAYER_HAS_CIVIC`（参数 `CivicType`，用例 Expansion2_Civilizations.xml）；`MODIFIER_PLAYER_ADD_FAVOR`（Expansion2_Modifiers.xml，`COLLECTION_OWNER` + `EFFECT_ADD_PLAYER_FAVOR`，参数 `Amount`；先例 `CIVIC_FUTURE_CIVIC` 的 `CIVIC_GRANT_FAVOR`）。完成修正照 Base Projects.xml 的 `PROJECT_COMPLETION_*`。
- 完成时的两件事：外交支持由 `ProjectCompletionModifiers` 给；信仰转科技由 Scripts/TsoDTE_Project.lua 做。

## src/Core/TsoDTE_Unit_BattleMage.sql

- 先例：单位行与 `UnitAiInfos` 照 Base Units.xml 的 `UNIT_CROSSBOWMAN`；成长能力照 GranColombia_Maya 的尼杭（`Inactive` 能力 + 标签限定 + `MODIFIER_PLAYER_UNITS_GRANT_ABILITY` 授予 + `MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH`）；科技条件照 `AGENDA_HIGH_NUKE_LOVE`（TraitModifiers + Owner + `REQUIREMENT_PLAYER_HAS_TECHNOLOGY`）；相邻加成照希腊重装步兵 `ABILITY_HOPLITE`（`MODIFIER_SINGLE_UNIT_ATTACH_MODIFIER` 套 `MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH`）；只加远程攻击照晋升 `VOLLEY` / `TORTOISE`（`REQUIREMENT_PLAYER_IS_ATTACKING` + `REQUIREMENT_COMBAT_TYPE_MATCHES`）。
- 成长（累加）：机械 40/30 → 弹道学 60/50 → 高级弹道学 85/70（远程/近战）。弹道学：基础战斗力 +20（近战，面板显示）、远程攻击时 +20（战斗预览显示）；高级弹道学：+20 / +25。远程单位防守时用近战战斗力，只有发起远程攻击时才用远程攻击力，所以「远程攻击时」覆盖了远程攻击力的全部用途。军团级法术：相邻有另一个战斗法师时，远程攻击 +5。
- 不升级：不写 `UnitUpgrades`，也不设 `MandatoryObsoleteTech`（弩手是 `TECH_ADVANCED_BALLISTICS`）。

## src/Core/TsoDTE_WMD.sql

- 武器行照可莉的 `WMD_JUMPY_DUMPTY`（MondstadtKlee_WMDs.xml）：`BlastRadius` 1、`FalloutDuration` 0，只伤单位与建筑（`AffectUnits`、`AffectBuildings` 为 1，其余为 0）；`ICBMStrikeRange` 取可莉的 8（需实证）。
- `Maintenance` 取 0，依据 master plan §6.1 第 3 部分：可莉填 8，那是按库存每回合收的维护费，与「库存 = 军团数」不合。
- 通知不登记自定义类型（实机里自定义类型的通知不出现），改用官方剧本的 `NotificationTypes.USER_DEFINED_1..3`（见 Scripts/TsoDTE_BattleMage.lua）。`WMDCapable` 在 TsoDTE_Unit_BattleMage.sql 里为 1，依赖 UI/UnitPanel_TsoDTE.lua 的按钮过滤。
