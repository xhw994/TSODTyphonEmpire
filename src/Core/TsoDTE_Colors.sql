-- WP1 Typhon colors (master plan §9.2): black base with red emblem, two alternate sets; PrimaryColor = base color, SecondaryColor = emblem color (base-game convention).
-- Color values R,G,B,A (0–255); naming COLOR_PLAYER_TSOD_<civ>_<purpose> (same as Cecil).

INSERT INTO Colors (Type, Color)
VALUES
    -- Primary: black base, red emblem
    ('COLOR_PLAYER_TSOD_TYPHON_EMPIRE_PRIMARY',        '22,20,22,255'),
    ('COLOR_PLAYER_TSOD_TYPHON_EMPIRE_SECONDARY',      '196,26,32,255'),
    -- Alternate 1: red base, black emblem (inverted)
    ('COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT1_PRIMARY',   '164,20,28,255'),
    ('COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT1_SECONDARY', '22,20,22,255'),
    -- Alternate 2: red base, gold emblem (design text: "gold-red banner")
    ('COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT2_PRIMARY',   '150,18,26,255'),
    ('COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT2_SECONDARY', '228,182,78,255');

INSERT INTO PlayerColors
    (Type, Usage, PrimaryColor, SecondaryColor,
     Alt1PrimaryColor, Alt1SecondaryColor,
     Alt2PrimaryColor, Alt2SecondaryColor)
VALUES
    ('LEADER_TSOD_ROSETTA_AUGUSTUS',
     'Unique',
     'COLOR_PLAYER_TSOD_TYPHON_EMPIRE_PRIMARY',
     'COLOR_PLAYER_TSOD_TYPHON_EMPIRE_SECONDARY',
     'COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT1_PRIMARY',
     'COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT1_SECONDARY',
     'COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT2_PRIMARY',
     'COLOR_PLAYER_TSOD_TYPHON_EMPIRE_ALT2_SECONDARY');
