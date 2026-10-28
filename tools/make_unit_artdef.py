"""Write src/ArtDefs/Units.artdef for the battle mage from official unit art entries: python -X utf8 tools/make_unit_artdef.py "<Civ6 install dir>"
Unit entry: copy of UNIT_SLINGER (4-member squad, ranged combat, sounds). Member TSOD_BattleMage: copy of the Inquisitor (robe and staff, civ-coloured)
keeping its Movement=Slinger / Combat=SlingerCombat ranged animations (the Secret Societies Cultist had only melee ones).
"""
import copy
import os
import sys
import xml.etree.ElementTree as ET

SOURCE_UNIT = 'UNIT_SLINGER'
SOURCE_MEMBER = 'Slinger'
TARGET_UNIT = 'UNIT_TSOD_BATTLE_MAGE'
BASE_MEMBER = 'Inquisitor'
MEMBER = 'TSOD_BattleMage'
CIV_TINT = 'USE_CIV_COLOR'

game = sys.argv[1]
root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
official = ET.parse(os.path.join(game, 'Base', 'ArtDefs', 'Units.artdef')).getroot()


def find(coll, name):
    return next(e for e in coll.findall('Element') if e.find('m_Name').get('text') == name)


out = ET.Element(official.tag)
for child in official:
    if child.tag != 'm_RootCollections':
        out.append(copy.deepcopy(child))
colls = ET.SubElement(out, 'm_RootCollections')
report = {}
for coll in official.find('m_RootCollections'):
    name = coll.find('m_CollectionName').get('text')
    new = ET.SubElement(colls, 'Element')
    ET.SubElement(new, 'm_CollectionName', text=name)
    ET.SubElement(new, 'm_ReplaceMergedCollectionElements').text = 'false'
    if name == 'Units':
        el = copy.deepcopy(find(coll, SOURCE_UNIT))
        el.find('m_Name').set('text', TARGET_UNIT)
        swapped = 0
        for ch in el.find('m_ChildCollections'):
            if ch.find('m_CollectionName').get('text') == 'Members':
                for ref in ch.iter('m_ElementName'):
                    if ref.get('text') == SOURCE_MEMBER:
                        ref.set('text', MEMBER)
                        swapped += 1
        assert swapped, 'member not found in ' + SOURCE_UNIT
        report['members swapped'] = swapped
        new.append(el)
    elif name == 'UnitMemberTypes':
        el = copy.deepcopy(find(coll, BASE_MEMBER))
        el.find('m_Name').set('text', MEMBER)
        tinted = 0
        for ref in el.iter('m_ElementName'):
            if ref.get('text') == BASE_MEMBER:          # the Inquisitor's own tint on robe and hood
                ref.set('text', CIV_TINT)
                tinted += 1
        report['tints switched to civ colours'] = tinted
        new.append(el)

ET.indent(out, space='\t')
path = os.path.join(root_dir, 'src', 'ArtDefs', 'Units.artdef')
ET.ElementTree(out).write(path, encoding='UTF-8', xml_declaration=True)
print('wrote', path, report)
