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
