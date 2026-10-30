"""Workshop cover, 1024x1024 JPEG: python -X utf8 tools/make_cover.py [--art FILE] [--crop L T R B] [--cn TEXT] [--en TEXT] [--layout square|wide|banner] [--out FILE]
Series layout (as Dream City's tools/make_cover.py): small top title, black plate with gold border and two gold title lines.
--layout wide makes a 1920x1080 (16:9) cover with the plate at the lower left.
--layout banner makes a 1920x950 cover for a Workshop collection page: Steam shows it ~2:1, top-aligned, under a title bar
over the top 15%, so the art starts at y=ART_TOP and there is no top title. The crop must match 1920:(950-ART_TOP).
Output goes to art/generated/ (not shipped in the mod; the uploader picks the preview file separately).
"""
import argparse
import math
import os

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LIBRARY = os.path.join(ROOT, '..', 'Civ6 modding', '黎明之剑-素材')
ART = os.path.join(LIBRARY, '人物', '罗塞塔·奥古斯都大帝.jpg')
CROP = (380, 441, 800, 861)               # Rosetta's head, the cup and the chest: the body fills ~64% of the width (user, 10-30)
OUT = os.path.join(ROOT, 'art', 'generated', 'TSODTyphonEmpire_cover.jpg')

SIZE = 1024
W, H = SIZE, SIZE          # canvas; main() switches it for the wide layout
TOP_CX = SIZE // 2
WIDE = dict(size=(1920, 1080), plate=(48, 720, 948, 1032), mid_cn=806, mid_en=950)
BANNER = dict(size=(1920, 950), plate=(48, 600, 948, 910), mid_cn=686, mid_en=830, art_top=130)
ART_TOP = 0            # black band above the art (banner layout)
SHOW_TOP_TITLE = True
GOLD = (228, 182, 78)

TOP_TITLE = 'The Sword of Dawn'
TOP_TITLE_FONT = r'C:\Windows\Fonts\segoeuil.ttf'
TOP_TITLE_SIZE = 32
TOP_TITLE_TRACK = 0.50
TOP_TITLE_TOP = 24

PLATE_BOX = (52, 676, 972, 984)
PLATE_FILL = (9, 9, 11)
PLATE_STROKE = 3
GLOW_SPREAD, GLOW_BLUR, GLOW_ALPHA = 5, 7, 0.50
SHADOW_ANGLE, SHADOW_DIST, SHADOW_BLUR, SHADOW_ALPHA = 30, 5, 19, 0.50

TEXT_CN = '黎明之剑：提丰帝国'
TEXT_EN = 'TSOD: Typhon Empire'
FONT_CN = r'C:\Windows\Fonts\simkai.ttf'
FONT_EN = r'C:\Windows\Fonts\Candara.ttf'
SIZE_CN, SIZE_EN = 76, 68
MID_CN, MID_EN = 762, 906
TRACK_CN, TRACK_EN = 0.06, 0.02


def background(path, crop):
    img = Image.open(path).convert('RGB').crop(crop).resize((W, H - ART_TOP), Image.LANCZOS)
    if ART_TOP:
        canvas = Image.new('RGB', (W, H), (0, 0, 0))
        canvas.paste(img, (0, ART_TOP))
        return canvas
    # Darken the top edge a little so the white top title stays readable on any art.
    shade = Image.new('L', img.size, 0)
    d = ImageDraw.Draw(shade)
    for y in range(140):
        d.line((0, y, W, y), fill=int(150 * (1 - y / 140) ** 1.5))
    return Image.composite(Image.new('RGB', img.size, (0, 0, 0)), img, shade)


def plate_mask(spread=0, offset=(0, 0)):
    m = Image.new('L', (W, H), 0)
    l, t, r, b = PLATE_BOX
    ImageDraw.Draw(m).rectangle((l - spread + offset[0], t - spread + offset[1],
                                 r + spread + offset[0], b + spread + offset[1]), fill=255)
    return m


