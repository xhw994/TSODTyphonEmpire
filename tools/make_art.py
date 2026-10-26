"""Generate the mod's textures from the reference art in images/.

Run from the repo root:
    python -X utf8 tools/make_art.py [--preview DIR]

Writes src/Textures/<NAME>.dds + <NAME>.tex for every texture below (uncompressed RGBA DDS,
same layout as the Cecil mod's working textures), and art/generated/<NAME>.png as the
editable source. --preview also writes contact sheets to DIR for review.

Crops are in source-image pixels; adjust them here and re-run.
"""
import os
import struct
import sys

from PIL import Image, ImageChops, ImageDraw, ImageEnhance, ImageFilter

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
IMG = os.path.join(ROOT, 'images')
TEX_DIR = os.path.join(ROOT, 'src', 'Textures')
GEN_DIR = os.path.join(ROOT, 'art', 'generated')

CIV_SIZES = [22, 30, 32, 36, 44, 45, 48, 50, 64, 80, 128, 200, 256]
LEADER_SIZES = [32, 45, 48, 50, 55, 64, 80, 256]

SRC_ROSETTA = '罗塞塔·奥古斯都大帝.jpg'
SRC_RAIN = '奥尔德南，雨夜，从燃石酸化工厂前的大道上驶过的马车.png'
# Loading screen background (2880 x 1440, exactly 2:1, so it scales to 1920 x 960 without a crop).
SRC_LOADING = '奥尔德南 冬日 修图.jpg'
# images/法师塔.jpg is Cecil's mage tower; the user agreed to use a short crop of it for the Mage Tower moment.
SRC_TOWER = '法师塔.jpg'
SRC_MATILDA = '玛蒂尔达·奥古斯都.jpg'

# Colors (src/Core/TsoDTE_Colors.sql): field 22,20,22; emblem 196,26,32; gold 228,182,78
BLACK = (22, 20, 22, 255)
RED = (196, 26, 32, 255)
GOLD = (228, 182, 78, 255)


