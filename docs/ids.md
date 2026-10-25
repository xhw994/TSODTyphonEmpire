# 提丰帝国 · ID 与文件归属登记

> **统筹者独占**。子代理只读，不改。需要新 ID 时写进回报，由统筹者登记到这里。
> 来源：impl plan §3.1 初版登记表 + WP0 的工程决定。

## 1. Mod 身份与外部 ID

| 项 | 值 | 说明 |
|---|---|---|
| Mod GUID | `1e55d0b1-f5d9-48d4-a9b4-32e488b7bf21` | 新生成；`.civ6proj` 的 `Guid` 与 `TSODTyphonEmpire.Art.xml` 的 id 相同 |
| ProjectGuid | `b3d032d7-d210-46cf-b0c7-fee28a046eeb` | ModBuddy 工程 GUID，`.civ6sln` 里大写 |
| 工程名 / 部署目录 | `TSODTyphonEmpire` | 部署到 `Mods\TSODTyphonEmpire\` |
| Mod 名 LOC | `LOC_TSOD_TYPHON_EMPIRE_MOD_TITLE` / `_TEASER` / `_DESCRIPTION` | 写在 `.civ6proj` 的 `LocalizedTextData` 里，**不进** `Texts/` |
| 依赖 | 风云变幻 `4873eb62-8ccc-4574-b784-dda455e74e68`、迭起兴衰 `1B28771A-C749-434B-9053-D1380C553DE9` | |
| 依赖 | 埃塞俄比亚包 `1B394FE9-23DC-4868-8F0A-5220CB8FB427` | 法师塔用它的 `DIS_CMP_Alchemical` 模型；用户 2026-10-19 定：默认全 DLC，写对依赖即可，不做无 DLC 退路 |
| 塞西尔 mod id | `4883e185-c2d7-4031-aae3-b67e4e885a24` | WP18 的 `ModInUse` 用 |
| criteria | `TsoDTE_Expansion2` = `RuleSetInUse RULESET_EXPANSION_2` | |
| criteria | `TsoDTE_ModCecil` = `ModInUse 4883e185-c2d7-4031-aae3-b67e4e885a24` + `RuleSetInUse RULESET_EXPANSION_2` | WP18 塞西尔联动。同一个 Criteria 里两条都要满足：联动引用的领袖特性与法师塔只在本 mod 的风云变幻数据里存在，原版规则集下不能加载 |

## 2. 前缀约定

| 类 | 前缀 |
|---|---|
| 文件名 | `TsoDTE_` |
| 修正 | `TSOD_TYPHON_` |
| 需求 / 需求组 | `REQ_TSOD_TYPHON_` / `REQSET_TSOD_TYPHON_` |
| 内容类型 | `<类型>_TSOD_<名>`，见 §3 |
| 相邻加成 `YieldChangeId`、AI 清单、百科分组 / 页面 ID | `TSOD_TYPHON_` |
| LOC tag | `LOC_<类型ID>_NAME` / `_DESCRIPTION`，与塞西尔一致 |

## 3. 内容 ID 登记

| 内容 | ID | 所属包 |
|---|---|---|
| 文明 | `CIVILIZATION_TSOD_TYPHON_EMPIRE` | WP1 |
| 领袖 | `LEADER_TSOD_ROSETTA_AUGUSTUS` | WP1 |
| 文明能力 | `TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE` | WP1 建壳，WP2 填修正 |
| 领袖能力 | `TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS` | WP1 建壳，WP3 填修正 |
| 特色单位 | `UNIT_TSOD_BATTLE_MAGE`，特性 `TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE`，标签 `CLASS_TSOD_BATTLE_MAGE` | WP4 |
| 特色区域 | `DISTRICT_TSOD_MAGE_TOWER`，特性 `TRAIT_CIVILIZATION_DISTRICT_TSOD_MAGE_TOWER` | WP5 |
| 特色建筑 | `BUILDING_TSOD_BURNSTONE_WORKS`，特性 `TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS` | WP6 |
| 能力：学院训练免费升级 | `ABILITY_TSOD_CAMPUS_TRAINED_PROMOTION`（Name / Description 留空，不在单位提示里显示；I1 反馈） | WP2 |
| 能力：弹道学成长 | `ABILITY_TSOD_BATTLE_MAGE_BALLISTICS` | WP4 |
| 能力：高级弹道学成长 | `ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS` | WP4 |
| 能力：军团级法术 | `ABILITY_TSOD_BATTLE_MAGE_CONCERT` | WP4 |
| 能力：湮灭之创 | `ABILITY_TSOD_ANNIHILATION_SCAR` | WP13 |
| 能力：战场再生 | `ABILITY_TSOD_ARMY_REGENERATION` | WP13 |
| 大规模杀伤性武器 | `WMD_TSOD_ANNIHILATION_SCAR` | WP13 |
| 通知 | 不登记自定义类型（实机不显示）。用官方 `NotificationTypes.USER_DEFINED_1`（湮灭之创就绪）、`_2`（已施放）、`_3`（战场再生）| WP13 |
| 议程 | `AGENDA_TSOD_KINDRED`，特性 `TRAIT_AGENDA_TSOD_KINDRED` | WP7 |
| 宗教 | `RELIGION_TSOD_WAR_GOD`，颜色 `COLOR_RELIGION_TSOD_WAR_GOD` | WP14 |
| 城市项目 | `PROJECT_TSOD_DESANCTIFICATION` | WP16 |
| 通知（去神圣化完成） | `NotificationTypes.USER_DEFINED_5`；领袖能力的新时代 / 黑暗时代 / 击杀尤里卡通知用 `_4`（WP3） | WP16 |
| 世界议会决议 | `WC_RES_TSOD_THEOCRATIC_COUNCIL` | WP17 |
| 配色 | 照塞西尔 `TsoDCE_Colors.sql` 的命名 | WP1 |
| 城市名 | `LOC_CITY_NAME_TSOD_<英文名>`，57 个，见 §7.1 | WP1 |

修正、需求、需求组的具体 ID 由各包在自己的前缀下自定，不必预先登记；但**跨包引用**的必须登记在这里。

## 4. LOC tag 归属（防止两个包写同一个 tag 撞唯一约束）

同一个 (Tag, Language) 只能由一个文件插入一次。下表之外的新 tag 都归写它的那个包，但不得与下表冲突。

| tag | 写在 | 所属包 |
|---|---|---|
| `LOC_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME` / `_DESCRIPTION` / `_ADJECTIVE` | `Texts/TsoDTE_Text_CivLeader.sql` | WP1 |
| `LOC_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME` | 同上 | WP1 |
| `LOC_CITY_NAME_TSOD_*`、`LOC_CITIZEN_NAME_TSOD_*` | 同上 | WP1 |
| `LOC_TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE_NAME` / `_DESCRIPTION` | `Texts/TsoDTE_Text_CivTrait.sql` | WP2（WP1 的 Traits 行只引用） |
| `LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME` / `_DESCRIPTION` | `Texts/TsoDTE_Text_LeaderTrait.sql` | WP3（WP1 的 Traits 行只引用） |
| `LOC_UNIT_TSOD_BATTLE_MAGE_NAME` / `_DESCRIPTION`，及其能力的 tag | `Texts/TsoDTE_Text_BattleMage.sql` | WP4 |
| `LOC_WMD_TSOD_ANNIHILATION_SCAR_NAME`，`LOC_ABILITY_TSOD_ANNIHILATION_SCAR_*`，`LOC_ABILITY_TSOD_ARMY_REGENERATION_*`，`LOC_NOTIFICATION_TSOD_ANNIHILATION_*`、`LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_*`，`LOC_TSOD_ANNIHILATION_SCAR_EXHAUSTED`（地图浮字） | `Texts/TsoDTE_Text_WMD.sql` | WP13 |
| `LOC_TSOD_TYPHON_BOOST_NOTIFY_*`、`LOC_TSOD_TYPHON_BOOST_ITEM_*`（领袖能力通知） | `Texts/TsoDTE_Text_LeaderTrait.sql` | WP3 |
| `LOC_DISTRICT_TSOD_MAGE_TOWER_NAME` / `_DESCRIPTION` | `Texts/TsoDTE_Text_MageTower.sql` | WP5 |
| `LOC_BUILDING_TSOD_BURNSTONE_WORKS_NAME` / `_DESCRIPTION` | `Texts/TsoDTE_Text_Burnstone.sql` | WP6 |
| `LOC_AGENDA_TSOD_KINDRED_NAME` / `_DESCRIPTION`，及议程态度说明 | `Texts/TsoDTE_Text_Agenda.sql` | WP7 |
| `LOC_DIPLO_MODIFIER_TSOD_KINDRED_STRONG_MILITARY` / `_RELIGION_RECEIVED`，`LOC_DIPLO_KUDO_LEADER_ANY_REASON_AGENDA_TSOD_KINDRED`，`LOC_DIPLO_WARNING_LEADER_ANY_REASON_AGENDA_TSOD_KINDRED` | 同上 | WP7（不归 WP8） |
| `LOC_DISTRICT_TSOD_MAGE_TOWER_ENCAMPMENT_SCIENCE`（相邻加成说明） | `Texts/TsoDTE_Text_MageTower.sql` | WP5 |
| `LOC_TRAIT_CIVILIZATION_BUILDING_TSOD_BURNSTONE_WORKS_NAME` | `Texts/TsoDTE_Text_Burnstone.sql` | WP6 |
| `LOC_ABILITY_TSOD_BATTLE_MAGE_*_PREVIEW`（战斗预览说明） | `Texts/TsoDTE_Text_BattleMage.sql` | WP4 |
| `LOC_PROJECT_TSOD_DESANCTIFICATION_NAME` / `_SHORT_NAME` / `_DESCRIPTION`，`LOC_NOTIFICATION_TSOD_DESANCTIFICATION_MESSAGE` / `_SUMMARY` | `Texts/TsoDTE_Text_Project.sql` | WP16 |
| `LOC_WC_RES_TSOD_THEOCRATIC_COUNCIL_NAME`，`LOC_WORLD_CONGRESS_TSOD_DESANCTIFY_RELIGION_DESC`（选项 1）、`LOC_WORLD_CONGRESS_TSOD_SECULAR_OVERSIGHT_DESC`（选项 2） | `Texts/TsoDTE_Text_Congress.sql` | WP17 |
| 全部 `LOC_PEDIA_*`（文明、领袖、单位、区域、建筑、人物、地点） | `Texts/TsoDTE_Text_Pedia.sql` | WP8 |
| `LOC_DIPLO_MODIFIER_TSOD_CECIL_ROSETTA_TO_GAWAIN`、`LOC_DIPLO_MODIFIER_TSOD_CECIL_GAWAIN_TO_ROSETTA`（塞西尔联动的态度说明） | `Texts/TsoDTE_Text_Compat.sql` | WP18 |
| 全部 `LOC_DIPLO_*_LEADER_TSOD_ROSETTA_AUGUSTUS_*` / `LOC_DIPLO_*_TSOD_ROSETTA_AUGUSTUS_*` 外交台词 | 同上 | WP8 |
| `LOC_LOADING_INFO_LEADER_TSOD_ROSETTA_AUGUSTUS`（载入画面词）、`LOC_PEDIA_LEADERS_PAGE_LEADER_TSOD_ROSETTA_AUGUSTUS_QUOTE`（领袖引言） | 同上 | WP8（WP1 的 `LoadingInfo`、`LeaderQuotes` 行只引用） |

特色单位、区域的特性行直接用单位 / 区域自己的 NAME 与 DESCRIPTION tag，没有单独的特性 tag（照塞西尔与官方先例）；特色建筑的特性另有一个 NAME tag（见上）。

## 5. 文件归属与工程动作

`.civ6proj`、`TSODTyphonEmpire.Art.xml`、`docs/*`、`tools/*` 只由统筹者改。

### 5.1 阶段 1 数据

| 文件 | 包 | 动作（InGame / FrontEnd） |
|---|---|---|
| `Core/TsoDTE_Civilization.sql` | WP1 | IG UpdateDatabase |
| `Core/TsoDTE_Leader.sql` | WP1 | IG UpdateDatabase |
| `Core/TsoDTE_Colors.sql` | WP1 | IG UpdateColors + FE UpdateColors（照塞西尔） |
| `Core/TsoDTE_Config.sql` | WP1 | FE UpdateDatabase |
| `Texts/TsoDTE_Text_CivLeader.sql` | WP1 | IG UpdateText + FE UpdateText |
| `Core/TsoDTE_CivTrait.sql` | WP2 | IG UpdateDatabase |
| `Texts/TsoDTE_Text_CivTrait.sql` | WP2 | IG UpdateText + FE UpdateText |
| `Scripts/TsoDTE_LeaderTrait.lua` | WP3 | IG AddGameplayScripts |
| `Texts/TsoDTE_Text_LeaderTrait.sql` | WP3 | IG UpdateText + FE UpdateText |
| `Core/TsoDTE_Unit_BattleMage.sql` | WP4 | IG UpdateDatabase |
| `Texts/TsoDTE_Text_BattleMage.sql` | WP4 | IG UpdateText + FE UpdateText |
| `Core/TsoDTE_WMD.sql` | WP13 | IG UpdateDatabase（紧跟 Unit_BattleMage；武器、能力、通知类型） |
| `Texts/TsoDTE_Text_WMD.sql` | WP13 | IG UpdateText（不进 FE） |
| `Scripts/TsoDTE_BattleMage.lua` | WP13 | IG AddGameplayScripts（组军团 / 军队、湮灭之创、对账、军队回血、通知） |
| `UI/UnitPanel_TsoDTE.lua` | WP13 | IG ReplaceUIScript（LuaContext `UnitPanel`）+ 同 LoadOrder 200000 的 ImportFiles |
| `Core/TsoDTE_District_MageTower.sql` | WP5 | IG UpdateDatabase |
| `Texts/TsoDTE_Text_MageTower.sql` | WP5 | IG UpdateText + FE UpdateText |
| `Core/TsoDTE_Project.sql` | WP16 | IG UpdateDatabase（紧跟 District_MageTower，要引用法师塔；含去神圣化的解锁、完成修正、通知类型，以及文明能力上的 TraitModifiers 行） |
| `Scripts/TsoDTE_Project.lua` | WP16 | IG AddGameplayScripts（完成去神圣化：信仰一半转研究进度，只对提丰，发通知） |
| `Texts/TsoDTE_Text_Project.sql` | WP16 | IG UpdateText（不进 FE：项目只在局内出现） |
| `Core/TsoDTE_Congress.sql` | WP17 | IG UpdateDatabase（紧跟 TsoDTE_Project.sql；决议、两个选项的修正、AI 偏好行） |
| `Texts/TsoDTE_Text_Congress.sql` | WP17 | IG UpdateText（不进 FE：世界议会只在局内出现） |
| `Core/TsoDTE_Building_Burnstone.sql` | WP6 | IG UpdateDatabase |
| `Texts/TsoDTE_Text_Burnstone.sql` | WP6 | IG UpdateText + FE UpdateText |
| `Core/TsoDTE_Agenda_AI.sql` | WP7 | IG UpdateDatabase |
| `Texts/TsoDTE_Text_Agenda.sql` | WP7 | IG UpdateText |
| `Texts/TsoDTE_Text_Pedia.sql` | WP8 | IG UpdateText |
| `Core/TsoDTE_Pedia.sql` | WP8 | IG UpdateDatabase（百科自定义分组与页面） |
| `Core/TsoDTE_Compat_Cecil.sql` | WP18 | IG UpdateDatabase（独立 action，criteria `TsoDTE_ModCecil`，LoadOrder 200；罗塞塔与高文的态度修正） |
| `Texts/TsoDTE_Text_Compat.sql` | WP18 | IG UpdateText（独立 action，无 criteria，LoadOrder 200；不进 FE） |

FrontEnd 也加载特性、单位、区域、建筑的文本，因为开局界面（WP1 的 `Config`）要显示它们的名字和说明。

### 5.2 IG UpdateDatabase 内的文件顺序

同一个动作里按下列顺序登记，被引用的类型先建：

1. `TsoDTE_Civilization.sql` → 2. `TsoDTE_Leader.sql`（两个特性的壳）
3. `TsoDTE_Unit_BattleMage.sql` → `TsoDTE_WMD.sql`（WP13，同包的武器与能力要在单位之后） → 4. `TsoDTE_District_MageTower.sql` → `TsoDTE_Project.sql`（WP16，引用法师塔区域，须在它之后）→ `TsoDTE_Congress.sql`（WP17，排在 Project 之后；它引用第 2 步的领袖特性，官方决议与修正早已存在） → 5. `TsoDTE_Building_Burnstone.sql`
6. `TsoDTE_CivTrait.sql`
7. `TsoDTE_Agenda_AI.sql` → 8. `TsoDTE_Pedia.sql`

（原第 7 个 `TsoDTE_LeaderTrait.sql` 已删：它的「新时代给尤里卡 / 鼓舞」在风云变幻里不生效，I1 实测后整体改走 `Scripts/TsoDTE_LeaderTrait.lua`。）

WP18 的两个联动数据文件**不在上面的主动作里**：各自是独立 action（criteria 与主动作不同），LoadOrder 200，排在主动作之后；它们引用的领袖特性与法师塔都由主动作建立。

### 5.3 LoadOrder

| 动作 | LoadOrder |
|---|---|
| 所有普通 InGame / FrontEnd 动作 | 100 |
| 阶段 2：战神教（WP14） | 110 |
| 阶段 2：系列联动（WP18） | 200 |
| 阶段 2：系列联动文本（WP18，`Texts/TsoDTE_Text_Compat.sql`，无 criteria 的独立 action） | 200 |
| 阶段 2：UI 替换 + 同 LoadOrder 的 ImportFiles（WP13） | 200000（高于 BuilderLagFix 的 160520，见 impl plan WP13 修订） |

### 5.4 美术动作（阶段 1 只有法师塔）

**已登记（WP10 提前做的法师塔模型）**：

| 文件 | 动作 | Art.xml 登记 |
|---|---|---|
| `ArtDefs/Landmarks.artdef`（`DISTRICT_TSOD_MAGE_TOWER`，学院整段复制，大学位换成埃塞俄比亚包的 `DIS_CMP_Alchemical`） | IG UpdateArt（`(Mod Art Dependency File)` → 烘焙出的 `.dep`） | consumer `Landmarks`、`Audio`、`StrategicView_Sprite`、`StrategicView_Translate`、`WorldView_Translate` |
| `ArtDefs/Districts.artdef`（同名元素，Landmark 的 Xref 指向上面那个） | 同上 | 同上 5 个 consumer |

Districts 的 Xref 指向自己的 Landmarks 元素，所以两个文件要登记在同一批 consumer 里（照官方 Ethiopia 的做法）。FrontEnd 的 UpdateArt 不需要（区域模型只在局内用）。`requiredGameArtIDs` 没加埃塞俄比亚（SDK 没有它的 pantry；塞西尔引用同一个包也没加），靠构建后的 `restore_cooked_entries.py` 还原；备用 art id `50320198-92ec-444f-805c-1b6f81dfb918`。
**脚本限制**：`restore_cooked_entries.py` 在同一个文件里出现多处 `TB_ERROR` 时会全部跳过。现在只有 1 处所以没事；如果以后换成埃塞俄比亚配套的炼金底座（5 个 DLC entry），要先把脚本改成按文档顺序逐个还原。

**仍缺**：`UpdateIcons`（IG + FE）等图标、立绘、XLP 的登记，等 WP9、WP11、WP12 交付后加。

### 5.5 跨包的表行归属（防止重复插入）

| 行 | 写在 | 包 |
|---|---|---|
| `Types`、`Traits` 的 `TRAIT_CIVILIZATION_TSOD_TYPHON_EMPIRE`，`CivilizationTraits` 里它那一行 | `TsoDTE_Civilization.sql` | WP1 |
| `Types`、`Traits` 的 `TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS`，`LeaderTraits` 里它那一行 | `TsoDTE_Leader.sql` | WP1 |
| 特色单位 / 区域 / 建筑各自的特性：`Types`、`Traits`、`CivilizationTraits` 行，以及 `UnitReplaces` / `DistrictReplaces` / `BuildingReplaces` | 各自的数据文件 | WP4 / WP5 / WP6 |
| 挂到文明能力、领袖能力上的 `TraitModifiers` 行 | 挂修正的那个包自己的文件 | WP2 / WP3 |
| 挂到文明能力上的去神圣化解锁（`TraitModifiers` 一行，指向 `MODIFIER_PLAYER_ALLOW_PROJECT_TSOD`） | `TsoDTE_Project.sql` | WP16 |
| 战斗法师成长能力的授予修正 | 挂在 WP4 自己的 `TRAIT_CIVILIZATION_UNIT_TSOD_BATTLE_MAGE` 上（等价于文明能力，且不碰 WP1 的壳） | WP4 |
| `Agendas`、`HistoricalAgendas`、议程特性、`AiListTypes` / `AiLists` / `AiFavoredItems` | `TsoDTE_Agenda_AI.sql` | WP7 |
| 神权理事会的 `Types`、`Resolutions`、`ResolutionEffects` 行，本决议专用的 `Modifiers` / `ModifierArguments`（`TSOD_TYPHON_COUNCIL_RELIGIOUS_STRENGTH_DOWN`），以及 AI 偏好 `AiListTypes` / `AiLists` / `AiFavoredItems` 的 `TSOD_TYPHON_ROSETTA_RESOLUTIONS` 三行 | `TsoDTE_Congress.sql` | WP17（AI 三表原属 WP7 的文件，这里只新增一个 ListType，不与 WP7 的行重复；统筹者确认） |
| 开局界面每个特色项一行（`Players` / `PlayerItems` 等配置表） | `TsoDTE_Config.sql` | WP1（只引用别包的 ID 与 LOC tag） |
| 挂在塞西尔领袖特性 `TRAIT_LEADER_TSOD_GAWAIN_CECIL` 与本包领袖特性 `TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS` 上的态度修正 `TraitModifiers` 行 | `TsoDTE_Compat_Cecil.sql` | WP18（只在塞西尔启用时写入；梦境之城的宜居度行已在阶段 2 实机反馈第 5 项删除） |

## 6. 专名英文对照（暂定，WP20 英文校对时可改）

各包写英文文本时一律用下表；表外新造的专名英文写进回报，由统筹者补登。

| 中文 | 英文 |
|---|---|
| 提丰帝国 / 提丰 | Typhon Empire / Typhon |
| 罗塞塔·奥古斯都 | Rosetta Augustus |
| 奥古斯都家族 | House of Augustus |
| 奥尔德南 | Ordenan |
| 冬堡 | Winterhold |
| 冬狼堡 | Winterwolf Keep |
| 奥兰戴尔 / 奥兰戴尔之喉 | Orandel / Throat of Orandel |
| 黄昏宫殿 | Twilight Palace |
| 黑曜石宫 / 黑铁王座 | Obsidian Palace / Black Iron Throne |
| 战斗法师 | Battle Mage |
| 法师塔 | Mage Tower |
| 燃石 / 燃石酸化工厂 | Burnstone / Burnstone Acidification Works |
| 湮灭之创 | Annihilation Scar |
| 战神 / 战神教 | God of War / War God Faith |
| 裴迪南 | Ferdinand |
| 安德莎 | Andesha |
| 温莎 | Windsor |
| 帕林 | Palin |
| 戴安娜 | Diana |
| 玛蒂尔达 | Matilda |
| 马尔姆 | Malm |
| 哈迪伦 | Hadiren |
| 巴德 | Bard |
| 塞西尔帝国 / 高文·塞西尔 | Cecil Empire / Gawain Cecil |
| 超凡者的帝国（文明能力） | Empire of the Extraordinary |
| 学院出身（能力） | Campus-Trained |
| 凡人的韧性（领袖能力） | Resilience of Mortals |
| 弹道学成长 / 高级弹道学成长 | Ballistics Growth / Advanced Ballistics Growth |
| 军团级法术 | Legion-Class Spell |
| 同类（议程） | Kindred |
| 超凡者 | Transcendents |
| 温德尔 / 玛佩尔 / 杜尼特 | Wendell / Marpel / Dunite |
| 狼将军 | Wolf General |
| 冬狼 / 铁河 / 黑钢骑士团 | Winterwolf / Iron River / Black Steel Knights |
| 黑旗魔法师团 / 黑曜石禁军 | Black Flag Mage Corps / Obsidian Guard |
| 皇家法师协会 / 帝国工造协会 | Royal Mage Association / Imperial Artificers' Guild |
| 战神教会 / 教皇 | Church of the God of War / Pope |
| 游荡者 / 永眠者 | Wanderers / Eternal Sleepers |
| 神之眼 / 梦境之神 | Eye of God / God of Dreams |
| 大崩塌 / 冬日猎神 | Great Collapse / Winter God-Hunt |
| 莫比乌斯港 / 安苏 / 刚铎 / 帝国大道 | Port Mobius / Kingdom of Ansu / Gondor Empire / Imperial Avenue |
| 丰饶之尘 / 灰晶 / 铁人 | Dust of Plenty / grey crystal / Iron Soldier |
| 神权理事会 / 去神圣化 | Theocratic Council / Desanctification |
| 市民名（WP1 新拟） | 博迈尔 Bomel、赫米尔 Hemil、莫里 Morey、克雷蒙特 Clermont、摩格洛克 Morglock、欧文 Owen、丹尼尔 Daniel、乔治 George、贝托蒙德 Bertomund、金娜 Gina、玛丽 Mary、塔利亚 Talia |

## 7. 待登记

### 7.1 城市英文名（WP1 拟，**待用户过目**）

顺序即 `CityNames` 插入顺序。拟名规则：§6 已定的照抄；常见西文名用原名；有字面义的意译（郡 Shire、镇 Town、岛 Isle）；「X堡」→ Xhold（冬狼堡 Winterwolf Keep 例外）。

| # | 中文 | 英文 | LOC tag | 说明 |
|---|---|---|---|---|
| 1 | 奥尔德南 | Ordenan | `LOC_CITY_NAME_TSOD_ORDENAN` | ids.md §6 |
| 2 | 冬堡 | Winterhold | `LOC_CITY_NAME_TSOD_WINTERHOLD` | ids.md §6 |
| 3 | 莫比乌斯 | Mobius | `LOC_CITY_NAME_TSOD_MOBIUS` | 通行译名 |
| 4 | 奥兰戴尔 | Orandel | `LOC_CITY_NAME_TSOD_ORANDEL` | ids.md §6 |
| 5 | 冬狼堡 | Winterwolf Keep | `LOC_CITY_NAME_TSOD_WINTERWOLF_KEEP` | ids.md §6 |
| 6 | 塔伦金斯 | Tarenkins | `LOC_CITY_NAME_TSOD_TARENKINS` | 伦→ren，照 Hadiren |
| 7 | 苏提姆 | Sutim | `LOC_CITY_NAME_TSOD_SUTIM` | 音译 |
| 8 | 赛文堡 | Sewenhold | `LOC_CITY_NAME_TSOD_SEWENHOLD` | 赛文→Sewen 照塞西尔 Sewen Terry；X堡→Xhold 照 Winterhold |
| 9 | 杜勒 | Dulur | `LOC_CITY_NAME_TSOD_DULUR` | 照塞西尔 塔姆杜勒 Tamdulur |
| 10 | 霍尔马克 | Holmark | `LOC_CITY_NAME_TSOD_HOLMARK` | 通行译名；霍尔→Hall 照塞西尔 |
| 11 | 达特 | Dart | `LOC_CITY_NAME_TSOD_DART` | 通行译名 |
| 12 | 法布罗 | Fabro | `LOC_CITY_NAME_TSOD_FABRO` | 音译 |
| 13 | 科尔曼罗尼 | Colmanroni | `LOC_CITY_NAME_TSOD_COLMANRONI` | Colman + roni |
| 14 | 马利克 | Malik | `LOC_CITY_NAME_TSOD_MALIK` | 通行译名 |
| 15 | 摩格洛克 | Morglock | `LOC_CITY_NAME_TSOD_MORGLOCK` | 音译 |
| 16 | 赫米尔 | Hemil | `LOC_CITY_NAME_TSOD_HEMIL` | 词尾尔→l，照 Orandel / Hamel |
| 17 | 铂金菲斯 | Platinphis | `LOC_CITY_NAME_TSOD_PLATINPHIS` | 铂金→Platin，菲斯→phis（Memphis） |
| 18 | 缪斯 | Muse | `LOC_CITY_NAME_TSOD_MUSE` | 通行译名 |
| 19 | 塔索斯岛 | Tassos Isle | `LOC_CITY_NAME_TSOD_TASSOS_ISLE` | 岛→Isle |
| 20 | 萨里尔 | Sariel | `LOC_CITY_NAME_TSOD_SARIEL` | 通行译名 |
| 21 | 杜沃松郡 | Duvosson Shire | `LOC_CITY_NAME_TSOD_DUVOSSON_SHIRE` | 郡→Shire 照塞西尔 |
| 22 | 哈玛尔郡 | Hamar Shire | `LOC_CITY_NAME_TSOD_HAMAR_SHIRE` | 通行译名 |
| 23 | 杜松郡 | Dusson Shire | `LOC_CITY_NAME_TSOD_DUSSON_SHIRE` | 与杜沃松同源，音译不意译 |
| 24 | 恩奇霍克郡 | Enkihawk Shire | `LOC_CITY_NAME_TSOD_ENKIHAWK_SHIRE` | 恩奇→Enki，霍克→hawk |
| 25 | 图兰郡 | Turan Shire | `LOC_CITY_NAME_TSOD_TURAN_SHIRE` | 通行译名 |
| 26 | 于勒堡 | Juleshold | `LOC_CITY_NAME_TSOD_JULESHOLD` | 于勒→Jules；X堡→Xhold |
| 27 | 苏提尼 | Sutini | `LOC_CITY_NAME_TSOD_SUTINI` | 与苏提姆同源 |
| 28 | 卢西亚 | Lucia | `LOC_CITY_NAME_TSOD_LUCIA` | 通行译名 |
| 29 | 尼米亚斯 | Nimias | `LOC_CITY_NAME_TSOD_NIMIAS` | 音译 |
| 30 | 金沙郡 | Goldsand Shire | `LOC_CITY_NAME_TSOD_GOLDSAND_SHIRE` | 意译，照塞西尔意译有义地名 |
| 31 | 巴特菲尔德郡 | Butterfield Shire | `LOC_CITY_NAME_TSOD_BUTTERFIELD_SHIRE` | 通行译名 |
| 32 | 松林镇 | Pinewood Town | `LOC_CITY_NAME_TSOD_PINEWOOD_TOWN` | 意译；镇→Town 照塞西尔 |
| 33 | 瑞文堡 | Ravenhold | `LOC_CITY_NAME_TSOD_RAVENHOLD` | 瑞文→Raven；X堡→Xhold |
| 34 | 康奈利安 | Cornelian | `LOC_CITY_NAME_TSOD_CORNELIAN` | 通行译名 |
| 35 | 卡兹 | Kaz | `LOC_CITY_NAME_TSOD_KAZ` | 卡→K |
| 36 | 黑山郡 | Blackmountain Shire | `LOC_CITY_NAME_TSOD_BLACKMOUNTAIN_SHIRE` | 意译，照塞西尔 Whitemountain |
| 37 | 卡普维 | Kapvi | `LOC_CITY_NAME_TSOD_KAPVI` | 卡→K |
| 38 | 科林 | Colin | `LOC_CITY_NAME_TSOD_COLIN` | 通行译名 |
| 39 | 亚斯兰特 | Aslante | `LOC_CITY_NAME_TSOD_ASLANTE` | 亚→A（亚瑟 Arthur） |
| 40 | 奥索尔 | Osol | `LOC_CITY_NAME_TSOD_OSOL` | 词尾尔→l |
| 41 | 多利亚 | Doria | `LOC_CITY_NAME_TSOD_DORIA` | 通行译名 |
| 42 | 西斯郡 | Seiss Shire | `LOC_CITY_NAME_TSOD_SEISS_SHIRE` | 音译，避开 Sith |
| 43 | 卡特罗尔 | Katrol | `LOC_CITY_NAME_TSOD_KATROL` | 卡→K，词尾尔→l |
| 44 | 赫米特 | Hemit | `LOC_CITY_NAME_TSOD_HEMIT` | 与赫米尔同源 |
| 45 | 瑞克堡 | Rickhold | `LOC_CITY_NAME_TSOD_RICKHOLD` | 瑞克→Rick；X堡→Xhold |
| 46 | 沙夫伦德郡 | Shafrend Shire | `LOC_CITY_NAME_TSOD_SHAFREND_SHIRE` | 伦→ren |
| 47 | 维托郡 | Vito Shire | `LOC_CITY_NAME_TSOD_VITO_SHIRE` | 通行译名 |
| 48 | 凯尔曼 | Kelman | `LOC_CITY_NAME_TSOD_KELMAN` | 词中尔→l，照 Malm |
| 49 | 安格雷郡 | Angray Shire | `LOC_CITY_NAME_TSOD_ANGRAY_SHIRE` | 雷→ray |
| 50 | 莫戈雷 | Mogoray | `LOC_CITY_NAME_TSOD_MOGORAY` | 雷→ray |
| 51 | 诺特兰 | Nottland | `LOC_CITY_NAME_TSOD_NOTTLAND` | 地名词尾兰→land |
| 52 | 滨海郡 | Seaside Shire | `LOC_CITY_NAME_TSOD_SEASIDE_SHIRE` | 意译 |
| 53 | 巴尔塔 | Balta | `LOC_CITY_NAME_TSOD_BALTA` | 通行译名 |
| 54 | 卡塔尼 | Katani | `LOC_CITY_NAME_TSOD_KATANI` | 卡→K |
| 55 | 亚德林 | Adelin | `LOC_CITY_NAME_TSOD_ADELIN` | 亚→A |
| 56 | 南海郡 | Southsea Shire | `LOC_CITY_NAME_TSOD_SOUTHSEA_SHIRE` | 意译 |
| 57 | 兰尼亚郡 | Lania Shire | `LOC_CITY_NAME_TSOD_LANIA_SHIRE` | 音译 |

### 7.2 各包回报的新增跨包 ID

| 类 | ID | 来源 | 谁会用 |
|---|---|---|---|
| 图标 | `ICON_CIVILIZATION_TSOD_TYPHON_EMPIRE`、`ICON_LEADER_TSOD_ROSETTA_AUGUSTUS`（**名字不可改**，LoadScreen.lua 按类型拼名） | WP1 | WP9 |
| 图标 | `ICON_UNIT_TSOD_BATTLE_MAGE`、`ICON_UNIT_TSOD_BATTLE_MAGE_PORTRAIT`（可选 `_WHITE`）、`ICON_DISTRICT_TSOD_MAGE_TOWER`（+ `_FOW`）、`ICON_BUILDING_TSOD_BURNSTONE_WORKS` | WP1/4/5/6 | WP9 |
| 立绘与背景 | `LEADER_TSOD_ROSETTA_AUGUSTUS_NEUTRAL` / `_BACKGROUND` / `_LOADING_FOREGROUND` / `_LOADING_BACKGROUND` / `_DIPLOMACY_BACKGROUND`，`FALLBACK_NEUTRAL_LEADER_TSOD_ROSETTA_AUGUSTUS` | WP1 | WP11 |
| 颜色 | `COLOR_PLAYER_TSOD_TYPHON_EMPIRE_PRIMARY` / `_SECONDARY` / `_ALT1_PRIMARY` / `_ALT1_SECONDARY` / `_ALT2_PRIMARY` / `_ALT2_SECONDARY`（主：底 22,20,22、徽 196,26,32；备 1 红底黑徽；备 2 红底金徽 228,182,78） | WP1 | WP14（宗教色另起） |
| 相邻加成 | `TSOD_TYPHON_MAGE_TOWER_ENCAMPMENT_SCIENCE` | WP5 | — |
| AI 清单 | `TSOD_TYPHON_ROSETTA_VICTORIES` / `_DISTRICTS` / `_BUILDINGS` / `_UNITS`（挂领袖特性），`TSOD_TYPHON_KINDRED_PSEUDOYIELDS`（挂议程特性） | WP7 | WP13、WP17 加偏好时追加到这些清单 |
| 百科分组 | `TSOD_TYPHON_PEOPLE`、`TSOD_TYPHON_PLACES`（CONCEPTS 分区） | WP8 | WP14（战神教页可并入） |
| 百科页面 | `TSOD_TYPHON_` + FERDINAND / ANDESHA / WINDSOR / PALIN / DIANA / MATILDA / MALM / ORDENAN / WINTERHOLD / WINTERWOLF_KEEP / THROAT_OF_ORANDEL / TWILIGHT_PALACE | WP8 | — |
| 玩家属性 | `TSOD_TYPHON_KILL_BOOST_<TechnologyType>`（击杀尤里卡，存档用）；`TSOD_TYPHON_TWILIGHT_PALACE_ERA`（上次处理的时代）；`TSOD_TYPHON_DARK_AGE_BONUS_ERA`（已补黑暗时代的时代）；`TSOD_TYPHON_DARK_AGE`（修正 `TSOD_TYPHON_DARK_AGE_PROBE` 写入，挂领袖特性，在 `Core/TsoDTE_Leader.sql`） | WP3 | — |
| 单位属性 | `TSOD_TYPHON_SCAR_SPENT`（施放过湮灭之创，不再计入库存） | WP13 | — |

**跨包约束**：领袖不得加 `RELIGIOUS` / `NONRELIGIOUS` / `LOW_RELIGIOUS_PREFERENCE` 类 LeaderTraits（WP7 的「宗教倾向中等」靠不挂实现）。

## 8. 美术（10-23 第一批）

| 类别 | 名称 | 来源 |
|---|---|---|
| 图标图集 | `ICON_ATLAS_TSOD_TYPHON_CIVILIZATION`（13 个尺寸）、`ICON_ATLAS_TSOD_TYPHON_LEADER`（8 个尺寸） | `Icons/TsoDTE_Icons.xml` |
| 单位 / 区域 / 建筑 / 项目图集（10-24） | `ICON_ATLAS_TSOD_TYPHON_UNIT`(+`_FOW`)、`_UNIT_PORTRAIT`、`_DISTRICT`(+`_FOW`)、`_BUILDING`(+`_FOW`)、`_PROJECT`；源图是用户按 `docs/icon-prompts.md` 生成的 5 张（`images/` 下），由 `tools/icon_art.py` 抠图、套六边形、做 FOW | 同上 |
| 贴图包 | `TsoDTE_UITextures`（UITexture）、`TsoDTE_LeaderFallbacks`（LeaderFallback）；包名带前缀，避免和塞西尔的 `UILeaders` 等同名 | `XLPs/` |
| 领袖贴图 | `LEADER_TSOD_ROSETTA_AUGUSTUS_NEUTRAL` / `_LOADING_FOREGROUND` / `_LOADING_BACKGROUND` / `_BACKGROUND` / `_DIPLOMACY_BACKGROUND`，`FALLBACK_NEUTRAL_LEADER_TSOD_ROSETTA_AUGUSTUS` | `tools/make_art.py` |
| 历史时刻 | `MOMENT_UNIT_TSOD_BATTLE_MAGE`、`MOMENT_DISTRICT_TSOD_MAGE_TOWER`、`MOMENT_BUILDING_TSOD_BURNSTONE_WORKS` | `Core/TsoDTE_Moments.sql` |

## 9. 模型（10-24）

| 内容 | 做法 | 文件 |
|---|---|---|
| 战斗法师 | 单位条目复制官方 `UNIT_SLINGER`（4 人、投石兵编队与远程战斗、音效）；成员是自定义的 `TSOD_BattleMage`：复制审判官（`Inquisitor`）的法袍、兜帽、法杖，法袍与兜帽改用文明色 `USE_CIV_COLOR`，动作沿用 `Movement=Slinger`、`Combat=SlingerCombat`。由 `tools/make_unit_artdef.py` 生成（第一版用的邪教徒只有近战动作） | `ArtDefs/Units.artdef` |
| 法师塔 | 12 个底座（四个时代 × 建筑组合）全部用 `DIS_CMP_Alchemical`，去掉图书馆 / 大学 / 研究实验室各自的建筑变体 | `ArtDefs/Landmarks.artdef` |
| 构建后还原 | `tools/restore_cooked_entries.py`：TB_ERROR 按元素逐个还原（不再限一处）；被 cooker 清空的 DLC 元素引用（如 `Cultist`）按出现顺序填回 | — |
