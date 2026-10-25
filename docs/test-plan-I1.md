# 集成 I1 · 阶段 1 数据测试清单

> 对应 impl plan §6。阶段 1 合并了数据包 WP1–WP8，外加提前做的法师塔模型（WP10 的一部分）。
> **图标空白、领袖没有立绘、战斗法师和燃石酸化工厂没有专属模型**都是预期现象（WP9、WP11、WP10 其余部分），不用记成问题。
> 湮灭之创、军队回血、通知属于阶段 2（WP13），这一轮测不到。
> 游戏内自动测试工具（WP19）还没做，这一轮用作弊菜单 + FireTuner 手动测。
> 构建与部署状态见 §0。

## 第一轮实测结果（WP1–6、WP8 已测）与第二轮要复测的

| 项 | 第一轮结果 | 处理 | 第二轮复测 |
|---|---|---|---|
| 法师塔远程攻击 | 能打，但要先有城墙 | 符合预期（同市中心、军营），不改 | — |
| 法师塔说明 | 军营相邻加成写在悬停说明里，重复 | 说明里删掉这句；建造面板 / 百科的「相邻加成」会按数据自动列出（百科文明介绍里保留） | 悬停说明里没有这句；相邻加成列表里有「+2 科技 来自相邻军营」 |
| 战斗法师悬停 / 战斗预览 | 两处都写了效果：①单位面板悬停（血条提示）列出「军团级法术：与至少一个……+5 远程攻击力」；②战斗预览里写成「高级弹道学成长+5 战斗力」 | ①来自能力的 Description（游戏只列 Description，不单独列名字）：三个能力的 Description 改成只写能力名；②来自 ModifierStrings 的 Preview：只写「+N 能力名」，同官方「+5 齐射（升级）」。效果说明留在单位描述和百科里 | ①悬停提示里三个能力各只有一行名字；②预览里是「+5 军团级法术」「+20 弹道学成长」「+25 高级弹道学成长」 |
| 弹道学 / 高级弹道学远程 | 近战面板 70 对；远程仍是 40 底，预览只有高级弹道学的 +5 | 基础战斗力修正只改近战。远程改走已验证能用的「远程攻击时 +N」：弹道学 +20、高级弹道学 +25 | 见流程第 4 步 |
| 黄昏宫殿（新时代尤里卡 / 鼓舞） | 过两个时代都没给 | SQL 效果在风云变幻里不生效，删掉，改用 Lua | 见流程第 6 步 |
| 燃石：科技是否辐射 | 辐射（6 格内别的城拿到了科技） | 文本本来就按辐射写，不改 | — |
| 燃石：农场 +5 | 对（3 粮玉米 → 10 = 3 + 农场 2 + 5） | — | — |
| 燃石：矿山 +2 | 草原丘陵矿山 2 粮 4 锤，应为 6 锤（丘陵 1 + 矿山 1 + 学徒 1 + 工业化 1 + 燃石 2） | 改成和农场同形的写法：矿山、采石场各一个修正，需求自己定义 | 见流程第 7 步 |
| 议程文本 | 罗塞塔是男性，议程写成了「她」 | 中英文改成「他 / his」 | 领袖界面的议程说明 |
| 军团 / 军队 | 民族主义只能组军团，组军队要「动员」市政 | 清单写错，已改 | — |
| 核弹按钮 | 没有 | 阶段 1 预期（`WMDCapable` 临时为 0） | — |
| 高文（塞西尔 mod）台词 | 部分台词像是通用台词 | 已查明是塞西尔 mod 的问题，见 §7 | — |

## 0. 已经自动验证过的（不用你测）

| 检查 | 结果 |
|---|---|
| `validate_mod.py`（部署后的 .modinfo） | 0 错误 0 提示 |
| `loc_audit.py` | 中英各 202 个 tag，齐全；数据行引用的 126 个 tag 中英都有定义 |
| `modifier_lint.py --ruleset xp2` | 0 错误，读到 18 个 SQL、147 行修正数据，0 条语句未检查（脚本已改成直接读 SQL） |
| `lua_lint.py` | 0 错误 |
| 全部 SQL 按工程顺序灌进游戏缓存库副本 | 语句 0 报错；本 mod 0 个外键违例 |
| 美术烘焙（cooker） | 只报 1 处 DLC 资产解析不了（`DIS_CMP_Alchemical`），`restore_cooked_entries.py` 还原了这 1 处；部署后的 artdef 里 0 个 `TB_ERROR` |

这些只说明「没有已知的静态错误」，**不代表进游戏一定生效**。

## 1. 准备

1. `%LOCALAPPDATA%\Firaxis Games\Sid Meier's Civilization VI\AppOptions.txt` 里 `EnableTuner 1` 已开（已确认）。
2. 启动游戏 → 附加内容：列表里能看到「《黎明之剑》提丰帝国文明」，启用。现在依赖里多了埃塞俄比亚包，没装它时这个 mod 会是灰的。
3. 每测完一轮，退出游戏后跑：
   ```
   python C:\Users\xegna\.claude\skills\civ6-modding\scripts\log_triage.py --mod TSODTyphonEmpire
   ```
   或者直接把日志交给我，我派 `civ6-modding-debugger` 去读。

## 2. 作弊菜单快速流程

按钮名取自麻雀作弊菜单的中文界面：完成当前科技研究、完成当前市政研究、所选城市完成当前建筑、加+1000金币、加+10时代得分 / 减-10时代得分、复制所选的单位、所选单位升级为军团 / 军队、所选单位升1级。作弊菜单没有刷单位按钮，**敌方单位仍用 FireTuner 刷**：在 FireTuner 的 Lua 环境下拉框选 `TsoDTE_LeaderTrait`（或任一 Gameplay 环境），执行

```
Players[0]:GetDiplomacy():DeclareWarOn(1); local u = UnitManager.InitUnit(1, 'UNIT_KNIGHT', x, y); u:SetDamage(95)
```

x、y 换成目标格子；单位类型按需要换。

用提丰开一局风云变幻，然后依次：

1. **写作 → 法师塔**：放置预览看造价 27、学院原有的相邻加成都在、挨着军营时多「+2 科技值」。「所选城市完成当前建筑」建成后：
   - 地图上有法师塔模型。**外观分阶段**：只放下区域和只有图书馆时是普通学院样子；造了大学以后，大学位换成炼金学会（埃塞俄比亚包的模型）。所以要造到大学才能看到炼金学会；炼金学会放在学院底座上位置对不对（悬浮、重叠、遮挡）是这一轮最需要你看的地方，有问题告诉我，备用方案是换成埃塞俄比亚包配套的炼金底座；
   - 有血条和区域控制（ZOC）；
   - 用 FireTuner 把敌人刷到 2 格内：**先不建城墙测一次远程攻击，再造古城墙测一次**。官方说明是「城墙使市中心和军营能发起远程攻击」，很可能要先有城墙；有城墙仍然打不了就告诉我。
