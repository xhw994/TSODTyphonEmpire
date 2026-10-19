# 提丰帝国 · 实现计划（impl plan）

> **配套**：《Master Plan v4（定稿）》`docs/master-plan.md`。设计上的「做什么、为什么」都在那里，本文件只管「怎么分工、怎么做、怎么验」。
> **读者**：统筹者（一个干净上下文的 Claude 会话，或你本人）和各个工作包的子代理。
> **原则**：
> - 每个工作包**独占自己的文件**，互不改对方的文件；
> - `.civ6proj` 和 `docs/ids.md` 只由统筹者改；
> - 每个子代理只读 master plan 里自己那几节，不读全文。

---

## 0. 怎么用这份计划

**为什么要分包**：master plan 加原作调研已经很长，一个会话从头做到尾，上下文一定会爆。

- **统筹者开一个新会话**，只读本文件和 `docs/ids.md`。不读小说，不读 master plan 全文。
- **每个工作包派一个子代理**，子代理用 `general-purpose` 类型，派发模板见 §7。
- **子代理只带回短报告**：建了哪些文件、用了哪些 ID、有哪些需实证项、要登记进工程的文件清单。不带回代码全文。
- **集成、构建、静态检查由统筹者做**；进游戏测试由你做，日志排查交给 `civ6-modding-debugger` 子代理。

**并行规则**：
- 同一阶段内，文件不重叠的工作包可以同时派发。
- 依赖关系见 §4 的依赖图；有依赖的必须等前一个包合并、静态检查通过之后再派。

---

## 1. 目标环境（已定）

| 项 | 取值 | 说明 |
|---|---|---|
| 规则集 | 风云变幻（同时依赖迭起兴衰） | 与塞西尔一致；黑暗时代、总督、`Buildings_XP2` 都在这两个资料片里 |
| DLC | 无硬依赖 | 埃塞俄比亚包是法师塔「炼金学会」模型的**软依赖**：没装时只缺这个模型，玩法不受影响（需实证） |
| 游戏模式 | 不专门适配 | 秘密结社模式下炼金学会会同时出现在别处，无冲突 |
| 他人 mod | 不专门适配 | 塞西尔、梦境之城同开要测一遍 |
| 存档 | 新开局 | 不考虑中途加入 |
| 工程形式 | ModBuddy 工程（`.civ6proj`），照抄塞西尔 | 要烘焙 ArtDef 和 XLP，必须走 SDK |
| 数据格式 | SQL 为主；图标登记沿用塞西尔的 XML | 见 memory「SQL 优先」 |
| 仓库 | `C:\Users\xegna\Documents\Workspace\TSODTyphonEmpire` | 与塞西尔、梦境之城同级 |

**为什么不用技能里的 civ6-mod-creator 快车道**：它只能从官方现成的特色项里挑，不能定义新的单位、区域、建筑，而且产出的是 XML。只借它的 ComfyUI 生图工作流（`vendor/civ6-mod-creator/workflows/`）给美术用，见 WP9、WP11。

---

## 2. 工程骨架（WP0 建）

```
TSODTyphonEmpire/
├─ docs/
│  ├─ master-plan.md        ← 从 Civ6 modding 目录移入
│  ├─ impl-plan.md          ← 本文件
│  └─ ids.md                ← ID 与文件归属登记（统筹者独占）
├─ tools/
│  └─ restore_cooked_entries.py   ← 从塞西尔复制：修复 cooker 把 DLC 素材引用改成 TB_ERROR
├─ src/
│  ├─ TSODTyphonEmpire.civ6proj   ← 统筹者独占
│  ├─ Core/        数据 SQL（每个工作包一个文件）
│  ├─ Scripts/     Gameplay Lua
│  ├─ UI/          UI Lua（替换脚本）
│  ├─ Texts/       文本 SQL（每个工作包一个文件，中英双语）
│  ├─ Icons/       图标登记 XML
│  ├─ ArtDefs/     ArtDef
│  ├─ XLPs/  Textures/  Assets/
└─ README_CN.md / README_EN.md（最后写）
```

文件前缀用 `TsoDTE_`，对应塞西尔的 `TsoDCE_`。

### 2.1 动作与加载顺序（统筹者写进 `.civ6proj`）

| 动作 | 类型 | 内容 | LoadOrder | criteria |
|---|---|---|---|---|
| InGame 数据 | UpdateDatabase | `Core/*.sql`（宗教除外） | 默认 | 风云变幻 |
| InGame 宗教 | UpdateDatabase | `Core/TsoDTE_Religion_WarGod.sql` | 默认 | 风云变幻 + 开局选项「启用战神教」 |
| InGame 文本 | UpdateText | `Texts/*.sql` | 默认 | — |
| InGame 图标 | UpdateIcons | `Icons/*.xml` | 默认 | — |
| InGame 美术 | UpdateArt | `(Mod Art Dependency File)` | 默认 | — |
| Gameplay 脚本 | AddGameplayScripts | `Scripts/*.lua` | 默认 | — |
| UI 替换 | ReplaceUIScript + 同 LoadOrder 的 ImportFiles | `UI/UnitPanel_TsoDTE.lua` | 200000（高于 BuilderLagFix 的 160520） | — |
| FrontEnd | UpdateDatabase / UpdateText / UpdateIcons / UpdateArt | 开局设置、配色、文本、图标 | 默认 | — |

