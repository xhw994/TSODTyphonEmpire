# 实机测试记录

每轮进游戏测试后由统筹方（设计会话）补一条，写清：哪个构建、测了什么、结果、证据（Lua.log 原文行）、据此做的改动。
用户只管测和反馈，记录由我们维护；以后遇到「以前是不是生效过」这类问题，先查这里和 git 历史，不问用户。

日志位置：`%LOCALAPPDATA%\Firaxis Games\Sid Meier's Civilization VI\Logs\Lua.log`（每次启动游戏覆盖，测完要及时读）。

---

## 用户已定的规则与决定（按时间）

| 日期 | 决定 |
|---|---|
| 10-19 | 领袖能力只有一个名字「凡人的韧性」，不用子名称（何不用之、黄昏宫殿只能作百科里的原作地名 / 概念）。 |
| 10-19 | 效果文本不用第二人称，不写介绍性文字（介绍放百科）。 |
| 10-21 | 湮灭之创使用后不加外交惩罚（只保留原生核武自带的外交后果）。 |
| 10-21 | 每个包本地提交，不推送；推送等用户说。 |
| 10-21 | 编队规则：军团（2 个合成）只有战场再生；军队（3 个合成）有湮灭之创和战场再生；库存 = 军队数；军团不能放。 |
| 10-21 | 删除 F6：别的单位发射别的武器，不让战斗法师代死（轰炸机本来就没有湮灭之创按钮）。 |
| 10-21 | 删除梦境之城联动里的「法师塔城市宜居度 +1」。 |
| 10-21 | 黑暗时代的「各 2 个」要做到，不能写成未生效。 |
| 10-23 | 美术用 `images/` 的设定图：国徽照「提丰地图和国徽」横幅上的四分盾与互换色皇冠。 |
| 10-23 | `images/法师塔.jpg` 是塞西尔的法师塔：外交背景不用它；法师塔历史时刻用户同意截取塔身借用。领袖头像以头部居中、不加红边（其他领袖都没有）。立绘要近身裁切，人物占满画面。 |
| 10-23 | 临时借官方图标的几项（战斗法师图标与肖像、法师塔、燃石酸化工厂、去神圣化）由用户按 `docs/icon-prompts.md` 的提示词去生图，每种一张，我负责缩放与登记。 |
| 10-24 | 用户交来 5 张图，全部采用；法师塔图案偏单薄，按「放大」处理（塔尖伸进六边形顶角），不满意再重做。 |
| 10-24 | 战斗法师单位图标第一版（竖杖顶圆环）在旗帜上像棒棒糖 / 魔法少女变身杖，换设计：横向、带攻击感，方案见 `docs/icon-prompts.md` ①（推荐铁拳握闪电）。其余图标通过。 |
| 10-23 | 罗塞塔外交台词按原著改写（`docs/dialogue-draft.md`），除「被玩家消灭」那句保留原稿外全部采用。 |

---

## 黑暗时代「各 2 个」的来龙去脉（据 git 与日志整理）

| 构建范围 | 实现 | 证据 |
|---|---|---|
| `7909c2f`–`afc6a6f`（10-17 至 10-19） | SQL：普通时代 1+1 与黑暗时代额外 1+1，都是 `MODIFIER_PLAYER_GRANT_RANDOM_*_BOOST_ON_NEW_ERA`（`src/Core/TsoDTE_LeaderTrait.sql`，`git show a37faaa^:src/Core/TsoDTE_LeaderTrait.sql`） | 第一轮实测：普通时代「过两个时代都没给」。当轮有没有进入过黑暗时代，没有记录。 |
| `a37faaa`–`cd5dc44`（10-20 至 10-21） | Lua：`GameEras:HasDarkAge` 判黑暗时代 | 10-21 两次实机 Lua.log 都是 `HasDarkAge callable in Gameplay: false` 与 `[dark age check: HasDarkAge is not available in Gameplay]`，即这段时间的构建只会给 1+1。 |
| `f1e6d60` 起（10-21） | Lua 读玩家属性 `TSOD_TYPHON_DARK_AGE`，由领袖特性上的修正 `TSOD_TYPHON_DARK_AGE_PROBE`（`MODIFIER_PLAYER_ADJUST_PROPERTY` + 官方需求集 `PLAYER_HAS_DARK_AGE`）在黑暗时代写入；读到就补 1+1，每时代一次 | 未实测。要看的日志见 test-plan §12.6。 |

---

## 第一轮（I1，阶段 1 数据）· 约 10-19

- 构建：`afc6a6f` 之前的阶段 1 版本。
- 结果：见 `test-plan-I1.md` 开头「第一轮实测结果」表（法师塔远程需城墙、弹道学远程未涨、新时代 SQL 修正不给、燃石矿山 +2 没生效、议程性别等）。
- 据此改动：`a37faaa`（云端会话）、`8386569`、`f406c4b`。

## 第二轮（阶段 1 复测）· 10-20 晚