2. **法师塔城造战士**：出生就能升级；**鼠标悬停单位血条的提示里没有「学院出身」**。没有法师塔的城市造一个对照，不能升级。伟人面板：每回合大将军点数 = 法师塔数 + 圣地数。
3. **机械 → 战斗法师**：面板远程 40、近战 30；没有升级按钮；**没有任何 WMD 按钮（阶段 1 预期，核弹按钮也没有）**。「复制所选的单位」放在旁边，用其中一个远程攻击：预览有「+5 军团级法术」（只有能力名，不带说明）；三个围一圈也只有一次 +5（不叠加）；被攻击防守时没有。鼠标悬停在单位血条上：能力列表里只有「弹道学成长」「军团级法术」这样的能力名，**没有效果说明**，也没有「学院出身」。
4. **弹道学** → 面板近战 50、远程仍显示 40；远程攻击预览里有「+20 弹道学成长」（合计远程 60）。**高级弹道学** → 面板近战 70；远程攻击预览里有「+20 弹道学成长」「+25 高级弹道学成长」（合计远程 85）。防守时预览里不应出现这两条（防守用近战，已经算在面板 70 里）。研究野战加农炮后仍能造战斗法师。
5. **民族主义 → 用游戏正常操作合并两个战斗法师组成军团**；**组军队要「动员」市政**。不用作弊按钮。阶段 1 只看战斗力 +10、不崩。湮灭之创按钮、施放后阵亡、通知、军队回血都在阶段 2。
6. **黄昏宫殿**（已改用 Lua）：用「减-10时代得分」压到黑暗时代，推科技、结束回合到时代切换：进入新时代后的**第一个提丰回合开始时**收到 2 个尤里卡 + 2 个鼓舞；再用「加+10时代得分」测一次普通 / 黄金 / 英雄时代，收到 1 + 1（英雄时代也是 1 + 1）。
   - Lua.log 每次都有一行 `[TsoDTE] Twilight Palace: player 0 entered ERA_xxx [dark age check: ...], boosted ...`，后面列出给了哪几项。写着 `boosted nothing` 说明所有时代都没有可触发的了。
   - **新时代给什么**：优先从新时代里「有尤里卡（或鼓舞）、没研究、没触发过」的项里随机抽；新时代已经没有了，就顺延到之后的时代，再不行才回头找更早的时代。所以科技推得太快时，给的可能是别的时代的项，不是没生效。
   - **黑暗时代判断要重点看**：官方只在 UI 环境用 `HasDarkAge`（文档里 `script=false`），Gameplay 里调不调得通没有证据。加载时 Lua.log 会有一行 `HasDarkAge callable in Gameplay: true / false`；每次进新时代的那行日志里 `[dark age check: ...]` 写明来源：`HasDarkAge` 表示调通了，`... is not available in Gameplay` 或 `... raised an error: ...` 表示没调通，这时黑暗时代只会给 1 + 1。把这两行告诉我，我再决定退路（不做翻倍，或另找判断办法）。
   - 英雄时代（黑暗时代之后的黄金时代）不特殊处理：脚本只区分「黑暗」和「非黑暗」，英雄 / 黄金 / 普通都是 1 + 1。
   - 先从新时代里抽；新时代的科技 / 市政都研究过或都触发过了，就从之后的时代抽，再没有就从更早的时代抽。所以科技推得很快也应该能拿到。
   - 存档、读档后不会再给一次。
   **何不用之**：用 FireTuner 刷一个骑士并打残，用提丰单位击杀 → 马镫亮尤里卡，Lua.log 有 `Kill boost`；再杀一个骑士不再触发。
7. **工业化 → 工业区、工坊、燃石酸化工厂**：
   - 本城 +6 生产力、+3 科技；
   - 本城农场 +5 食物（第一轮已对）；**矿山、采石场 +2 生产力（第一轮没生效，已改写法，重点复测）**：工业化之后、草原丘陵上的无资源矿山应是 2 粮 6 锤（不建燃石是 4 锤）。看的时候确认矿山在燃石所在城市的范围内；
   - 6 格内另一座城的市中心拿到 +6 生产力、+3 科技（第一轮已确认科技也辐射）；农场、矿山、采石场的加成不应出现在别的城；
   - 通电后再 +3 生产力（共 +9）。

收尾：跑 `log_triage.py --mod TSODTyphonEmpire`。**通过标准**：上面各条都对，Lua.log 和 Database.log 里没有 TsoDTE 的报错。

## 3. 开局与基本数据（WP1、WP8）

- [ ] 风云变幻规则集下能选到罗塞塔·奥古斯都；本体规则集下看不到。
- [ ] 开局界面显示文明能力、领袖能力，以及战斗法师、法师塔、燃石酸化工厂三项；中文、英文界面都没有 `LOC_` 原文；效果文本里没有「您」。
- [ ] 载入画面有旁白文字和领袖引言（背景会回退成罗斯福的，属预期）。
- [ ] 首都叫奥尔德南（Ordenan）；之后几座城的名字来自列表前几项（`RandomCityNameDepth=5`，只大体按顺序）；第 10 个城市英文是 Holmark。
- [ ] 两边都选提丰各开一局，第二个玩家用上备用色。
- [ ] 黑底红徽的国界在深色地形上看得清。

## 4. 各包的需实证项（流程之外要留意的）

- **WP2**：免费升级在存档读档、单位升级换代后不会再给一次；有军营的城市外来宗教压力为 0，提丰自己创教后自己的宗教照常传播；条件写的是「学院或法师塔」两者任一，法师塔城市确实算数（流程第 2 步）。
- **WP3**：Lua.log 出现 `[TsoDTE] Leader trait initialized for 1 player(s)`。黄昏宫殿已改 Lua（第一轮 SQL 版没生效）：有 `Twilight Palace` 日志但没亮尤里卡 / 鼓舞 → `TriggerBoost` 要改双参数；完全没有这行日志 → 回合开始事件或时代接口有问题，把 Lua.log 给我。Lua.log 有 `Kill boost` 但没亮尤里卡 → 同样是 `TriggerBoost` 参数问题。
- **WP4**：第一轮确认 `MODIFIER_UNIT_ADJUST_BASE_COMBAT_STRENGTH` 只改近战、不改远程，已拆成「近战基础值 + 远程攻击时加成」。没有专属模型：**单位隐身属预期，游戏崩溃要马上告诉我**。
- **WP5**：敌方间谍在本城的任务面板上，等级比对照城市低 1。
- **WP6**：掠夺工业区后，农场、矿山、采石场的加成消失。
- **WP10**：古典、工业、现代三个时代各看一遍法师塔（空区域、图书馆、大学、研究实验室四个阶段）；被掠夺后的样子；`Logs/ArtDef.log` 里应有 `Loading Package: .../DLC/Ethiopia/.../tilebases.blp` 且没有这个区域的报错。没装埃塞俄比亚包的话 mod 会是灰的，不能启用（依赖已声明）。区域完全没出现 → 告诉我，这说明 `Districts.artdef` 的登记有问题。

## 5. 议程「同类」与 AI（WP7）

换别的文明开局，让罗塞塔当 AI：

