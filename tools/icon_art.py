"""Turn the generated icon images in images/ into Civ6 icon sets (called from make_art.py).

Inputs (one image each, see docs/icon-prompts.md):
    战斗法师单位图标.jpg   black glyph on white      -> unit icon + FOW
    战斗法师肖像.jpg       figure on magenta         -> unit portrait
    法师塔区域图案.jpg     glyph on black            -> district icon (blue hexagon) + FOW
    燃石酸化工厂.jpg       building on magenta       -> building icon + FOW
    去神圣化项目.jpg       glyph on black            -> project icon (silver hexagon)

Styles follow the official icons (extracted to images/icon-refs/): unit glyphs are white with a dark
edge and a gold-on-brown FOW version; districts and projects are a glyph on a pointy-top hexagon
badge; buildings are painted objects with a sepia FOW version.
"""
import math
import os

from PIL import Image, ImageChops, ImageDraw, ImageEnhance, ImageFilter, ImageOps

M = 1024          # master canvas
UNIT_SIZES = [22, 32, 38, 50, 80, 256]
PORTRAIT_SIZES = [38, 50, 70, 95, 200, 256]
DISTRICT_SIZES = [22, 32, 38, 50, 80, 128, 256]
BUILDING_SIZES = [32, 38, 50, 80, 128, 256]
PROJECT_SIZES = [30, 32, 38, 50, 70, 80, 256]


# ----------------------------------------------------------------------------- keying
def _alpha_from(img, fn):
    rgb = img.convert('RGB')
    a = Image.new('L', rgb.size)
    a.putdata([fn(p) for p in rgb.getdata()])
    return a


def key_white_glyph(img):
    """Black glyph on white -> alpha from darkness."""
    return _alpha_from(img, lambda p: max(0, min(255, int((255 - (p[0] + p[1] + p[2]) / 3) * 1.15))))


def key_magenta(img, bg=(252, 25, 251)):
    """Subject on flat magenta -> RGBA. Soft edges are un-mixed from the background colour so
    smoke and glow keep their own colour instead of a pink fringe."""
    rgb = img.convert('RGB')
    span = min(bg[0], bg[2]) - bg[1]
    out = []
    for r, g, b in rgb.getdata():
        # linear mixing model: for a grey-ish subject over magenta, min(R,B) - G = (1 - a) * span
        m = min(r, b) - g
        a = 1.0 - max(0.0, min(1.0, m / span))
        if a <= 0.08:
            out.append((0, 0, 0, 0))
            continue
        if a < 1.0:
            r, g, b = (max(0, min(255, int((c - (1 - a) * k) / a))) for c, k in zip((r, g, b), bg))
        out.append((r, g, b, int(a * 255)))
    res = Image.new('RGBA', rgb.size)
    res.putdata(out)
    return res


def key_black(img, threshold=28):
    """Subject on black: flood-fill the black background from the borders, soft 2 px edge."""
    rgb = img.convert('RGB')
    w, h = rgb.size
    lum = rgb.convert('L')
    bg = Image.new('L', (w, h), 0)
    px, lp = bg.load(), lum.load()
    stack = [(x, 0) for x in range(w)] + [(x, h - 1) for x in range(w)] + \
            [(0, y) for y in range(h)] + [(w - 1, y) for y in range(h)]
    def fill(seeds, mark, limit=None):
        """Flood dark pixels from seeds; returns the visited list (stops early past limit)."""
        seen = []
        while seeds:
            x, y = seeds.pop()
            if mark[x, y] or lp[x, y] > threshold:
                continue
            mark[x, y] = 255
            seen.append((x, y))
            if x > 0: seeds.append((x - 1, y))
            if x < w - 1: seeds.append((x + 1, y))
            if y > 0: seeds.append((x, y - 1))
            if y < h - 1: seeds.append((x, y + 1))
        return seen

    fill(stack, px)
    # enclosed background (inside a halo, between a ring and a tower): large dark holes go too
    visited = Image.new('L', (w, h), 0)
    vp = visited.load()
    for y in range(0, h, 4):
        for x in range(0, w, 4):
            if not px[x, y] and not vp[x, y] and lp[x, y] <= threshold:
                region = fill([(x, y)], vp)
                if len(region) > (w * h) // 600:
                    for qx, qy in region:
                        px[qx, qy] = 255
    alpha = ImageOps.invert(bg).filter(ImageFilter.GaussianBlur(1.2))   # soft 1-2 px edge
    res = rgb.convert('RGBA')
    res.putalpha(alpha)
    return res


