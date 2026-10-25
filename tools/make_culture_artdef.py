"""Write src/ArtDefs/Civilizations.artdef and Cultures.artdef: Typhon looks and sounds like LIKE.

    python -I -X utf8 tools/make_culture_artdef.py "<Civ6 install dir>"

Without these, the game has no city-building style, unit culture or civilization audio entry
for the civilization. The official way to give a civilization a style is to list it in each
culture it belongs to (Cultures.artdef: building styles under "Culture", unit looks under
"UnitCulture") and to give it a Civilizations.artdef entry whose Audio XrefName picks the
civilization's audio set. We copy all of that from LIKE (Germany: an imperial European look).
Our culture entries set m_AppendMergedParameterCollections=true, so the civilization is added to
the official lists instead of replacing them (the Cecil mod does the same with Scotland).
"""
import copy
import os
import sys
import xml.etree.ElementTree as ET

CIV = 'CIVILIZATION_TSOD_TYPHON_EMPIRE'
LIKE = 'CIVILIZATION_GERMANY'

game = sys.argv[1]
root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
base = os.path.join(game, 'Base', 'ArtDefs')


def name(el):
    return el.find('m_Name').get('text')


def skeleton(official):
    out = ET.Element(official.tag)
    for node in official:
        if node.tag != 'm_RootCollections':
            out.append(copy.deepcopy(node))
    return out, ET.SubElement(out, 'm_RootCollections')


def new_coll(colls, cname):
    c = ET.SubElement(colls, 'Element')
    ET.SubElement(c, 'm_CollectionName', text=cname)
    ET.SubElement(c, 'm_ReplaceMergedCollectionElements').text = 'false'
    return c


def write(tree_root, path):
    ET.indent(tree_root, space='\t')
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        f.write('<?xml version="1.0" encoding="UTF-8" ?>\n' + ET.tostring(tree_root, encoding='unicode') + '\n')


# ---- Civilizations.artdef: copy LIKE's entry (audio set) ---------------------------------
official = ET.parse(os.path.join(base, 'Civilizations.artdef')).getroot()
out, colls = skeleton(official)
for coll in official.find('m_RootCollections'):
    new = new_coll(colls, coll.find('m_CollectionName').get('text'))
    for el in coll.findall('Element'):
        if name(el) == LIKE:
            mine = copy.deepcopy(el)
            mine.find('m_Name').set('text', CIV)
            new.append(mine)
            audio = [v.get('text') for v in mine.iter('m_Value')]
write(out, os.path.join(root_dir, 'src', 'ArtDefs', 'Civilizations.artdef'))

# ---- Cultures.artdef: join every culture LIKE belongs to ---------------------------------
official = ET.parse(os.path.join(base, 'Cultures.artdef')).getroot()
out, colls = skeleton(official)
joined = {}
for coll in official.find('m_RootCollections'):
    cname = coll.find('m_CollectionName').get('text')
    new = new_coll(colls, cname)
    for el in coll.findall('Element'):
        for value in el.find('m_Fields/m_Values'):
            refs = value.find('m_Values')
            if refs is None:
                continue
            like_ref = next((r for r in refs if r.find('m_ElementName') is not None
                             and r.find('m_ElementName').get('text') == LIKE), None)
            if like_ref is None:
                continue
            mine = ET.SubElement(new, 'Element')
            fields = ET.SubElement(ET.SubElement(mine, 'm_Fields'), 'm_Values')
            holder = copy.deepcopy(value)            # the civilization list, holding only us
            for r in list(holder.find('m_Values')):
                holder.find('m_Values').remove(r)
            ref = copy.deepcopy(like_ref)
            ref.find('m_ElementName').set('text', CIV)
            ref.find('m_ParamName').set('text', 'Civilizations001')
            holder.find('m_Values').append(ref)
            fields.append(holder)
            ET.SubElement(mine, 'm_ChildCollections')
            ET.SubElement(mine, 'm_Name', text=name(el))
            ET.SubElement(mine, 'm_AppendMergedParameterCollections').text = 'true'
            joined.setdefault(cname, []).append(name(el))
write(out, os.path.join(root_dir, 'src', 'ArtDefs', 'Cultures.artdef'))
print('audio', audio, 'cultures', joined)
