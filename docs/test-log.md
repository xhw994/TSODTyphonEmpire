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

## 阶段 2 第三轮 · 待测

- 构建：`a391c2a`（已部署，未推送）。必须新开局。
- 要看：test-plan §12.0、§12.1、§12.6。重点是施放后军队是否消失（`strike end: army at x,y killed K unit(s), still listed 0`），以及黑暗时代那行 `Dark age bonus ... [property 1]`。
