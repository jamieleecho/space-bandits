#!/usr/bin/env python3
"""Generate a 22x68 tile (352x1088 pixel) space background for level 2.

Approach: define a library of <=127 unique 16x16 tiles, then compose
the tilemap by selecting tiles from the library. This ensures we stay
within the CoCo 3's tile limit.
"""

import random
from PIL import Image

random.seed(42)

WIDTH_TILES = 22
HEIGHT_TILES = 68
TILE = 16
WIDTH = WIDTH_TILES * TILE    # 352
HEIGHT = HEIGHT_TILES * TILE  # 1088

# CoCo 3 palette (each channel 0-3)
PALETTE_COCO = [
    (0, 0, 0),    #  0: black - main background
    (0, 0, 1),    #  1: very dark blue
    (0, 0, 2),    #  2: medium blue - nebula
    (0, 1, 2),    #  3: teal-blue - nebula
    (1, 0, 2),    #  4: dark purple - nebula
    (2, 0, 3),    #  5: bright purple
    (1, 1, 1),    #  6: dark gray
    (2, 2, 2),    #  7: medium gray
    (3, 3, 3),    #  8: white - stars
    (1, 1, 2),    #  9: blue-gray - dim stars
    (3, 3, 0),    # 10: yellow
    (3, 0, 0),    # 11: red
    (0, 2, 3),    # 12: cyan
    (2, 1, 0),    # 13: dark orange
    (3, 2, 1),    # 14: orange
    (0, 1, 1),    # 15: dark teal
]

PALETTE_RGB = []
for r, g, b in PALETTE_COCO:
    PALETTE_RGB.extend([r * 85, g * 85, b * 85])
while len(PALETTE_RGB) < 768:
    PALETTE_RGB.extend([0, 0, 0])

# Color indices
BG = 0; DARK_BLUE = 1; MED_BLUE = 2; TEAL_BLUE = 3; DARK_PURPLE = 4
BRIGHT_PURPLE = 5; DARK_GRAY = 6; MED_GRAY = 7; WHITE = 8; BLUE_GRAY = 9
YELLOW = 10; RED = 11; CYAN = 12; DARK_ORANGE = 13; ORANGE = 14; DARK_TEAL = 15


def make_tile(fill=BG):
    """Create a 16x16 tile filled with one color."""
    return [fill] * (TILE * TILE)


def tile_set_pixel(tile, x, y, color):
    if 0 <= x < TILE and 0 <= y < TILE:
        tile[y * TILE + x] = color


def tile_fill_rect(tile, x, y, w, h, color):
    for dy in range(h):
        for dx in range(w):
            tile_set_pixel(tile, x + dx, y + dy, color)


def tile_hline(tile, x, y, w, color):
    for dx in range(w):
        tile_set_pixel(tile, x + dx, y, color)


def tile_vline(tile, x, y, h, color):
    for dy in range(h):
        tile_set_pixel(tile, x, y + dy, color)


# ========== DEFINE TILE LIBRARY ==========
tile_lib = {}  # name -> pixel data

# --- Empty/space tiles ---
tile_lib['empty'] = make_tile(BG)
tile_lib['dark_blue'] = make_tile(DARK_BLUE)

# --- Star tiles: predefined star patterns on black ---
star_patterns = [
    # (name, [(x, y, color), ...])
    ('star_1', [(7, 7, WHITE)]),
    ('star_2', [(3, 12, WHITE)]),
    ('star_3', [(11, 4, WHITE)]),
    ('star_4', [(5, 9, BLUE_GRAY)]),
    ('star_5', [(13, 2, BLUE_GRAY)]),
    ('star_6', [(2, 6, YELLOW)]),
    ('star_7', [(10, 13, WHITE), (3, 5, BLUE_GRAY)]),
    ('star_8', [(7, 3, WHITE), (12, 11, DARK_TEAL)]),
    ('star_9', [(1, 14, BLUE_GRAY), (14, 1, WHITE)]),
    ('star_10', [(8, 8, WHITE), (7, 8, BLUE_GRAY), (9, 8, BLUE_GRAY)]),  # bright star
    ('star_11', [(6, 6, WHITE), (6, 5, BLUE_GRAY), (6, 7, BLUE_GRAY)]),  # bright star vertical
    ('star_12', [(4, 10, MED_GRAY)]),
    ('star_13', [(9, 2, DARK_TEAL), (2, 13, WHITE)]),
    ('star_14', [(12, 7, YELLOW), (5, 3, BLUE_GRAY)]),
    ('star_15', [(7, 12, WHITE), (14, 5, MED_GRAY), (1, 1, BLUE_GRAY)]),
    ('star_16', [(3, 3, WHITE), (11, 11, WHITE)]),
    ('star_17', [(8, 1, BLUE_GRAY), (4, 14, DARK_TEAL)]),
    ('star_18', [(13, 9, WHITE), (6, 4, BLUE_GRAY), (1, 12, MED_GRAY)]),
]

