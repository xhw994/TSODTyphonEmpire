# 待生成图标：提示词与规格

替换现在暂借官方图标的 5 项。**每项只生成 1 张**，我负责抠图、缩放到全部尺寸、做战争迷雾（FOW）版本、套六边形底座，并登记进游戏。

风格参考图（官方同类图标，已放在 `images/icon-refs/`，生图时可以作为参考图上传，Midjourney 用 `--sref`）：

| 参考图 | 对应要生成的 |
|---|---|
| `unit_icon_crossbowman.png` | ① 战斗法师单位图标 |
| `unit_portrait_crossbowman.png` | ② 战斗法师肖像 |
| `district_campus.png` | ③ 法师塔区域图案（只要中间的图案，六边形我来做） |
| `building_factory.png` | ④ 燃石酸化工厂 |
| `project_campus.png` | ⑤ 去神圣化项目图案（只要中间的图案，六边形我来做） |

## 通用规格（每张都要满足）

- 正方形 1:1，**至少 1024×1024**，PNG。
- 主体居中，四周留白约 6%（主体不要碰到边，也不要太小）。
- 背景按每项写的颜色，**纯色、无渐变、无纹理、无地面阴影**，方便抠图。
- 不要文字、水印、签名、边框、画框。
- 光源从左上方来（与游戏内图标一致）。
- 存放：生成好的图放到 `images/icons/`，文件名按每项给的名字。

---

## ① 战斗法师单位图标 → `images/战斗法师单位图标.png`（第二版）

游戏里显示在单位旗帜、生产列表上，22 像素也要认得出。官方做法是画单位的武器（弩手就是一把弩）。

**第一版的问题**（10-24 实测）：竖直的杖顶着一个圆环，在旗帜上缩小后像棒棒糖、像魔法少女的变身杖。第二版要避开：
- 不要「细长杆子顶着一个圆」的构图；
- 要**宽**：像官方的弩那样左右撑开，宽度不小于高度的 80%；
- 要有「军队」「攻击」的感觉，不要可爱、不要对称的装饰花边。

画法同前：**纯黑色的平面剪影符号，放在纯白背景上**，粗线条、大块面，不要细节和细线（我会转成白色、加描边、做 FOW 版本）。正方形，至少 1024×1024。

下面三个方案任选一个，推荐 A。

### 方案 A（推荐）：铁拳握闪电

戴金属护手的拳头，横握一道锯齿形闪电，闪电向左右两侧伸出，整体横向展开。「战斗」加「法术」，小尺寸下也只是一个拳头加一道闪电。

哈吉米（Gemini）：
```
画一个游戏界面用的单位图标符号：纯黑色平面剪影，纯白背景（#FFFFFF）。内容是一只戴金属护手的拳头，横握着一道锯齿形闪电，闪电从拳头两侧向左右伸出，整体横向展开、宽度和高度差不多。粗线条、大块面、没有细节，风格像《文明6》的单位图标（参考图里的那把弩）。不要圆环、不要阴影、渐变、文字、边框。正方形 1024×1024。
```

Midjourney：
```
flat black silhouette game unit icon, an armored gauntlet fist gripping a jagged lightning bolt held horizontally, the bolt extending out to both sides, wide composition, bold chunky shapes, no fine detail, minimal military glyph, pure white background --ar 1:1 --style raw --no text, watermark, border, shadow, circle, ring
```

### 方案 B：施法的手掌

戴护手的手掌向前张开，掌心前方爆出一团带三四道尖芒的法术光团（星芒形，不要圆环）。

哈吉米（Gemini）：
```
画一个游戏界面用的单位图标符号：纯黑色平面剪影，纯白背景（#FFFFFF）。内容是一只戴金属护手的手掌向前张开，掌心前方爆出一团尖锐的星芒形法术光团（四道尖刺向外射出，不要圆环）。整体宽度和高度差不多，粗线条、大块面、没有细节，风格像《文明6》的单位图标。不要阴影、渐变、文字、边框。正方形 1024×1024。
```

### 方案 C：法杖与长剑交叉

一把直剑和一根顶端菱形水晶的作战法杖交叉成 X。最像官方「交叉武器」的写法，但两根细长物在 22 像素时可能糊。

哈吉米（Gemini）：
```
画一个游戏界面用的单位图标符号：纯黑色平面剪影，纯白背景（#FFFFFF）。内容是一把直剑和一根顶端为菱形水晶的作战法杖交叉成 X 形，两者都画得粗壮。整体宽度和高度相同，粗线条、大块面、没有细节，风格像《文明6》的单位图标。不要圆环、不要阴影、渐变、文字、边框。正方形 1024×1024。
```

验收：把图缩到 32 像素看一眼，还能认出拳头加闪电（或手掌加法术、剑加杖），不像别的东西。