- [ ] 领袖界面能看到议程名和说明。
- [ ] 相识满 30 回合后，用 FireTuner 加减陆军，让你的陆军跨过他的水平：关系里 +8 那一条出现、消失。
- [ ] 相识满 10 回合后，派传教士进他的城市：出现 −12 那一条，赞许、警告弹窗里有理由句。
- [ ] 多开几局，他不会再随机抽到「常备军」。
- [ ] Autoplay 跑 150 回合，看 `AI_Planning.csv` 里有没有法师塔、燃石酸化工厂、战斗法师，`AI_Victories.csv` 里征服排在科技前面。

## 6. 百科与台词（WP8）

- [ ] 文明百科：文明、领袖、单位、区域、建筑五页的历史章节都在；「在黄昏宫殿的噩梦里，奥古斯都们从未屈服。」现在在领袖百科里。
- [ ] 「概念」页底部有「提丰帝国：人物」「提丰帝国：地点」两组共 12 页；搜索「提丰」「Typhon」能找到。（需实证：自定义分组能否显示）
- [ ] 罗塞塔当 AI 时：初见、问候、谴责、宣战、和平、开放边境、驻军警告等台词是专属的，不是通用台词。
- [ ] 英文界面再看一遍。

## 7. 同开

- [ ] 同时启用塞西尔开一局，两边都能正常加载，Database.log 无冲突。（梦境之城联动已在阶段 2 实机反馈第 5 项删除。）
- [x] 顺带：高文的部分台词像是通用台词。**已查明，是塞西尔 mod 的问题，不在本 mod 里修**（见下）。

### 7.1 高文台词缺失（塞西尔 mod，`xhw994/TSODCecilEmpire`）

游戏按 `LOC_DIPLO_<场合>_LEADER_<领袖类型去掉 LEADER_ 后>_ANY` 找领袖专属台词，例如提丰的 `LOC_DIPLO_GREETING_LEADER_TSOD_ROSETTA_AUGUSTUS_ANY`。找不到就用通用台词，**不报错，也不写日志**。

塞西尔的领袖类型是 `LEADER_TSOD_GAWAIN_CECIL`，`Texts/TsoDCE_CivLeaderTexts.sql` 里 32 个台词 tag 只有 3 个带 `LEADER_`，其余 29 个都省了，所以这 29 句一直没被用上，游戏里看到的是通用台词：

| 能用上（3） | 用不上（29，节选） |
|---|---|
| `ACCEPT_DECLARE_FRIEND_FROM_HUMAN_LEADER_…`、`REJECT_DECLARE_FRIEND_FROM_HUMAN_LEADER_…`、`DECLARE_FRIEND_FROM_AI_LEADER_…` | `GREETING_TSOD_GAWAIN_CECIL_ANY`、`FIRST_MEET_…`、`DECLARE_WAR_FROM_AI_…`、`DENOUNCE_FROM_AI_…`、`MAKE_PEACE_…`、`OPEN_BORDERS_…`、`WARNING_TOO_MANY_TROOPS_NEAR_ME_…`、`DEFEAT_…`、`KUDO_EXIT_…` 等 |

修法：在塞西尔 mod 里把这 29 个 tag 的 `_TSOD_GAWAIN_CECIL_` 改成 `_LEADER_TSOD_GAWAIN_CECIL_`（议程理由句 `KUDO_ / WARNING_…_REASON_ANY` 同理），中文（`LocalizedText`）和英文（`BaseGameText`）两段都要改。之前怀疑塞西尔没有英文，复查后是有的，只是写在 `BaseGameText` 表里。

自己验证某句台词在不在：FireTuner 里执行 `print(Locale.Lookup('LOC_DIPLO_GREETING_LEADER_TSOD_GAWAIN_CECIL_ANY'))`，打出来的是 tag 原文就说明没有这句。

## 8. 阶段 2 · WP13 湮灭之创 / 战场再生 / 通知（未实测）

> **2026-10-21 改版，以 §12.0–§12.1 为准。** 本节下面的旧表格写的是改版前的规则，仅作背景：
> - 编队规则（用户定）：军团（2 个合成）只有战场再生；军队（3 个合成）有湮灭之创和战场再生；库存 = 军队数。
> - F6（别的单位施放时让军团代死）已删，用户否定。
> - 实机证据：Gameplay 环境收不到 `UnitOperationStarted`，只收得到 `UnitOperationDeactivated`，且此时引擎已扣库存。阵亡改在施放结束时做；施放过的单位打上 `TSOD_TYPHON_SCAR_SPENT` 标记，不再补弹。
> - 通知改用官方剧本的 `NotificationTypes.USER_DEFINED_1..5`，不再登记自定义通知类型（实机不显示）。

> 这一节是**待测清单**，不是测试结果。下面没有一条在游戏里验证过，改动只完成了静态检查（loc_audit、lua_lint、modifier_lint 通过，没有已知的静态错误）。
> 默认**没有额外外交惩罚**，只保留游戏原生核武的外交后果（用户定：以可莉 mod 为准）。测试时如果发现外交问题，记下来，不要当成 bug 直接修。

### 8.1 进游戏前要确认的

| 项 | 预期 |
|---|---|
| 构建后 `validate_mod.py` 对部署的 `.modinfo` | 0 错误。`InGameActions` 里有 `ReplaceUIScript`（LoadOrder 200000）和同 LoadOrder 的 `ImportFiles` |
| `Lua.log` | 出现 `[TsoDTE] Battle mage module initialized`；没有 `unit or weapon row missing`、`MilitaryFormationTypes missing` |
| `Logs/Modding.log` / `Database.log` | 没有 `WMD_TSOD_ANNIHILATION_SCAR`、`NOTIFICATION_TSOD_*`、`ABILITY_TSOD_*` 的外键或未知类型报错 |
| 没装可莉、没装 BuilderLagFix 的存档 | 单位面板能正常打开，`Lua.log` 没有 `UnitPanel include failed` 的整段报错（个别 `include failed` 行可接受，要记下来） |
| 装了可莉（工坊 2882489805）的存档 | 可莉的文件在 `UI/Replacements/` 下，`include("UnitPanel_Klee.lua")` 需按文件名找到它（**需实证**）。找不到时会退到 `UnitPanel.lua` 并记 `Initialize` 逻辑；两种情况下，单位面板的武器按钮都应只剩湮灭之创（军团 / 军队）与官方 / 可莉原有按钮 |

### 8.2 湮灭之创

| 项 | 预期 | 结果 |
|---|---|---|
| 民族主义下，两个战斗法师编成军团 | 右侧通知栏出现「战斗法师军团已能施放湮灭之创。」，点击定位到该单位；弹数（作弊菜单 / FireTuner 的 PlayerWMDs）+1 | |
| 单个未编组的战斗法师 | 单位面板没有「湮灭之创」按钮；弹数 0 | |
| 军团状态的战斗法师 | 单位面板只出现「湮灭之创」一项，官方核弹、热核、可莉的武器都不出现；能力「湮灭之创」在单位提示里只显示名字和「可施放一次。施放后本单位阵亡。」 | |
| 施放湮灭之创 | 该军团阵亡；原位置浮出「魔力枯竭」；通知「战斗法师军团施放湮灭之创，全员魔力枯竭阵亡。」；弹数 −1 | |
| 施放后 | 同回合另一支军团仍能施放，弹数等于剩下的军团数（不会少扣） | |
| 轰炸机 / 核潜艇 / 别的单位 | 面板里看不到湮灭之创；官方核弹照常显示 | |
| 战斗法师军团与一个轰炸机都能施放（测 F6） | 轰炸机施放湮灭之创时，离目标最近的战斗法师军团阵亡；找不到就只有日志（`strike by non-corps unit`） | |
| 战斗法师在普通状态 | 面板里看不到湮灭之创，也看不到官方核弹 | |
| 只装提丰、未组军团时 `Lua.log` | 没有 `Battle mage reconcile` 行（库存已对） | |
| 作弊菜单组军团（用户已撤销 F4，只测正常路径） | 正常合并军团后的对账按上面的规则走；不专门测作弊路径 | |