for name, stars in star_patterns:
    t = make_tile(BG)
    for x, y, c in stars:
        tile_set_pixel(t, x, y, c)
    tile_lib[name] = t

# --- Star on dark blue background ---
star_db_patterns = [
    ('star_db_1', [(7, 7, WHITE)]),
    ('star_db_2', [(4, 11, BLUE_GRAY)]),
    ('star_db_3', [(11, 3, WHITE), (3, 13, BLUE_GRAY)]),
]
for name, stars in star_db_patterns:
    t = make_tile(DARK_BLUE)
    for x, y, c in stars:
        tile_set_pixel(t, x, y, c)
    tile_lib[name] = t

# --- Nebula tiles ---
def make_nebula_tile(name, base_color, highlights, pattern='full'):
    t = make_tile(BG)
    if pattern == 'full':
        for y in range(TILE):
            for x in range(TILE):
                tile_set_pixel(t, x, y, base_color)
        # Add some texture
        random.seed(hash(name))
        for _ in range(30):
            x, y = random.randint(0, 15), random.randint(0, 15)
            tile_set_pixel(t, x, y, highlights[0] if random.random() < 0.5 else base_color)
    elif pattern == 'top_fade':
        for y in range(TILE):
            density = y / TILE
            for x in range(TILE):
                random.seed(hash(name) + x * 100 + y)
                if random.random() < density:
                    tile_set_pixel(t, x, y, base_color)
                elif random.random() < density * 0.3:
                    tile_set_pixel(t, x, y, highlights[0])
    elif pattern == 'bottom_fade':
        for y in range(TILE):
            density = 1.0 - y / TILE
            for x in range(TILE):
                random.seed(hash(name) + x * 100 + y)
                if random.random() < density:
                    tile_set_pixel(t, x, y, base_color)
                elif random.random() < density * 0.3:
                    tile_set_pixel(t, x, y, highlights[0])
    elif pattern == 'left_fade':
        for y in range(TILE):
            for x in range(TILE):
                density = x / TILE
                random.seed(hash(name) + x * 100 + y)
                if random.random() < density:
                    tile_set_pixel(t, x, y, base_color)
    elif pattern == 'right_fade':
        for y in range(TILE):
            for x in range(TILE):
                density = 1.0 - x / TILE
                random.seed(hash(name) + x * 100 + y)
                if random.random() < density:
                    tile_set_pixel(t, x, y, base_color)
    elif pattern == 'sparse':
        random.seed(hash(name))
        for _ in range(40):
            x, y = random.randint(0, 15), random.randint(0, 15)
            tile_set_pixel(t, x, y, base_color)
        for _ in range(10):
            x, y = random.randint(0, 15), random.randint(0, 15)
            tile_set_pixel(t, x, y, highlights[0])
    elif pattern == 'corner_tl':
        for y in range(TILE):
            for x in range(TILE):
                density = max(0, 1.0 - (x + y) / 20)
                random.seed(hash(name) + x * 100 + y)
                if random.random() < density:
                    tile_set_pixel(t, x, y, base_color)
    elif pattern == 'corner_tr':
        for y in range(TILE):
            for x in range(TILE):
                density = max(0, 1.0 - ((15 - x) + y) / 20)
                random.seed(hash(name) + x * 100 + y)
                if random.random() < density:
                    tile_set_pixel(t, x, y, base_color)
    elif pattern == 'corner_bl':
        for y in range(TILE):
            for x in range(TILE):
                density = max(0, 1.0 - (x + (15 - y)) / 20)
                random.seed(hash(name) + x * 100 + y)
                if random.random() < density:
                    tile_set_pixel(t, x, y, base_color)
    elif pattern == 'corner_br':
        for y in range(TILE):
            for x in range(TILE):
                density = max(0, 1.0 - ((15 - x) + (15 - y)) / 20)
                random.seed(hash(name) + x * 100 + y)
                if random.random() < density:
                    tile_set_pixel(t, x, y, base_color)
    tile_lib[name] = t

