"""Write src/ArtDefs/Units.artdef for the battle mage from an official unit's art entry.

    python -X utf8 tools/make_unit_artdef.py "<Civ6 install dir>"

The entry is a copy of UNIT_CROSSBOWMAN (formation, ranged combat style, embark unit, audio) with
the visible member swapped for the Secret Societies Cultist (DLC/Ethiopia, already a dependency).
Change SOURCE_UNIT / MEMBER below to try another model; the user picked the Cultist look, and the
fallback if its attacks look wrong is Apostle or Inquisitor (base game).
"""
import copy
import os
import sys
import xml.etree.ElementTree as ET

SOURCE_UNIT = 'UNIT_CROSSBOWMAN'
SOURCE_MEMBER = 'Crossbowman'
MEMBER = 'Cultist'
TARGET_UNIT = 'UNIT_TSOD_BATTLE_MAGE'

game = sys.argv[1]
root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
official = ET.parse(os.path.join(game, 'Base', 'ArtDefs', 'Units.artdef')).getroot()

out = ET.Element(official.tag)
for child in official:
    if child.tag != 'm_RootCollections':
        out.append(copy.deepcopy(child))
colls = ET.SubElement(out, 'm_RootCollections')
for coll in official.find('m_RootCollections'):
    name = coll.find('m_CollectionName').get('text')
    new = ET.SubElement(colls, 'Element')
    ET.SubElement(new, 'm_CollectionName', text=name)
    ET.SubElement(new, 'm_ReplaceMergedCollectionElements').text = 'false'
    if name != 'Units':
        continue
    src = next(e for e in coll.findall('Element') if e.find('m_Name').get('text') == SOURCE_UNIT)
    el = copy.deepcopy(src)
    el.find('m_Name').set('text', TARGET_UNIT)
    swapped = 0
    for ch in el.find('m_ChildCollections'):
        if ch.find('m_CollectionName').get('text') != 'Members':
            continue
        for ref in ch.iter('m_ElementName'):
            if ref.get('text') == SOURCE_MEMBER:
                ref.set('text', MEMBER)
                swapped += 1
    assert swapped, 'member not found'
    new.append(el)

ET.indent(out, space='\t')
path = os.path.join(root_dir, 'src', 'ArtDefs', 'Units.artdef')
ET.ElementTree(out).write(path, encoding='UTF-8', xml_declaration=True)
print('wrote', path, 'members swapped:', swapped)
