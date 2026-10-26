"""Loyalty lens textures from the emblem: python -X utf8 tools/make_loyalty_overlay.py
Overlay (512, white emblem on a soft dark halo) and pressure arrow pip (128, plain white emblem).
"""
import os

from PIL import Image, ImageDraw, ImageFilter

from make_art import GEN_DIR, TEX, TEX_DIR, emblem_mono, write_dds

OVERLAY = 'LOYALTY_OVERLAY_TSOD_TYPHON_EMPIRE'
PRESSURE = 'LOYALTY_PRESSURE_TSOD_TYPHON_EMPIRE'


def fitted(emblem, box, canvas):
    e = emblem.copy()
    e.thumbnail((box, box), Image.LANCZOS)
    out = Image.new('RGBA', (canvas, canvas), (255, 255, 255, 0))
    out.alpha_composite(e, ((canvas - e.width) // 2, (canvas - e.height) // 2))
    return out


def halo(canvas, radius, blur, peak):
    mask = Image.new('L', (canvas, canvas), 0)
    c = canvas // 2
    ImageDraw.Draw(mask).ellipse((c - radius, c - radius, c + radius, c + radius), fill=peak)
    out = Image.new('RGBA', (canvas, canvas), (0, 0, 0, 0))
    out.putalpha(mask.filter(ImageFilter.GaussianBlur(blur)))
    return out


def emit(img, name):
    img.save(os.path.join(GEN_DIR, name + '.png'))
    levels = write_dds(img, os.path.join(TEX_DIR, name + '.dds'), mips=True)
    with open(os.path.join(TEX_DIR, name + '.tex'), 'w', encoding='utf-8', newline='\n') as f:
        f.write(TEX.format(usemips='true', nummips=levels - 1, h=img.height, w=img.width, name=name,
                           cls='Generic_BaseColor', tags='\t\t<Element text="Generic_BaseColor"/>'))


def main():
    os.makedirs(GEN_DIR, exist_ok=True)
    emblem = emblem_mono()
    emblem = emblem.crop(emblem.getchannel('A').getbbox())
    overlay = halo(512, 150, 60, 215)
    overlay.alpha_composite(fitted(emblem, 250, 512))
    emit(overlay, OVERLAY)
    emit(fitted(emblem, 76, 128), PRESSURE)
    print('wrote', OVERLAY, PRESSURE, 'to', TEX_DIR)


if __name__ == '__main__':
    main()
