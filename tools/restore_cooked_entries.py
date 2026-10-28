# -*- coding: utf-8 -*-
"""Post-build patch: restores BLP entry names the cooker cannot resolve back to the values in the source artdef.

Background
----
Civ6's AssetCooker looks up assets only in projects that declare them in requiredGameArtIDs and whose SDK Assets have a **pantry directory** present.
The SDK Assets ship only five pantry directories (Civ6 / Expansion1 /
Expansion2 / Shared / CivRoyaleScenario); the other DLCs (Ethiopia etc.)
have none at all.

So when assets from those DLCs are referenced, the cooker reports no error and does not stop; it only quietly replaces `m_EntryName`
with a placeholder such as `TB_ERROR`. In-game, the symptom is that the model does not show.

At runtime, however, this limit does not apply: as long as the player has the matching DLC, the game loads its BLP package as usual
(visible in Logs/ArtDef.log as `Loading Package: .../DLC/Ethiopia/.../tilebases.blp`).
So restoring the entry name is enough; the cooker did not change any other field.

Usage
----
    python tools/restore_cooked_entries.py <source ArtDefs dir> <deployed mod dir>

Normally it does not need to be run by hand: the .civ6proj has an AfterTargets="Build" target
that calls this script automatically after every build. Both command-line builds and ModBuddy GUI builds trigger it.
The entry point is kept for running it separately, e.g. after manually editing the deployed output.
"""
import sys, io, os, re
import xml.etree.ElementTree as ET

PLACEHOLDER = re.compile(r"^(TB|BLP|ASSET)_ERROR$")


def asset_entries(path):
    """{element name: entry name of that element's Asset parameter}"""
    out = {}
    root = ET.parse(path).getroot()
    for el in root.iter("Element"):
        name = el.find("m_Name")
        fields = el.find("m_Fields")
        if name is None or fields is None:
            continue
        values = fields.find("m_Values")
        if values is None:
            continue
        for v in values:
            entry = v.find("m_EntryName")
            param = v.find("m_ParamName")
            if entry is not None and param is not None and param.get("text") == "Asset":
                out[name.get("text")] = entry.get("text")
    return out


ELEMENT_REF = re.compile(r'<m_ElementName text="([^"]*)"\s*/>')


def restore_element_refs(src_text, text):
    """The cooker clears references to ArtDef elements it cannot find (e.g. DLC unit member Cultist) to empty strings.
    The source file and the deployed output have matching structure, so they are compared in order of appearance: where the deployed value is empty and the source's is not, the source value is filled back in.
    If the reference counts differ between the two, nothing is changed, to avoid misalignment. Returns (new text, number restored)."""
    src_refs = [m.group(1) for m in ELEMENT_REF.finditer(src_text)]
    matches = list(ELEMENT_REF.finditer(text))
    if len(src_refs) != len(matches):
        print(f"    [跳过] 元素引用个数不一致（源 {len(src_refs)}，部署 {len(matches)}），不还原")
        return text, 0
    out, last, fixed = [], 0, 0
    for want, m in zip(src_refs, matches):
        if m.group(1) == '' and want != '':
            out.append(text[last:m.start()])
            out.append(f'<m_ElementName text="{want}"/>')
            last = m.end()
            print(f"    [还原] 元素引用: '' -> {want}")
            fixed += 1
    out.append(text[last:])
    return ''.join(out), fixed


def restore(src_artdef, cooked_artdef):
    src = asset_entries(src_artdef)
    broken = [(n, e) for n, e in asset_entries(cooked_artdef).items() if PLACEHOLDER.match(e)]
    text = io.open(cooked_artdef, encoding="utf-8").read()
    text, fixed = restore_element_refs(io.open(src_artdef, encoding="utf-8").read(), text)
    for name, placeholder in broken:
        want = src.get(name)
        if not want or PLACEHOLDER.match(want):
            print(f"    [跳过] {name}: 源文件里也没有可用的 entry")
            continue
        # Look for the placeholder within the element's own scope: an artdef element's m_Name comes after its fields,
        # so search backward from the element's m_Name for the nearest placeholder, without crossing another element's m_Name.
        # This way each occurrence of a placeholder can be restored one by one (each element has only one Asset parameter).
        m = re.search(r'<m_Name text="%s"\s*/>' % re.escape(name), text)
        if not m:
            print(f"    [跳过] {name}: 部署产物里找不到这个元素")
            continue
        needle = f'<m_EntryName text="{placeholder}"/>'
        j = text.rfind(needle, 0, m.start())
        if j < 0 or text.rfind('<m_Name text=', 0, m.start()) > j:
            print(f"    [跳过] {name}: 占位符不在这个元素里")
            continue
        text = text[:j] + f'<m_EntryName text="{want}"/>' + text[j + len(needle):]
        print(f"    [还原] {name}: {placeholder} -> {want}")
        fixed += 1
    if fixed:
        io.open(cooked_artdef, "w", encoding="utf-8", newline="").write(text)
    return fixed


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        return 1
    src_dir, mod_dir = sys.argv[1], sys.argv[2]
    cooked_dir = None
    for cand in ("ArtDefs", "Artdefs"):
        p = os.path.join(mod_dir, cand)
        if os.path.isdir(p):
            cooked_dir = p
            break
    if cooked_dir is None:
        print(f"找不到已部署的 ArtDefs 目录：{mod_dir}")
        return 1

    total = 0
    for fn in sorted(os.listdir(cooked_dir)):
        if not fn.lower().endswith(".artdef"):
            continue
        src = os.path.join(src_dir, fn)
        if not os.path.isfile(src):
            continue
        print(f"  {fn}")
        total += restore(src, os.path.join(cooked_dir, fn))
    print(f"共还原 {total} 处。" if total else "没有需要还原的 entry。")
    return 0


if __name__ == "__main__":
    sys.exit(main())