ReplaceUIScript 配同 LoadOrder 的 ImportFiles，是梦境之城 README 里写过的社区约定，后来的 mod 才能接力。

---

## 3. 共享约定（所有子代理必读）

1. **ID 只从 `docs/ids.md` 取**，不自行发明。确实需要新 ID 时，写进报告由统筹者登记。初版登记表见 §3.1。
2. **修正 ID 前缀**一律 `TSOD_TYPHON_`；需求、需求组前缀 `REQ_TSOD_TYPHON_`、`REQSET_TSOD_TYPHON_`。
3. **文本**：每个工作包一个 `Texts/TsoDTE_Text_<包名>.sql`，`zh_Hans_CN` 与 `en_US` 两种语言都要有。LOC tag 形如 `LOC_<类型ID>_NAME` / `_DESCRIPTION`，与塞西尔一致。
4. **先查后写**：任何 `EFFECT_*`、`MODIFIER_*`、`REQUIREMENT_*`、表名、列名、Lua 方法，写之前都用 civ6-modding 技能查过（`kb_query.py`、`effect_usage.py`、`gamefiles_grep.py`、`schema_query.py`）。master plan 里已经核实过的标识符可以直接用，但要照官方先例抄写法，不要凭记忆。
5. **四条静态检查**全过才算完成：`validate_mod.py`、`loc_audit.py`、`modifier_lint.py`、`lua_lint.py`。
6. **不改别人的文件**，包括 `.civ6proj`、`docs/ids.md` 和其他包的 SQL。
7. **需实证项**照实写进报告，不写「已生效」（技能铁律第 9 条）。

### 3.1 ID 登记初版

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
| 城市名 | `LOC_CITY_NAME_TSOD_<英文名>`，57 个，英文名由 WP1 拟定后登记 | WP1 |

---

## 4. 工作包总览

```
阶段 0   WP0 骨架与契约（统筹者，串行）
           │
阶段 1   ┌─ 数据（可并行）── WP1 文明与领袖   WP2 文明能力   WP3 领袖能力
         │                   WP4 战斗法师基础 WP5 法师塔     WP6 燃石酸化工厂
         │                   WP7 议程与 AI    WP8 百科与台词
         ├─ 美术（可并行，需要你提供或认可图源）
         │                   WP9 图标  WP10 模型 ArtDef  WP11 领袖美术  WP12 历史时刻
         └─ 工具（可并行，不在提丰仓库里）
                             WP19 可复用测试工具
           │
集成 I1   统筹者合并 → 静态检查 → 构建 → 游戏内自动测试 → 你测体验
           │
阶段 2   WP13 湮灭之创 + 军队回血 + 通知（依赖 WP4；方案 A）
         WP16 去神圣化项目   WP17 神权理事会决议   WP18 系列联动   WP14 战神教
         WP11 续：多情绪立绘与外交场景
           │
集成 I2   同 I1，加平衡测试（Autoplay）
           │
发布     WP20 发布准备：英文校对、繁体中文、兼容测试、工坊发布物、署名、系列合集
           │
之后     WP21 联机测试（P2）    WP15 专属外交政策卡（可选）    剧本（P3，不在本计划内）
```