- 构建：`78535c0` 前后。
- 用户反馈：「测试都没问题了」，另改领袖能力文本两处（`78535c0`）。
- 缺口：这一轮具体测了哪些项、有没有进入黑暗时代，当时**没有记录**。

## 阶段 2 第一轮 · 10-21 下午（读旧存档）

- 构建：`6490b6f`（WP13、WP16、WP17、WP18）。读的是 WP16 / WP18 之前的存档。
- 结果：
  - 三个合成的军队有回血、能发湮灭之创，但发完不死；军团和军队各给了一发，能发两次。
  - 去神圣化项目看不到；高文对罗塞塔的态度修正看不到（读旧存档，特性修正不会补挂）。
  - 进入新时代的尤里卡、鼓舞没有任何提示。
- Lua.log 证据：`Battle mage reconcile: player 0 stock 0 -> 1`、`1 -> 2`（施放后又 `1 -> 2`）；没有任何施放开始的日志；`[dark age check: HasDarkAge is not available in Gameplay]`。
- 据此：第二批改动 `9f33c92`–`cd5dc44`（统筹会话）。

## 阶段 2 第二轮 · 10-21 傍晚（新开局）

- 构建：`cd5dc44`。
- 结果：
  1. 湮灭之创每回合都补；2. 军队施放后没死；3. 通知都不出现；4. 击杀通知用了已否定的名字「何不用之」；5. 文档把黑暗时代写成未生效。
- Lua.log 证据（17:59）：只有 `strike end: player 0 unit 262147 still in list=true killed again=0` 与随后的 `stock 0 -> 1`，**没有任何 `strike:` 开头的行**——Gameplay 收不到 `UnitOperationStarted`，杀单位的代码从没执行；`UnitOperationDeactivated` 能收到，且此时库存已被引擎扣成 0。
- 据此：整批回滚 `f6fdd60`，重做 `5193d7a`、`9932d31`–`a391c2a`（设计会话）：
  - 阵亡改在 `UnitOperationDeactivated` 里做（判据：军队状态的战斗法师 + 库存少于军队数），施放过的单位标 `TSOD_TYPHON_SCAR_SPENT`，不再补弹；
  - 通知改用官方剧本的 `NotificationTypes.USER_DEFINED_1..5`；
  - 黑暗时代改用属性探测（见上表）；
  - 通知摘要统一用「凡人的韧性」。

## 阶段 2 第三轮 · 10-22（用户玩塞西尔，罗塞塔是 AI 玩家 1）

- 构建：`a391c2a`。
- 用户反馈：
  1. 神权理事会的目标下拉框列的是地貌（截图：「雨林」），选不了宗教，游戏崩溃。
  2. 玩塞西尔时，市政「大众传媒」的解锁图标里也显示「去神圣化」项目（悬停说明完整）；但塞西尔确实造不了。只对了一半。
  3. 希望罗塞塔作为对手时多用原著台词，要一份前后对照表。
  - 本轮没有测战斗法师施放、黑暗时代。
- Lua.log 证据（10-22 23:28）：
  - `Battle mage module initialized (notification types -1636606976, 125439418, 1887255852)`：USER_DEFINED 类型取到了。
  - `Runtime Error: bad argument #1 to 'tostring' (value expected)` 于 `TsoDTE_LeaderTrait.lua:489`（`InitTsoDTELeaderTrait` 里加载时那行诊断打印）：`GetProperty` 读不到属性时返回的是「无值」而不是 nil，直接塞给 `tostring()` 会报错。事件注册在它之前，所以功能仍在跑：`New era boost: player 1 entered ERA_CLASSICAL, boosted TECH_CELESTIAL_NAVIGATION, CIVIC_DEFENSIVE_TACTICS`（AI 罗塞塔进入古典时代，1+1 生效）。LuaJIT 桩里 GetProperty 返回显式 nil，所以没测出来。
  - 没有本 mod 的数据库错误。

## 阶段 2 第四轮 · 待测

- 构建：本轮修复后的构建（下面这次提交）。必须新开局。
- 本轮改动：
  - 神权理事会：目标列表改由 `Scripts/TsoDTE_Congress.lua` 的 `WC_Validate_TsoDTE_TheocraticCouncil` 提供（已创立宗教）；没有宗教时不进候选。原因见 `Core/TsoDTE_Congress.sql` 文件头。
  - 去神圣化：去掉 `PrereqCivic`，「大众传媒」改为解锁修正的需求，非提丰的市政树不再显示。
  - 领袖能力加载时那行诊断打印的 `tostring` 崩溃修好；LuaJIT 桩改成 GetProperty 读不到时返回「无值」，以后能抓到同类问题。
- 要看：test-plan §12.0–§12.3、§12.6，以及美术第一批 §12.7（10-23 加入：国徽、领袖图标、立绘、背景、历史时刻；特色单位 / 区域 / 建筑 / 项目暂借官方图标）。