### 8.3 军队回血

| 项 | 预期 | 结果 |
|---|---|---|
| 民族主义下组成军队（需要「动员」） | 通知「战斗法师军队获得了战场再生。」；能力「战场再生」出现在单位提示里，文字「每回合恢复 10 点生命。移动或战斗后同样恢复。」 | |
| 受伤的军队，回合开始 | `Lua.log` 出现 `Army regen: ... damage A -> B`，生命确实增加（10 点） | |
| 同一支军队，**下一回合**仍回血 | 再次出现 `Army regen` 行，生命继续增加（这是「下回合仍回血要能验证」） | |
| 军队移动后 / 战斗后 | 同样回血（第二天也要看一次） | |
| 解散为普通单位（或军队被消灭之前离开编队） | 回血停止；能力「战场再生」被收回（对账里 `reconcile` 行可见） | |
| 静止的军队 | 生命增加量是否等于 10（**需实证 N8**：如果比 10 多，说明和原版静止回血叠加） | |

### 8.4 通知

| 通知 | 时机 | 预期 |
|---|---|---|
| 「湮灭之创就绪」 | 组成军团 | 进通知栏，不自动弹窗，点掉后消失 |
| 「湮灭之创已施放」 | 施放后 | 同上，位置在阵亡的原地 |
| 「战场再生」 | 组成军队 | 每回合结束消失（ExpiresEndOfTurn） |
| AI 的施放、AI 的回血 | 任何时候 | **不发通知**（人类玩家才有） |

### 8.5 需实证项（每条的退路见 `src/Scripts/TsoDTE_BattleMage.lua` 文件头与对应代码）

| 编号 | 问题 | 测什么 | 退路 |
|---|---|---|---|
| N1 | 在 `UnitOperationStarted` 里 `UnitManager.Kill` 施放单位，爆炸还会结算吗 | 施放后有没有地图上的爆炸；目标有没有受伤；Lua.log 有没有报错 | 阵亡挪到 `UnitOperationDeactivated` 里做 |
| N2 | `pUnit:GetOperationParameter` 能否读到武器类型与目标坐标 | Lua.log 有没有 `GetOperationParameter failed` 或 `weapon type unreadable` | 读不到武器类型就整个不处理（只写日志），需要改用别的方式识别武器 |
| N3 | 引擎施放时是否自己扣库存 | 施放后、回合结束前，弹数是否和军团数一致（不少扣、不多扣） | 对账在 Started 与 Deactivated 都做，两种情况都应正确；若弹数还是错，记下 Lua.log 里的 `stock` 行 |
| N4 | `ChangeWeaponCount` 接受负数 | 弹数减少是否真的发生（施放后弹数 −1） | 未找到替代的减少方式。若不接受负数，库存只能增加，需要重新设计库存的维护方法 |
| N5 | `UnitFormCorps` / `UnitFormArmy` 在 Gameplay 环境是否派发 | 组军团时是否有 READY 通知（没有就是这个问题；能力还是会在回合开始补上） | 回合开始的对账已能补能力，缺的只是通知 |
| N6 | 一支军团或军队只对应一个单位对象 | 两个战斗法师组成军团后，弹数是 1 不是 2 | 按单位对象计数会出错；需要改为按 `GetFormationUnitCount` 去重 |
| N7 | AI 会不会滥用 | AI 的战斗法师是否频繁施放、是否一回合内把军团打光 | 未找到只禁止 AI 使用的数据开关。若滥用，退路是在 Lua 里对 AI 发起的 `WMD_STRIKE` 取消（需实证能否取消该操作） |
| N8 | 军队回血与原版静止回血是否叠加 | 静止的军队回血量是否为 10 | 若叠加，改成只在移动或攻击过的单位上补；或改回修正（`MODIFIER_PLAYER_UNIT_GRANT_HEAL_AFTER_ACTION`） |
| N9 | `Game.AddWorldViewText` 的第一个参数 | AI 施放时人类能否看到「魔力枯竭」浮字 | 改传 `0`（BlackDeath 原版用的是 0） |

### 8.6 没做的（本轮不测）

- 外交惩罚：没有额外代码，只有原生核武语义（用户定）。
- 作弊菜单组军团的专门路径（F4 已撤销）。
- 图标：通知与能力目前没有专属图标（WP9 之后补）。
- 战神教、WP14–WP18、测试工具、发布准备。

## 9. 阶段 2 待测（WP16）

> 文件里原本没有 §9，这一节新开。这是**待测清单**，不是测试结果。下面没有一条在游戏里验证过，改动只完成了静态检查（loc_audit、lua_lint、modifier_lint 没有已知的静态错误）。
> 解锁依赖法师塔与「大众传媒」市政；只有提丰（文明能力）能看到这个项目。外交惩罚不做，本节不测外交惩罚。

### 9.1 进游戏前要确认的

| 项 | 预期 |
|---|---|
| 构建后 `validate_mod.py` 对部署的 `.modinfo` | 0 错误。`InGameActions` 的 `UpdateDatabase` 里 `TsoDTE_Project.sql` 排在 `TsoDTE_District_MageTower.sql` 之后；`AddGameplayScripts` 里有 `TsoDTE_Project.lua` |
| `Lua.log` | 出现 `[TsoDTE] Desanctification module initialized`；没有 `project row missing` |
| `Logs/Database.log` | 没有 `PROJECT_TSOD_DESANCTIFICATION`、`MODIFIER_PLAYER_ALLOW_PROJECT_TSOD`、`NOTIFICATION_TSOD_DESANCTIFICATION` 的外键或未知类型报错 |
| 生产面板（提丰，有法师塔的城市，已研究「大众传媒」） | 出现「去神圣化」项目，说明文字为两行，效果句与文本一致 |

### 9.2 可见性与解锁

| 项 | 预期 | 结果 |
|---|---|---|
| 其他文明（非提丰）、有法师塔、已研究大众传媒 | 生产面板里没有「去神圣化」 | |
| 提丰、无法师塔的城市 | 没有该项目 | |
| 提丰、有法师塔、未研究大众传媒 | 没有该项目（`PrereqCivic` 生效） | |
| 提丰、有法师塔、已研究大众传媒 | 有该项目；可以生产；完成后再次出现（可重复） | |

### 9.3 完成效果