| 包 | 名称 | 依赖 | 独占文件 | master plan 章节 | 规模 |
|---|---|---|---|---|---|
| WP0 | 骨架与契约 | — | `.civ6proj`、`docs/*`、`tools/*` | 全部（只看结构） | 小 |
| WP1 | 文明与领袖数据 | WP0 | `Core/TsoDTE_Civilization.sql`、`TsoDTE_Leader.sql`、`TsoDTE_Colors.sql`、`TsoDTE_Config.sql`、`Texts/TsoDTE_Text_CivLeader.sql` | §0、§9.1-9.2、§11 | 中 |
| WP2 | 文明能力 | WP0 | `Core/TsoDTE_CivTrait.sql`、`Texts/TsoDTE_Text_CivTrait.sql` | §4 | 小 |
| WP3 | 领袖能力 | WP0 | `Core/TsoDTE_LeaderTrait.sql`、`Scripts/TsoDTE_LeaderTrait.lua`、`Texts/TsoDTE_Text_LeaderTrait.sql` | §5 | 小 |
| WP4 | 战斗法师基础 | WP0 | `Core/TsoDTE_Unit_BattleMage.sql`、`Texts/TsoDTE_Text_BattleMage.sql` | §6.1 的 1、2 部分 | 中 |
| WP5 | 法师塔 | WP0 | `Core/TsoDTE_District_MageTower.sql`、`Texts/TsoDTE_Text_MageTower.sql` | §6.2 | 小 |
| WP6 | 燃石酸化工厂 | WP0 | `Core/TsoDTE_Building_Burnstone.sql`、`Texts/TsoDTE_Text_Burnstone.sql` | §6.3 | 小 |
| WP7 | 议程与 AI | WP0 | `Core/TsoDTE_Agenda_AI.sql`、`Texts/TsoDTE_Text_Agenda.sql` | §8.1-8.2 | 小 |
| WP8 | 百科与台词 | WP0 | `Texts/TsoDTE_Text_Pedia.sql` | §2、§8.4、§9.5、§12 | 中 |
| WP9 | 图标 | WP0 + 图源 | `Icons/TsoDTE_Icons.xml`、`Textures/ICON_*`、相关 XLP | §9.1、§9.4 | 中（主要是素材） |
| WP10 | 模型 ArtDef | WP0 | `ArtDefs/Landmarks.artdef`、`Units.artdef`、`Buildings.artdef` | §9.3 | 中 |
| WP11 | 领袖美术 | WP0 + 图源 | `ArtDefs/FallbackLeaders.artdef`、`Civilizations.artdef`、`Cultures.artdef`、`Overlay.artdef`、领袖相关 XLP 与贴图 | §2.1、§9.4、§9.5 | 大（主要是素材；多情绪立绘与外交场景在阶段 2） |
| WP12 | 历史时刻 | WP0 + 图源 | `Core/TsoDTE_Moments.sql`、时刻插图贴图 | §9.4 | 小（主要是素材） |
| WP13 | 湮灭之创 + 回血 + 通知 | WP4 合并后 | `Core/TsoDTE_WMD.sql`、`Core/TsoDTE_Notifications.sql`、`Scripts/TsoDTE_BattleMage.lua`、`UI/UnitPanel_TsoDTE.lua`、`Texts/TsoDTE_Text_WMD.sql` | §6.1 的 3、4、5 部分，§8.2 | 大 |
| WP14 | 战神教 | WP0 | `Core/TsoDTE_Religion_WarGod.sql`、`Texts/TsoDTE_Text_Religion.sql`、宗教图标与叠加层 | §7 | 中（主要是美术） |
| WP15 | 外交政策卡（可选） | I2 后 | `Core/TsoDTE_Policy.sql`、`Scripts/TsoDTE_Policy.lua` | §8.3 | 小 |
| WP16 | 去神圣化项目 | WP5 合并后 | `Core/TsoDTE_Project_Desanctification.sql`、`Scripts/TsoDTE_Project.lua`、`Texts/TsoDTE_Text_Project.sql` | §6.4 | 小 |
| WP17 | 神权理事会决议 | WP0 | `Core/TsoDTE_Congress.sql`、`Texts/TsoDTE_Text_Congress.sql` | §8.5 | 小（但需实证） |
| WP18 | 系列联动 | WP1、WP7 合并后 | `Core/TsoDTE_Compat_Cecil.sql`、`Core/TsoDTE_Compat_DreamCity.sql`、`Texts/TsoDTE_Text_Compat.sql` | §8.6 | 小 |
| WP19 | 可复用测试工具 | — | 在技能套件里，不在提丰仓库；提丰仓库只放 `tests/` 下的测试用例 | 本文件 §6.1 | 中 |
| WP20 | 发布准备 | I2 后 | `README_CN.md`、`README_EN.md`、`WORKSHOP_*.md`、封面与截图、各 `Texts/*` 的英文校对和繁中文件 | — | 中 |
| WP21 | 联机测试（P2） | WP20 后 | 只出测试报告 | — | 小 |

**关于 WP1 和其他包的交界**：
- 开局界面的特色项展示（`Config` 里每个特色项一行）由 WP1 写，直接引用登记表里的 ID，不用等其他包。
- 两个特性的「壳」（Types、Traits 行）也由 WP1 建；WP2、WP3 只往里挂修正。

---

## 5. 各工作包说明

每包的内容以 master plan 对应章节为准，这里只写**边界、要点、验收**。

### WP0 骨架与契约（统筹者）

1. 建仓库目录（§2），`git init`，把两份计划移进 `docs/`，从塞西尔复制 `tools/restore_cooked_entries.py`。
2. 以塞西尔的 `.civ6proj` 为蓝本新建工程：
   - **新 GUID**，绝不复制塞西尔的（技能铁律第 8 条）；
   - Mod 名照塞西尔格式：`[The Sword of Dawn (TSOD)] Typhon Empire Civilization` /《黎明之剑》提丰帝国文明；
   - 依赖：风云变幻 + 迭起兴衰；
   - 挂上构建后自动运行 `restore_cooked_entries.py` 的 target。
3. 写 `docs/ids.md`：§3.1 的登记表加上文件归属。
4. 建空的动作（§2.1），先能空构建成功。

**验收**：空 mod 能构建、部署，游戏里 mod 列表能看到它。

### WP1 文明与领袖数据

- **文明**：文明、领袖、首都（奥尔德南）、57 个城市（按 master plan §11.2 的顺序）、市民名（§11.3）、民族 `ETHNICITY_EURO`，`RandomCityNameDepth` 同塞西尔。
- **城市英文名**：音译要统一风格，例如奥尔德南 Ordenan、冬堡 Winterhold、冬狼堡 Winterwolf Keep。全部列进 `docs/ids.md` 的待登记清单，统筹者确认后登记。
- **配色**：黑底红徽，加两组备用色（§9.2）。
- **开局设置**：文明与领袖条目，特色项展示四行。
- **两个特性的壳**。
- **验收**：开局界面能选到罗塞塔；城市按顺序命名；没有 `LOC_` 原文漏出。

### WP2 文明能力

master plan §4 的三条：
- 学院城市训练单位免费升级：兵营能力授予 + `Amount=-1`；
- 学院、圣地 +1 大将军点数：「神圣之光」的写法；
- 有军营区域的城市不受宗教压力：「神之堡垒」的效果。

