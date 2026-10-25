# -*- coding: utf-8 -*-
"""构建后修补：把 cooker 解析不了的 BLP entry 名还原回源 artdef 里的值。

背景
----
Civ6 的 AssetCooker 只在 `requiredGameArtIDs` 声明过、且 SDK Assets 里**存在
pantry 目录**的 project 里查找资产。SDK Assets 只带了 Civ6 / Expansion1 /
Expansion2 / Shared / CivRoyaleScenario 五份 pantry，其余 DLC（Ethiopia 等）
一份都没有。

于是引用这些 DLC 的资产时，cooker 既不报错也不中断，只是把 `m_EntryName`
悄悄换成 `TB_ERROR` 之类的占位符 —— 游戏里的表现就是「那个模型不显示」。

但运行时不受这个限制：只要玩家装了对应 DLC，游戏会照常加载它的 BLP 包
（可在 Logs/ArtDef.log 里看到 `Loading Package: .../DLC/Ethiopia/.../tilebases.blp`）。
所以把 entry 名还原回去即可，其余字段 cooker 并没有改动。

用法
----
    python tools/restore_cooked_entries.py <源 ArtDefs 目录> <已部署的 mod 目录>

平时不用手动跑：.civ6proj 里挂了一个 AfterTargets="Build" 的 target，
每次构建完会自动调用本脚本。命令行和 ModBuddy 图形界面构建都会触发。
留着这个入口是为了单独补跑，比如手工改过部署产物之后。
"""
import sys, io, os, re
import xml.etree.ElementTree as ET

PLACEHOLDER = re.compile(r"^(TB|BLP|ASSET)_ERROR$")


def asset_entries(path):
    """{元素名: 该元素 Asset 参数的 entry 名}"""
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
    """cooker 把找不到的 ArtDef 元素引用（比如 DLC 单位成员 Cultist）清成空串。
    源文件和部署产物的结构一一对应，按出现顺序比对：部署里是空、源里不是空的，填回去。
    两边引用个数不一致时不动，避免错位。返回 (新文本, 还原数)。"""
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
        # 在该元素自己的范围里找占位符：artdef 里元素的 m_Name 写在它的字段之后，
        # 所以从该元素的 m_Name 往前找最近的占位符，且中间不能隔着别的元素的 m_Name。
        # 这样同一个占位符出现多少次都能逐个还原（每个元素只有一个 Asset 参数）。
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