| 项 | 预期 | 结果 |
|---|---|---|
| 完成时，信仰值 100 | 信仰值变为 50（减半），研究进度增加 50（`Lua.log` 里 `expected +50` 且 progress 读回为 before + 50） | |
| 完成时，信仰值为奇数，如 101 | 转换 50（向下取整），信仰剩 51 | |
| 完成时，外交支持 | 增加 25（`MODIFIER_PLAYER_ADD_FAVOR`，只一次，RunOnce） | |
| 完成时，其他文明的外交支持 | 不变（修正只挂在提丰身上） | |
| 完成后下一回合 | 外交支持不再每回合增加；信仰值没有被再次结算（见 9.5 P4） | |
| 提丰完成时，人类玩家的右侧通知栏 | 出现「去神圣化完成」，点掉为止；通知文字含「信仰值的一半已转化为科技值」 | |
| AI 提丰（若有）完成 | 照样转换，不发通知 | |
| 非提丰玩家完成（若能完成） | `Lua.log` 没有 `Desanctification: player` 行，信仰与研究都不变 | |
| 当前没有研究（用作弊或 FireTuner 清空） | 信仰不变，`Lua.log` 出现 `has no current research`（P5） | |

### 9.4 联机

| 项 | 预期 | 结果 |
|---|---|---|
| 联机中提丰完成 | 双方信仰与研究进度一致（无不同步报错） | |

### 9.5 需实证项（每条的退路在 `src/Scripts/TsoDTE_Project.lua` 对应注释处）

| 编号 | 问题 | 测什么 | 退路 |
|---|---|---|---|
| P1 | `Events.CityProjectCompleted` 在 Gameplay 环境是否派发，且 `playerID`、`cityID`、`projectID` 有效 | 完成后 `Lua.log` 出现转换行（说明事件派发到了）；没有 `city ... not found under player ... (P1)` 行 | 若不派发：在 UI 环境订阅同一事件，再用 `UI.RequestPlayerOperation(PlayerOperations.EXECUTE_SCRIPT)` 调本文件里的转换函数（kb 的第 3 种通信办法）。若派发了但 `cityID` 取不到，转换仍照常做（只依赖玩家），只记日志 |
| P2 | `bCancelled` 的含义 | 每次跳过时 `Lua.log` 都会出现 `bCancelled=true`；正常完成时不应出现。若正常完成也出现，说明它不是「取消」的意思 | 若完成时它也为真，去掉这个判断，改为只看 `projectID` |
| P3 | 转换公式（信仰减半、向下取整、研究加等量） | 9.3 的两条数值；`Lua.log` 里 `faith A -> B` 与 `expected +N` | 若数值不对，检查 `GetFaithBalance` 在事件时刻的值（是否已被别的逻辑改过） |
| P4 | 完成后信仰是否被再次结算 | 完成当回合结束、下一回合开始，信仰值的变化是否与转换后一致（不再扣或加转换前的量） | 若被再次结算，改为用玩家属性记「已转换」标记，并在回合开始时对账（同 WP13 的 `ReconcilePlayer` 思路） |
| P5 | `GetResearchingTech` 无当前研究时返回 `-1` | 清空当前研究后完成，信仰不变，日志出现 `has no current research` | 若这时也应转换，改为把数量记在玩家属性里（`SetProperty`），选定研究时补入 |
| P6 | `SetResearchProgress` 第二个参数是绝对值 | `Lua.log` 里 `progress before -> after` 的 after 等于 before + 转换量 | 若 after 不变，检查该科技是否已研究完、进度是否被截断；若是参数含义不同，改用 `ChangeCurrentResearchProgress`（其参数未文档化，需先实测） |
| P7 | 研究进度加到超过研究造价时的行为 | 研究造价较低时（如刚开始的科技）完成，科技是否立即完成、进度是否截断 | 若截断，改为转换量上限为「造价 − 当前进度」，超出部分保留在信仰里 |
| P8 | `PrereqCivic` 与 `UnlocksFromEffect` 并存时，两个条件是否都生效 | 9.2 的四行 | 若未研究大众传媒时项目仍可见，改为在 `MODIFIER_PLAYER_ALLOW_PROJECT_TSOD` 的 OwnerRequirementSet 里加 `REQUIREMENT_PLAYER_HAS_CIVIC` |
| P9 | 通知在 Gameplay 环境发送是否显示 | 9.3 的通知行 | 若不显示，改为在 UI 环境发送（同 P1 的桥） |

### 9.6 没做的（本轮不测）

- 外交惩罚：没有额外代码（用户定：以可莉 mod 为准）。
- 图标与项目的专属图片（WP9 之后补）。
- 百科条目（WP8 之后补）。
- 数值（一半、25、造价 65）进游戏再调。

## 10. 阶段 2 待测（WP17 神权理事会）

> 这是**待测清单**，不是测试结果。下面没有一条在游戏里验证过。改动只完成了静态检查（loc_audit、modifier_lint、lua_lint 没有已知的静态错误），还没有在游戏里加载。
> 决议只在风云变幻规则集下加载（criteria `TsoDTE_Expansion2`）。要进入现代时代的对局才能测到它；怎么推进到现代时代，实测时再定。
> 没有工坊先例：下面 C1–C5 都是需实证项，不成立时的退路按 impl plan §6.2 的「换成正面效果，或不做这个决议」，具体写在每条里。

### 10.1 进游戏前要确认的

| 项 | 预期 |
|---|---|
| 静态检查（src） | loc_audit 222 个 tag 中英齐全；modifier_lint 0 错、5 提示（与改动前相同，都不是本包的）；lua_lint 0 错 0 提示 |
| `Logs/Database.log` | 没有 `WC_RES_TSOD_THEOCRATIC_COUNCIL`、`TSOD_TYPHON_COUNCIL_RELIGIOUS_STRENGTH_DOWN`、`TSOD_TYPHON_ROSETTA_RESOLUTIONS`、`ResolutionEffectId` 210 / 215 的外键、唯一约束、未知类型或 `no such table` 报错 |
| `Modding.log` | `TsoDTE_Congress.sql`、`TsoDTE_Text_Congress.sql` 有加载记录，且只在风云变幻的对局里出现 |
| 议会界面 | 决议名显示「神权理事会」，两个选项显示中文效果句；没有 `LOC_` 原文 |

### 10.2 可见性

| 项 | 预期 | 结果 |
|---|---|---|
| 原版规则集（非风云变幻）对局 | 没有本决议；`Database.log` 没有因本文件产生的 `no such table` | |
| 风云变幻、未到现代时代 | 议会不抽本决议（`EarliestEra = ERA_MODERN`） | |
| 风云变幻、现代时代后的议会 | 能抽到本决议（见 C1、C4） | |
| 风云变幻、现代时代后，没有提丰的对局 | 也能抽到（master plan §8.5：只要 mod 启用就进决议池，是设计如此）；AI 偏好只对提丰的 AI 生效 | |

### 10.3 议程池与目标