**验收**：在有学院的城市造一个陆军单位，出生时就能晋升；城市面板的大将军点数 +1；对有军营的城市传教，压力不增长。

### WP3 领袖能力

- **SQL**：新时代给随机尤里卡和鼓舞（首尔），黑暗时代再给一组（`REQUIREMENT_PLAYER_HAS_DARK_AGE`）。
- **Lua**：`Events.UnitKilledInCombat` → 被杀单位的前置科技 → `PlayerTechs:TriggerBoost`。每项科技只触发一次；只对提丰玩家生效（按领袖判断）。
- 写法参考塞西尔的 `TsoDCE_CivilizationTraits.lua`：拿到拥有此特性的玩家，再在加载完成时注册事件。
- **需实证**：进入黑暗时代的那一刻，「是否黑暗时代」判定是否已更新；不行就改用 Lua。
- **验收**：用 FireTuner 杀一个敌方后期单位，看到对应科技亮尤里卡；连续两个时代各收到一次尤里卡与鼓舞。

### WP4 战斗法师基础

- 单位行：替代弩手；造价 180；近战 30 / 远程 40 / 射程 2；`PrereqTech` 机械；不设升级。
- 标签：`CLASS_RANGED`、`CLASS_TSOD_BATTLE_MAGE`、`CLASS_ALL_ERAS`；`WMDCapable="true"`（为阶段 2 预留）。
- **AI 类型**：照弩手，再加 `UNITTYPE_NUCLEAR`。
- **成长**：照尼杭的结构自建两个能力。文明能力挂 `MODIFIER_PLAYER_UNITS_GRANT_ABILITY`，拥有者条件为 `REQUIREMENT_PLAYER_HAS_TECHNOLOGY`。
  - 弹道学：远程 +20、近战 +20；
  - 高级弹道学：远程 +25、近战 +20。
  - **先测** `MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH` 对远程是否生效；不生效就换 `MODIFIER_UNIT_ADJUST_COMBAT_STRENGTH`。
- **军团级法术**：相邻有另一个战斗法师时远程 +5。
- **验收**：
  - 游戏里能造出来，弩手被替代，且没有升级按钮；
  - 用 FireTuner 给出弹道学后，远程显示 60；
  - 两个战斗法师相邻时战斗预览出现 +5。

### WP5 法师塔

- 区域行：替代学院；造价 27；`HitPoints="100"`；`ZOC` 与 `CityStrengthModifier` 照奥皮杜姆。
- 相邻加成：保留学院原有的相邻加成，再加「每个相邻军营区域 +2 科技」。
- 反间谍：`MODIFIER_CITY_ADJUST_SPY_BONUS`，`Amount=1`，照领事馆。
- **验收**：区域能自己远程打击；挨着军营时科技相邻加成 +2；敌方间谍在本城的成功率面板下降一级。

### WP6 燃石酸化工厂

- 建筑行：替代工厂；保留工厂的范围效果与用电规则。
- 产出：+6 生产力、+3 科技。
- 本城所有农场 +5 食物：`MODIFIER_CITY_PLOT_YIELDS_ADJUST_PLOT_YIELD` + `REQUIREMENTS_PLOT_HAS_FARM`。
- **不做**排碳和烧煤。
- **验收**：建成后城市的农场地块食物 +5，城市产出正确。

### WP7 议程与 AI

- **议程「同类」**：
  - 军力比较照官方隐藏议程「常备军」（`REQUIREMENT_PLAYER_MILITARY_STRENGTH_LEAD`）；
  - 传教照姆本巴议程（`REQUIREMENT_PLAYER_RELIGION_RECEIVED`），把态度反过来。
- **AI 偏好**：学院、军营、圣地、法师塔、战斗法师、燃石酸化工厂；征服优先、科技其次；宗教倾向中等。用 civ6-modding-ai 技能。
- **验收**：和 AI 罗塞塔外交时，议程态度的条目显示正确；看 Autoplay 日志，AI 会造法师塔和战斗法师。

### WP8 百科与台词

- **百科**：文明与领袖的历史条目，素材取 master plan §2 和 §12 的出处，用自己的话概述，不大段照抄原文。
- **人物与地点条目**（master plan §9.5）：
  - 人物：裴迪南、安德莎、温莎、帕林、戴安娜、玛蒂尔达、马尔姆；
  - 地点：奥尔德南、冬堡、冬狼堡、奥兰戴尔之喉、黄昏宫殿。
  - 先查官方百科能不能加自定义分组页；不能就并进文明条目的段落里。
- **内嵌图标**：描述文本里的产出和单位类别一律用官方 `[ICON_XXX]`。
- **单位、区域、建筑的百科短文**：由各自的包只写 NAME 和 DESCRIPTION，百科的长文统一在这里写，避免多包重复改。
- **外交台词**：照 §8.4 的基调写问候、宣战、被宣战、和平、战败等。
- **引言**：领袖引言、文明引言。
- **验收**：`loc_audit.py` 无缺失；百科页能打开。

### WP9 图标（需要你给图源）

- **全部尺寸**见 master plan §9.4：
  - 文明、领袖；
  - 战斗法师单位图标 + `_FOW` + 立绘；
  - 法师塔区域图标 + `_FOW`；
  - 燃石酸化工厂；
  - 三种通知（可以借用单位图标）；
  - 战神教（WP14 时补）。