## ② 战斗法师肖像 → `images/icons/battle_mage_portrait.png`

单位面板、百科里的大图。官方是彩绘的全身人物，四分之三侧身，带动作。

- 背景：**纯品红色 #FF00FF**（人物身上不要出现这个颜色）。
- 内容：提丰帝国的战斗法师，男性士兵，黑色军装式法袍、红色滚边与红色内衬（提丰的黑红配色），胸前与肩部有轻甲片，腰间皮带。右手持一根顶端有菱形水晶的法杖，左手向前伸出，掌心前方浮着一个发红白光的法阵。半蹲或前跨的施法姿势，全身入画（头到脚）。
- 画风：《文明6》单位肖像那种厚涂卡通写实，清晰的深色轮廓线，饱和但不刺眼。

Midjourney：
```
Civilization VI unit portrait style, full body battle mage soldier of a dark imperial army, black military robe with crimson trim and red lining, light steel pauldrons and breastplate, leather belt, holding a staff topped with a diamond crystal, other hand thrust forward casting a glowing red-white magic circle, dynamic three-quarter view casting pose, painterly game art with clean dark outlines, isolated on solid flat magenta #FF00FF background --ar 1:1 --style raw --no text, watermark, ground shadow, border
```

哈吉米（Gemini）：
```
按《文明6》单位肖像的画风（参考图里的弩手）画一个全身人物：提丰帝国的战斗法师，男性士兵。黑色军装式法袍，红色滚边和红色内衬，肩部和胸前有轻甲，腰间皮带。右手拿一根顶端有菱形水晶的法杖，左手向前伸，掌心前浮着一个发红白光的法阵。四分之三侧身、前跨施法的动作，从头到脚都要画进去。背景是纯品红色（#FF00FF），人物身上不要出现品红。不要地面阴影、文字、边框。正方形 1024×1024。
```

验收：头到脚完整，背景是一整块品红。

## ③ 法师塔区域图案 → `images/icons/mage_tower_glyph.png`

区域图标是六边形徽章，中间一个有光泽的图案（学院是一个装着蓝色液体的玻璃烧瓶）。**六边形和底色我来做**（沿用学院的蓝色，玩家一眼知道是科技区域），你只生成中间的图案。

- 背景：**纯黑色 #000000**。
- 内容：一座细高的法师塔（尖顶、几扇尖拱窗），塔身中段环绕一圈发光的魔力环。像玻璃或抛光陶瓷做的小摆件，浅蓝和白色，带高光，和参考图的烧瓶质感一致。

Midjourney：
```
glossy game icon of a slender wizard tower with a pointed spire and gothic arched windows, a glowing ring of magical energy circling its middle, rendered like a polished glass ornament, pale blue and white with bright specular highlights, centered, isolated on solid pure black background --ar 1:1 --style raw --no text, watermark, border, hexagon, frame
```

哈吉米（Gemini）：
```
画一个游戏图标中间的图案：一座细高的法师塔，尖顶，几扇哥特尖拱窗，塔身中段环绕一圈发光的魔力环。质感像抛光的玻璃摆件，浅蓝色和白色，有明亮的高光，参考图里那个烧瓶的质感。纯黑背景（#000000），只画塔本身，不要六边形外框、文字、边框。正方形 1024×1024。
```

验收：塔是一个独立的物件，没有外框；缩小到 50 像素还能看出是塔。

## ④ 燃石酸化工厂 → `images/icons/burnstone_works.png`

建筑图标是彩绘的等距视角建筑（参考图里的工厂）。

- 背景：**纯品红色 #FF00FF**。
- 内容：提丰风格的重工业厂房——深色石砌墙、深灰石板屋顶、哥特式尖拱窗，两三根高烟囱冒烟，侧面有几个圆柱形储罐，罐上的玻璃观察窗透出黄绿色发光的液体（燃石酸），管道连接。
- 视角：俯视约 30° 的等距视角，和官方建筑图标一致；整栋建筑完整入画，下面不要地面。

Midjourney：
```
Civilization VI building icon style, isometric view of a dark gothic industrial plant, dark stone walls and slate roofs, pointed arch windows, tall smokestacks with light smoke, cylindrical storage tanks with glass portholes showing glowing yellow-green liquid, connecting pipes, painterly game art with clean outlines, complete building, isolated on solid flat magenta #FF00FF background --ar 1:1 --style raw --no text, watermark, ground, terrain, shadow, border
```

