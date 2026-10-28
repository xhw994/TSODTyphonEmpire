-- WP17 Theocratic Council (new World Congress resolution); loaded only under Gathering Storm (Resolutions / ResolutionEffects are new tables in the expansion).
-- Based on the official World Religion resolution WC_RES_WORLD_RELIGION, with its option A reversed (master plan §8.5); items awaiting in-game proof are in test-plan §10.

-- 1. Type registration and main resolution table
-- Uses its own ValidationLua: the official WC_Validate_RegliousBan has no Lua handler and the engine special-cases the target,
-- copying it would keep the terrain left by the previous validation in the target list, and the game crashes (in-game test 10-22); see Scripts/TsoDTE_Congress.lua.
INSERT INTO Types (Type, Kind) VALUES
    ('WC_RES_TSOD_THEOCRATIC_COUNCIL', 'KIND_RESOLUTION');

INSERT INTO Resolutions (
    ResolutionType, TargetKind, Name,
    Effect1Description, Effect2Description,
    ValidationLua, AITargetChooser,
    InjectionOnly, EarliestEra
) VALUES (
    'WC_RES_TSOD_THEOCRATIC_COUNCIL', 'RELIGION', 'LOC_WC_RES_TSOD_THEOCRATIC_COUNCIL_NAME',
    'LOC_WORLD_CONGRESS_TSOD_DESANCTIFY_RELIGION_DESC',
    'LOC_WORLD_CONGRESS_TSOD_SECULAR_OVERSIGHT_DESC',
    'WC_Validate_TsoDTE_TheocraticCouncil', 'ReligiousTarget',
    0, 'ERA_MODERN'
);

-- 2. Option 1 modifier: Desanctification
-- Type follows the official WC_RES_RELIGIOUS_UNITS_STRENGTH, but its Amount is +10 and cannot be reused, so a separate ModifierId writes -10.
-- Whether a negative value takes effect, and whether the target religion is passed in by the vote: see test-plan §10 (C2, C3).
INSERT INTO Modifiers (ModifierId, ModifierType) VALUES
    ('TSOD_TYPHON_COUNCIL_RELIGIOUS_STRENGTH_DOWN', 'MODIFIER_MAJOR_PLAYERS_ADJUST_UNITS_RELIGIOUS_STRENGTH_BY_RELIGION_TYPE');

INSERT INTO ModifierArguments (ModifierId, Name, Value) VALUES
    ('TSOD_TYPHON_COUNCIL_RELIGIOUS_STRENGTH_DOWN', 'Amount', '-10');

-- 3. Resolution effect rows
-- Option 2 reuses the official ANYONE_CONDEMNS_FOR_FAVOR; no separate modifier.
-- ResolutionEffectId 210 and 215: the official ones go up to 205, and the Workshop mods have no ResolutionEffects row (checked).
INSERT INTO ResolutionEffects (ResolutionEffectId, ResolutionType, WhichEffect, ModifierId) VALUES
    (210, 'WC_RES_TSOD_THEOCRATIC_COUNCIL', 1, 'TSOD_TYPHON_COUNCIL_RELIGIOUS_STRENGTH_DOWN'),
    (215, 'WC_RES_TSOD_THEOCRATIC_COUNCIL', 2, 'ANYONE_CONDEMNS_FOR_FAVOR');

-- 4. AI preferences: Typhon AI supports this resolution (option 1)
-- Favored stops at the "resolution" level and does not name an option; Favored=1 for option 1 is inferred from the official WC_RES_WORLD_RELIGION mapping and not yet proven in-game
-- (test-plan §10.5 C5); if the opposite is true, deleting these three rows does not affect the resolution itself.
INSERT INTO AiListTypes (ListType) VALUES
    ('TSOD_TYPHON_ROSETTA_RESOLUTIONS');

INSERT INTO AiLists (ListType, LeaderType, AgendaType, System) VALUES
    ('TSOD_TYPHON_ROSETTA_RESOLUTIONS', 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS', NULL, 'Resolutions');

INSERT INTO AiFavoredItems (ListType, Item, Favored, Value) VALUES
    ('TSOD_TYPHON_ROSETTA_RESOLUTIONS', 'WC_RES_TSOD_THEOCRATIC_COUNCIL', 1, 0);
