"""War God Faith art (WP14): python -X utf8 tools/make_religion_art.py [--src IMG] [--line IMG] [--icons] [--preview DIR]
Lens textures always; --icons also makes the icon set and moment stamp and switches their registration (docs/ids.md §10).
"""
import argparse
import os
import random

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageOps

from make_art import GEN_DIR, ICON_SRC, ROOT, TEX, TEX_DIR, write_dds, write_packages

SRC = '战神教标志.png'
MOMENT_SRC = '战神教历史时刻.png'
LINE_SRC = '战神教标志-线稿.png'      # optional; without it the outline is traced from SRC
OVERLAY = 'RELIGION_OVERLAY_TSOD_WAR_GOD'
PRESSURE = 'RELIGION_PRESSURE_TSOD_WAR_GOD'
SPRITE = 'RELIGION_PRESSURE_ICON_TSOD_WAR_GOD'
ICON = 'ICON_RELIGION_TSOD_WAR_GOD'
ATLAS = 'ICON_ATLAS_TSOD_TYPHON_RELIGION'
MOMENT = 'MOMENT_RELIGION_TSOD_WAR_GOD'
INTERIM_MOMENT = 'PM_FoundedReligion_Custom4'
# Official religion atlases: 22 and 50 are solid; 100 (the religion picker) and 270 are thin line art with a sparkle.
FILLED_SIZES = [22, 50]
LINE_SIZES = [100, 270]
BROWN = (64, 48, 23)
M = 1024
# Official line icons (e.g. Religion_Custom4.dds): line gray ~164, bright 255 nodes on the line, a four-point sparkle top right.
LINE_GRAY = 164
LINE_WIDTH = 8           # traced outline width on the 1024 master (~2 px at 270, ~1 px at 100), as thin as the lion
NODE_R, SPARKLE_L = 8, 50