哈吉米（Gemini）：
```
按《文明6》建筑图标的画风（参考图里的工厂）画一栋建筑：提丰帝国的燃石酸化工厂。深色石砌墙，深灰石板屋顶，哥特尖拱窗，两三根高烟囱冒着淡烟；旁边有几个圆柱形储罐，罐上的玻璃观察窗透出黄绿色发光液体，用管道相连。俯视约 30 度的等距视角，整栋建筑完整入画，下面不要地面和草地。背景纯品红色（#FF00FF），建筑上不要出现品红。不要文字、边框。正方形 1024×1024。
```

验收：整栋建筑完整、没有地面块，背景一整块品红。

## ⑤ 去神圣化项目图案 → `images/icons/desanctification_glyph.png`

项目图标是银灰色六边形徽章加中间的图案。**六边形我来做**，你只生成中间的图案。

- 背景：**纯黑色 #000000**。
- 内容：一本摊开的书，书页上方悬着一个光环，光环有一道裂纹，正在变暗（神圣褪去、知识取而代之）。银白和淡金色，有光泽的小摆件质感。

Midjourney：
```
glossy game icon of an open book with a fading cracked halo floating above its pages, polished silver and pale gold ornament style with soft specular highlights, centered, isolated on solid pure black background --ar 1:1 --style raw --no text, watermark, border, hexagon, frame
```

哈吉米（Gemini）：
```
画一个游戏图标中间的图案：一本摊开的书，书页上方悬着一个光环，光环上有一道裂纹、正在变暗（象征神圣褪去，知识取而代之）。银白和淡金色，像抛光的金属小摆件，有柔和的高光。纯黑背景（#000000），只画书和光环，不要六边形外框、文字、边框。正方形 1024×1024。
```

验收：书和光环都清楚，缩小到 50 像素能认出是书。

---

## 我这边拿到图后做的事

1. 按背景色抠图，裁掉多余留白，按官方留白比例放回正方形。
2. 单位图标：黑剪影转白色，加深色描边；FOW 版本做成官方那种金色加深棕描边。
3. 区域、项目：画六边形徽章（区域用学院同款蓝，项目用银灰），把图案合成上去；区域另做羊皮纸色的 FOW 版本。
4. 建筑：另做偏棕金色的 FOW 版本。
5. 缩放到各尺寸：单位 22–256（6 个）、肖像 38–256（6 个）、区域 22–256（7 个）、建筑 32–256（6 个）、项目 30–256（7 个）。
6. 把 `Icons/TsoDTE_Icons.xml` 里对应的官方别名换成自己的图集，构建、部署。

---

# 战神教（WP14）：宗教标志与历史时刻

现在暂借官方「自定义宗教 4」的狮子：宗教图标、宗教透镜（3D 地图上的城市图标、压力箭头，2D 战略视图图标）、历史时刻都是它。**一共只要 1 张，第 2 张可选。** 通用规格同上（正方形、至少 1024×1024、PNG、四周留白约 6%、不要文字水印边框），两张都是**纯黑平面剪影放在纯白背景（#FFFFFF）上**。

风格参考图（`images/icon-refs/`）：

| 参考图 | 看什么 |
|---|---|
| `religion_icons_50.png` | 官方小尺寸宗教图标：一整块白色实心剪影（十字、新月、法轮……），22 像素也认得出 |
| `religion_icon_270_islam.png` | 官方大图标：同一个符号的细线描边版（我从你的剪影自动描边，不用另画） |
| `religion_moment_book.png` | 「创立宗教」历史时刻：所有宗教共用一本摊开的圣典，左页上盖着本宗教的符号印章（这里是狮子），印章只有 166×122 |

## ⑥ 战神教标志 → `images/战神教标志.png`

用在宗教图标的全部 4 个尺寸（22、50、100、270）和宗教透镜上，所以必须是**一个粗壮、轮廓简单的实心剪影**，缩到 22 像素还认得出。原作意象：教皇的铁质权杖、「战锤击打盾牌一般的巨响」、铁灰色的祭火。

避开：
- 不要和提丰国徽撞：盾面上**不要**四分格、不要皇冠；
- 不要像官方已有的宗教符号：单独的十字、新月、星形、法轮；
- 不要「细长杆子顶一个圆」（战斗法师图标第一版的教训）；两根细长物交叉在 22 像素时容易糊成一个叉。

下面两个方案任选一个，推荐 A。

### 方案 A（推荐）：被战锤击打的盾

一面圆盾或尖底骑士盾（盾面朴素，只有一圈盾缘），一柄方头战锤从右上方斜着砸在盾面上，撞击点迸出三四道短而粗的放射状裂纹或冲击线。大块面主要是盾，所以小尺寸下最稳。

哈吉米（Gemini）：
```
画一个游戏界面用的宗教图标符号：纯黑色平面剪影，纯白背景（#FFFFFF）。内容是一面朴素的圆形骑士盾（只有一圈盾缘，盾面上没有花纹、没有分格、没有皇冠），一柄方头战锤从右上方斜着砸在盾面上，撞击点迸出三四道短而粗的放射状冲击线。粗线条、大块面、没有细节，像《文明6》宗教图标里的十字和新月那样简洁（参考图）。不要阴影、渐变、文字、边框。正方形 1024×1024，主体居中，四周留白。
```

