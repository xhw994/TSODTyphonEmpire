"""Workshop cover, 1024x1024 JPEG: python -X utf8 tools/make_cover.py [--art FILE] [--crop L T R B]
Series layout (as Dream City's tools/make_cover.py): small top title, black plate with gold border and two gold title lines.
Output goes to art/generated/ (not shipped in the mod; the uploader picks the preview file separately).
"""
import argparse
import math
import os

from PIL import Image, ImageChops, ImageDraw, ImageFilter, ImageFont

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LIBRARY = os.path.join(ROOT, '..', 'Civ6 modding', '黎明之剑-素材')
ART = os.path.join(LIBRARY, '人物', '罗塞塔·奥古斯都大帝.jpg')
CROP = (0, 150, 1236, 1386)               # square around Rosetta's head and the emblem banners
OUT = os.path.join(ROOT, 'art', 'generated', 'TSODTyphonEmpire_cover.jpg')

SIZE = 1024
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
    img = Image.open(path).convert('RGB').crop(crop).resize((SIZE, SIZE), Image.LANCZOS)
    # Darken the top edge a little so the white top title stays readable on any art.
    shade = Image.new('L', (SIZE, SIZE), 0)
    d = ImageDraw.Draw(shade)
    for y in range(140):
        d.line((0, y, SIZE, y), fill=int(150 * (1 - y / 140) ** 1.5))
    return Image.composite(Image.new('RGB', img.size, (0, 0, 0)), img, shade)


def plate_mask(spread=0, offset=(0, 0)):
    m = Image.new('L', (SIZE, SIZE), 0)
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
    a = ap.parse_args()
    img = draw_plate(background(a.art, tuple(a.crop)))
    d = ImageDraw.Draw(img)
    draw_tracked(d, SIZE // 2, None, TOP_TITLE, ImageFont.truetype(TOP_TITLE_FONT, TOP_TITLE_SIZE),
                 TOP_TITLE_TRACK, fill=(255, 255, 255), stroke=0, top_y=TOP_TITLE_TOP)
    cx = (PLATE_BOX[0] + PLATE_BOX[2]) // 2
    draw_tracked(d, cx, MID_CN, TEXT_CN, ImageFont.truetype(FONT_CN, SIZE_CN), TRACK_CN)
    draw_tracked(d, cx, MID_EN, TEXT_EN, ImageFont.truetype(FONT_EN, SIZE_EN), TRACK_EN)
    os.makedirs(os.path.dirname(a.out), exist_ok=True)
    img.save(a.out, 'JPEG', quality=92, subsampling=0)
    print('wrote %s (%d KB)' % (a.out, os.path.getsize(a.out) // 1024))


if __name__ == '__main__':
    main()