# ----------------------------------------------------------------------------- DDS / TEX
def write_dds(img, path, mips=False):
    """Uncompressed 32-bit RGBA DDS (masks R=0xff, G=0xff00, B=0xff0000, A=0xff000000)."""
    img = img.convert('RGBA')
    levels = [img]
    if mips:
        w, h = img.size
        while w > 1 or h > 1:
            w, h = max(1, w // 2), max(1, h // 2)
            levels.append(img.resize((w, h), Image.LANCZOS))
    w, h = img.size
    flags = 0x1 | 0x2 | 0x4 | 0x8 | 0x1000 | (0x20000 if mips else 0)
    caps = 0x1000 | ((0x8 | 0x400000) if mips else 0)
    header = struct.pack('<4sIIIIIII44x', b'DDS ', 124, flags, h, w, w * 4, 0, len(levels))
    pf = struct.pack('<IIIIIIII', 32, 0x41, 0, 32, 0x000000ff, 0x0000ff00, 0x00ff0000, 0xff000000)
    tail = struct.pack('<IIIII', caps, 0, 0, 0, 0)
    with open(path, 'wb') as f:
        f.write(header + pf + tail)
        for lv in levels:
            f.write(lv.tobytes())
    return len(levels)


TEX = """<?xml version="1.0" encoding="UTF-8" ?>
<AssetObjects..TextureInstance>
	<m_ExportSettings>
		<ePixelformat>PF_R8G8B8A8_UNORM</ePixelformat>
		<eFilterType>FT_BOX</eFilterType>
		<bUseMips>{usemips}</bUseMips>
		<iNumManualMips>0</iNumManualMips>
		<bCompleteMipChain>false</bCompleteMipChain>
		<fValueClampMin>0.000000</fValueClampMin>
		<fValueClampMax>1.000000</fValueClampMax>
		<fSupportScale>1.000000</fSupportScale>
		<fGammaIn>2.200000</fGammaIn>
		<fGammaOut>2.200000</fGammaOut>
		<iSlabWidth>0</iSlabWidth>
		<iSlabHeight>0</iSlabHeight>
		<iColorKeyX>64</iColorKeyX>
		<iColorKeyY>64</iColorKeyY>
		<iColorKeyZ>64</iColorKeyZ>
		<eExportMode>TEXTURE_2D</eExportMode>
		<bSampleFromTopLayer>false</bSampleFromTopLayer>
	</m_ExportSettings>
	<m_CookParams>
		<m_Values/>
	</m_CookParams>
	<m_Version>
		<major>1</major>
		<minor>0</minor>
		<build>0</build>
		<revision>0</revision>
	</m_Version>
	<m_Height>{h}</m_Height>
	<m_Width>{w}</m_Width>
	<m_Depth>1</m_Depth>
	<m_NumMipMaps>{nummips}</m_NumMipMaps>
	<m_SourceFilePath text="art/generated/{name}.png"/>
	<m_SourceObjectName text=""/>
	<m_ImportedTime>0</m_ImportedTime>
	<m_ExportedTime>0</m_ExportedTime>
	<m_ClassName text="{cls}"/>
	<m_DataFiles>
		<Element>
			<m_ID text="DDS"/>
			<m_RelativePath text="{name}.dds"/>
		</Element>
	</m_DataFiles>
	<m_Name text="{name}"/>
	<m_Description text=""/>
	<m_Tags>
{tags}
	</m_Tags>
</AssetObjects..TextureInstance>
"""


def emit(img, name, fallback=False):
    """Save PNG source + DDS + TEX. Returns the image for previews."""
    img = img.convert('RGBA')
    img.save(os.path.join(GEN_DIR, name + '.png'))
    levels = write_dds(img, os.path.join(TEX_DIR, name + '.dds'), mips=fallback)
    if fallback:
        cls = 'Leader_Fallback'
        tags = '\t\t<Element text="Leader_Fallback"/>\n\t\t<Element text="Leader"/>\n\t\t<Element text="Fallback"/>'
    else:
        cls = 'UserInterface'
        tags = '\t\t<Element text="UserInterface"/>'
    with open(os.path.join(TEX_DIR, name + '.tex'), 'w', encoding='utf-8', newline='\n') as f:
        f.write(TEX.format(usemips='true' if levels > 1 else 'false', nummips=levels - 1,
                           h=img.height, w=img.width, name=name, cls=cls, tags=tags))
    return img


# ----------------------------------------------------------------------------- helpers
def load(name):
    return Image.open(os.path.join(IMG, name)).convert('RGBA')


def crop_resize(img, box, size):
    return img.crop(box).resize(size, Image.LANCZOS)


def feather(img, left, top, right, bottom):
    """Fade alpha to 0 over the given pixel widths at each edge."""
    w, h = img.size
    mask = Image.new('L', (w, h), 0)
    px = mask.load()
    for y in range(h):
        fy = min(1.0, y / top if top else 1.0, (h - 1 - y) / bottom if bottom else 1.0)
        for x in range(w):
            fx = min(1.0, x / left if left else 1.0, (w - 1 - x) / right if right else 1.0)
            px[x, y] = int(255 * max(0.0, min(fx, fy)))
    out = img.copy()
    out.putalpha(ImageChops.multiply(img.getchannel('A'), mask))
    return out


def erode(mask, px):
    for _ in range(px // 4):
        mask = mask.filter(ImageFilter.MinFilter(9))
    return mask


# ----------------------------------------------------------------------------- emblem
S = 1024


def _bezier(p0, p1, p2, p3, n=24):
    pts = []
    for i in range(1, n + 1):
        t = i / n
        a, b, c, d = (1 - t) ** 3, 3 * (1 - t) ** 2 * t, 3 * (1 - t) * t ** 2, t ** 3
        pts.append((a * p0[0] + b * p1[0] + c * p2[0] + d * p3[0], a * p0[1] + b * p1[1] + c * p2[1] + d * p3[1]))
    return pts


# Heater shield as on the banner in 提丰地图和国徽.jpg: peaked top edge, straight sides, curved base.
SHIELD = ([(184, 211), (514, 110), (844, 211), (844, 560)]
          + _bezier((844, 560), (844, 760), (700, 880), (514, 930))
          + _bezier((514, 930), (328, 880), (184, 760), (184, 560)))
DIV_X, DIV_Y = 514, 600
# The crown polygon runs past the divider and is clipped to the top half in crown_mask(),
# so crown and quarters share exact pixel edges (no hairline seam).
CROWN = [(286, DIV_Y + 6), (286, 344), (343, 468), (400, 392), (457, 468), (514, 296), (571, 468),
         (628, 392), (685, 468), (742, 344), (742, DIV_Y + 6)]
CROWN_TIPS = [(286, 344), (400, 392), (514, 296), (628, 392), (742, 344)]
RIM = 44
GAP = 20


def poly_mask(points):
    m = Image.new('L', (S, S), 0)
    ImageDraw.Draw(m).polygon(points, fill=255)
    return m


def crown_mask():
    m = poly_mask(CROWN)
    d = ImageDraw.Draw(m)
    for x, y in CROWN_TIPS:
        d.ellipse((x - 22, y - 22, x + 22, y + 22), fill=255)
    top = Image.new('L', (S, S), 0)
    ImageDraw.Draw(top).rectangle((0, 0, S - 1, DIV_Y - 1), fill=255)
    return ImageChops.multiply(m, top)


def quad_mask(tr_bl=True):
    """Top-right + bottom-left quarters (or the other two). Exact partition: top rows < DIV_Y, left cols < DIV_X."""
    m = Image.new('L', (S, S), 0)
    d = ImageDraw.Draw(m)
    if tr_bl:
        d.rectangle((DIV_X, 0, S - 1, DIV_Y - 1), fill=255)
        d.rectangle((0, DIV_Y, DIV_X - 1, S - 1), fill=255)
    else:
        d.rectangle((0, 0, DIV_X - 1, DIV_Y - 1), fill=255)
        d.rectangle((DIV_X, DIV_Y, S - 1, S - 1), fill=255)
    return m


def emblem_layers():
    outer = poly_mask(SHIELD)
    rim_inner = erode(outer, RIM)
    field = erode(rim_inner, GAP)
    rim = ImageChops.subtract(outer, rim_inner)
    crown = crown_mask()
    red = ImageChops.multiply(field, quad_mask(True))          # TR + BL
    # counterchange: crown is red over the black quarters, black over the red quarters
    crown_on_black = ImageChops.multiply(crown, ImageChops.multiply(field, quad_mask(False)))
    crown_on_red = ImageChops.multiply(crown, red)
    red = ImageChops.add(ImageChops.subtract(red, crown_on_red), crown_on_black)
    return rim, field, red


def emblem_mono():
    """White silhouette for ICON_CIVILIZATION_* (the game tints it with the player colors)."""
    rim, field, red = emblem_layers()
    alpha = ImageChops.add(rim, red)
    img = Image.new('RGBA', (S, S), (255, 255, 255, 0))
    img.putalpha(alpha)
    return img


def emblem_color():
    rim, field, red = emblem_layers()
    img = Image.new('RGBA', (S, S), (0, 0, 0, 0))
    img.paste(Image.new('RGBA', (S, S), BLACK), (0, 0), field)
    img.paste(Image.new('RGBA', (S, S), RED), (0, 0), red)
    img.paste(Image.new('RGBA', (S, S), GOLD), (0, 0), rim)
    return img


def icon_sizes(src, base, sizes):
    out = []
    for s in sizes:
        out.append(emit(src.resize((s, s), Image.LANCZOS), '%s_%d' % (base, s)))
    return out


# ----------------------------------------------------------------------------- leader
ROSETTA_HEAD = (512, 452, 712, 652)        # square crop centered on the head (crown + hair + beard)


def leader_icon_master():
    src = load(SRC_ROSETTA)
    head = crop_resize(src, ROSETTA_HEAD, (S, S))
    canvas = Image.new('RGBA', (S, S), (0, 0, 0, 0))
    inset = 24
    circle = Image.new('L', (S, S), 0)
    ImageDraw.Draw(circle).ellipse((inset, inset, S - inset, S - inset), fill=255)
    backing = Image.new('RGBA', (S, S), BLACK)
    canvas.paste(backing, (0, 0), circle)
    canvas.paste(head, (0, 0), ImageChops.multiply(circle, head.getchannel('A')))
    return canvas


# ----------------------------------------------------------------------------- packages
PLATFORMS = ('WINDOWS', 'MACOS', 'IOS', 'LINUX', 'XBONE', 'PS4', 'SWITCH', 'STADIA')


def write_xlp(path, cls, package, entries):
    body = '\n'.join('\t\t<Element>\n\t\t\t<m_EntryID text="%s"/>\n\t\t\t<m_ObjectName text="%s"/>\n\t\t</Element>'
                     % (e, e) for e in entries)
    plats = '\n'.join('\t\t<Element>%s</Element>' % p for p in PLATFORMS)
    text = ('<?xml version="1.0" encoding="UTF-8" ?>\n<AssetObjects..XLP>\n\t<m_Version>\n\t\t<major>1</major>\n'
            '\t\t<minor>0</minor>\n\t\t<build>0</build>\n\t\t<revision>0</revision>\n\t</m_Version>\n'
            '\t<m_ClassName text="%s"/>\n\t<m_PackageName text="%s"/>\n\t<m_Entries>\n%s\n\t</m_Entries>\n'
            '\t<m_AllowedPlatforms>\n%s\n\t</m_AllowedPlatforms>\n</AssetObjects..XLP>\n') % (cls, package, body, plats)
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        f.write(text)


def write_packages():
    """Every texture in src/Textures goes into one of the two packages (fallback vs UI)."""
    names = sorted(os.path.splitext(f)[0] for f in os.listdir(TEX_DIR) if f.endswith('.tex'))
    fallback = [n for n in names if n.startswith('FALLBACK_NEUTRAL_')]
    ui = [n for n in names if n not in fallback]
    xdir = os.path.join(ROOT, 'src', 'XLPs')
    write_xlp(os.path.join(xdir, 'TsoDTE_UITextures.xlp'), 'UITexture', 'TsoDTE_UITextures', ui)
    write_xlp(os.path.join(xdir, 'TsoDTE_LeaderFallbacks.xlp'), 'LeaderFallback', 'TsoDTE_LeaderFallbacks', fallback)
    return len(ui), len(fallback)


# ----------------------------------------------------------------------------- main
def main():
    preview = None
    if '--preview' in sys.argv:
        preview = sys.argv[sys.argv.index('--preview') + 1]
        os.makedirs(preview, exist_ok=True)
    os.makedirs(TEX_DIR, exist_ok=True)
    os.makedirs(GEN_DIR, exist_ok=True)

    made = {}
    mono = emblem_mono()
    made['civ'] = icon_sizes(mono, 'ICON_CIVILIZATION_TSOD_TYPHON_EMPIRE', CIV_SIZES)
    leader = leader_icon_master()
    made['leader'] = icon_sizes(leader, 'ICON_LEADER_TSOD_ROSETTA_AUGUSTUS', LEADER_SIZES)

    rosetta = load(SRC_ROSETTA)
    # setup / load screen portrait, 731 x 1461 like the official neutral portraits
    # crown to below the knees, so the figure fills the narrow setup-screen panel and the face reads
    neutral = feather(crop_resize(rosetta, (350, 395, 850, 1395), (731, 1461)), 30, 20, 30, 90)
    made['neutral'] = emit(neutral, 'LEADER_TSOD_ROSETTA_AUGUSTUS_NEUTRAL')
    emit(neutral, 'LEADER_TSOD_ROSETTA_AUGUSTUS_LOADING_FOREGROUND')
    # diplomacy fallback, 825 x 1024, figure on the left
    fig = feather(crop_resize(rosetta, (360, 395, 870, 1295), (580, 1024)), 30, 20, 90, 110)
    fallback = Image.new('RGBA', (825, 1024), (0, 0, 0, 0))
    fallback.alpha_composite(fig, (0, 0))
    made['fallback'] = emit(fallback, 'FALLBACK_NEUTRAL_LEADER_TSOD_ROSETTA_AUGUSTUS', fallback=True)

    rain = load(SRC_RAIN)
    bg = crop_resize(rain, (400, 0, 2559, 1080), (1920, 960))
    # the loading screen uses its own winter view; the leader-selection background keeps the rainy night
    loading = load(SRC_LOADING).resize((1920, 960), Image.LANCZOS)
    made['loading_bg'] = emit(loading, 'LEADER_TSOD_ROSETTA_AUGUSTUS_LOADING_BACKGROUND')
    emit(bg, 'LEADER_TSOD_ROSETTA_AUGUSTUS_BACKGROUND')
    # throne room above Rosetta's head in his portrait (left of x=240 is the novel's logo)
    made['diplo_bg'] = emit(crop_resize(rosetta, (240, 0, 1180, 470), (1920, 960)),
                            'LEADER_TSOD_ROSETTA_AUGUSTUS_DIPLOMACY_BACKGROUND')

    # historic moments, 456 x 332 like the Cecil mod
    tower = load(SRC_TOWER)
    made['m_district'] = emit(crop_resize(tower, (1050, 0, 2350, 947), (456, 332)), 'MOMENT_DISTRICT_TSOD_MAGE_TOWER')
    made['m_building'] = emit(crop_resize(rain, (520, 100, 2020, 1192), (456, 332)), 'MOMENT_BUILDING_TSOD_BURNSTONE_WORKS')
    matilda = load(SRC_MATILDA)
    made['m_unit'] = emit(crop_resize(matilda, (0, 450, 1999, 1906), (456, 332)), 'MOMENT_UNIT_TSOD_BATTLE_MAGE')

    # unit / district / building / project icons from the generated images (docs/icon-prompts.md)
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import icon_art
    icons = icon_art.build(IMG, emit, icon_sizes)

    if preview:
        refs = os.path.join(IMG, 'icon-refs')
        pairs = [('unit', 'unit_icon_crossbowman'), ('unit_fow', 'unit_icon_crossbowman_FOW'),
                 ('portrait', 'unit_portrait_crossbowman'), ('district', 'district_campus'),
                 ('district_fow', 'district_campus_FOW'), ('building', 'building_factory'),
                 ('building_fow', 'building_factory_FOW'), ('project', 'project_campus')]
        sheet = Image.new('RGBA', (256 * len(pairs), 512 + 80), (70, 90, 120, 255))
        for i, (k, ref) in enumerate(pairs):
            sheet.alpha_composite(icons[k][-1], (i * 256, 0))          # ours, 256 px
            rp = os.path.join(refs, ref + '.png')
            if os.path.exists(rp):
                sheet.paste(Image.open(rp).convert('RGBA').resize((256, 256)), (i * 256, 256))
            x = i * 256 + 8
            for im in icons[k][:3]:                                      # smallest sizes
                sheet.alpha_composite(im, (x, 520))
                x += im.width + 6
        sheet.save(os.path.join(preview, 'icons_vs_official.png'))
        emblem_color().save(os.path.join(preview, 'emblem_color.png'))
        sheet = Image.new('RGBA', (sum(made['civ'][i].width + 8 for i in range(len(CIV_SIZES))), 256), (196, 26, 32, 255))
        x = 0
        for im in made['civ']:
            sheet.alpha_composite(im, (x, 0))
            x += im.width + 8
        sheet.save(os.path.join(preview, 'civ_icons.png'))
        sheet = Image.new('RGBA', (sum(im.width + 8 for im in made['leader']), 256), (90, 90, 90, 255))
        x = 0
        for im in made['leader']:
            sheet.alpha_composite(im, (x, 0))
            x += im.width + 8
        sheet.save(os.path.join(preview, 'leader_icons.png'))
        for k in ('neutral', 'fallback', 'loading_bg', 'diplo_bg', 'm_district', 'm_building', 'm_unit'):
            im = made[k]
            bgc = Image.new('RGBA', im.size, (40, 40, 40, 255))
            bgc.alpha_composite(im)
            bgc.convert('RGB').save(os.path.join(preview, k + '.jpg'), quality=85)
    print('textures written to', TEX_DIR, '; packages (ui, fallback):', write_packages())


if __name__ == '__main__':
    main()