- **国徽**照 §9.1：黑底红徽、四分盾加互换色皇冠的单色剪影。
- **工具**：
  - 本机有 hemmelfort 的「文明6 MOD辅助工具」，能一次出全套尺寸和 dds，技能建议用它之前先问你；
  - texconv 还没装（`winget install Microsoft.DirectXTex.Texconv`）。
- **图源选项**：
  - 你提供；
  - 用 mod-creator 的 ComfyUI 工作流生成；
  - 塞西尔用过的 AI 生图。
- **验收**：所有界面（开局、城市面板、单位面板、科技树、百科）都没有空白图标。

### WP10 模型 ArtDef

- **法师塔**：学院各时代底座做骨架，`DIS_CMP_Alchemical`（炼金学会）做主体，`LM_Ley_Line` 叠光效，测试太耀眼就删。
  - 引用方式照塞西尔 `Landmarks.artdef` 引用 `DIS_CTY_Obelisk`；
  - 构建后靠 `restore_cooked_entries.py` 修复 `TB_ERROR`。
- **燃石酸化工厂**：沿用工厂模型。
- **战斗法师**：调研可借的官方单位素材（宗教单位长袍、弩手换装等），拿 2~3 个候选给你挑，挑定后写 `Units.artdef`。
- **验收**：法师塔、工厂、战斗法师在地图上都有模型；没装埃塞俄比亚包时，法师塔至少显示学院底座（需实证）。

### WP11 领袖美术（需要你给图源）

- **立绘**：男性中年、消瘦阴郁、灰色短卷发、金边黑外套、背光的高背椅（§2.1）。
- **背景**：
  - 外交背景建议用「黄昏宫殿」的画像长廊，或黑曜石宫的书房；
  - 载入画面背景 1920×960，外交场景背景 1920×1010。
- **忠诚度 Overlay 与 Pressure**：照 `制作一组Overlay.docx` 用资产编辑器做，模板在工作区根目录。
- **阶段 2：多情绪立绘与外交场景**（master plan §9.5）：
  - 在中性立绘基础上，用 AI 改图出开心、不悦、愤怒、宣战几种情绪，登记进 `FallbackLeaders.artdef`；
  - 外交场景三层，背景为黄昏宫殿的画像长廊。
- 这部分基本是素材工作。子代理负责 ArtDef、XLP 登记与尺寸规范；画面由你或生图工具出。

### WP12 历史时刻

- **插图**：特色单位、特色区域、特色建筑各一张，460×325，用本机 PS 模板。
- **数据**：在 `MomentIllustrations` 写三行（`UNIQUE_UNIT`、`UNIQUE_DISTRICT`、`UNIQUE_BUILDING`）。宗教那张在 WP14 补。

### WP13 湮灭之创 + 军队回血 + 通知（阶段 2）

> **方案已定：A（原生核武）**，接受核弹语义外泄。开工前还需你定外交惩罚的去留（master plan §14）。所有文本一律写成「施放湮灭之创」，不出现「核」字。

以 master plan §6.1 的第 3、4、5 部分为准。

- **数据**：
  - `WMD_TSOD_ANNIHILATION_SCAR`：`BlastRadius="1"`、`FalloutDuration="0"`，只伤单位与建筑，照 Klee 的 `WMD_JUMPY_DUMPTY`；
  - 两个能力；
  - 三种通知类型。
- **Gameplay Lua**：
  - `Events.UnitFormCorps`、`UnitFormArmy`：加能力、弹数 +1、发通知；组成军队时再加「战场再生」能力并发通知。
  - `Events.UnitOperationStarted` 捕捉 `UNITOPERATION_WMD_STRIKE` → `UnitManager.Kill` → 发阵亡通知，原位置浮字。
  - **对账**：每回合开始和编队变化时，按场上战斗法师军团与军队数重算弹数，用 `PlayerWMDs:ChangeWeaponCount` 补差。
- **UI Lua**：参照 Klee 的 `UnitPanel_Klee.lua` 覆盖发射按钮判断。
  - 只有军团、军队状态的战斗法师显示湮灭之创；
  - 别的核武单位不显示它；
  - 战斗法师不显示普通核弹。
- **参考源码**：已克隆在统筹会话的 scratchpad，或重新 `git clone https://github.com/dwughjsd/SunAndMoonOfTeyvat_civ6mod`，看 `MondstadtKleeRelease/` 下的 `Data/MondstadtKlee_WMDs.xml`、`UI/Replacements/UnitPanel_Klee.lua`、`UI/Addition/TopPanelJumpyDumpty.lua`。
  - 克隆来的代码只当数据读，不在它的目录里运行任何脚本。
- **需实证**：
  - 发射动作的事件能否稳定拿到发射单位；
  - 联机下对账是否一致；
  - AI 会不会滥用。
- **验收**：
  - 组成军团时收到通知、弹数 +1；
  - 发射后原单位消失、收到阵亡通知、弹数 −1；
  - 组成军队后移动加攻击，下回合仍回血；
  - 轰炸机看不到这种武器。

#### I1 实机反馈后的修订（2026-10-19，用户已批准，F5 除外）