# Blue nebula tiles
make_nebula_tile('neb_blue_full', MED_BLUE, [TEAL_BLUE], 'full')
make_nebula_tile('neb_blue_top', MED_BLUE, [DARK_BLUE], 'top_fade')
make_nebula_tile('neb_blue_bot', MED_BLUE, [DARK_BLUE], 'bottom_fade')
make_nebula_tile('neb_blue_left', MED_BLUE, [DARK_BLUE], 'left_fade')
make_nebula_tile('neb_blue_right', MED_BLUE, [DARK_BLUE], 'right_fade')
make_nebula_tile('neb_blue_sparse', MED_BLUE, [TEAL_BLUE], 'sparse')
make_nebula_tile('neb_blue_tl', MED_BLUE, [DARK_BLUE], 'corner_tl')
make_nebula_tile('neb_blue_tr', MED_BLUE, [DARK_BLUE], 'corner_tr')
make_nebula_tile('neb_blue_bl', MED_BLUE, [DARK_BLUE], 'corner_bl')
make_nebula_tile('neb_blue_br', MED_BLUE, [DARK_BLUE], 'corner_br')

# Purple nebula tiles
make_nebula_tile('neb_purp_full', DARK_PURPLE, [BRIGHT_PURPLE], 'full')
make_nebula_tile('neb_purp_top', DARK_PURPLE, [BRIGHT_PURPLE], 'top_fade')
make_nebula_tile('neb_purp_bot', DARK_PURPLE, [BRIGHT_PURPLE], 'bottom_fade')
make_nebula_tile('neb_purp_left', DARK_PURPLE, [BRIGHT_PURPLE], 'left_fade')
make_nebula_tile('neb_purp_right', DARK_PURPLE, [BRIGHT_PURPLE], 'right_fade')
make_nebula_tile('neb_purp_sparse', DARK_PURPLE, [BRIGHT_PURPLE], 'sparse')
make_nebula_tile('neb_purp_tl', DARK_PURPLE, [BRIGHT_PURPLE], 'corner_tl')
make_nebula_tile('neb_purp_tr', DARK_PURPLE, [BRIGHT_PURPLE], 'corner_tr')
make_nebula_tile('neb_purp_bl', DARK_PURPLE, [BRIGHT_PURPLE], 'corner_bl')
make_nebula_tile('neb_purp_br', DARK_PURPLE, [BRIGHT_PURPLE], 'corner_br')

# Mixed nebula
make_nebula_tile('neb_mix_full', TEAL_BLUE, [DARK_PURPLE], 'full')
make_nebula_tile('neb_mix_sparse', TEAL_BLUE, [DARK_PURPLE], 'sparse')

# --- Space base tiles ---
# Solid structural tiles
t = make_tile(DARK_GRAY); tile_lib['base_dark'] = t
t = make_tile(MED_GRAY); tile_lib['base_gray'] = t

# Hull plate - dark gray with rivets
t = make_tile(DARK_GRAY)
for i in range(0, 16, 4):
    tile_set_pixel(t, i, 0, MED_GRAY)
    tile_set_pixel(t, i, 15, MED_GRAY)
tile_lib['hull_h'] = t

# Hull plate - vertical
t = make_tile(DARK_GRAY)
for i in range(0, 16, 4):
    tile_set_pixel(t, 0, i, MED_GRAY)
    tile_set_pixel(t, 15, i, MED_GRAY)
tile_lib['hull_v'] = t

# Window tile (2x3 window on gray)
t = make_tile(DARK_GRAY)
tile_fill_rect(t, 5, 4, 6, 8, CYAN)
tile_fill_rect(t, 6, 5, 4, 6, TEAL_BLUE)
tile_set_pixel(t, 8, 7, DARK_BLUE)  # reflection
tile_lib['window'] = t

# Window tile variant (yellow lit)
t = make_tile(DARK_GRAY)
tile_fill_rect(t, 5, 4, 6, 8, YELLOW)
tile_fill_rect(t, 6, 5, 4, 6, ORANGE)
tile_set_pixel(t, 8, 7, WHITE)
tile_lib['window_lit'] = t

# Small window on dark gray
t = make_tile(DARK_GRAY)
tile_fill_rect(t, 6, 6, 4, 4, CYAN)
tile_lib['window_sm'] = t