def draw_plate(img):
    rad = math.radians(SHADOW_ANGLE)
    off = (int(round(-SHADOW_DIST * math.cos(rad))), int(round(SHADOW_DIST * math.sin(rad))))
    shadow = plate_mask(2, off).filter(ImageFilter.GaussianBlur(SHADOW_BLUR)).point(lambda v: int(v * SHADOW_ALPHA))
    img = Image.composite(Image.new('RGB', img.size, (0, 0, 0)), img, shadow)
    glow_mask = plate_mask(GLOW_SPREAD).filter(ImageFilter.GaussianBlur(GLOW_BLUR)).point(lambda v: int(v * GLOW_ALPHA))
    glow = Image.composite(Image.new('RGB', img.size, GOLD), Image.new('RGB', img.size, (0, 0, 0)), glow_mask)
    img = ImageChops.lighter(img, glow)
    ImageDraw.Draw(img).rectangle(PLATE_BOX, fill=PLATE_FILL, outline=GOLD, width=PLATE_STROKE)
    return img


def draw_tracked(d, cx, mid_y, text, font, track, fill=GOLD, stroke=1, top_y=None):
    extra = font.size * track
    widths = [d.textlength(ch, font=font) for ch in text]
    total = sum(widths) + extra * (len(text) - 1)
    ink = d.textbbox((0, 0), text, font=font)
    y = (top_y - ink[1]) if top_y is not None else (mid_y - (ink[1] + ink[3]) / 2.0)
    x = cx - total / 2.0 + extra / 2.0
    for ch, w in zip(text, widths):
        d.text((x, y), ch, font=font, fill=fill, stroke_width=stroke, stroke_fill=fill)
        x += w + extra


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--art', default=ART)
    ap.add_argument('--crop', type=int, nargs=4, default=CROP)
    ap.add_argument('--out', default=OUT)
    ap.add_argument('--cn', default=TEXT_CN)
    ap.add_argument('--en', default=TEXT_EN)
    ap.add_argument('--layout', choices=('square', 'wide', 'banner'), default='square')
    a = ap.parse_args()
    global W, H, PLATE_BOX, MID_CN, MID_EN, TOP_CX, ART_TOP, SHOW_TOP_TITLE
    if a.layout == 'wide':
        (W, H), PLATE_BOX, MID_CN, MID_EN = WIDE['size'], WIDE['plate'], WIDE['mid_cn'], WIDE['mid_en']
        TOP_CX = (PLATE_BOX[0] + PLATE_BOX[2]) // 2       # the top title sits above the plate, clear of the figures
    if a.layout == 'banner':
        (W, H), PLATE_BOX, MID_CN, MID_EN, ART_TOP = BANNER['size'], BANNER['plate'], BANNER['mid_cn'], BANNER['mid_en'], BANNER['art_top']
        SHOW_TOP_TITLE = False
    cw, ch = a.crop[2] - a.crop[0], a.crop[3] - a.crop[1]
    if abs(cw / ch - W / (H - ART_TOP)) > 0.01:
        raise SystemExit('crop %dx%d is not %d:%d; the art would be stretched' % (cw, ch, W, H - ART_TOP))
    img = draw_plate(background(a.art, tuple(a.crop)))
    d = ImageDraw.Draw(img)
    if SHOW_TOP_TITLE:
        draw_tracked(d, TOP_CX, None, TOP_TITLE, ImageFont.truetype(TOP_TITLE_FONT, TOP_TITLE_SIZE),
                     TOP_TITLE_TRACK, fill=(255, 255, 255), stroke=0, top_y=TOP_TITLE_TOP)
    cx = (PLATE_BOX[0] + PLATE_BOX[2]) // 2
    draw_tracked(d, cx, MID_CN, a.cn, ImageFont.truetype(FONT_CN, SIZE_CN), TRACK_CN)
    draw_tracked(d, cx, MID_EN, a.en, ImageFont.truetype(FONT_EN, SIZE_EN), TRACK_EN)
    os.makedirs(os.path.dirname(a.out), exist_ok=True)
    img.save(a.out, 'JPEG', quality=92, subsampling=0)
    print('wrote %s (%d KB)' % (a.out, os.path.getsize(a.out) // 1024))


if __name__ == '__main__':
    main()