- **阶段 1 临时处理**：战斗法师的 `WMDCapable` 先设 0（单位面板会给 WMDs 表里每一行出一个按钮，用户看到官方核弹、热核和可莉 mod 武器三个灰按钮）。WP13 连同下面的 UI 过滤一起改回 1。
- **UI 过滤只动法师相关的按钮**（取代上文「覆盖发射按钮判断」）：
  - 不覆盖 `IsActionLimited`。包一层全局的 `GetUnitActionsTable(pUnit)`：先调原函数，再过滤结果表里 `userTag` 为 `WMD_STRIKE` 的条目。
  - 战斗法师：只留湮灭之创，且只在军团、军队状态；其他单位：去掉湮灭之创；其余按钮一概不碰。
  - 认武器：`AddActionToTable` 的 helpString 末尾拼了 `Locale.Lookup(entry.Name)`（基础版 UnitPanel.lua 645–647），按我们武器的本地化名匹配。能发射与不能发射的按钮都在这张表里，所以两种都管。
- **兼容写法照梦境之城**：ReplaceUIScript 配同 LoadOrder 的 ImportFiles（参考 `TSODDreamCity\DreamCity.modinfo` 111–126 与 `UI\CityStates_TSODDreamCity.lua` 文件头）。
  - LoadOrder 定为 **200000**，要高于 BuilderLagFix 的 160520（ids.md §5.3 同步）。
  - 用户装的另外两个替换 UnitPanel 的 mod：可莉（工坊 2882489805，`UnitPanel_Klee.lua` 自己 include 基础版，只重定义 `IsActionLimited`）；BuilderLagFix（工坊 2024939221，LoadOrder 160520，它的 `UnitPanel_XP2.lua` 只 include `UnitPanel_Expansion2` 和 `BuilderLagFix`，后者在 ImportFiles 里，并整体重写了 `GetUnitActionsTable`）。
  - 接力顺序（避免基础版被 include 两次）：a. `include("UnitPanel_Klee")`；b. 若之后 `Initialize` 仍未定义，按可莉的循环依次 include `UnitPanel_Expansion2`、`UnitPanel_Expansion1`、`UnitPanel`；c. `include("BuilderLagFix")`；d. 最后包我们这一层。文件不存在时 include 不报错。文件头照梦境之城写明这些。
  - **限度**写进注释，也要告诉用户：同一个面板脚本只能有一个替换生效，做不到对所有 mod 兼容。以后若有不认识的 mod 替换单位面板且比我们后加载，损失的只是这层过滤（三个按钮重新出现），游戏逻辑不受影响。
- **别的单位发射湮灭之创（F6，默认做法，用户可改）**：弹药是玩家级库存，轰炸机、核潜艇也能发射；按对账「多退少补」会下回合补回，等于无限弹；UI 过滤也拦不住 AI。处理：在 `UnitOperationStarted` 里，若发射者不是军团 / 军队状态的战斗法师，就让离目标最近的一支战斗法师军团（或军队）代为阵亡，保持「弹数 = 军团数」；找不到可阵亡的军团时只记日志。
- **作弊菜单组军团不专门处理**（F4 撤销，用户原话：「这个我用正常途径就行，没必要改实现效果」）。§6.1 的对账照原计划做（回合开始 + 编队变化）；测试只走游戏正常合并。
- **外交惩罚的去留**仍待用户定（F5）。

### WP14 战神教（阶段 2，可选内容）

- **数据**：`Types` + `Religions` + 颜色 + 历史时刻，照 Tomatekh's Historical Religions（本地工坊 870850597）。
- **开局开关**：在开局设置里加一个选项，用 `ConfigurationValueMatches` 控制宗教文件是否加载。
- **美术**：
  - 宗教图标 270 尺寸，外加 22 尺寸的文本内嵌图标；
  - 宗教透镜叠加层，用资产编辑器做 `.ast`；
  - 一张历史时刻插图。
- **图标设计**：没有官方标志，按 §7 的意象自己设计。
- **验收**：开关打开时，创立宗教可以选「战神教」；关闭时完全看不到。

### WP16 去神圣化项目（阶段 2）

- 项目行：需法师塔，解锁市政「大众传媒」，可重复。
- 设 `UnlocksFromEffect="true"`，文明能力挂 `MODIFIER_PLAYER_ALLOW_PROJECT`，照凯瑟琳「宫廷庆典」。
- 完成时给外交支持度：项目完成修正 `MODIFIER_PLAYER_ADD_FAVOR`，25 点。
- 完成时把信仰值存量的一半转成科技：Lua `Events.CityProjectCompleted` → `ChangeFaithBalance` / `ChangeCurrentResearchProgress`。只对提丰生效，并发一条通知。
- **验收**：只有提丰在法师塔里看得到这个项目；完成后信仰值减半、研究进度增加、外交支持度 +25。

### WP17 神权理事会决议（阶段 2）

- `Resolutions` 一行：`TargetKind="RELIGION"`，`EarliestEra="ERA_MODERN"`，复用 `ValidationLua="WC_Validate_RegliousBan"`、`AITargetChooser="ReligiousTarget"`。
- `ResolutionEffects` 两行：
  - A 复用 `MODIFIER_MAJOR_PLAYERS_ADJUST_UNITS_RELIGIOUS_STRENGTH_BY_RELIGION_TYPE`，`Amount=-10`；
  - B 复用官方的 `ANYONE_CONDEMNS_FOR_FAVOR`。