| 编号 | 问题 | 测什么 | 退路 |
|---|---|---|---|
| C1 | 新决议能否进入议程池 | 进入现代时代后，连续几届议会的议题候选里是否出现「神权理事会」。静态上 `Scripts/WorldCongress.lua` 的 `CanUseResolutions` 对未列出的决议直接放行（`else` 分支），没有过滤；池子怎么抽由引擎决定 | 不进池：按 impl plan §6.2，换成正面效果，或不做这个决议（删 `Resolutions`、`ResolutionEffects`、本决议的 `Modifiers` / `ModifierArguments`、AI 三行与 `TsoDTE_Text_Congress.sql` 的登记） |
| C4 | 现代时代后世界议会能否抽到 | 与 C1 同一组对局。对照：`WC_RES_HERITAGE_ORG` 同为 `EarliestEra = ERA_MODERN` 且没有 `LatestEra`。若它能抽到而本决议抽不到，是本决议的问题；若两者都抽不到，是测试条件问题，不算本决议失败 | 同 C1 |
| V1 | 校验函数 `WC_Validate_RegliousBan` 与选目标 `ReligiousTarget` 在 Lua 里没有定义（安装目录的 .lua 搜索为 0 条；官方「世界宗教」也用这两个名字，它们应由引擎处理）。目标列表由谁给出，未知 | 选中本决议时，目标列表是否只列出已建立的宗教（至少一个宗教）；没有宗教时是否不进入议题 | 目标为空或列出非宗教：改用新名字（如 `WC_Validate_TSOD_Theocracy`），在新 Lua 文件里用 `GameEvents.<名字>.Add` 填 `options.ResolutionOptions`，并把该文件登记到 `AddGameplayScripts`。**不要**去改官方名字的注册，那会同时影响世界宗教 |

### 10.4 效果

| 编号 | 问题 | 测什么 | 退路 |
|---|---|---|---|
| C2 | `Amount = -10` 是否生效，方向与数值是否正确 | 选项 1 通过后，目标宗教的单位战斗力与宗教战斗力各减 10（对比决议前的单位面板与战斗预览）。FireTuner 的 Modifiers 面板里 `TSOD_TYPHON_COUNCIL_RELIGIOUS_STRENGTH_DOWN` 为 Active，`# Subjects` > 0 | 不生效或当作 0：按 impl plan §6.2，换成正面效果，或不做这个决议（同 C1） |
| C3 | 选项 1 的目标宗教是否由投票结果传入 | 只有被选中的宗教的单位减 10；其他宗教的单位不变（用两个宗教各造一个单位对比）。官方同类修正（`WC_RES_RELIGIOUS_UNITS_STRENGTH`）的参数只有 `Amount`，宗教是引擎注入的，这是推断，未实证 | 作用到所有宗教：删 `ResolutionEffects` 中 `WhichEffect = 1` 那行，只留选项 2。一个都不作用：同 C2 |
| B1 | 选项 2 复用的 `ANYONE_CONDEMNS_FOR_FAVOR` 对本决议的宗教生效 | 选项 2 通过后，审判（谴责）该宗教的单位获得 25 点外交支持；其他宗教的单位不给 | 与官方同名决议相同，没有单独退路。不生效时先查 `ResolutionEffects` 中 `WhichEffect = 2` 那行是否登记到本决议 |

### 10.5 AI 偏好

| 编号 | 问题 | 测什么 | 退路 |
|---|---|---|---|
| C5 | 提丰 AI 是否投选项 1 | 提丰 AI 参与的多次议会中，它投的是选项 1。`AiFavoredItems` 只能表达「支持该决议」，选哪一边是引擎的事。文件里的对应关系是按官方 `WC_RES_WORLD_RELIGION` 的 Favored 推断的，未实证。能核对时用 AI 决策日志（`civ6-modding-ai` 列出的 AI_*.csv）；核对不了就看议会结果 | 投选项 2、或与选项无关：删 `TsoDTE_Congress.sql` 里 `TSOD_TYPHON_ROSETTA_RESOLUTIONS` 的三行（`AiFavoredItems`、`AiLists`、`AiListTypes`），决议本身不受影响，AI 回到官方默认 |

### 10.6 ID 与登记

| 编号 | 问题 | 测什么 | 退路 |
|---|---|---|---|
| R1 | `ResolutionEffectId` 210、215 与别的内容冲突 | 官方 `ResolutionEffectId` 最大为 205；工坊 mod 里查无 `ResolutionEffects` 行（静态查过）。测 `Database.log` 无 `UNIQUE constraint failed` | 冲突：在 `ResolutionEffects` 里换成未用的整数，两行一起改 |
| T1 | 文本登记 | 议会界面的决议名与两个选项是中文（不是 `LOC_` 原文） | 显示 `LOC_`：检查 `TsoDTE_Text_Congress.sql` 是否在 `UpdateText` 里（`.civ6proj`），loc_audit 静态已通过 |

### 10.7 没做的（本轮不测）

- 外交惩罚：不加（用户定：以可莉 mod 为准）。
- 决议的专属图标：WP9 之后补。
- 数值（-10、25）进游戏再调。
- 选项的标签（「去神圣化」「世俗监督」）：只写在文件注释里，游戏里只显示效果句，与官方决议的显示一致。

## 11. 阶段 2 待测（WP18 系列联动）

> 这是**待测清单**，不是测试结果。下面没有一条在游戏里验证过。改动只完成了静态检查（loc_audit 225 个 tag 中英齐全；modifier_lint 0 错，多出的 1 条提示是官方的 `PLAYER_IS_SUZERAIN`，不是本包的问题；lua_lint 0 错 0 提示），还没有在游戏里加载。
> 联动只剩塞西尔一项（criteria 是 `ModInUse`，加 `RuleSetInUse RULESET_EXPANSION_2`，见下面 L1）。只装提丰时不加载；同开塞西尔时加载。梦境之城的宜居度已按阶段 2 实机反馈第 5 项删除（原 11.3 节）。
> 下面每条都写了退路。需实证项的数值与结构都来自官方同类写法，不是本包自拟的。

### 11.1 加载与隔离

