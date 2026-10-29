# Typhon Empire — Civilization VI Mod

> A fan-made Civilization VI mod introducing the **Typhon Empire** from the Chinese web novel *Sword of Dawn (黎明之剑)*.

<!-- Badges -->
[![Steam Workshop](https://img.shields.io/badge/Steam-Workshop-blue?logo=steam)](https://steamcommunity.com/sharedfiles/filedetails/?id=3829307748)
![Civ VI](https://img.shields.io/badge/Civilization_VI-Gathering_Storm-green)
![Lua](https://img.shields.io/badge/language-Lua-blue)

---

## Overview

This mod adds the **Typhon Empire** civilization to Civilization VI, led by Emperor **Rosetta Augustus**. Inspired by the web novel *Sword of Dawn*, it is a conquest civilization whose Campuses and Holy Sites both serve the army: Mage Towers and Encampments are planned in pairs, Battle Mages grow stronger without being upgraded, and the late game turns Faith into Science and Diplomatic Favor. It suits players who like a strong land army with a technology engine behind it.

It is a companion to the **Cecil Empire** mod, the old rival from the same novel.

---

## Civilization Features

### Civilization Ability: *Empire of the Extraordinary*

- Land military units trained in a city with a **Campus** (or Mage Tower) start with a **free promotion**.
- **Campus** and **Holy Site** districts provide **+1 Great General point** per turn.
- Cities with an **Encampment** ignore pressure from Religions founded by other civilizations.

---

### Unique Unit: Battle Mage

| Attribute | Value |
|---|---|
| Replaces | Crossbowman |
| Unlock | Machinery |
| Cost | 180 |
| Upgrades | Never; it grows stronger by itself |
| After Ballistics | +20 melee Combat Strength, +20 Ranged Strength when attacking |
| After Advanced Ballistics | another +20 melee, another +25 Ranged Strength when attacking |
| Adjacent to another Battle Mage | +5 Ranged Strength (does not stack) |
| Corps and armies | Heal 10 health at the start of every turn (*Battlefield Regeneration*) |
| Army only | Can cast **Annihilation Scar** once; the whole army dies after casting |

The Battle Mage keeps every promotion it earns, so a veteran never has to be replaced.

---

### Unique District: Mage Tower

| Attribute | Value |
|---|---|
| Replaces | Campus |
| Cost | Cheaper than the Campus |
| Adjacency | All Campus bonuses, plus **+2 Science** for each adjacent Encampment |
| Defense | Defensible, and can make ranged attacks |
| Counter-espionage | Enemy Spies operate at 1 level below normal in this city |

Place it next to an Encampment from the start.

---

### Unique Building: Burnstone Acidification Works

| Attribute | Value |
|---|---|
| Replaces | Factory |
| Unlock | Industrialization |
| Yields | +6 Production and +3 Science, extended to all City Centers within 6 tiles |
| This city only | Farms +5 Food; Mines and Quarries +2 Production |

---

### Weapon: Annihilation Scar

Built on the game's native weapon of mass destruction system, but presented as a skill of the Battle Mage army. Only a Battle Mage in army formation shows the button, and each army is one cast. Blast radius 1; it damages units and buildings only, not population, improvements or roads, and leaves no fallout. Corps need the Nationalism civic and armies need the Mobilization civic, as in the base game.


---

### City Project: Desanctification

| Attribute | Value |
|---|---|
| Available to | Typhon only |
| Requires | A Mage Tower district; unlocked by the Mass Media civic |
| Repeatable | Yes; cost grows with game progress |
| On completion | Half of your Faith becomes an equal amount of Science, and you gain 25 Diplomatic Favor |

---

### World Congress Resolution: Theocratic Council

A new resolution, available from the Modern era, that targets one founded Religion.

| Option | Effect |
|---|---|
| Desanctification | -10 Strength (Combat and Religious) for all units of the chosen Religion |
| Secular Oversight | All players may condemn units of the chosen Religion; each condemnation grants 25 Diplomatic Favor |

It joins the resolution pool whenever the mod is enabled, with or without Typhon in the game.

---

### Leader: Rosetta Augustus

#### Ability: *Resilience of Mortals*

- Entering a new era grants **1 random Eureka and 1 random Inspiration** from that era, or **2 of each** if it is a Dark Age.
- Killing an enemy unit in combat grants the **Eureka** for that unit's prerequisite technology if it has not been researched yet (once per technology).

#### Agenda: *Kindred*

- **Likes** civilizations whose land forces are no weaker than his.
- **Dislikes** civilizations that spread their Religion to his cities.

---

### Optional Religion: War God Faith

The Church of the God of War from *Sword of Dawn*, devoted to Kel, added as a religion. Its Civilopedia entry tells the story of the church.

| Attribute | Value |
|---|---|
| Available to | Any civilization can found it, not only Typhon |

---

### Also Included

A loyalty lens overlay with the Typhon emblem, 57 city names from the fan map of Typhon, and a Civilopedia section with people and places from the novel.

---

## Recommended Victory Paths

| Victory Type | Strategy |
|---|---|
| **Domination** | Pair Mage Towers with Encampments, grow Battle Mages through Ballistics, form armies and end fights with Annihilation Scar |
| **Science** | Let Mage Tower adjacency and the Burnstone Acidification Works carry research; use Rosetta's Eurekas to catch up and Desanctification to turn Faith into Science |

**Early game tip:** Rosetta's catch-up is strongest against more advanced rivals, so pick fights you can win and take the Eurekas their units give you.

---

## Installation

### Steam Workshop *(recommended)*

1. Subscribe on the [Steam Workshop page](https://steamcommunity.com/sharedfiles/filedetails/?id=3829307748).
2. Launch Civilization VI → **Additional Content** → enable **Typhon Empire**.

### Manual Installation

1. Build the project in `src/` with the Civ VI SDK (ModBuddy, or MSBuild on `src/TSODTyphonEmpire.civ6proj`), or use a packaged release. The `src/` folder itself is not a ready-to-play mod folder.
2. Copy the built `TSODTyphonEmpire` folder to your Civ VI mods directory:
   - **Windows:** `%USERPROFILE%\Documents\My Games\Sid Meier's Civilization VI\Mods\`
   - **macOS:** `~/Library/Application Support/Sid Meier's Civilization VI/Mods/`
3. Launch Civilization VI → **Additional Content** → enable **Typhon Empire**.

### Requirements

- **Gathering Storm** ruleset, **Rise and Fall**, and the **Ethiopia Pack** (the Mage Tower reuses its Alchemical Society model).
- Start a new game; enabling the mod in an existing save is not supported.

---

## Compatibility

- **Cecil Empire:** with both mods enabled, Rosetta Augustus and Gawain Cecil each get a diplomatic attitude toward the other ("a rival is still a kindred spirit"). It only loads when the Cecil mod is detected.
- **Unit Panel:** the mod replaces the Unit Panel script so that only Annihilation Scar is shown, and chains with other mods that also change it (for example the Klee mod) following the community convention. A UI mod that replaces the Unit Panel outright may add extra base-game nuclear buttons to the Battle Mage.

If you find a conflict, please open an issue with your mod list and the `Database.log` and `Lua.log` files.

---

## Credits

| Contribution | Source |
|---|---|
| Source material & lore | Original novelist of *Sword of Dawn* (远瞳) |
| Base game assets | Firaxis Games / 2K; unit, district and building models reuse official assets, including the Ethiopia Pack |
| Artwork | Emblem, portraits, backgrounds and moment illustrations from the novel author's Bilibili posts and official setting art; some icons generated with AI (Gemini), processed |
| Thanks | Sun and Moon of Teyvat Pack (Klee) by Shimamura et al. |
| Modding tutorials | Hemmelfort, Sukritact, QQ group 711403691 |
| Reference material | Civilopedia, Civilization Fandom |
| Development assistance | The three Claude sisters and Gemini Argon |

---

## License

This mod is fan-made and non-commercial. All original game assets remain property of Firaxis Games / 2K. Lore and characters are inspired by *Sword of Dawn* — all credit to the original author.

---

## Feedback & Contributing

Found a bug or have a balance suggestion? [Open an issue](https://github.com/xhw994/TSODTyphonEmpire/issues) — all feedback is welcome.

---

*Also see: [README (中文)](./README_CN.md) · [README (English, Workshop)](./README_EN.md)*