- 提丰 AI 偏好投 A：去 civ6-modding-ai 查决议偏好怎么写；查不到就不做 AI 偏好。
- **需实证**：没有工坊先例；负值战斗力是否生效；新决议能否正常进入议程池。
- **验收**：现代时代后的世界议会能抽到这个决议；投出 A 后，该宗教单位的战斗力 −10。

### WP18 系列联动（阶段 2）

- 塞西尔联动文件，criteria `ModInUse`（塞西尔的 mod id）：
  - 罗塞塔对高文、高文对罗塞塔各一条外交态度修正，条件 `REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES`，附专属说明文本；
  - 查外交台词能否按对方领袖区分，能就加罗塞塔遇到高文的专属问候。
- 梦境之城联动文件，criteria `ModInUse`（梦境之城的 mod id）：
  - 照梦境之城自己的宗主国写法：外层 `MODIFIER_ALL_PLAYERS_ATTACH_MODIFIER` 加宗主条件，内层再限定为提丰；
  - 效果是有法师塔的城市 +1 宜居度。
- **不改**塞西尔和梦境之城的仓库。
- **验收**：只装提丰时这两个文件不加载；同开时态度条目和宜居度出现。

### WP19 可复用测试工具（不属于提丰仓库）

见 §6.1。建议做进 civ6-modding 技能套件，以后所有文明 mod 都能用。

### WP20 发布准备

- **文本**：英文全文校对；繁体中文用简体自动转换，再人工过一遍专有名词。
- **兼容测试**：把相关 mod 全部装上过一遍：和而不同、CIVITAS、Better City States、常用界面 mod（尤其也替换单位面板的）、塞西尔、梦境之城。
- **工坊发布物**（civ6-modding-publish 技能）：
  - 中英简介（BBCode，照塞西尔与梦境之城的格式）、封面（借梦境之城的 `make_cover.py`）、截图、标签；
  - 版本号；
  - 加入《黎明之剑》系列合集。
- **署名**：地图与旗帜的同人作者、AI 生图的说明，照塞西尔 README 的「素材来源」写。

### WP21 联机测试（P2）

两台机器或两个账号开一局，按 §6.1 的游戏内自动测试跑一遍，重点看何不用之、湮灭之创的对账、去神圣化的信仰转换有没有不同步。

---

## 6. 集成、测试与验收（统筹者）

每个阶段结束做一次：

1. **合并**：把各包报告里的文件清单登记进 `.civ6proj`，补进 `docs/ids.md`。
2. **静态检查**：对 `src/` 跑 §6.1 的第一层。
3. **构建**：MSBuild 或 ModBuddy 构建 → 自动修复 ArtDef → 部署到 Mods 目录。构建后对部署出来的 `.modinfo` 再跑一次 `validate_mod.py`：ModBuddy 工程的 `.modinfo` 是构建时生成的。
4. **游戏内自动测试**：§6.1 第二层。
5. **你测体验**：只测自动测试测不了的部分，如画面、通知样式、手感。
6. **排错**：日志交给 `civ6-modding-debugger` 子代理，它只带回结论。

### 6.1 测试流程（可复用，分四层）

**先回答两个问题：**
- **「四条静态检查」是什么**：不是游戏自带的，是我们 civ6-modding 技能套件里的四个脚本。游戏对 mod 没有任何测试；写错了大多数时候也不报错，只是没反应，这四个脚本就是为了在进游戏前抓这类错误。

| 脚本 | 查什么 |
|---|---|
| `validate_mod.py` | `.modinfo` 结构、GUID、文件登记、criteria、LoadOrder |
| `loc_audit.py` | LOC 文本 tag 有没有漏定义、中英文是否齐全 |
| `modifier_lint.py` | EffectType、RequirementType、ModifierType 是否存在，规则集是否可用，需求组是否都定义了 |
| `lua_lint.py` | 事件名是否存在、Gameplay 与 UI 环境有没有用错、有没有联机不同步的写法 |

- **为什么不上 GitHub Actions**：后三个脚本依赖技能的本地知识库 `civ6kb.sqlite`。它是从本机游戏文件扫出来的，不能放进公开的 CI。所以改用**本地 git pre-commit 钩子**，每次提交前自动跑，效果一样。

**四层测试**：

| 层 | 内容 | 自动化程度 | 技能里现有吗 |
|---|---|---|---|
| 1 静态 | 四个脚本 + 构建，挂 pre-commit 钩子 | 全自动 | 脚本有；钩子要做 |
| 2 游戏内自动测试 | 测试工具 mod 自动布置场景、断言结果，见下 | 你只需开一局 | **没有，要做（WP19）** |
| 3 平衡与 AI | Autoplay 跑 N 回合，收集 `AI_*.csv` 与得分，与官方文明对照 | 半自动 | FireTuner 的 `Autoplay.ltp` 和 AI 日志有，汇总脚本要做 |
| 4 体验 | 你按清单看画面和手感 | 手动 | — |

**第 2 层：游戏内自动测试工具**。技能里只有 FireTuner 调试台和日志排查，没有自动测试。但需要的 Lua 方法全都核实存在，可以做：