| 编号 | 问题 | 测什么 | 退路 |
|---|---|---|---|
| L1 | `ModInUse` 检测本地工坊安装的 mod 是否成立 | 塞西尔是工坊 mod。只装提丰时 `Logs/Modding.log` 里没有 `TsoDTE_Compat_Cecil` 的加载记录；装上塞西尔后，才出现该 action 的加载记录（criteria 没满足时日志里不会出现该 action，这是判断依据） | 检测不到（装了 mod 却不加载）：先确认 mod id 与 `.civ6proj` 的 `Guid` 一致（塞西尔 `4883e185-…`，梦境之城 `3b138c5a-…`）；仍不成立，就把两个 criteria 改成 `ConfigurationValueMatches` 之类的替代，或把两个联动并入主动作、用 `Scripts` 内判断，由统筹者决定 |
| L2 | 只装提丰时两个联动文件都不加载 | 只启用风云变幻、迭起兴衰、埃塞俄比亚包与提丰。`Database.log` 没有 `TSOD_TYPHON_CECIL_*`、`TraitModifiers` 的外键报错；FireTuner 的 Modifiers 面板里看不到这些 ID | 加载了：检查 `ActionCriteriaData` 里的 `TsoDTE_ModCecil` 是否写成 `ModInUse`，GUID 是否抄错 |
| L3 | 原版规则集下两个联动都不加载 | 装上塞西尔，但选原版（或迭起兴衰）规则集开局。`Database.log` 没有 `no such table`、`FOREIGN KEY` 报错 | 加载了却报外键：说明 `RuleSetInUse` 没有生效，检查两个 Criteria 里的 `RuleSetInUse RULESET_EXPANSION_2` |
| L4 | 两个联动同开 | 塞西尔与提丰同时启用。A1 要出现，两边互不干扰 | 某一边缺失：只装提丰与塞西尔对照，定位是哪个 criteria 或哪个文件出问题 |
| L5 | 联动数据晚于对方 mod 的数据加载 | 联动文件引用的 `TRAIT_LEADER_TSOD_GAWAIN_CECIL` 是对方 mod 的 LoadOrder 100 数据（塞西尔 `TsoDCE_IG_UpdateDatabase` 是 100）；本包的联动是 200。`Database.log` 没有这两个 trait 的外键报错。LoadOrder 跨 mod 是否按数值全局排序，这是推断，未实证 | 外键报错：把两个联动 action 的 LoadOrder 再调大（如 300），或让本包的 `TraitModifiers` 行改挂在本包自己的 trait 上（不再引用对方 trait，失去宗主国与对方领袖的挂载点，需要重新设计） |

### 11.2 塞西尔联动：外交态度

| 编号 | 问题 | 测什么 | 退路 |
|---|---|---|---|
| A1 | 态度数值 +6 是否生效，方向是否正确 | 同开一局，罗塞塔与高文都在对局里。外交界面里罗塞塔对高文、高文对罗塞塔各有一行「宿敌亦是同类」，数值为 +6。FireTuner 的 Modifiers 面板里 `TSOD_TYPHON_CECIL_ROSETTA_TO_GAWAIN` 与 `TSOD_TYPHON_CECIL_GAWAIN_TO_ROSETTA` 为 Active，`# Subjects` > 0。数值取自官方 `MODIFIER_PLAYER_DIPLOMACY_SIMPLE_MODIFIER` 正向 `InitialValue` 的中位数（Base 与 DLC 的 Gameplay/Data 共 85 条正向值，中位数 6），属于需实证 | 数值不对：只改 `Compat_Cecil.sql` 里两行 `InitialValue`，按实测调；方向反了（变成负）：检查 `InitialValue` 的符号。不生效：先查 Subject 是否是对方领袖（`REQUIREMENT_PLAYER_LEADER_TYPE_MATCHES`），再查 `TraitModifiers` 是否挂上 |
| A2 | 只有对方是对应领袖时才生效 | 同开时，罗塞塔与其他文明（非高文）的态度不出现这一行。对称地，高文对非罗塞塔的文明也不出现 | 所有文明都出现：`SubjectRequirementSetId` 没有生效，检查两个 `REQSET_TSOD_TYPHON_CECIL_OTHER_IS_*` |
| A3 | 说明文本显示正确 | 态度条目的文字是「罗塞塔·奥古斯都视高文·塞西尔为宿敌，宿敌亦是同类」（高文那条对称）；不显示 `LOC_` 原文 | 显示 `LOC_`：检查 `TsoDTE_Text_Compat.sql` 是否登记在 `.civ6proj` 的 `UpdateText`（独立 action `TsoDTE_IG_UpdateText_Compat`） |
| A4 | 没有台词 | 罗塞塔遇到高文时的问候仍是原来的（WP8 的通用台词）。这不是 bug：官方外交台词的结构没有对方领袖维度（`DiplomacyStatements` 的占位符只有 `$(LEADER)`、`$(MOOD)`、`$(REASON)`），所以按 impl plan §6.2 不加台词，只做态度说明 | 若将来找到能按对方领袖区分的写法，再补，不在本轮 |

### 11.4 静态与登记

| 编号 | 问题 | 测什么 | 退路 |
|---|---|---|---|
| S1 | 联动文件 SQL 的外键与唯一约束 | `Database.log` 没有 `TraitModifiers`、`Modifiers`、`RequirementSets`、`RequirementArguments` 的 `FOREIGN KEY` 或 `UNIQUE constraint failed` 报错（装上塞西尔时测） | 外键报错：通常是引用的 trait 或 leader 在对方 mod 里 ID 不同，核对塞西尔 `TsoDCE_Leaders.sql` 与梦境之城 `DreamCity_Civilizations.sql` 的 ID |
| S2 | 没做的（本轮不测） | 外交惩罚（核武相关，用户定：以可莉 mod 为准，不加）；罗塞塔遇到高文的专属问候（见 A4）；梦境之城的宜居度（阶段 2 实机反馈第 5 项，已删除） | — |

## 12. 阶段 2 测试流程（作弊菜单快速流程）

写法同 §2。按顺序做，每一步写出看到的结果；通过的打勾，不通过的把 Lua.log、Database.log 的对应行和截图交给统筹者。**全部未进游戏验证**，每条的退路见 §8–§11。