# Solar panel tile
t = make_tile(DARK_BLUE)
for i in range(0, 16, 4):
    tile_hline(t, 0, i, 16, DARK_GRAY)
for i in range(0, 16, 4):
    tile_vline(t, i, 0, 16, DARK_GRAY)
# Fill cells with alternating colors
for gy in range(4):
    for gx in range(4):
        c = MED_BLUE if (gx + gy) % 2 == 0 else DARK_PURPLE
        tile_fill_rect(t, gx * 4 + 1, gy * 4 + 1, 3, 3, c)
tile_lib['solar'] = t

# Solar panel edge (left)
t = make_tile(BG)
tile_fill_rect(t, 8, 0, 8, 16, DARK_BLUE)
for i in range(0, 16, 4):
    tile_hline(t, 8, i, 8, DARK_GRAY)
for i in range(8, 16, 4):
    tile_vline(t, i, 0, 16, DARK_GRAY)
tile_vline(t, 8, 0, 16, MED_GRAY)  # frame edge
for gy in range(4):
    for gx in range(2):
        c = MED_BLUE if (gx + gy) % 2 == 0 else DARK_PURPLE
        tile_fill_rect(t, 9 + gx * 4, gy * 4 + 1, 3, 3, c)
tile_lib['solar_l'] = t

# Solar panel edge (right)
t = make_tile(BG)
tile_fill_rect(t, 0, 0, 8, 16, DARK_BLUE)
for i in range(0, 16, 4):
    tile_hline(t, 0, i, 8, DARK_GRAY)
for i in range(0, 8, 4):
    tile_vline(t, i, 0, 16, DARK_GRAY)
tile_vline(t, 7, 0, 16, MED_GRAY)
for gy in range(4):
    for gx in range(2):
        c = MED_BLUE if (gx + gy) % 2 == 0 else DARK_PURPLE
        tile_fill_rect(t, gx * 4 + 1, gy * 4 + 1, 3, 3, c)
tile_lib['solar_r'] = t

# Antenna tile
t = make_tile(BG)
tile_vline(t, 8, 0, 16, MED_GRAY)
tile_set_pixel(t, 8, 0, RED)
tile_set_pixel(t, 7, 0, RED)
tile_hline(t, 5, 4, 7, MED_GRAY)
tile_set_pixel(t, 4, 5, DARK_GRAY)
tile_set_pixel(t, 12, 5, DARK_GRAY)
tile_lib['antenna'] = t

# Hull top edge
t = make_tile(BG)
tile_fill_rect(t, 0, 8, 16, 8, DARK_GRAY)
tile_hline(t, 0, 8, 16, MED_GRAY)  # highlight
tile_lib['hull_top'] = t

# Hull bottom edge
t = make_tile(BG)
tile_fill_rect(t, 0, 0, 16, 8, DARK_GRAY)
tile_hline(t, 0, 7, 16, MED_GRAY)
tile_lib['hull_bot'] = t

# Hull top-left corner
t = make_tile(BG)
tile_fill_rect(t, 8, 8, 8, 8, DARK_GRAY)
tile_hline(t, 8, 8, 8, MED_GRAY)
tile_vline(t, 8, 8, 8, MED_GRAY)
tile_lib['hull_tl'] = t

# Hull top-right corner
t = make_tile(BG)
tile_fill_rect(t, 0, 8, 8, 8, DARK_GRAY)
tile_hline(t, 0, 8, 8, MED_GRAY)
tile_vline(t, 7, 8, 8, MED_GRAY)
tile_lib['hull_tr'] = t

# Hull bottom-left corner
t = make_tile(BG)
tile_fill_rect(t, 8, 0, 8, 8, DARK_GRAY)
tile_hline(t, 8, 7, 8, MED_GRAY)
tile_vline(t, 8, 0, 8, MED_GRAY)
tile_lib['hull_bl'] = t

# Hull bottom-right corner
t = make_tile(BG)
tile_fill_rect(t, 0, 0, 8, 8, DARK_GRAY)
tile_hline(t, 0, 7, 8, MED_GRAY)
tile_vline(t, 7, 0, 8, MED_GRAY)
tile_lib['hull_br'] = t

# Hull left edge
t = make_tile(BG)
tile_fill_rect(t, 8, 0, 8, 16, DARK_GRAY)
tile_vline(t, 8, 0, 16, MED_GRAY)
tile_lib['hull_left'] = t