def fit(img, fill, canvas=M):
    """Trim to the alpha bounding box and centre it so its larger side is fill * canvas."""
    box = img.getchannel('A').point(lambda v: 255 if v > 8 else 0).getbbox()
    img = img.crop(box)
    scale = fill * canvas / max(img.size)
    img = img.resize((max(1, round(img.width * scale)), max(1, round(img.height * scale))), Image.LANCZOS)
    out = Image.new('RGBA', (canvas, canvas), (0, 0, 0, 0))
    out.alpha_composite(img, ((canvas - img.width) // 2, (canvas - img.height) // 2))
    return out


def dilate(mask, px):
    for _ in range(max(1, px // 4)):
        mask = mask.filter(ImageFilter.MaxFilter(9))
    return mask


def solid(color, mask):
    out = Image.new('RGBA', mask.size, color)
    out.putalpha(ImageChops.multiply(mask, Image.new('L', mask.size, color[3] if len(color) > 3 else 255)))
    return out


# ----------------------------------------------------------------------------- unit glyph
def unit_glyph(src):
    a = fit(_mask_rgba(key_white_glyph(src)), 0.80).getchannel('A')
    edge = dilate(a, 12)
    main = Image.new('RGBA', (M, M), (0, 0, 0, 0))
    main.alpha_composite(solid((20, 18, 20, 210), edge))
    main.alpha_composite(solid((255, 255, 255, 255), a))
    fow = Image.new('RGBA', (M, M), (0, 0, 0, 0))
    fow.alpha_composite(solid((52, 38, 24, 255), dilate(a, 44)))
    fow.alpha_composite(solid((201, 164, 106, 255), a))
    return main, fow


def _mask_rgba(alpha):
    img = Image.new('RGBA', alpha.size, (255, 255, 255, 0))
    img.putalpha(alpha)
    return img


# ----------------------------------------------------------------------------- hexagon badges
def hexagon(cx, cy, r):
    return [(cx + r * math.cos(math.radians(a)), cy + r * math.sin(math.radians(a))) for a in range(-90, 270, 60)]


def _poly(points):
    m = Image.new('L', (M, M), 0)
    ImageDraw.Draw(m).polygon(points, fill=255)
    return m


def _vgradient(top, bottom):
    g = Image.new('RGBA', (M, M))
    d = ImageDraw.Draw(g)
    for y in range(M):
        t = y / (M - 1)
        d.line((0, y, M, y), fill=tuple(int(top[i] + (bottom[i] - top[i]) * t) for i in range(3)) + (255,))
    return g


def badge(glyph, outer, rim, top, bottom, light, glyph_fill):
    """Pointy-top hexagon: outer border, dark rim, gradient face, thin light inner line, glyph."""
    c, R = M / 2, M * 0.47
    out = Image.new('RGBA', (M, M), (0, 0, 0, 0))
    out.alpha_composite(solid(outer + (255,), _poly(hexagon(c, c, R))))
    out.alpha_composite(solid(rim + (255,), _poly(hexagon(c, c, R * 0.955))))
    face_mask = _poly(hexagon(c, c, R * 0.90))
    face = _vgradient(top, bottom)
    face.putalpha(face_mask)
    out.alpha_composite(face)
    line = ImageChops.subtract(_poly(hexagon(c, c, R * 0.88)), _poly(hexagon(c, c, R * 0.865)))
    out.alpha_composite(solid(light + (150,), line))
    g = fit(glyph, glyph_fill)
    shadow = solid((0, 0, 0, 120), g.getchannel('A').filter(ImageFilter.GaussianBlur(10)))
    out.alpha_composite(shadow, (0, 10))
    out.alpha_composite(g)
    return out


def sepia(img, tone=(214, 178, 120), contrast=0.85, brightness=1.0):
    a = img.getchannel('A')
    gray = ImageEnhance.Contrast(img.convert('L')).enhance(contrast)
    gray = ImageEnhance.Brightness(gray).enhance(brightness)
    col = ImageOps.colorize(gray, black=(40, 28, 16), white=tone).convert('RGBA')
    col.putalpha(a)
    return col


def district_fow(main):
    # parchment hexagon with an embossed, low-contrast glyph, like Districts256_FOW
    return sepia(main, tone=(222, 196, 140), contrast=0.7, brightness=1.05)


# ----------------------------------------------------------------------------- build all
def build(img_dir, emit, sizes_emit):
    """emit(img, name) writes one texture; sizes_emit(master, base, sizes) writes a size set."""
    made = {}

    def load(n):
        # the same name in .png / .jpg / .jpeg / .webp: take the most recently saved one
        stem = os.path.splitext(n)[0]
        found = [os.path.join(img_dir, stem + ext) for ext in ('.png', '.jpg', '.jpeg', '.webp')
                 if os.path.exists(os.path.join(img_dir, stem + ext))]
        if not found:
            raise FileNotFoundError(os.path.join(img_dir, stem + '.*'))
        im = Image.open(max(found, key=os.path.getmtime)).convert('RGB')
        return im.resize((M, M), Image.LANCZOS) if im.size != (M, M) else im

    unit, unit_fow = unit_glyph(load('战斗法师单位图标.jpg'))
    made['unit'] = sizes_emit(unit, 'ICON_UNIT_TSOD_BATTLE_MAGE', UNIT_SIZES)
    made['unit_fow'] = sizes_emit(unit_fow, 'ICON_UNIT_TSOD_BATTLE_MAGE_FOW', UNIT_SIZES)

    portrait = fit(key_magenta(load('战斗法师肖像.jpg')), 0.94)
    made['portrait'] = sizes_emit(portrait, 'ICON_UNIT_TSOD_BATTLE_MAGE_PORTRAIT', PORTRAIT_SIZES)

    tower = key_black(load('法师塔区域图案.jpg'))
    district = badge(tower, outer=(110, 160, 255), rim=(18, 20, 70), top=(26, 30, 110), bottom=(48, 100, 220),
                     light=(150, 200, 255), glyph_fill=0.86)   # tall and narrow: enlarged so the spire reaches into the top point
    made['district'] = sizes_emit(district, 'ICON_DISTRICT_TSOD_MAGE_TOWER', DISTRICT_SIZES)
    made['district_fow'] = sizes_emit(district_fow(district), 'ICON_DISTRICT_TSOD_MAGE_TOWER_FOW', DISTRICT_SIZES)

    works = fit(key_magenta(load('燃石酸化工厂.jpg')), 0.94)
    made['building'] = sizes_emit(works, 'ICON_BUILDING_TSOD_BURNSTONE_WORKS', BUILDING_SIZES)
    made['building_fow'] = sizes_emit(sepia(works), 'ICON_BUILDING_TSOD_BURNSTONE_WORKS_FOW', BUILDING_SIZES)

    book = key_black(load('去神圣化项目.jpg'))
    project = badge(book, outer=(30, 38, 50), rim=(70, 82, 98), top=(205, 214, 224), bottom=(128, 142, 160),
                    light=(240, 245, 250), glyph_fill=0.60)
    made['project'] = sizes_emit(project, 'ICON_PROJECT_TSOD_DESANCTIFICATION', PROJECT_SIZES)
    return made