前提：`EnableTuner 1` 已开；`Mods\TSODTyphonEmpire\` 是最新部署（构建后的版本）；开局用提丰、风云变幻规则集。需要高文的联动测试，另开一局，塞西尔与提丰同时启用。

### 12.0 开局（必须新开一局）

- 读旧存档不行：领袖特性与文明能力上的修正只在开局挂载，旧存档缺黑暗时代探测（`TSOD_TYPHON_DARK_AGE_PROBE`）、去神圣化解锁（`TSOD_TYPHON_DESANCTIFICATION_ALLOW`）、塞西尔态度修正。
  - 存档里临时补挂（FireTuner，Gameplay 环境）：`Players[0]:AttachModifierByID('TSOD_TYPHON_DESANCTIFICATION_ALLOW')`，同理可补 `TSOD_TYPHON_DARK_AGE_PROBE`。未实测。
- 载入后 `Lua.log` 应有：
  - `[TsoDTE] Battle mage module initialized (notification types 数字, 数字, 数字)`：三个都是数字，不是 nil。
  - `[TsoDTE] Dark age sources for player 0: property nil, HasDarkAge callable false, notification type 数字`。

### 12.1 战斗法师：军团、军队、湮灭之创（WP13）

1. 研究机械，造三个战斗法师。民族主义后，用游戏正常操作把两个合成**军团**。
   - 看到：通知「战斗法师军团获得了战场再生，每回合恢复生命。」；单位面板**没有**湮灭之创按钮；库存 0。
2. 「动员」后，再合一个成**军队**。
   - 看到：通知「战斗法师军队已能施放湮灭之创。」；单位面板只有湮灭之创一个核武类按钮；`Lua.log` 有 `stock 0 -> 1`。
3. 让军团或军队受点伤，下一回合开始：`Lua.log` 有 `[TsoDTE] Regen: ... damage A -> B`，B = A − 10。再下一回合仍回。
4. 用军队施放湮灭之创。
   - 看到：爆炸；整支军队消失；通知「战斗法师军队施放湮灭之创，全员魔力枯竭阵亡。」；原地浮字「魔力枯竭」。
   - `Lua.log` 依次有：`strike end: player 0 unit N state army stock 0 armies 1`，`strike end: army at x,y killed K unit(s), still listed 0`。
   - **如果军队没消失**：把这两行发回来。`still listed` 大于 0 说明 `UnitManager.Kill` 在这个时机不生效；即便如此，这支军队也已标记为「已施放」，下回合不会再补弹（`stock` 不会回到 1）。
5. 下一回合开始：库存仍为 0（`Lua.log` 不应再出现 `stock 0 -> 1`，除非你又组了新军队）。
6. 轰炸机、普通状态的战斗法师：面板里没有湮灭之创按钮。别的单位发射别的武器，战斗法师不受影响。

### 12.7 美术第一批（10-23）

贴图由 `tools/make_art.py` 从 `images/` 的设定图生成（`python -X utf8 tools/make_art.py`），打进 `XLPs/TsoDTE_UITextures.xlp`、`XLPs/TsoDTE_LeaderFallbacks.xlp`。

1. 开局界面：文明图标是四分盾加互换色皇冠（游戏按玩家颜色着色：黑底红徽）；领袖图标是罗塞塔头像；选中罗塞塔时右侧有立绘和雨夜奥尔德南背景。
2. 载入画面：雨夜奥尔德南背景 + 罗塞塔立绘（边缘渐隐，不是抠图）。
3. 外交界面：罗塞塔肖像里的王座厅（带提丰国徽的旗帜）做背景，左侧罗塞塔立绘（备用立绘 825×1024，边缘渐隐）。
4. 历史时刻：首次造出战斗法师（玛蒂尔达插图）、法师塔（截取塔身）、燃石酸化工厂（雨夜马车）各有插图。
5. 战斗法师（单位旗帜上的法杖图标、单位面板的全身肖像）、法师塔（蓝色六边形里的塔）、燃石酸化工厂（哥特式工厂）、去神圣化项目（银色六边形里的书与光环）都是自己的图标；战争迷雾里的单位、区域图标是金褐色版本。
6. `Lua.log` / `Database.log` 没有 `ICON_` 或贴图找不到的报错（`Failed to load background image texture`、`We are lacking a texture for`）。

### 12.8 模型（10-24）

1. 战斗法师：4 人小队，每人是审判官的兜帽法袍加法杖，法袍和兜帽用文明色（提丰黑红）。
   - **远程攻击**：用投石兵的远程动作（向前挥杖投掷），会有投射物飞出。确认是远程动作、不是冲上去近战。
   - 编队、行军、上船正常；第一次试的邪教徒模型只有近战动作，已换掉。
   - 单位旗帜上的图标是「铁拳握闪电」。
2. 法师塔：区域一建成、任何时代都是炼金术会所的塔（不用等大学）。图书馆、大学、研究实验室不再各自出现模型——塔就是区域本身。

### 12.6 领袖能力的通知与黑暗时代（WP3）

1. 进入下一个时代（作弊菜单推科技 / 市政，结束回合直到时代切换）。
   - 看到：通知，摘要「凡人的韧性」，内容「进入新时代，获得“某科技”的尤里卡、“某市政”的鼓舞。」，点击跳到首都。
   - `Lua.log`：`[TsoDTE] New era boost: player 0 entered ERA_..., boosted ...`。
2. 黑暗时代：用「减-10时代得分」压到黑暗时代线以下，再进下一个时代。
   - 看到：除第 1 步的通知外，再来一条「黑暗时代，额外获得……」（可能同一回合，也可能晚一回合）。
   - `Lua.log`：`[TsoDTE] Dark age bonus: player 0 in ERA_... [property 1], boosted ...`。
   - **没有这条**：看载入时那行 `property` 的值，以及进入黑暗时代后是否一直是 nil。是 nil 说明 `MODIFIER_PLAYER_ADJUST_PROPERTY` 写的属性 Lua 读不到，发回来，我换别的办法。
3. 击杀一个前置科技没研究过的敌方单位（FireTuner 刷骑士）：通知「击杀骑士，获得“马镫”的尤里卡。」，点击跳到击杀者。再杀一个骑士没有通知。

### 12.2 去神圣化项目（WP16）

1. 提丰：造法师塔，研究「大众传媒」。项目出现在有法师塔的城市的生产列表里。
   - 「大众传媒」的市政树图标里**不再**显示这个项目（10-22 改：不设 PrereqCivic，大众传媒改成解锁修正的需求；代价是提丰自己也不在市政树上看到它，条件写在项目说明里）。
   - 项目说明第一行：「需要“法师塔”区域与“大众传媒”市政。」
   - 需实证：研究大众传媒后修正是否随之生效（项目是否出现）。
2. 完成项目：外交支持 +25；信仰减半转为科技；通知（摘要「去神圣化完成」）。`Lua.log`：`[TsoDTE] Desanctification: completion event player ...` 和转换记录。
3. 换塞西尔或其他文明：大众传媒的市政树里看不到这个项目，生产列表里也没有。

### 12.3 神权理事会决议（WP17）

**快速触发（测试开关 mod）**：仓库 `tests/congress_harness/`，已部署为「[测试] 提丰 · 世界议会快速开会」。只在测这一节时和主 mod 一起启用，正式游戏关掉。
- 世界议会从开局起开会（`WORLD_CONGRESS_INITIAL_ERA` 0），每 3 回合一次（`WORLD_CONGRESS_MAX_TIME_BETWEEN_MEETINGS` 3）；神权理事会不受现代时代限制。
- 每次开会的候选只留神权理事会和另一个决议，所以只要有已创立的宗教，就一定抽到它。`Lua.log` 有 `[TsoDTE test] congress pool narrowed to 2 resolution(s), theocratic council true`。
- 需要一个已创立的宗教：作弊菜单「加+1000信仰」，用信仰招募大预言家建宗教；或者等 AI 建。
- 需实证：初始时代改成 0 后第一次开会是否正常；有问题告诉我，改回 1。

1. 至少有一个已创立的宗教、现代时代后，世界议会能抽到「神权理事会」。
2. 目标下拉框列的是**宗教**（10-22 改：用自己的验证函数，只列已创立宗教，不含万神殿）。`Lua.log`：`[TsoDTE] Theocratic council: N religion target(s) for player ...`。
3. 选项 1：所选宗教的单位 −10 战斗力；选项 2：谴责该宗教单位获得外交支持。
4. 没有任何宗教时，这个决议不应出现（不会再出现空目标导致的崩溃）。

### 12.4 系列联动（WP18）

1. 只装提丰（关掉塞西尔）：联动文件不加载，外交界面没有额外态度条目。
2. 同开塞西尔：高文与罗塞塔之间各有一条态度修正（说明文本可见）。需实证 L1、A1，退路见 §11。
3. 注意：外交台词不按对方领袖区分（设计如此，见 S2）。

### 12.5 收尾

- 跑 `log_triage.py --mod TSODTyphonEmpire`，看 Database.log 与 Lua.log 有没有本 mod 的错误。
- DoD：12.1–12.4 各条通过（或已写明需实证项的结果），Lua.log 与 Database.log 没有 TsoDTE 报错。