# Hull right edge
t = make_tile(BG)
tile_fill_rect(t, 0, 0, 8, 16, DARK_GRAY)
tile_vline(t, 7, 0, 16, MED_GRAY)
tile_lib['hull_right'] = t

# Engine nozzle top
t = make_tile(DARK_GRAY)
tile_fill_rect(t, 4, 8, 8, 8, MED_GRAY)
tile_fill_rect(t, 5, 12, 6, 4, DARK_ORANGE)
tile_lib['engine_top'] = t

# Engine nozzle bottom (with exhaust)
t = make_tile(BG)
tile_fill_rect(t, 5, 0, 6, 4, ORANGE)
tile_fill_rect(t, 6, 2, 4, 6, YELLOW)
tile_fill_rect(t, 7, 6, 2, 6, DARK_ORANGE)
tile_set_pixel(t, 7, 12, DARK_TEAL)
tile_set_pixel(t, 8, 13, DARK_TEAL)
tile_lib['engine_bot'] = t

# Docking bay opening
t = make_tile(DARK_GRAY)
tile_fill_rect(t, 2, 2, 12, 12, BG)
tile_hline(t, 3, 1, 2, YELLOW)
tile_hline(t, 11, 1, 2, YELLOW)
tile_fill_rect(t, 4, 4, 8, 8, DARK_BLUE)
tile_lib['dock_bay'] = t

# Strut (horizontal connector)
t = make_tile(BG)
tile_fill_rect(t, 0, 6, 16, 4, MED_GRAY)
tile_hline(t, 0, 6, 16, DARK_GRAY)
tile_hline(t, 0, 9, 16, DARK_GRAY)
tile_lib['strut_h'] = t

# Strut (vertical connector)
t = make_tile(BG)
tile_fill_rect(t, 6, 0, 4, 16, MED_GRAY)
tile_vline(t, 6, 0, 16, DARK_GRAY)
tile_vline(t, 9, 0, 16, DARK_GRAY)
tile_lib['strut_v'] = t

# Red warning light on black
t = make_tile(BG)
tile_set_pixel(t, 8, 8, RED)
tile_set_pixel(t, 7, 8, DARK_ORANGE)
tile_set_pixel(t, 9, 8, DARK_ORANGE)
tile_lib['light_red'] = t

# Runway light pair
t = make_tile(BG)
tile_set_pixel(t, 4, 8, ORANGE)
tile_set_pixel(t, 4, 9, YELLOW)
tile_set_pixel(t, 11, 8, ORANGE)
tile_set_pixel(t, 11, 9, YELLOW)
tile_lib['runway'] = t

# Tower tile (vertical structure with detail)
t = make_tile(DARK_GRAY)
tile_vline(t, 4, 0, 16, MED_GRAY)
tile_vline(t, 11, 0, 16, MED_GRAY)
tile_fill_rect(t, 6, 5, 4, 3, CYAN)
tile_lib['tower'] = t

# Dome top
t = make_tile(BG)
tile_fill_rect(t, 4, 8, 8, 8, DARK_GRAY)
tile_hline(t, 4, 8, 8, MED_GRAY)
tile_fill_rect(t, 6, 6, 4, 2, DARK_GRAY)
tile_hline(t, 6, 6, 4, MED_GRAY)
tile_set_pixel(t, 5, 7, DARK_GRAY)
tile_set_pixel(t, 10, 7, DARK_GRAY)
tile_lib['dome_top'] = t

# Pipe horizontal
t = make_tile(BG)
tile_hline(t, 0, 7, 16, MED_GRAY)
tile_hline(t, 0, 8, 16, DARK_GRAY)
tile_lib['pipe_h'] = t


print(f"Tile library: {len(tile_lib)} tiles")

# ========== COMPOSE THE TILEMAP ==========
# The map is 22 columns x 68 rows of tile names
tilemap = [['empty'] * WIDTH_TILES for _ in range(HEIGHT_TILES)]

# Helper to place a tile
def place(tx, ty, name):
    if 0 <= tx < WIDTH_TILES and 0 <= ty < HEIGHT_TILES:
        tilemap[ty][tx] = name

# Helper: fill rectangle of tiles
def fill_tiles(tx, ty, tw, th, name):
    for dy in range(th):
        for dx in range(tw):
            place(tx + dx, ty + dy, name)