Midjourney：
```
flat black silhouette religion icon, a plain round knight's shield with only a rim, a square-headed war hammer striking it diagonally from the upper right, three or four short thick impact lines bursting from the point of impact, bold chunky shapes, no fine detail, minimal sacred emblem like Civilization VI religion symbols, pure white background --ar 1:1 --style raw --no text, watermark, border, shadow, crown, quartered shield, cross, crescent, star
```

### 方案 B：权杖与战锤交叉

教皇的铁质权杖（顶端一个粗壮的方形或冠状杖首）和一柄方头战锤交叉成 X，两者都画得很粗，杖首和锤头要大，交叉点后面可以垫一小团三尖火焰（铁色的祭火）把中间填实。

哈吉米（Gemini）：
```
画一个游戏界面用的宗教图标符号：纯黑色平面剪影，纯白背景（#FFFFFF）。内容是一根粗壮的铁质权杖（顶端是一个大而方正的杖首）和一柄方头战锤交叉成 X 形，交叉点后面衬着一小团三尖的火焰，把中间填实。两件器物都画得很粗，杖首和锤头都要大，粗线条、大块面、没有细节，像《文明6》宗教图标那样简洁（参考图）。不要阴影、渐变、文字、边框。正方形 1024×1024，主体居中，四周留白。
```

Midjourney：
```
flat black silhouette religion icon, a thick iron sceptre with a large blocky head crossed with a square-headed war hammer in an X, a small three-tongued flame behind the crossing point filling the center, both objects very thick with oversized heads, bold chunky shapes, no fine detail, minimal sacred emblem like Civilization VI religion symbols, pure white background --ar 1:1 --style raw --no text, watermark, border, shadow, cross, crescent, star
```

验收：缩到 22 像素（大约指甲盖大小）看一眼，还能认出「盾加锤」（或「杖加锤」），不是一团黑块，也不像十字架。

## ⑦ 战神教历史时刻（可选）→ `images/战神教历史时刻.png`

计划里写的是「暴风雪中的铁灰色巨人」，但官方的宗教历史时刻**不是一整幅画**：画面是所有宗教共用的圣典，每个宗教只在左页上盖一个 166×122 的棕色印章（见 `religion_moment_book.png`）。所以这张要的是**巨人的剪影**，我把它转成和官方一样的棕色印章；暴风雪画不进这么小的印章，只用飘起的披风表现风。

**不交这张也行**：官方每个宗教的印章就是它的宗教符号，我会直接用 ⑥ 的标志盖章。

- 内容：冬堡群山前的铁灰色巨人（战神降临的化身）。全身，穿厚重的板甲、头盔遮住脸，一手提着巨大的方头战锤，向左前方迈步，身后一大片向右飘起的破披风。
- 只要剪影，轮廓要大块、清楚，不要细节；人物占满画面高度。

哈吉米（Gemini）：
```
画一个纯黑色平面剪影，纯白背景（#FFFFFF）：一个穿厚重板甲的巨人，头盔遮住脸，一手提着巨大的方头战锤，向左前方大步迈进，身后一大片向右飘起的破披风。全身入画，人物占满画面高度，轮廓大块、清楚，没有细节和细线。不要地面、阴影、渐变、文字、边框。正方形 1024×1024。
```

Midjourney：
```
flat black silhouette of a towering giant in heavy plate armor, closed helmet hiding the face, gripping a huge square-headed war hammer, striding forward to the left, a large tattered cloak billowing to the right behind him, full body filling the frame, bold clean shapes, no fine detail, pure white background --ar 1:1 --style raw --no text, watermark, border, ground, shadow
```

验收：缩到 80 像素高还能看出是一个提锤的巨人。

## 战神教：我这边拿到图后做的事

1. `python -X utf8 tools/make_religion_art.py --icons`（读 `images/战神教标志.png`，有 `images/战神教历史时刻.png` 就用它做印章）：
   - 宗教图标：22、50、100 是白色实心剪影；270 是自动描边的细线版，和官方一致；
   - 宗教透镜：3D 城市图标 512（细线版加深色光晕）、压力箭头 128 与 2D 战略视图图标 128（实心）；
   - 历史时刻：166×122 的棕色印章。
2. 脚本同时把 `Icons/TsoDTE_Icons_Religion.sql` 的临时别名换成自己的图集，把时刻插图从官方狮子换成 `MOMENT_RELIGION_TSOD_WAR_GOD`。
3. 构建、部署，在 test-log 记一轮。
