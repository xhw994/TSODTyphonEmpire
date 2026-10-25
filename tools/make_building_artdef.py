"""Give the burnstone works (replaces the Factory) a model in the industrial zone.

    python -I -X utf8 tools/make_building_artdef.py "<Civ6 install dir>"

Writes src/ArtDefs/Buildings.artdef and adds a DISTRICT_INDUSTRIAL_ZONE element to
src/ArtDefs/Landmarks.artdef. It follows the official Electronics Factory, Japan's Factory
replacement, in Base:
  - Buildings.artdef: a [Building] element (copy of BUILDING_FACTORY: strategic-view sprites)
    and a "Buildings (Level 2)" entry in the ProductionBuildings chain.
  - Landmarks.artdef, industrial zone: the district ground for each building set
    (BaseVariants), the building model itself (BuildingVariants), and the building sets
    that name it (BuildingSets). Without these the district has no model for the building.
The model is the standard Factory (DIS_PRD_Factory). The industrial zone's other children are
official and stay as they are: artdef collections merge by element name.
Run it again after changing the constants; it replaces its own entries.
"""
import copy
import os
import sys
import xml.etree.ElementTree as ET

BUILDING = 'BUILDING_TSOD_BURNSTONE_WORKS'
SHORT = 'TSOD_BURNSTONE_WORKS'                # how building-set names spell a building
MODEL_FROM = '03Industrial Age Factory'       # official BuildingVariant whose model we use
LIKE = 'ELECTRONICS_FACTORY'                  # official Factory replacement we copy the sets from
DISTRICT = 'DISTRICT_INDUSTRIAL_ZONE'
CHAIN, CHAIN_LEVEL, CHAIN_FROM = 'ProductionBuildings', 'Buildings (Level 2)', '2ElectronicsFactory'

game = sys.argv[1]
root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
base = os.path.join(game, 'Base', 'ArtDefs')


def name(el):
    n = el.find('m_Name')
    return n.get('text') if n is not None else None


def child(el, coll):
    return next(c for c in el.find('m_ChildCollections') if c.find('m_CollectionName').get('text') == coll)


def root_coll(tree_root, coll):
    return next(c for c in tree_root.find('m_RootCollections') if c.find('m_CollectionName').get('text') == coll)


def find(coll, wanted):
    return next(e for e in coll.findall('Element') if name(e) == wanted)


def swap_text(el, old, new):
    """Replace old with new in every text attribute under el (names and references)."""
    hits = 0
    for node in el.iter():
        t = node.get('text')
        if t and old in t:
            node.set('text', t.replace(old, new))
            hits += 1
    return hits


def write(tree_root, path):
    ET.indent(tree_root, space='\t')
    body = ET.tostring(tree_root, encoding='unicode')
    with open(path, 'w', encoding='utf-8', newline='\n') as f:
        f.write('<?xml version="1.0" encoding="UTF-8" ?>\n' + body + '\n')


report = {}

# ---- Buildings.artdef --------------------------------------------------------------------
official = ET.parse(os.path.join(base, 'Buildings.artdef')).getroot()
out = ET.Element(official.tag)
for node in official:
    if node.tag != 'm_RootCollections':
        out.append(copy.deepcopy(node))
colls = ET.SubElement(out, 'm_RootCollections')
for coll in official.find('m_RootCollections'):
    cname = coll.find('m_CollectionName').get('text')
    new = ET.SubElement(colls, 'Element')
    ET.SubElement(new, 'm_CollectionName', text=cname)
    ET.SubElement(new, 'm_ReplaceMergedCollectionElements').text = 'false'
    if cname == 'Building':
        el = copy.deepcopy(find(coll, 'BUILDING_FACTORY'))
        el.find('m_Name').set('text', BUILDING)
        new.append(el)
    elif cname == 'BuildingChains':
        el = copy.deepcopy(find(coll, CHAIN))
        for ch in el.find('m_ChildCollections'):
            keep = None
            if ch.find('m_CollectionName').get('text') == CHAIN_LEVEL:
                keep = copy.deepcopy(find(ch, CHAIN_FROM))
            for e in ch.findall('Element'):
                ch.remove(e)
            if keep is not None:
                swap_text(keep, 'BUILDING_' + LIKE, BUILDING)
                keep.find('m_Name').set('text', '3TsodBurnstoneWorks')
                ch.append(keep)
        new.append(el)
write(out, os.path.join(root_dir, 'src', 'ArtDefs', 'Buildings.artdef'))

# ---- Landmarks.artdef: the industrial zone -----------------------------------------------
official_zone = find(root_coll(ET.parse(os.path.join(base, 'Landmarks.artdef')).getroot(), 'Districts'), DISTRICT)
zone = copy.deepcopy(official_zone)
for ch in zone.find('m_ChildCollections'):
    cname = ch.find('m_CollectionName').get('text')
    originals = ch.findall('Element')
    for e in originals:
        ch.remove(e)
    if cname == 'BuildingVariants':
        el = copy.deepcopy(next(e for e in originals if name(e) == MODEL_FROM))
        swap_text(el, 'BUILDING_FACTORY', BUILDING)
        el.find('m_Name').set('text', '03Industrial Age TsodBurnstoneWorks')
        ch.append(el)
        report[cname] = 1
    elif cname in ('BaseVariants', 'BuildingSets'):
        made = 0
        for e in originals:
            if not any(LIKE in (n.get('text') or '') for n in e.iter()):
                continue
            el = copy.deepcopy(e)
            swap_text(el, LIKE, SHORT)    # BaseVariants find a set by its name: "WORKSHOP, TSOD_BURNSTONE_WORKS"
            if cname == 'BaseVariants':   # official names here are free text; keep ours apart
                el.find('m_Name').set('text', 'Tsod ' + name(e).replace('Factory', 'BurnstoneWorks').rstrip('0123456789'))
            ch.append(el)
            made += 1
        report[cname] = made

path = os.path.join(root_dir, 'src', 'ArtDefs', 'Landmarks.artdef')
landmarks = ET.parse(path).getroot()
districts = root_coll(landmarks, 'Districts')
for e in districts.findall('Element'):
    if name(e) == DISTRICT:                       # our own entry from an earlier run
        districts.remove(e)
districts.append(zone)
write(landmarks, path)
print('wrote Buildings.artdef and', DISTRICT, 'in Landmarks.artdef', report)