def mask_of(path):
    im = Image.open(path)
    im.load()
    im = im.convert('RGBA')
    a = im.getchannel('A')
    if a.getextrema()[0] < 250:
        return a
    return ImageOps.invert(im.convert('L')).point(lambda v: 0 if v < 40 else min(255, (v - 40) * 255 // 175))


def master(mask):
    m = mask.crop(mask.getbbox())
    m.thumbnail((900, 900), Image.LANCZOS)
    out = Image.new('L', (M, M), 0)
    out.paste(m, ((M - m.width) // 2, (M - m.height) // 2))
    return out


def contour(mask, width=15):
    return ImageChops.subtract(mask, mask.filter(ImageFilter.MinFilter(width * 2 + 1)))


def paint(mask, color, box, w, h=None, center=None):
    h = h or w
    m = mask.crop(mask.getbbox())
    m.thumbnail((box, box), Image.LANCZOS)
    layer = Image.new('RGBA', m.size, color + (255,))
    layer.putalpha(m)
    cx, cy = center or (w // 2, h // 2)
    out = Image.new('RGBA', (w, h), color + (0,))
    out.alpha_composite(layer, (cx - m.width // 2, cy - m.height // 2))
    return out


def extremes(mask):
    """Line pixels furthest out in 8 directions, NE first (where the sparkle goes)."""
    px = mask.load()
    pts = [(x, y) for y in range(0, M, 3) for x in range(0, M, 3) if px[x, y] > 128]
    dirs = [(1, -1), (0, -1), (1, 0), (1, 1), (0, 1), (-1, 1), (-1, 0), (-1, -1)]
    out = []
    for dx, dy in dirs:
        p = max(pts, key=lambda q: q[0] * dx + q[1] * dy)
        if all((p[0] - o[0]) ** 2 + (p[1] - o[1]) ** 2 > 120 ** 2 for o in out):
            out.append(p)
    return out


def constellation(line):
    """Line art in the official religion style: gray line, bright nodes, a sparkle; RGBA on the 1024 master."""
    out = Image.new('RGBA', (M, M), (255, 255, 255, 0))
    out.paste(Image.new('RGBA', (M, M), (LINE_GRAY,) * 3 + (255,)), mask=line)
    lights = Image.new('L', (M, M), 0)
    d = ImageDraw.Draw(lights)
    pts = extremes(line)
    (sx, sy), nodes = pts[0], pts[1:]
    for x, y in nodes:
        d.ellipse((x - NODE_R, y - NODE_R, x + NODE_R, y + NODE_R), fill=255)
    w = SPARKLE_L * 0.16
    d.polygon([(sx, sy - SPARKLE_L), (sx + w, sy - w), (sx + SPARKLE_L, sy), (sx + w, sy + w),
               (sx, sy + SPARKLE_L), (sx - w, sy + w), (sx - SPARKLE_L, sy), (sx - w, sy - w)], fill=255)
    d.ellipse((sx - NODE_R * 1.4, sy - NODE_R * 1.4, sx + NODE_R * 1.4, sy + NODE_R * 1.4), fill=255)
    lights = ImageChops.lighter(lights, lights.filter(ImageFilter.GaussianBlur(6)).point(lambda v: min(255, v * 2)))
    out.alpha_composite(Image.merge('RGBA', [Image.new('L', (M, M), 255)] * 3 + [lights]))
    return out


def place(rgba, box, w):
    """Fit an RGBA master into a w x w canvas (premultiplied, so edges stay clean)."""
    m = rgba.crop(rgba.getchannel('A').getbbox()).convert('RGBa')
    m.thumbnail((box, box), Image.LANCZOS)
    m = m.convert('RGBA')
    out = Image.new('RGBA', (w, w), (255, 255, 255, 0))
    out.alpha_composite(m, ((w - m.width) // 2, (w - m.height) // 2))
    return out


def halo(canvas, radius, blur, peak):
    disc = Image.new('L', (canvas, canvas), 0)
    c = canvas // 2
    ImageDraw.Draw(disc).ellipse((c - radius, c - radius, c + radius, c + radius), fill=peak)
    out = Image.new('RGBA', (canvas, canvas), (0, 0, 0, 0))
    out.putalpha(disc.filter(ImageFilter.GaussianBlur(blur)))
    return out


def emit(img, name, cls, tags, mips):
    img.save(os.path.join(GEN_DIR, name + '.png'))
    levels = write_dds(img, os.path.join(TEX_DIR, name + '.dds'), mips=mips)
    with open(os.path.join(TEX_DIR, name + '.tex'), 'w', encoding='utf-8', newline='\n') as f:
        f.write(TEX.format(usemips='true' if mips else 'false', nummips=levels - 1, h=img.height, w=img.width,
                           name=name, cls=cls, tags='\n'.join('\t\t<Element text="%s"/>' % t for t in tags)))
    return img


def lens(filled, star):
    overlay = halo(512, 200, 45, 110)
    overlay.alpha_composite(place(star, 300, 512))
    pip = paint(filled, (255, 255, 255), 50, 128)
    return [emit(overlay, OVERLAY, 'Generic_BaseColor', ['Generic_BaseColor'], True),
            emit(pip, PRESSURE, 'Generic_BaseColor', ['Generic_BaseColor'], True),
            emit(pip.copy(), SPRITE, 'StrategicView_Sprite', ['StrategicView_Sprite', 'StrategicView', 'Sprite'], True)]


def stamp(mask, figure=False):
    # A full figure (the moment art) needs most of the seal to stay legible (99 px, user's choice 10-28); a symbol keeps the official margin.
    rnd = random.Random(14)
    grain = Image.new('L', (166, 122))
    grain.putdata([rnd.randint(150, 255) for _ in range(166 * 122)])
    out = paint(mask, BROWN, 99 if figure else 80, 166, 122, center=(86, 61) if figure else (86, 55))
    out.putalpha(ImageChops.multiply(out.getchannel('A'), grain.filter(ImageFilter.GaussianBlur(0.8))))
    return out


def icons(filled, star, moment_mask, figure):
    made = [emit(paint(filled, (255, 255, 255), round(s * 0.88), s), '%s_%d' % (ICON, s), 'UserInterface',
                 ['UserInterface'], False) for s in FILLED_SIZES]
    made += [emit(place(star, round(s * 0.82), s), '%s_%d' % (ICON, s), 'UserInterface',
                  ['UserInterface'], False) for s in LINE_SIZES]
    made.append(emit(stamp(moment_mask, figure), MOMENT, 'UserInterface', ['UserInterface'], False))
    rows = ',\n'.join("    ('%s', %d, 1, 1, '%s_%d')" % (ATLAS, s, ICON, s) for s in FILLED_SIZES + LINE_SIZES)
    with open(os.path.join(ROOT, 'src', 'Icons', 'TsoDTE_Icons_Religion.sql'), 'w', encoding='utf-8', newline='\n') as f:
        f.write('-- War God Faith icons (InGame UpdateIcons), written by tools/make_religion_art.py --icons.\n'
                '-- The UI looks up "ICON_" .. ReligionType; sizes follow the official religion atlases 22 / 50 / 100 / 270.\n'
                'INSERT INTO IconTextureAtlases (Name, IconSize, IconsPerRow, IconsPerColumn, Filename) VALUES\n'
                '%s;\n\nINSERT INTO IconDefinitions (Name, Atlas, "Index") VALUES\n    (\'%s\', \'%s\', 0);\n'
                % (rows, ICON, ATLAS))
    religion = os.path.join(ROOT, 'src', 'Core', 'TsoDTE_Religion_WarGod.sql')
    text = open(religion, encoding='utf-8').read()
    if INTERIM_MOMENT in text:
        text = text.replace("-- Temporarily borrows the illustration of official custom religion 4 (the lion), matching the temporary icon.\n", '')
        with open(religion, 'w', encoding='utf-8', newline='\n') as f:
            f.write(text.replace("'%s'" % INTERIM_MOMENT, "'%s'" % MOMENT))
    return made


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--src', default=os.path.join(ICON_SRC, SRC))
    ap.add_argument('--line', default=os.path.join(ICON_SRC, LINE_SRC))
    ap.add_argument('--moment', default=os.path.join(ICON_SRC, MOMENT_SRC))
    ap.add_argument('--icons', action='store_true')
    ap.add_argument('--preview')
    a = ap.parse_args()
    os.makedirs(GEN_DIR, exist_ok=True)
    filled = master(mask_of(a.src))
    line = master(mask_of(a.line)) if os.path.exists(a.line) else contour(filled, LINE_WIDTH)
    star = constellation(line)
    made = lens(filled, star)
    if a.icons:
        figure = os.path.exists(a.moment)
        moment_mask = master(mask_of(a.moment)) if figure else filled
        made += icons(filled, star, moment_mask, figure)
        print('packages (ui, fallback):', write_packages())
    if a.preview:
        os.makedirs(a.preview, exist_ok=True)
        sheet = Image.new('RGBA', (sum(im.width + 10 for im in made), 512), (60, 90, 60, 255))
        x = 0
        for im in made:
            sheet.alpha_composite(im, (x, 0))
            x += im.width + 10
        sheet.save(os.path.join(a.preview, 'religion_art.png'))
    print('wrote', len(made), 'textures to', TEX_DIR)


if __name__ == '__main__':
    main()
