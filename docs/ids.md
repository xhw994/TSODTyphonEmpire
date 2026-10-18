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
| 软依赖 | 埃塞俄比亚包 `1B394FE9-23DC-4868-8F0A-5220CB8FB427` | 只影响法师塔主体模型，不声明依赖 |
| 塞西尔 mod id | `4883e185-c2d7-4031-aae3-b67e4e885a24` | WP18 的 `ModInUse` 用 |
| 梦境之城 mod id | `3b138c5a-bb00-42ce-9ae2-2186fbd5595b` | WP18 的 `ModInUse` 用 |
| criteria | `TsoDTE_Expansion2` = `RuleSetInUse RULESET_EXPANSION_2` | |

## 2. 前缀约定

| 类 | 前缀 |
|---|---|
| 文件名 | `TsoDTE_` |
| 修正 | `TSOD_TYPHON_` |
| 需求 / 需求组 | `REQ_TSOD_TYPHON_` / `REQSET_TSOD_TYPHON_` |
| 内容类型 | `<类型>_TSOD_<名>`，见 §3 |
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
| 能力：学院训练免费升级 | `ABILITY_TSOD_CAMPUS_TRAINED_PROMOTION` | WP2 |
| 能力：弹道学成长 | `ABILITY_TSOD_BATTLE_MAGE_BALLISTICS` | WP4 |
| 能力：高级弹道学成长 | `ABILITY_TSOD_BATTLE_MAGE_ADV_BALLISTICS` | WP4 |
| 能力：军团级法术 | `ABILITY_TSOD_BATTLE_MAGE_CONCERT` | WP4 |
| 能力：湮灭之创 | `ABILITY_TSOD_ANNIHILATION_SCAR` | WP13 |
| 能力：战场再生 | `ABILITY_TSOD_ARMY_REGENERATION` | WP13 |
| 大规模杀伤性武器 | `WMD_TSOD_ANNIHILATION_SCAR` | WP13 |
| 通知 | `NOTIFICATION_TSOD_ANNIHILATION_READY`、`NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE`、`NOTIFICATION_TSOD_ARMY_REGENERATION` | WP13 |
| 议程 | `AGENDA_TSOD_KINDRED`，特性 `TRAIT_AGENDA_TSOD_KINDRED` | WP7 |
| 宗教 | `RELIGION_TSOD_WAR_GOD`，颜色 `COLOR_RELIGION_TSOD_WAR_GOD` | WP14 |
| 城市项目 | `PROJECT_TSOD_DESANCTIFICATION` | WP16 |
| 世界议会决议 | `WC_RES_TSOD_THEOCRATIC_COUNCIL` | WP17 |
| 配色 | 照塞西尔 `TsoDCE_Colors.sql` 的命名 | WP1 |
| 城市名 | `LOC_CITY_NAME_TSOD_<英文名>`，57 个，见 §6 | WP1 |

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
| `LOC_DISTRICT_TSOD_MAGE_TOWER_NAME` / `_DESCRIPTION` | `Texts/TsoDTE_Text_MageTower.sql` | WP5 |
| `LOC_BUILDING_TSOD_BURNSTONE_WORKS_NAME` / `_DESCRIPTION` | `Texts/TsoDTE_Text_Burnstone.sql` | WP6 |
| `LOC_AGENDA_TSOD_KINDRED_NAME` / `_DESCRIPTION`，及议程态度说明 | `Texts/TsoDTE_Text_Agenda.sql` | WP7 |
| 全部 `LOC_PEDIA_*`（文明、领袖、单位、区域、建筑、人物、地点） | `Texts/TsoDTE_Text_Pedia.sql` | WP8 |
| 全部 `LOC_DIPLO_*_LEADER_TSOD_ROSETTA_AUGUSTUS_*` / `LOC_DIPLO_*_TSOD_ROSETTA_AUGUSTUS_*` 外交台词 | 同上 | WP8 |
| `LOC_LOADING_INFO_LEADER_TSOD_ROSETTA_AUGUSTUS`（载入画面词）、领袖与文明引言 | 同上 | WP8（WP1 的 `LoadingInfo` 等行只引用） |

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
| `Core/TsoDTE_LeaderTrait.sql` | WP3 | IG UpdateDatabase |
| `Scripts/TsoDTE_LeaderTrait.lua` | WP3 | IG AddGameplayScripts |
| `Texts/TsoDTE_Text_LeaderTrait.sql` | WP3 | IG UpdateText + FE UpdateText |
| `Core/TsoDTE_Unit_BattleMage.sql` | WP4 | IG UpdateDatabase |
| `Texts/TsoDTE_Text_BattleMage.sql` | WP4 | IG UpdateText + FE UpdateText |
| `Core/TsoDTE_District_MageTower.sql` | WP5 | IG UpdateDatabase |
| `Texts/TsoDTE_Text_MageTower.sql` | WP5 | IG UpdateText + FE UpdateText |
| `Core/TsoDTE_Building_Burnstone.sql` | WP6 | IG UpdateDatabase |
| `Texts/TsoDTE_Text_Burnstone.sql` | WP6 | IG UpdateText + FE UpdateText |
| `Core/TsoDTE_Agenda_AI.sql` | WP7 | IG UpdateDatabase |
| `Texts/TsoDTE_Text_Agenda.sql` | WP7 | IG UpdateText |
| `Texts/TsoDTE_Text_Pedia.sql` | WP8 | IG UpdateText |

FrontEnd 也加载特性、单位、区域、建筑的文本，因为开局界面（WP1 的 `Config`）要显示它们的名字和说明。

### 5.2 IG UpdateDatabase 内的文件顺序

同一个动作里按下列顺序登记，被引用的类型先建：

1. `TsoDTE_Civilization.sql` → 2. `TsoDTE_Leader.sql`（两个特性的壳）
3. `TsoDTE_Unit_BattleMage.sql` → 4. `TsoDTE_District_MageTower.sql` → 5. `TsoDTE_Building_Burnstone.sql`
6. `TsoDTE_CivTrait.sql` → 7. `TsoDTE_LeaderTrait.sql`
8. `TsoDTE_Agenda_AI.sql`

### 5.3 LoadOrder

| 动作 | LoadOrder |
|---|---|
| 所有普通 InGame / FrontEnd 动作 | 100 |
| 阶段 2：战神教（WP14） | 110 |
| 阶段 2：系列联动（WP18） | 200 |
| 阶段 2：UI 替换 + 同 LoadOrder 的 ImportFiles（WP13） | 100000 |

### 5.4 美术动作（阶段 1 暂缺）

`UpdateArt (Mod Art Dependency File)` 与 `TSODTyphonEmpire.Art.xml` 里的 artdef / XLP 登记，等美术包（WP9–WP12）交付后由统筹者加。WP0 的 `Art.xml` 已清空全部 `relativeArtDefPaths` 与 `relativePackagePaths`。

## 6. 待登记

### 6.1 城市英文名（WP1 拟，用户过目后登记）

_（空，等 WP1 回报）_

### 6.2 各包回报的新增跨包 ID

_（空）_