- **它是什么**：一个只在开发时启用、永不发布的「测试工具 mod」。
- **开局后自动做三件事**：
  1. **布置**：给科技（`PlayerTechs:SetTech`）、刷单位（`UnitManager.InitUnit`）、建区域和建筑（`CityBuildQueue:CreateDistrict` / `CreateBuilding`）、加经验（`UnitExperience:ChangeExperience`）。
  2. **断言**：读单位战斗力（`Unit:GetCombat` / `GetRangedCombat`）、能力层数（`GetAbility():GetAbilityCount`）、城市和区域产出（`City:GetYield` / `District:GetYield`）、核武库存（`PlayerWMDs:GetWeaponCount`），以及**修正是否生效**（`GameEffects.GetModifierActive`，这正好治「改了没反应」）。
  3. **报告**：每条用例往 `Lua.log` 写一行 `[TSOD-TEST] PASS/FAIL <用例> <实际值>`，再由一个小脚本汇总成表。
- **需要过回合的用例**（例如黑暗时代、军队回血）：工具里调 `AutoplayManager.SetTurns` / `SetActive` 自动推几回合；这套接口游戏自己的自动化脚本在用。
- **你要做的只有开一局**：用保存好的开局配置，选罗塞塔、开测试工具，一键开始。
- **更进一步（P2）**：游戏自带一套 Firaxis 内部的自动化框架（`Base/Assets/UI/Automation/`，有 `PlayGame`、`LoadGame` 测试和 `Benchmark.RunAIBenchmark`），理论上可以连「开局」都自动。怎么从外部触发还没摸清，留作后续实验。
- **放在哪**：建议把通用的测试工具做进 civ6-modding 技能套件（作为新的测试能力和模板 mod），各文明 mod 只在自己仓库的 `tests/` 里写用例。塞西尔、梦境之城以后也能用。
- 写进本计划的「需实证」项，都应该先变成一条测试用例。

### 6.2 需实证项总表

| 项 | 所属包 | 不成立时的退路 |
|---|---|---|
| 一次性升级效果放在能力里是否只触发一次 | WP2 | Lua 在单位生成时加经验 |
| 「神之堡垒」效果挂在文明能力上的语义 | WP2 | 改为按城市逐个挂修正，或接受原语义 |
| 进入黑暗时代时判定是否已更新 | WP3 | Lua 监听新时代 |
| 基础战斗力修正对远程是否生效 | WP4 | 换普通战斗力修正 |
| 没装埃塞俄比亚包时法师塔的显示 | WP10 | 只用本体素材 |
| 发射事件拿到发射单位、联机对账 | WP13 | 改为按回合对账加阵亡判定 |
| 使用湮灭之创是否产生外交不满（方案 A） | WP13 | 方案 B |
| 新决议能否进入议程池、负战斗力是否生效 | WP17 | 换成正面效果，或不做这个决议 |
| 外交台词能否按对方领袖区分 | WP18 | 只做态度说明文本 |

---

## 7. 子代理派发模板

统筹者给每个包派子代理时，用下面的模板（把尖括号部分换掉）：

```
你负责《黎明之剑》提丰帝国文明 mod 的工作包 <WPn：名称>。

仓库：C:\Users\xegna\Documents\Workspace\TSODTyphonEmpire
必读（只读这些）：
- docs/impl-plan.md 的 §1、§3 和 §5 里 <WPn> 那一节
- docs/master-plan.md 的 <章节号>
- docs/ids.md

你独占的文件：<文件清单>。不要创建或修改清单以外的任何文件，尤其不要碰 .civ6proj 和 docs/ids.md。

做法：
- 用 civ6-modding 技能（及对应子技能 <data/modifier/lua/content/text/art/ai>）。
- 任何 EFFECT/MODIFIER/REQUIREMENT/表名/列名/Lua 方法，写之前先用技能的查询脚本核实，照官方先例的写法抄。
- 写完对自己的文件跑 validate_mod.py、loc_audit.py、modifier_lint.py、lua_lint.py。

完成后只回报（不要贴代码全文）：
1. 创建的文件清单，以及每个文件该用的 .civ6proj 动作类型；
2. 用到的全部 ID，标出 ids.md 里没有、需要登记的；
3. 静态检查结果；
4. 需实证项和你建议的进游戏测试步骤；
5. 和 master plan 有出入的地方，以及原因。
```

**统筹者自己的上下文纪律**：
- 只保留本文件、`ids.md` 和各包的回报；
- 不读子代理写的 SQL 全文。有问题时让子代理自己修，或另派一个检查子代理。

---

## 8. 需要你提供或决定的东西

| 什么 | 何时需要 | 备注 |
|---|---|---|
| 图源方案：自己画、ComfyUI、还是其他 AI 生图 | WP9、WP11、WP12 开工前 | **已定（2026-10-17）：其他 AI 生图，同塞西尔**。你出图、挑图，子代理负责尺寸、dds、XLP 与 ArtDef 登记 |
| 战斗法师的单位模型 | WP10 中途 | 子代理给 2~3 个官方素材候选 |
| 城市英文名 | WP1 完成时 | 子代理拟、你过目 |
| 进游戏测试 | 每次集成后 | 按 §6 的清单 |
| 由谁统筹 | 开工前 | 建议新开一个会话当统筹者，见 §0 |
| 湮灭之创的外交惩罚留不留（方案 A 已定） | WP13 开工前 | master plan §14 |
| 测试工具放进技能套件还是单独仓库 | WP19 开工前 | 建议放进技能套件 |