# --- STARFIELD (rows 12-67, after the base) ---
# Distribute star tiles across the open space area
star_names = [n for n in tile_lib if n.startswith('star_') and not n.startswith('star_db')]
star_db_names = [n for n in tile_lib if n.startswith('star_db')]

STAR_START = 12  # starfield begins after the base
random.seed(123)
for ty in range(STAR_START, HEIGHT_TILES):
    for tx in range(WIDTH_TILES):
        r = random.random()
        if r < 0.30:
            tilemap[ty][tx] = random.choice(star_names)
        elif r < 0.35:
            tilemap[ty][tx] = random.choice(star_db_names)
        elif r < 0.38:
            tilemap[ty][tx] = 'dark_blue'
        # else stays 'empty'

# --- NEBULA REGIONS ---
def place_nebula(tx, ty, tw, th, color='blue'):
    p = f'neb_{color}'
    # Check which variants exist; fall back to sparse/full
    def get(suffix):
        name = f'{p}_{suffix}'
        return name if name in tile_lib else f'{p}_sparse'
    # corners
    place(tx, ty, get('tl'))
    place(tx + tw - 1, ty, get('tr'))
    place(tx, ty + th - 1, get('bl'))
    place(tx + tw - 1, ty + th - 1, get('br'))
    # top edge
    for x in range(tx + 1, tx + tw - 1):
        place(x, ty, get('top'))
    # bottom edge
    for x in range(tx + 1, tx + tw - 1):
        place(x, ty + th - 1, get('bot'))
    # left edge
    for y in range(ty + 1, ty + th - 1):
        place(tx, y, get('left'))
    # right edge
    for y in range(ty + 1, ty + th - 1):
        place(tx + tw - 1, y, get('right'))
    # interior
    for y in range(ty + 1, ty + th - 1):
        for x in range(tx + 1, tx + tw - 1):
            if random.random() < 0.3:
                place(x, y, f'{p}_sparse')
            else:
                place(x, y, f'{p}_full')

# --- SPACE BASE (rows 0-11, top 12 rows) ---
BASE_ROW = 0

place_nebula(2, 20, 7, 5, 'blue')
place_nebula(14, 18, 6, 4, 'purp')
place_nebula(4, 32, 8, 5, 'purp')
place_nebula(12, 34, 7, 4, 'blue')
place_nebula(1, 44, 6, 5, 'blue')
place_nebula(8, 47, 8, 4, 'mix')
place_nebula(15, 52, 5, 4, 'purp')
place_nebula(3, 56, 7, 4, 'blue')
place_nebula(10, 60, 6, 3, 'purp')

# Row 56-57: Approach - runway lights and empty space
for ty in range(BASE_ROW, BASE_ROW + 2):
    for tx in range(WIDTH_TILES):
        if tx in (5, 16):
            place(tx, ty, 'runway')
        elif tx in (7, 14):
            place(tx, ty, 'light_red')

# Row 58: Antenna and approach
place(11, BASE_ROW + 2, 'antenna')

# Row 59: Top edge of main hull + outposts
# Left outpost (small dome)
place(2, BASE_ROW + 3, 'dome_top')
place(3, BASE_ROW + 3, 'hull_top')
# Pipe connecting left outpost to main
for tx in range(4, 7):
    place(tx, BASE_ROW + 4, 'pipe_h')

# Main hull top edge
for tx in range(7, 15):
    place(tx, BASE_ROW + 3, 'hull_top')
place(7, BASE_ROW + 3, 'hull_tl')
place(14, BASE_ROW + 3, 'hull_tr')

# Right outpost
place(18, BASE_ROW + 3, 'dome_top')
place(19, BASE_ROW + 3, 'hull_top')
# Pipe connecting right outpost to main
for tx in range(15, 18):
    place(tx, BASE_ROW + 4, 'pipe_h')

# Row 60-61: Left outpost body
place(2, BASE_ROW + 4, 'hull_left')
place(3, BASE_ROW + 4, 'window_sm')
place(2, BASE_ROW + 5, 'hull_bl')
place(3, BASE_ROW + 5, 'hull_bot')

# Right outpost body
place(18, BASE_ROW + 4, 'window_sm')
place(19, BASE_ROW + 4, 'hull_right')
place(18, BASE_ROW + 5, 'hull_bot')
place(19, BASE_ROW + 5, 'hull_br')

# Main hull body rows 60-63
for ty in range(BASE_ROW + 4, BASE_ROW + 8):
    place(7, ty, 'hull_left')
    place(14, ty, 'hull_right')
    for tx in range(8, 14):
        if ty == BASE_ROW + 4:
            place(tx, ty, 'hull_h')
        elif ty == BASE_ROW + 5:
            if tx in (9, 12):
                place(tx, ty, 'window')
            elif tx == 11:
                place(tx, ty, 'window_lit')
            else:
                place(tx, ty, 'hull_v')
        elif ty == BASE_ROW + 6:
            place(tx, ty, 'hull_h')
        elif ty == BASE_ROW + 7:
            if tx in (9, 12):
                place(tx, ty, 'window')
            elif tx == 10:
                place(tx, ty, 'window_lit')
            else:
                place(tx, ty, 'hull_v')

# Solar panels (left)
place(4, BASE_ROW + 5, 'strut_h')
place(5, BASE_ROW + 5, 'solar_l')
place(6, BASE_ROW + 5, 'solar')
place(4, BASE_ROW + 6, 'solar_l')
place(5, BASE_ROW + 6, 'solar')
place(6, BASE_ROW + 6, 'solar_r')

# Solar panels (right)
place(15, BASE_ROW + 5, 'solar')
place(16, BASE_ROW + 5, 'solar_r')
place(17, BASE_ROW + 5, 'strut_h')
place(15, BASE_ROW + 6, 'solar_l')
place(16, BASE_ROW + 6, 'solar')
place(17, BASE_ROW + 6, 'solar_r')

# Docking bay (row 64)
place(9, BASE_ROW + 8, 'dock_bay')
place(10, BASE_ROW + 8, 'dock_bay')
place(11, BASE_ROW + 8, 'dock_bay')
place(12, BASE_ROW + 8, 'dock_bay')
for tx in [7, 8, 13, 14]:
    place(tx, BASE_ROW + 8, 'hull_h')
place(7, BASE_ROW + 8, 'hull_left')
place(14, BASE_ROW + 8, 'hull_right')

# Hull bottom + towers (row 65)
place(7, BASE_ROW + 9, 'hull_bl')
for tx in range(8, 14):
    place(tx, BASE_ROW + 9, 'hull_bot')
place(14, BASE_ROW + 9, 'hull_br')

# Tower structures flanking (rows 65-66)
place(5, BASE_ROW + 8, 'tower')
place(5, BASE_ROW + 9, 'tower')
place(16, BASE_ROW + 8, 'tower')
place(16, BASE_ROW + 9, 'tower')

# Engine section (rows 66-67)
for tx in [9, 11, 13]:
    place(tx, BASE_ROW + 10, 'engine_top')
    place(tx, BASE_ROW + 11, 'engine_bot')
# Struts connecting engines
place(10, BASE_ROW + 10, 'strut_h')
place(12, BASE_ROW + 10, 'strut_h')

# Fill remaining base-area empty tiles with sparse stars
for ty in range(BASE_ROW, STAR_START):
    for tx in range(WIDTH_TILES):
        if tilemap[ty][tx] == 'empty':
            if random.random() < 0.15:
                tilemap[ty][tx] = random.choice(star_names[:6])

# ========== RENDER TO PIXELS ==========
print("Rendering tilemap to pixels...")
pixels = [BG] * (WIDTH * HEIGHT)

for ty in range(HEIGHT_TILES):
    for tx in range(WIDTH_TILES):
        name = tilemap[ty][tx]
        tile = tile_lib[name]
        for py in range(TILE):
            for px in range(TILE):
                pixels[(ty * TILE + py) * WIDTH + tx * TILE + px] = tile[py * TILE + px]

# Count unique tiles
tiles_used = set()
for ty in range(HEIGHT_TILES):
    for tx in range(WIDTH_TILES):
        name = tilemap[ty][tx]
        tiles_used.add(tuple(tile_lib[name]))

print(f"Unique tiles in final image: {len(tiles_used)}")
assert len(tiles_used) <= 127, f"Too many unique tiles: {len(tiles_used)}"

# Save
img = Image.new('P', (WIDTH, HEIGHT))
img.putpalette(PALETTE_RGB)
img.putdata(pixels)
img.save('game/tiles/02-space.png')
print(f"Saved game/tiles/02-space.png ({WIDTH}x{HEIGHT})")

# Verify
verify = Image.open('game/tiles/02-space.png')
print(f"Verified: {verify.mode}, {verify.size}")
print("Done!")
